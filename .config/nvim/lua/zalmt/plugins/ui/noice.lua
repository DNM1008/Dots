return {
	"folke/noice.nvim",
	event = "CmdLineEnter",
	dependencies = {
		"MunifTanjim/nui.nvim", -- required for Noice UI
		"rcarriga/nvim-notify", -- fancy notifications
	},
	config = function()
		-- grab Catppuccin colors
		local normal_bg = vim.fn.synIDattr(vim.fn.hlID("NormalFloat"), "bg") or "#1E1E2E"
		local border_fg = vim.fn.synIDattr(vim.fn.hlID("FloatBorder"), "fg") or "#F5E0DC"

		-- setup nvim-notify
		local notify = require("notify")
		notify.setup({
			background_colour = normal_bg, -- pull from Catppuccin
			fps = 60,
			render = "compact",
			stages = "fade",
		})
		vim.notify = notify -- redirect vim.notify

		-- setup noice.nvim
		require("noice").setup({
			views = {
				cmdline_popup = {
					position = {
						row = 5,
						col = "50%",
					},
					size = {
						width = 60,
						height = "auto",
					},
				},
				popupmenu = {
					relative = "editor",
					position = {
						row = 8,
						col = "50%",
					},
					size = {
						width = 60,
						height = 10,
					},
					border = {
						style = "rounded",
						padding = { 0, 1 },
					},
					win_options = {
						winhighlight = { Normal = "Normal", FloatBorder = "DiagnosticInfo" },
					},
				},
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					-- view = "notify",
					view = "mini",
					filter = { event = "msg_show", min_height = 0 },
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
			},
			cmdline = {
				format = {
					cmdline = { pattern = "^:", icon = "", lang = "vim" },
					search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
					search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
					filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
					lua = { pattern = "^:%s*lua%s+", icon = "", lang = "lua" },
					help = { pattern = "^:%s*h%s+", icon = "?", lang = "vim" },
				},
			},
			history = { view = "split" },
			scroll = { scroll_down = "<C-d>", scroll_up = "<C-u>" },
		})

		-- override Noice highlights to match Catppuccin
		vim.api.nvim_set_hl(0, "NoicePopup", { bg = normal_bg })
		vim.api.nvim_set_hl(0, "NoicePopupBorder", { fg = border_fg })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = normal_bg })
		vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { fg = border_fg })
		vim.api.nvim_set_hl(0, "NoiceMini", { bg = normal_bg })
		vim.api.nvim_set_hl(0, "NoiceError", { fg = "#F38BA8" }) -- optional, accent
		vim.api.nvim_set_hl(0, "NoiceWarn", { fg = "#F9E2AF" })
		vim.api.nvim_set_hl(0, "NoiceInfo", { fg = "#89B4FA" })

		-- optional keymaps
		vim.keymap.set("n", "<leader>nl", function()
			require("noice").cmd("last")
		end, { desc = "Show last message" })

		vim.keymap.set("n", "<leader>nh", function()
			require("noice").cmd("history")
		end, { desc = "Show message history" })
	end,
}
