return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"BurntSushi/ripgrep",
		"folke/snacks.nvim",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local previewers = require("telescope.previewers")

		local function is_image(path)
			local ext = vim.fn.fnamemodify(path, ":e"):lower()
			return vim.tbl_contains({
				"png",
				"jpg",
				"jpeg",
				"gif",
				"webp",
				"bmp",
			}, ext)
		end

		telescope.setup({
			defaults = {
				path_display = { "smart" },

				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous,
						["<C-j>"] = actions.move_selection_next,
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},

				preview = {
					mime_hook = function(filepath, bufnr, opts)
						if is_image(filepath) then
							vim.schedule(function()
								local win = vim.fn.bufwinid(bufnr)
								if win == -1 then
									return
								end

								require("snacks.image").open(filepath, {
									win = win,
									buf = bufnr,
								})
							end)
						else
							previewers.buffer_previewer_maker(filepath, bufnr, opts)
						end
					end,
				},
			},
		})

		telescope.load_extension("fzf")

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
		keymap.set("n", "<leader>fh", function()
			require("telescope.builtin").find_files({ cwd = vim.fn.expand("~") })
		end, { desc = "Fuzzy find files in home directory" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
		keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
	end,
}
