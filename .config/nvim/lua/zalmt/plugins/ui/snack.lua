return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	dependencies = {
		{ "nvim-tree/nvim-web-devicons", version = "*" },
	},
	opts = {
		animate = {
			duration = 0.5,
			easing = "linear",
		},
		bigfile = { enabled = true, size = 50 * 1024 * 1024 },
		image = {
			enabled = true,
			-- doc = {
			-- 	enabled = true,
			-- },
		},
		indent = { enabled = true },
		-- Enable the input module (replaces vim.ui.input / dressing input)
		input = {
			enabled = true,
			-- Optional: customise appearance if you want
			border = "rounded",
			width = 50,
			prompt_align = "left",
		},
		-- Enable the picker module (replaces vim.ui.select / dressing select)
		picker = {
			enabled = true,
			-- Optional: customise the picker style
			theme = "cursor",
		},
		quickfile = { enabled = true },
		scroll = {
			enabled = true,
		},
		words = { enabled = true },

		explorer = { enabled = false },
		notifier = { enabled = false },
		scope = { enabled = false },
		statuscolumn = { enabled = false },
	},
}
