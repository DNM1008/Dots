return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local nvimtree = require("nvim-tree")
		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1
		nvimtree.setup({
			open_on_tab = true, -- Open tree when opening a new tab
			update_cwd = true, -- Update cwd when navigating
			view = {
				width = 35,
				relativenumber = true,
			},
			renderer = {
				indent_markers = {
					enable = true,
				},
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "", -- arrow when folder is closed
							arrow_open = "", -- arrow when folder is open
						},
					},
				},
			},
			actions = {
				open_file = {
					window_picker = {
						enable = true,
						picker = function()
							-- Check if window-picker is available
							local ok, window_picker = pcall(require, "window-picker")
							if not ok then
								return nil
							end

							-- Get all valid windows for picking
							local wins = vim.tbl_filter(function(win_id)
								local bufnr = vim.api.nvim_win_get_buf(win_id)
								local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
								local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")

								-- Exclude filtered filetypes and buftypes
								local excluded_ft = { "NvimTree", "neo-tree", "notify" }
								local excluded_bt = { "terminal", "quickfix" }

								return not vim.tbl_contains(excluded_ft, filetype)
									and not vim.tbl_contains(excluded_bt, buftype)
							end, vim.api.nvim_list_wins())

							-- If no valid windows, create a new split to the right
							if #wins == 0 then
								-- Find the nvim-tree window
								local nvim_tree_win = nil
								for _, win_id in pairs(vim.api.nvim_list_wins()) do
									local bufnr = vim.api.nvim_win_get_buf(win_id)
									local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
									if filetype == "NvimTree" then
										nvim_tree_win = win_id
										break
									end
								end

								-- Create a new split to the right of nvim-tree
								if nvim_tree_win then
									vim.api.nvim_set_current_win(nvim_tree_win)
									vim.cmd("rightbelow vsplit")
									return vim.api.nvim_get_current_win()
								else
									-- Fallback if nvim-tree window not found
									vim.cmd("vsplit")
									return vim.api.nvim_get_current_win()
								end
							end

							-- If only one valid window, use it
							if #wins == 1 then
								return wins[1]
							end

							-- Otherwise use window picker
							return window_picker.pick_window()
						end,
						chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
						exclude = {
							filetype = { "NvimTree", "neo-tree", "notify" },
							buftype = { "terminal", "quickfix" },
						},
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
			git = {
				ignore = false,
			},
			-- Custom keymaps using on_attach
			on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				local function opts(desc)
					return {
						desc = "nvim-tree: " .. desc,
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true,
					}
				end
				-- Load default mappings first
				api.config.mappings.default_on_attach(bufnr)
				-- Vertical split
				vim.keymap.set("n", "<leader>v", api.node.open.vertical, opts("Open: Vertical Split"))
			end,
		})

		-- Auto-open on startup with better logic
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				-- Auto-open nvim-tree in these cases:
				-- 1. No arguments (just 'nvim')
				-- 2. Single directory argument ('nvim .')
				if vim.fn.argc() == 0 or (vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1) then
					vim.cmd("NvimTreeOpen")
				end
			end,
		})

		-- Global keymaps
		local keymap = vim.keymap
		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
		keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle explorer on file" })
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
	end,
}
