-- Play a video inside a nvim window. mpv's kitty vo writes frames to a pipe,
-- and nvim forwards them to its own UI (nvim_ui_send), so frames never
-- interleave with nvim's redraws the way a second writer on the tty would.
local M = {}

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

function M.play(file, win)
	win = win or vim.api.nvim_get_current_win()
	file = vim.fn.fnamemodify(file, ":p")

	local cell = Snacks.image.terminal.size()
	local pos = vim.api.nvim_win_get_position(win)
	local w, h = vim.api.nvim_win_get_width(win), vim.api.nvim_win_get_height(win)
	local top, left = pos[1] + 1, pos[2] + 1

	local prev = vim.api.nvim_win_get_buf(win)
	local buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "wipe"
	vim.api.nvim_win_set_buf(win, buf)

	local marker = ("\27[%d;%df"):format(top, left)
	local sock = vim.fn.tempname() .. ".mpv"
	local parts, latest, scheduled = {}, nil, false

	local function draw()
		scheduled = false
		local frame = latest
		latest = nil
		if frame and vim.api.nvim_buf_is_valid(buf) then
			vim.api.nvim_ui_send("\0277" .. frame .. "\0278")
		end
	end

	local function push(frame)
		latest = frame
		if not scheduled then
			scheduled = true
			vim.schedule(draw)
		end
	end

	local started = false
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
			push(table.concat(parts))
		end
		started = true
		parts = { data:sub(p) }
	end

	local function cleanup()
		-- frames are anonymous images (kitty drops them when relayed with an i=),
		-- so delete every placement covering the video's top-left cell
		vim.api.nvim_ui_send(("\27_Ga=d,d=P,x=%d,y=%d,q=2\27\\"):format(left, top))
		if vim.api.nvim_win_is_valid(win) and vim.api.nvim_win_get_buf(win) == buf then
			vim.api.nvim_win_set_buf(win, vim.api.nvim_buf_is_valid(prev) and prev or vim.api.nvim_create_buf(true, false))
		end
		os.remove(sock)
	end

	local proc = vim.system({
		"mpv",
		"--no-terminal",
		"--vo=kitty",
		"--vo-kitty-use-shm=no",
		"--vo-kitty-alt-screen=no",
		"--vo-kitty-config-clear=no",
		"--vo-kitty-top=" .. top,
		"--vo-kitty-left=" .. left,
		"--vo-kitty-cols=" .. w,
		"--vo-kitty-rows=" .. h,
		"--vo-kitty-width=" .. math.floor(w * cell.cell_width),
		"--vo-kitty-height=" .. math.floor(h * cell.cell_height),
		"--input-ipc-server=" .. sock,
		file,
	}, { stdout = on_stdout }, vim.schedule_wrap(cleanup))

	local function map(lhs, cmd, desc)
		vim.keymap.set("n", lhs, function()
			ipc(sock, cmd)
		end, { buffer = buf, desc = desc, nowait = true })
	end
	map("q", { "quit" }, "Video: quit")
	map("<Space>", { "cycle", "pause" }, "Video: pause")
	map("p", { "cycle", "pause" }, "Video: pause")
	map("l", { "seek", 5 }, "Video: +5s")
	map("h", { "seek", -5 }, "Video: -5s")
	map("m", { "cycle", "mute" }, "Video: mute")

	-- geometry is fixed at launch; stop rather than draw over other windows
	local group = vim.api.nvim_create_augroup("zalmt_video_" .. buf, {})
	local function stop()
		ipc(sock, { "quit" })
		pcall(vim.api.nvim_del_augroup_by_id, group)
	end
	vim.api.nvim_create_autocmd("BufWipeout", { group = group, buffer = buf, callback = stop })
	-- IPC is async and may not land before nvim exits; kill directly
	vim.api.nvim_create_autocmd("VimLeavePre", {
		group = group,
		callback = function()
			proc:kill(15)
		end,
	})
	local function moved()
		if not vim.api.nvim_win_is_valid(win) then
			return true
		end
		local p = vim.api.nvim_win_get_position(win)
		return p[1] + 1 ~= top or p[2] + 1 ~= left
			or vim.api.nvim_win_get_width(win) ~= w or vim.api.nvim_win_get_height(win) ~= h
	end
	vim.api.nvim_create_autocmd({ "WinResized", "VimResized", "WinClosed", "WinNew" }, {
		group = group,
		callback = vim.schedule_wrap(function()
			if moved() then
				stop()
			end
		end),
	})
end

return M
