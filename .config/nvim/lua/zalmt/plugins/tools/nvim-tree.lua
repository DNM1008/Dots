return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"s1n7ax/nvim-window-picker",
	},
	config = function()
		local nvimtree = require("nvim-tree")
		local tree_utils = require("zalmt.utils.nvim-tree")
		-- local preview = require("nvim-tree-preview")
		-- preview.setup()

		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		nvimtree.setup({
			open_on_tab = true,
			update_cwd = true,

			view = {
				-- width = 40,
				width = 35,
				relativenumber = true,
				adaptive_size = true,
			},

			renderer = {
				indent_markers = { enable = true },

				icons = {
					glyphs = {
						folder = {
							arrow_closed = "",
							arrow_open = "",
						},
					},
				},
			},

			actions = {
				open_file = {
					window_picker = {
						enable = true,
						picker = tree_utils.pick_window,
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

				-- keymaps to toggle preview and open in vertical/horizontal splits
				-- vim.keymap.set("n", "<Tab>", preview.watch, { buffer = bufnr, desc = "Preview" })
				-- vim.keymap.set("n", "<Esc>", preview.unwatch, { buffer = bufnr, desc = "Preview Stop" })
				vim.keymap.set("n", "<leader>v", api.node.open.vertical, opts("Open: Vertical Split"))
				vim.keymap.set("n", "<leader>h", api.node.open.horizontal, opts("Open: Horizonta Split"))
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

		-- nvim-tree's fs watcher only covers its own root; when opened in a
		-- subdirectory of a larger repo, git status changes at the repo root
		-- (e.g. `git add`, `git commit`) never trigger a re-render. Force a
		-- reload on refocus so decorations stay in sync.
		vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
			callback = function()
				if tree_utils.find_tree_window() then
					require("nvim-tree.api").tree.reload()
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
