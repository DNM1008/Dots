local M = {}

local cache_dir = vim.fn.stdpath("cache") .. "/pdfview"

local function page_count(file)
	local out = vim.fn.system({ "pdfinfo", file })
	return tonumber(out:match("Pages:%s*(%d+)")) or 1
end

-- rasterize via pdftoppm (poppler) directly: imagemagick's PDF coder is
-- blocked by policy.xml on this system, so snacks.image's magick-based
-- pdf conversion never actually runs.
local function render_page(file, page)
	vim.fn.mkdir(cache_dir, "p")
	local prefix = cache_dir .. "/" .. vim.fn.sha256(file):sub(1, 12) .. "-p" .. page
	local existing = vim.fn.glob(prefix .. "*.png", false, true)
	if #existing > 0 then
		return existing[1]
	end
	vim.fn.system({
		"pdftoppm", "-png", "-r", "150",
		"-f", tostring(page), "-l", tostring(page),
		file, prefix,
	})
	local out = vim.fn.glob(prefix .. "*.png", false, true)
	return out[1]
end

local function render(buf, file, page, total)
	if not vim.api.nvim_buf_is_valid(buf) then
		return
	end
	local png = render_page(file, page)
	if not png then
		vim.notify("pdftoppm failed to render page " .. page, vim.log.levels.ERROR)
		return
	end
	Snacks.image.placement.clean(buf)
	Snacks.util.bo(buf, {
		filetype = "image",
		modifiable = false,
		modified = false,
		swapfile = false,
	})
	vim.b[buf].pdf_page = page
	vim.b[buf].pdf_total = total
	vim.b[buf].pdf_file = file
	Snacks.image.placement.new(buf, png, {
		conceal = true,
		auto_resize = true,
	})
	vim.wo.statusline = ("%s — page %d/%d"):format(vim.fn.fnamemodify(file, ":t"), page, total)
end

local function goto_page(buf, delta)
	local page = (vim.b[buf].pdf_page or 1) + delta
	local total = vim.b[buf].pdf_total or 1
	page = math.max(1, math.min(total, page))
	render(buf, vim.b[buf].pdf_file, page, total)
end

function M.attach(buf)
	local file = vim.api.nvim_buf_get_name(buf)
	local total = page_count(file)
	render(buf, file, 1, total)

	local opts = { buffer = buf, silent = true, nowait = true }
	vim.keymap.set("n", "J", function()
		goto_page(buf, 1)
	end, opts)
	vim.keymap.set("n", "K", function()
		goto_page(buf, -1)
	end, opts)
	vim.keymap.set("n", "<PageDown>", function()
		goto_page(buf, 1)
	end, opts)
	vim.keymap.set("n", "<PageUp>", function()
		goto_page(buf, -1)
	end, opts)
	vim.keymap.set("n", "gg", function()
		render(buf, file, 1, total)
	end, opts)
	vim.keymap.set("n", "G", function()
		render(buf, file, total, total)
	end, opts)
	vim.keymap.set("n", "gz", function()
		vim.fn.jobstart({ "zathura", file }, { detach = true })
	end, opts)
end

return M
