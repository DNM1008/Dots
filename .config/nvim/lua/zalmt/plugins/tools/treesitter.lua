return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		-- Allow custom parser injection (LuaLS-safe)
		---@type table<string, any>
		local parser_configs = require("nvim-treesitter.parsers").get_parser_configs()

		parser_configs.comment = {
			install_info = {
				url = "https://github.com/OXY2DEV/tree-sitter-comment",
				files = { "src/parser.c" },
				branch = "main",
				queries = "queries/",
			},
		}

		-- Correct the setup() type locally for LuaLS
		---@type fun(opts: table)
		local treesitter_setup = require("nvim-treesitter").setup

		treesitter_setup({
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
					local max_filesize = 100 * 1024 -- 100 KB
					local filename = vim.api.nvim_buf_get_name(buf)

					if filename == "" then
						return false
					end

					local size = vim.fn.getfsize(filename)
					return size > max_filesize
				end,
			},

			autotag = { enable = true },
			incremental_selection = { enable = false },
			indent = { enable = false },
		})
	end,
}
