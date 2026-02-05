return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},

	opts = function()
		-- custom parser injection (safe + lazy-correct)
		local ok, parsers = pcall(require, "nvim-treesitter.parsers")
		if ok and type(parsers.get_parser_configs) == "function" then
			parsers.get_parser_configs().comment = {
				install_info = {
					url = "https://github.com/OXY2DEV/tree-sitter-comment",
					files = { "src/parser.c" },
					branch = "main",
					queries = "queries/",
				},
			}
		end

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
