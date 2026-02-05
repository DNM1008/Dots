return {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				-- Core
				flavour = "macchiato",
				background = {
					light = "latte",
					dark = "macchiato",
				},
				transparent_background = true,
				show_end_of_buffer = false,
				term_colors = false,

				-- Floating windows
				float = {
					transparent = true,
					solid = false,
				},

				-- Inactive window dimming
				dim_inactive = {
					enabled = false,
					shade = "dark",
					percentage = 0.15,
				},

				-- Font styles
				no_italic = false,
				no_bold = false,
				no_underline = false,

				styles = {
					comments = { "italic" },
					conditionals = { "italic" },
					loops = {},
					functions = {},
					keywords = {},
					strings = {},
					variables = {},
					numbers = {},
					booleans = {},
					properties = {},
					types = {},
					operators = {},
				},

				-- LSP styling
				lsp_styles = {
					virtual_text = {
						errors = { "italic" },
						hints = { "italic" },
						warnings = { "italic" },
						information = { "italic" },
						ok = { "italic" },
					},
					underlines = {
						errors = { "underline" },
						hints = { "underline" },
						warnings = { "underline" },
						information = { "underline" },
						ok = { "underline" },
					},
					inlay_hints = {
						background = true,
					},
				},

				-- Integrations
				default_integrations = true,
				auto_integrations = false,
				integrations = {
					treesitter = true,
					cmp = true,
					gitsigns = true,

					---@diagnostic disable-next-line: assign-type-mismatch
					nvimtree = {
						enabled = true,
						show_root = true,
						transparent_panel = true,
					},

					mini = {
						enabled = true,
						indentscope_color = "",
					},

					notify = false,
				},

				-- Overrides
				color_overrides = {},
				custom_highlights = {},
			})

			vim.cmd.colorscheme("catppuccin")
		end,
	},
}
