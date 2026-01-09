return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "macchiato",
				transparent_background = true,
				integrations = {
					treesitter = true,
					nvimtree = {
						enabled = true,
						show_root = true,
						transparent_panel = true,
					},
				},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
