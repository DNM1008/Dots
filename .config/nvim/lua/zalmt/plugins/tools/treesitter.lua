return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},

	opts = function()
		return {
			auto_install = true,

			ensure_installed = {
				"bash",
				"css",
				"gitignore",
				"html",
				"javascript",
				"json",
				"lua",
				"markdown",
				"markdown_inline",
				"prisma",
				"python",
				"query",
				"svelte",
				"vim",
				"vimdoc",
				"yaml",
				"comment",
			},

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
				disable = function(_, buf)
					local name = vim.api.nvim_buf_get_name(buf)
					return name ~= "" and vim.fn.getfsize(name) > 100 * 1024
				end,
			},

			autotag = { enable = true },
			incremental_selection = { enable = false },
			indent = { enable = false },
		}
	end,
}
