---------------------
-- globals
---------------------
local term_buf = nil
local term_win = nil

vim.g.mapleader = " "
local keymap = vim.keymap

---------------------
-- helpers
---------------------

local function get_nvimtree_width()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)

		if vim.bo[buf].filetype == "NvimTree" then
			return vim.api.nvim_win_get_width(win)
		end
	end

	return 0
end

function TermToggle(mode)
	-- close terminal if visible
	if mode == "close" then
		if term_win and vim.api.nvim_win_is_valid(term_win) then
			vim.api.nvim_win_close(term_win, true)
			term_win = nil
		end

		return
	end

	-- create split
	if mode == "vertical" then
		vim.cmd("botright vnew")

		vim.wo.winfixwidth = true
		vim.o.winminwidth = 20

		local usable_width = vim.o.columns - get_nvimtree_width()
		local half_width = math.floor(usable_width * 0.5)

		vim.cmd("vertical resize " .. half_width)
	else
		vim.cmd("botright new")
		vim.cmd("resize 20")
	end

	local scratch_buf = vim.api.nvim_get_current_buf()

	-- reuse terminal buffer
	if term_buf and vim.api.nvim_buf_is_valid(term_buf) and vim.bo[term_buf].buftype == "terminal" then
		vim.cmd("buffer " .. term_buf)
		vim.api.nvim_buf_delete(scratch_buf, { force = true })
	else
		vim.cmd("terminal")
		term_buf = vim.api.nvim_get_current_buf()

		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.wo.signcolumn = "no"
	end

	term_win = vim.api.nvim_get_current_win()

	-- redraw terminal
	local job = vim.b[term_buf].terminal_job_id

	if job then
		vim.api.nvim_chan_send(job, "\x0c")
	end

	vim.cmd("startinsert!")
end

local function swap_with_direction(dir)
	local cur_win = vim.api.nvim_get_current_win()
	local cur_buf = vim.api.nvim_win_get_buf(cur_win)

	vim.cmd("wincmd " .. dir)

	local target_win = vim.api.nvim_get_current_win()

	if cur_win == target_win then
		return
	end

	local target_buf = vim.api.nvim_win_get_buf(target_win)

	vim.api.nvim_win_set_buf(cur_win, target_buf)
	vim.api.nvim_win_set_buf(target_win, cur_buf)

	vim.api.nvim_set_current_win(cur_win)
end

---------------------
-- general Keymaps
---------------------

-- clear search highlight
keymap.set("n", "<leader>ch", "<cmd>nohl<CR>", {
	desc = "Clear search highlights",
})

-- window management
keymap.set("n", "<leader>sv", function()
	vim.cmd("vnew")
	vim.cmd("Alpha")
end, {
	desc = "Vertical split",
})

keymap.set("n", "<leader>sh", function()
	vim.cmd("new")
	vim.cmd("Alpha")
end, {
	desc = "Horizontal split",
})

keymap.set("n", "<leader>se", "<C-w>=", {
	desc = "Equalise splits",
})

keymap.set("n", "<leader>sx", "<cmd>close<CR>", {
	desc = "Close split",
})

-- resize splits
keymap.set("n", "<A-Left>", "<cmd>vertical resize -2<CR>", {
	silent = true,
})

keymap.set("n", "<A-Right>", "<cmd>vertical resize +2<CR>", {
	silent = true,
})

keymap.set("n", "<A-Up>", "<cmd>resize +2<CR>", {
	silent = true,
})

keymap.set("n", "<A-Down>", "<cmd>resize -2<CR>", {
	silent = true,
})

-- move splits
keymap.set("n", "<A-h>", function()
	swap_with_direction("h")
end, {
	desc = "Swap left",
})

keymap.set("n", "<A-j>", function()
	swap_with_direction("j")
end, {
	desc = "Swap down",
})

keymap.set("n", "<A-k>", function()
	swap_with_direction("k")
end, {
	desc = "Swap up",
})

keymap.set("n", "<A-l>", function()
	swap_with_direction("l")
end, {
	desc = "Swap right",
})

-- tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", {
	desc = "New tab",
})

keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", {
	desc = "Close tab",
})

keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", {
	desc = "Next tab",
})

keymap.set("n", "<leader>tp", "<cmd>tabprev<CR>", {
	desc = "Previous tab",
})

keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", {
	desc = "Buffer to new tab",
})

keymap.set("n", "<leader>tl", "<cmd>tabs<CR>", {
	desc = "List tabs",
})

-- lazy
keymap.set("n", "<leader>ls", "<cmd>Lazy sync<CR>", {
	desc = "Lazy sync",
})

keymap.set("n", "<leader>lu", "<cmd>Lazy update<CR>", {
	desc = "Lazy update",
})

keymap.set("n", "<leader>lx", "<cmd>Lazy clean<CR>", {
	desc = "Lazy clean",
})

keymap.set("n", "<leader>lz", "<cmd>Lazy<CR>", {
	desc = "Lazy",
})

-- mason
keymap.set("n", "<leader>ms", "<cmd>Mason<CR>", {
	desc = "Mason",
})

-- lazygit
keymap.set("n", "<leader>gg", function()
	require("snacks").lazygit()
end, {
	desc = "LazyGit (Snacks)",
})

---------------------
-- terminal toggle
---------------------

keymap.set("n", "<leader><CR>h", function()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		TermToggle("close")
	else
		TermToggle("horizontal")
	end
end, {
	silent = true,
	desc = "Terminal horizontal",
})

keymap.set("n", "<leader><CR>v", function()
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		TermToggle("close")
	else
		TermToggle("vertical")
	end
end, {
	silent = true,
	desc = "Terminal vertical",
})

keymap.set("t", "<leader><CR>", function()
	vim.cmd("stopinsert")
	TermToggle("close")
end, {
	silent = true,
})

keymap.set("t", "<Esc>", "<C-\\><C-n>", {
	silent = true,
})

---------------------
-- better wrapped-line movement
---------------------

keymap.set("n", "j", "gj", {
	desc = "Visual down",
})

keymap.set("n", "k", "gk", {
	desc = "Visual up",
})

---------------------
-- markdown preview
---------------------

keymap.set("n", "<leader>pt", "<cmd>RenderMarkdown preview<CR>", {
	desc = "Markdown preview",
})
