return {
	"folke/noice.nvim",
	event = "CmdLineEnter",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		-- =========================
		-- Catppuccin palette
		-- =========================
		local ok, palettes = pcall(require, "catppuccin.palettes")
		if not ok then
			return
		end

		local palette = palettes.get_palette()

		-- =========================
		-- nvim-notify (Catppuccin)
		-- =========================
		local notify = require("notify")
		notify.setup({
			background_colour = palette.base, -- true Catppuccin background
			fps = 60,
			render = "plain",
			stages = "fade",
			timeout = 3000,
		})

		vim.notify = notify

		-- =========================
		-- noice.nvim (behaviour)
		-- =========================
		require("noice").setup({
			views = {
				cmdline_popup = {
					position = { row = 5, col = "50%" },
					size = { width = 60, height = "auto" },
				},
				popupmenu = {
					relative = "editor",
					position = { row = 8, col = "50%" },
					size = { width = 60, height = 10 },
					border = {
						style = "rounded",
						padding = { 0, 1 },
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

		-- =========================
		-- Noice + Catppuccin highlights
		-- =========================
		local function apply_highlights()
			local p = require("catppuccin.palettes").get_palette()
			local hl = vim.api.nvim_set_hl

			-- Surfaces
			hl(0, "NoicePopup", { bg = p.mantle, fg = p.text })
			hl(0, "NoiceCmdlinePopup", { bg = p.mantle, fg = p.text })
			hl(0, "NoiceMini", { bg = p.base, fg = p.text })

			-- Borders
			hl(0, "NoicePopupBorder", { fg = p.lavender })
			hl(0, "NoiceCmdlinePopupBorder", { fg = p.lavender })

			-- Message levels
			hl(0, "NoiceError", { fg = p.red })
			hl(0, "NoiceWarn", { fg = p.yellow })
			hl(0, "NoiceInfo", { fg = p.blue })
			hl(0, "NoiceHint", { fg = p.teal })
		end

		apply_highlights()

		-- Reapply after :colorscheme
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = apply_highlights,
		})

		-- =========================
		-- Optional keymaps
		-- =========================
		vim.keymap.set("n", "<leader>nl", function()
			require("noice").cmd("last")
		end, { desc = "Noice last message" })

		vim.keymap.set("n", "<leader>nh", function()
			require("noice").cmd("history")
		end, { desc = "Noice history" })
	end,
}
