return {
	"s1n7ax/nvim-window-picker",
	name = "window-picker",
	event = "VeryLazy",
	config = function()
		require("window-picker").setup({
			hint = "statusline-winbar", -- or "floating-letter", "floating-big-letter"
			selection_chars = "FJDKSLA;CMRUEIWOQP",

			picker_config = {
				statusline_winbar_picker = {
					selection_display = function(char)
						return "%=" .. char .. "%="
					end,
					use_winbar = "never", -- "always" | "never" | "smart"
				},
				floating_big_letter = {
					font = "ansi-shadow",
				},
			},

			show_prompt = true,
			prompt_message = "Pick window: ",

			filter_rules = {
				autoselect_one = true,
				include_current_win = false,
				include_unfocusable_windows = false,
				bo = {
					filetype = { "NvimTree", "neo-tree", "notify", "snacks_notif" },
					buftype = { "terminal" },
				},
			},

			-- This is the part that controls the colors
			highlights = {
				enabled = true,

				-- If you're using 'hint = "statusline-winbar"', these apply
				statusline = {
					focused = {
						fg = "#cad3f5",
						bg = "#a6da95",
						bold = true,
					},
					unfocused = {
						fg = "#939ab7",
						bg = "#24273a",
						bold = false,
					},
				},
				winbar = {
					focused = {
						fg = "#cad3f5",
						bg = "#a6da95",
						bold = true,
					},
					unfocused = {
						fg = "#939ab7",
						bg = "#24273a",
						bold = false,
					},
				},
			},
		})
	end,
}
