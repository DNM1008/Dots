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
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false, -- 🏎️ Disable regex-based highlighting for speed
			},
			indent = {
				enable = false, -- 🚀 Treesitter indent can be slow, consider disabling it
			},
			autotag = {
				enable = true,
			},
			ensure_installed = {
				"json",
				"javascript",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"bash",
				"lua",
				"vim",
				"gitignore",
				"query",
				"vimdoc",
			},
			incremental_selection = {
				enable = false, -- ⏳ Disabling if not actively used to reduce processing overhead
			},
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
