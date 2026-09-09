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
		lazygit = {
			enabled = true,
		},
		image = {
			enabled = true,
			-- pdf handled separately in core/pdf.lua with page navigation
			formats = {
				"png",
				"jpg",
				"jpeg",
				"gif",
				"bmp",
				"webp",
				"tiff",
				"heic",
				"avif",
				"mp4",
				"mov",
				"avi",
				"mkv",
				"webm",
				"icns",
			},
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
		zen = {
			enabled = true,
			toggles = {
				dim = true,
				git_signs = false,
				mini_diff_signs = false,
				diagnostics = false,
				inlay_hints = false,
			},
			show = {
				statusline = false,
				tabline = false,
			},
			win = {
				style = "zen",
				width = 0.6,
				backdrop = { transparent = true, blend = 40 },
				wo = {
					number = false,
					relativenumber = false,
					signcolumn = "no",
					cursorline = false,
					cursorcolumn = false,
					foldcolumn = "0",
					list = false,
				},
			},
		},

		explorer = { enabled = false },
		notifier = { enabled = false },
		scope = { enabled = false },
		statuscolumn = { enabled = false },
	},
}
