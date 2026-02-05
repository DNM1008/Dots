return {
	"chaoren/vim-wordmotion",
	config = function()
		-- Treat underscores as spaces
		vim.g.wordmotion_spaces = "_"

		-- Make default motions (w, e, b, iw, aw, etc.) respect this
		vim.g.wordmotion_prefix = ""
	end,
}
