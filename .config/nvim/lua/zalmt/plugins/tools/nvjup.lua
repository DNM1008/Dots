return {
	"LumbaBalumba/nvjup",
	lazy = false, -- nvjup must register BufReadCmd before an .ipynb is opened
	build = "uv sync --frozen",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"hrsh7th/nvim-cmp",
		"nvim-telescope/telescope.nvim",
		"MeanderingProgrammer/render-markdown.nvim",
		"folke/snacks.nvim",
	},
	opts = {},
}
