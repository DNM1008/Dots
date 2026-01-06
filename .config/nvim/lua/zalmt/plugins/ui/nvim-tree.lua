return {
	"nvim-tree/nvim-tree.lua",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"s1n7ax/nvim-window-picker",
	},

	config = function()
		-- Disable netrw early
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		local nvimtree = require("nvim-tree")
		local api = require("nvim-tree.api")

		local window = require("zalmt.utils.window")
		local tree_utils = require("zalmt.utils.nvim-tree")

		nvimtree.setup({
			open_on_tab = false,
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
						picker = window.pick_or_create_window,
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

		-- Lifecycle behaviour
		tree_utils.open_on_startup()
		tree_utils.auto_close_on_last_window()

		-- User keymaps
		local keymap = vim.keymap
		keymap.set("n", "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
		keymap.set("n", "<leader>ef", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Toggle explorer on file" })
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" })
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
	end,
}
