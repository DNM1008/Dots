local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ import = "zalmt.plugins" },
	{ import = "zalmt.plugins.lsp" },
	{ import = "zalmt.plugins.ui" },
	{ import = "zalmt.plugins.editor" },
	{ import = "zalmt.plugins.completion" },
	{ import = "zalmt.plugins.tools" },
}, {
	checker = {
		enabled = true,
		notify = false,
	},
	change_detection = {
		notify = false,
	},
})
