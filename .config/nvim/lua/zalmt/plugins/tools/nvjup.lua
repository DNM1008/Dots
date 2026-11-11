local awrit = vim.fn.stdpath("data") .. "/lazy/awrit"

return {
	-- not a nvim plugin: lazy only clones it and runs its setup (bun + electron)
	-- so nvjup's <leader>nF works on a fresh install
	{
		"chase/awrit",
		branch = "electron",
		lazy = true,
		build = "./setup.sh",
	},
	{
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
		opts = {
			interactive = { awrit_command = { awrit .. "/awrit" } },
		},
	},
}
