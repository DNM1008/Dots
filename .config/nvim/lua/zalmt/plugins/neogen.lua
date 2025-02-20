return {
	"danymat/neogen",
	dependencies = "nvim-treesitter/nvim-treesitter",
	config = function()
		require("neogen").setup({
			enabled = true,
			input_after_comment = true, -- Cursor moves into the comment after generation
		})
	end,
	keys = {
		{ "<leader>nd", "<cmd>lua require('neogen').generate()<CR>", desc = "Generate docstring" },
	},
}
