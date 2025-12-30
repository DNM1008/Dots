---------------------
-- Globals
---------------------
local term_buf = nil
local term_win = nil

vim.g.mapleader = " "
local keymap = vim.keymap

---------------------
-- Helpers
---------------------

local function count_visible_editor_windows()
	local count = 0

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)

		if
			vim.api.nvim_win_get_config(win).relative == ""
			and vim.bo[buf].filetype ~= "NvimTree"
			and buf ~= term_buf
		then
			count = count + 1
		end
	end

	return count
end

local function get_nvimtree_width()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "NvimTree" then
			return vim.api.nvim_win_get_width(win)
		end
	end
	return 0
end

---------------------
-- General Keymaps
---------------------

-- Clear search highlight
keymap.set("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Clear search highlights" })

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalise splits" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- Resize splits
keymap.set("n", "<A-Left>", "<cmd>vertical resize -2<CR>", { silent = true })
keymap.set("n", "<A-Right>", "<cmd>vertical resize +2<CR>", { silent = true })
keymap.set("n", "<A-Up>", "<cmd>resize +2<CR>", { silent = true })
keymap.set("n", "<A-Down>", "<cmd>resize -2<CR>", { silent = true })

-- Tabs
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "New tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close tab" })
keymap.set("n", "<leader>tn", "<cmd>tabnext<CR>", { desc = "Next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabprev<CR>", { desc = "Previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Buffer to new tab" })
keymap.set("n", "<leader>tl", "<cmd>tabs<CR>", { desc = "List tabs" })

---------------------
-- Terminal Toggle
---------------------

function TermToggle(size)
	-- Hide if visible
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.cmd("hide")
		term_win = nil
		return
	end

	local is_vertical = count_visible_editor_windows() == 1

	if is_vertical then
		vim.cmd("botright vnew")

		local usable_width = vim.o.columns - get_nvimtree_width()
		local half_width = math.floor(usable_width * 0.5)

		vim.cmd("vertical resize " .. half_width)
	else
		vim.cmd("botright new")
		vim.cmd("resize " .. size)
	end

	local scratch_buf = vim.api.nvim_get_current_buf()

	if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
		vim.cmd("buffer " .. term_buf)
		vim.cmd("bd " .. scratch_buf)
	else
		vim.cmd("terminal")
		term_buf = vim.api.nvim_get_current_buf()

		vim.wo.number = false
		vim.wo.relativenumber = false
		vim.wo.signcolumn = "no"
	end

	vim.cmd("startinsert!")
	term_win = vim.api.nvim_get_current_win()
end

---------------------
-- Terminal Keymaps
---------------------

keymap.set("n", "<leader><CR>", function()
	TermToggle(20)
end, { silent = true })

keymap.set("t", "<leader><CR>", "<C-\\><C-n>:lua TermToggle(20)<CR>", { silent = true })
keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })

---------------------
-- Better wrapped-line movement
---------------------

keymap.set("n", "j", "gj", { desc = "Visual down" })
keymap.set("n", "k", "gk", { desc = "Visual up" })
