return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"s1n7ax/nvim-window-picker",
	},
	config = function()
		local nvimtree = require("nvim-tree")

		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		-- helper: write buffer in target window before replacement
		local function write_buffer_in_window(winid)
			if not winid or not vim.api.nvim_win_is_valid(winid) then
				return
			end

			local bufnr = vim.api.nvim_win_get_buf(winid)

			if
				vim.api.nvim_buf_is_valid(bufnr)
				and vim.bo[bufnr].modifiable
				and vim.bo[bufnr].modified
				and vim.bo[bufnr].buftype == ""
			then
				vim.api.nvim_buf_call(bufnr, function()
					vim.cmd("silent write")
				end)
			end
		end

		nvimtree.setup({
			open_on_tab = true,
			update_cwd = true,

			view = {
				width = 45,
				relativenumber = true,
			},

			renderer = {
				indent_markers = { enable = true },
				icons = {
					glyphs = {
						folder = {
							arrow_closed = "",
							arrow_open = "",
						},
					},
				},
			},

			actions = {
				open_file = {
					window_picker = {
						enable = true,
						picker = function()
							local ok, window_picker = pcall(require, "window-picker")
							if not ok then
								return nil
							end

							local wins = vim.tbl_filter(function(win_id)
								local bufnr = vim.api.nvim_win_get_buf(win_id)
								local ft = vim.bo[bufnr].filetype
								local bt = vim.bo[bufnr].buftype

								local excluded_ft = { "NvimTree", "neo-tree", "notify" }
								local excluded_bt = { "terminal", "quickfix" }

								return not vim.tbl_contains(excluded_ft, ft) and not vim.tbl_contains(excluded_bt, bt)
							end, vim.api.nvim_list_wins())

							-- no valid windows -> create split
							if #wins == 0 then
								local tree_win
								for _, win in ipairs(vim.api.nvim_list_wins()) do
									local bufnr = vim.api.nvim_win_get_buf(win)
									if vim.bo[bufnr].filetype == "NvimTree" then
										tree_win = win
										break
									end
								end

								if tree_win then
									vim.api.nvim_set_current_win(tree_win)
									vim.cmd("rightbelow vsplit")
									local win = vim.api.nvim_get_current_win()
									write_buffer_in_window(win)
									return win
								end

								vim.cmd("vsplit")
								local win = vim.api.nvim_get_current_win()
								write_buffer_in_window(win)
								return win
							end

							-- exactly one valid window
							if #wins == 1 then
								write_buffer_in_window(wins[1])
								return wins[1]
							end

							-- multiple windows -> picker
							local picked = window_picker.pick_window()
							write_buffer_in_window(picked)
							return picked
						end,
					},
				},
			},

			filters = {
				custom = { ".DS_Store" },
			},

			git = {
				ignore = false,
			},

			on_attach = function(bufnr)
				local api = require("nvim-tree.api")
				api.config.mappings.default_on_attach(bufnr)

				local function opts(desc)
					return {
						desc = "nvim-tree: " .. desc,
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true,
					}
				end

				vim.keymap.set("n", "<leader>v", api.node.open.vertical, opts("Open: Vertical Split"))
			end,
		})

		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				require("nvim-tree.api").tree.open({ focus = false })
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local bufnr = vim.api.nvim_win_get_buf(win)
					if vim.bo[bufnr].filetype ~= "NvimTree" then
						vim.api.nvim_set_current_win(win)
						break
					end
				end
			end,
		})

		local keymap = vim.keymap
		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
		keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle explorer on file" })
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
	end,
}
