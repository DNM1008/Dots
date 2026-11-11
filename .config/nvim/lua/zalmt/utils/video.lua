-- Play a video inside a nvim window. mpv's kitty vo writes frames to a pipe,
-- and nvim forwards them to its own UI (nvim_ui_send), so frames never
-- interleave with nvim's redraws the way a second writer on the tty would.
local M = {}

local players = {} -- buf -> active player

local function ipc(sock, cmd)
	local pipe = vim.uv.new_pipe(false)
	pipe:connect(sock, function(err)
		if err then
			return pipe:close()
		end
		pipe:write(vim.json.encode({ command = cmd }) .. "\n", function()
			pipe:close()
		end)
	end)
end

local function geometry(win)
	local pos = vim.api.nvim_win_get_position(win)
	return {
		top = pos[1] + 1,
		left = pos[2] + 1,
		w = vim.api.nvim_win_get_width(win),
		h = vim.api.nvim_win_get_height(win),
	}
end

local function same(a, b)
	return a.top == b.top and a.left == b.left and a.w == b.w and a.h == b.h
end

-- frames are anonymous images (kitty drops them when relayed with an i=),
-- so delete every placement covering the video's top-left cell
local function delete_at(g)
	return ("\27_Ga=d,d=P,x=%d,y=%d,q=2\27\\"):format(g.left, g.top)
end

-- opts.paused: start paused; opts.clear: escape sequence sent with the first
-- frame (removes the previous player's image without a blank gap)
function M.play(buf, win, opts)
	if players[buf] then
		return
	end
	opts = opts or {}
	local file = vim.api.nvim_buf_get_name(buf)
	local cell = Snacks.image.terminal.size()

	-- g0: geometry mpv renders for; g: where the window is now
	local g0 = geometry(win)
	local g = g0
	local player = { sock = vim.fn.tempname() .. ".mpv", paused = opts.paused or false }
	players[buf] = player

	local clear = opts.clear
	local marker = ("\27[%d;%df"):format(g0.top, g0.left)
	local parts, latest, last, scheduled, started = {}, nil, nil, false, false

	-- mpv's geometry is fixed at launch; when the window has moved, place the
	-- frame at the new cell and let kitty scale it into the new box
	local function render(frame)
		local out = frame
		if not same(g, g0) then
			local s, v = frame:match("s=(%d+),v=(%d+)")
			local scale = math.min(g.w * cell.cell_width / s, g.h * cell.cell_height / v)
			local c = math.max(1, math.floor(s * scale / cell.cell_width + 0.5))
			local r = math.max(1, math.floor(v * scale / cell.cell_height + 0.5))
			local hdr = frame:find("a=T,", #marker + 1, true)
			out = ("\27[%d;%df"):format(g.top, g.left)
				.. frame:sub(#marker + 1, hdr + 3)
				.. ("c=%d,r=%d,"):format(c, r)
				.. frame:sub(hdr + 4)
		end
		if clear then
			out = clear .. out
			clear = nil
		end
		-- synchronized update with the cursor hidden, so kitty never shows the
		-- cursor while it is parked at the video's corner
		vim.api.nvim_ui_send("\27[?2026h\27[?25l\0277" .. out .. "\0278\27[?25h\27[?2026l")
	end

	local function draw()
		scheduled = false
		local frame = latest
		latest = nil
		-- a draw queued before cleanup would leave a stale frame behind
		if frame and players[buf] == player then
			last = frame
			if not player.hidden then
				render(frame)
			end
		end
	end

	local function on_stdout(_, data)
		if not data then
			return
		end
		local p = data:find(marker, 1, true)
		if not p then
			if started then
				parts[#parts + 1] = data
			end
			return
		end
		if started then
			parts[#parts + 1] = data:sub(1, p - 1)
			latest = table.concat(parts)
			if not scheduled then
				scheduled = true
				vim.schedule(draw)
			end
		end
		started = true
		parts = { data:sub(p) }
	end

	local group = vim.api.nvim_create_augroup("zalmt_video_" .. buf, {})
	local timer = vim.uv.new_timer()

	local function cleanup()
		players[buf] = nil
		pcall(vim.api.nvim_del_augroup_by_id, group)
		timer:close()
		os.remove(player.sock)
		-- a hidden player's image was already removed; the cell now belongs to another tab
		local del = player.hidden and "" or (clear or "") .. delete_at(g)
		if
			player.restart
			and vim.api.nvim_buf_is_valid(buf)
			and vim.api.nvim_win_is_valid(win)
			and vim.api.nvim_win_get_buf(win) == buf
			and vim.api.nvim_win_get_tabpage(win) == vim.api.nvim_get_current_tabpage()
		then
			-- the old (scaled) frame stays up until the new player's first frame
			M.play(buf, win, { paused = player.paused, clear = del })
		else
			vim.api.nvim_ui_send(del)
		end
	end

	local proc = vim.system({
		"mpv",
		"--no-terminal",
		"--vo=kitty",
		"--vo-kitty-use-shm=no",
		"--vo-kitty-alt-screen=no",
		"--vo-kitty-config-clear=no",
		"--vo-kitty-top=" .. g0.top,
		"--vo-kitty-left=" .. g0.left,
		"--vo-kitty-cols=" .. g0.w,
		"--vo-kitty-rows=" .. g0.h,
		"--vo-kitty-width=" .. math.floor(g0.w * cell.cell_width),
		"--vo-kitty-height=" .. math.floor(g0.h * cell.cell_height),
		"--input-ipc-server=" .. player.sock,
		"--pause=" .. (player.paused and "yes" or "no"),
		file,
	}, { stdout = on_stdout }, vim.schedule_wrap(cleanup))

	-- scaled-up frames get blurry: once resizing settles, relaunch at the new
	-- size if it is noticeably bigger (mpv resumes from its watch-later entry)
	local function maybe_relaunch()
		if player.restart or player.hidden or players[buf] ~= player or not last then
			return
		end
		local s, v = last:match("s=(%d+),v=(%d+)")
		local scale = math.min(g.w * cell.cell_width / s, g.h * cell.cell_height / v)
		if scale > 1.1 then
			player.restart = true
			ipc(player.sock, { "quit-watch-later" })
		end
	end

	local function shows(w, tab)
		return vim.api.nvim_win_is_valid(w)
			and vim.api.nvim_win_get_buf(w) == buf
			and (not tab or vim.api.nvim_win_get_tabpage(w) == tab)
	end

	local function relayout()
		if players[buf] ~= player then
			return
		end
		local tab = vim.api.nvim_get_current_tabpage()
		if not shows(win, tab) then
			-- follow the buffer to another window showing it (e.g. after :only)
			local other = vim.iter(vim.fn.win_findbuf(buf)):find(function(w)
				return shows(w, tab)
			end)
			if other then
				win = other
			elseif shows(win) then
				-- only on another tab: remove the image and pause until we come back
				if not player.hidden then
					player.hidden = true
					timer:stop()
					ipc(player.sock, { "set_property", "pause", true })
					vim.api.nvim_ui_send((clear or "") .. delete_at(g))
					clear = nil
				end
				return
			else
				return M.stop(buf)
			end
		end
		local was_hidden = player.hidden
		if was_hidden then
			player.hidden = false
			ipc(player.sock, { "set_property", "pause", player.paused })
		end
		local ng = geometry(win)
		if same(ng, g) then
			if was_hidden and last then
				render(last)
			end
			return
		end
		if not was_hidden then
			clear = (clear or "") .. delete_at(g)
		end
		g = ng
		if last then
			render(last)
		end
		timer:start(400, 0, vim.schedule_wrap(maybe_relaunch))
	end

	vim.api.nvim_create_autocmd({ "WinResized", "VimResized", "WinClosed", "WinNew", "TabEnter" }, {
		group = group,
		callback = vim.schedule_wrap(relayout),
	})
	-- IPC is async and may not land before nvim exits; kill directly
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			proc:kill(15)
		end,
	})
end

function M.stop(buf)
	local player = players[buf]
	if player then
		ipc(player.sock, { "quit" })
	end
end

-- BufReadCmd handler: keep the binary out of the buffer, play on display
function M.attach(buf)
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modifiable = false
	vim.bo[buf].filetype = "video"

	local function map(lhs, fn, desc)
		vim.keymap.set("n", lhs, fn, { buffer = buf, desc = desc, nowait = true })
	end
	local function send(cmd)
		return function()
			local player = players[buf]
			if player then
				ipc(player.sock, cmd)
			end
		end
	end
	map("p", function()
		local player = players[buf]
		if player then
			player.paused = not player.paused
			ipc(player.sock, { "set_property", "pause", player.paused })
		else
			M.play(buf, vim.api.nvim_get_current_win())
		end
	end, "Video: play/pause")
	map("q", function()
		M.stop(buf)
	end, "Video: stop")
	map("l", send({ "seek", 5 }), "Video: +5s")
	map("h", send({ "seek", -5 }), "Video: -5s")
	map("m", send({ "cycle", "mute" }), "Video: mute")

	vim.api.nvim_create_autocmd("BufWinEnter", {
		buffer = buf,
		callback = function()
			local win = vim.api.nvim_get_current_win()
			vim.schedule(function()
				if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
					M.play(buf, win)
				end
			end)
		end,
	})
	vim.api.nvim_create_autocmd("BufWinLeave", {
		buffer = buf,
		callback = function()
			M.stop(buf)
		end,
	})
end

return M
