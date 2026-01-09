---------------------
-- Globals
---------------------
vim.g.mapleader = " "
local keymap = vim.keymap

---------------------
-- Helpers
---------------------
local win_utils = require("zalmt.utils.window")
local terminal = require("zalmt.utils.terminal")

---------------------
-- General Keymaps
---------------------

-- Clear search highlight
keymap.set("n", "<leader>nh", "<cmd>nohl<CR>", { desc = "Clear search highlights" })

-- Window management (Alpha splits)
keymap.set("n", "<leader>sv", function()
	vim.cmd("vnew")
	vim.cmd("Alpha")
end, { desc = "Vertical split with Alpha" })

keymap.set("n", "<leader>sh", function()
	vim.cmd("new")
	vim.cmd("Alpha")
end, { desc = "Horizontal split with Alpha" })

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
--- Lazygit
---------------------
-- keymap.set("n", "<leader>gg", require("zalmt.core.lazygit").open, { desc = "LazyGit (Snacks)" })
keymap.set("n", "<leader>gg", function()
	require("snacks").lazygit()
end, { desc = "LazyGit (Snacks)" })

---------------------
--- Lazy
---------------------
keymap.set("n", "<leader>lz", "<cmd>Lazy<CR>", { desc = "Lazy" })
keymap.set("n", "<leader>ls", "<cmd>Lazy sync<CR>", { desc = "Lazy sync" })
keymap.set("n", "<leader>lu", "<cmd>Lazy update<CR>", { desc = "Lazy update" })
keymap.set("n", "<leader>lx", "<cmd>Lazy clean<CR>", { desc = "Lazy clean" })

---------------------
--- Mason
---------------------
keymap.set("n", "<leader>m", "<cmd>Mason<CR>", { desc = "Mason" })

---------------------
-- Terminal Toggle
---------------------
keymap.set("n", "<leader><CR>", function()
	terminal.toggle(20)
end, { silent = true })

keymap.set("t", "<leader><CR>", "<C-\\><C-n>:lua require('zalmt.utils.terminal').toggle(20)<CR>", { silent = true })

keymap.set("t", "<Esc>", "<C-\\><C-n>", { silent = true })

---------------------
-- Better wrapped-line movement
---------------------

keymap.set("n", "j", "gj", { desc = "Visual down" })
keymap.set("n", "k", "gk", { desc = "Visual up" })
