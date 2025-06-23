return {
	"nvim-treesitter/nvim-treesitter",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local treesitter = require("nvim-treesitter.configs")

		treesitter.setup({
			auto_install = true,
			autotag = {
				enable = true,
			},
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
			},
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = true,
			},
			ignore_install = {},
			incremental_selection = {
				enable = false, -- ⏳ Disabling if not actively used to reduce processing overhead
			},
			indent = {
				enable = false, -- 🚀 Treesitter indent can be slow, consider disabling it
			},
			modules = {},
			sync_install = false,
			-- 🔥 Performance: Disable Treesitter for large files
			disable = function(lang, buf)
				local max_filesize = 100 * 1024 -- 100 KB
				local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
				if ok and stats and stats.size > max_filesize then
					return true
				end
			end,
		})
	end,
}
