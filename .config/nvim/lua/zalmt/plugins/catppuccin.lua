return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000, -- make sure to load this before all the other start plugins
		config = function()
			require("catppuccin").setup({
				transparent_background = true, -- Enable transparency
				integrations = {
					nvimtree = {
						enabled = true,
						show_root = true,
						transparent_panel = true, -- Makes NvimTree transparent too
					},
				},
			})
			-- Load the colorscheme
			vim.cmd([[colorscheme catppuccin]])
		end,
	},
}
