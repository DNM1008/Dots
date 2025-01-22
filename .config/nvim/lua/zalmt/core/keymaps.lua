-- Set leader key to space
vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

---------------------
-- General Keymaps -------------------

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- Increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- Window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- Resizing splits with Alt key
keymap.set("n", "<A-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })
keymap.set("n", "<A-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })
keymap.set("n", "<A-Up>", ":resize +2<CR>", { noremap = true, silent = true })
keymap.set("n", "<A-Down>", ":resize -2<CR>", { noremap = true, silent = true })

-- Tab management
keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
keymap.set("n", "<leader>tl", ":tabs<CR>", { desc = "List all tabs" }) -- List all tabs

-----------------------
-- Terminal Toggle Function -------------------

function TermToggle(height)
	if term_win and vim.api.nvim_win_is_valid(term_win) then
		vim.cmd("hide")
	else
		vim.cmd("botright new")
		local new_buf = vim.api.nvim_get_current_buf()
		vim.cmd("resize " .. height)
		if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
			vim.cmd("buffer " .. term_buf) -- go to terminal buffer
			vim.cmd("bd " .. new_buf) -- cleanup new buffer
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
end
-- Terminal keymaps
keymap.set("n", "<leader><CR>", function()
	TermToggle(20)
end, { noremap = true, silent = true })
keymap.set("i", "<leader><CR>", "<Esc>:lua TermToggle(20)<CR>", { noremap = true, silent = true })
keymap.set("t", "<leader><CR>", "<C-\\><C-n>:lua TermToggle(20)<CR>", { noremap = true, silent = true })
keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

-- Improve movement with wrapped lines
keymap.set("n", "j", "gj", { desc = "Move down visually" })
keymap.set("n", "k", "gk", { desc = "Move up visually" })
