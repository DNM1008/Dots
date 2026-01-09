-- core/highlights.lua
-- Small, intentional highlight overrides

local augroup = vim.api.nvim_create_augroup("UserHighlights", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
	group = augroup,
	callback = function()
		-- LSP semantic tokens (style only, no colours)
		vim.api.nvim_set_hl(0, "@lsp.type.parameter", { italic = true })
		vim.api.nvim_set_hl(0, "@lsp.type.property", { italic = false })

		-- LSP references (subtle background, works with Catppuccin)
		vim.api.nvim_set_hl(0, "LspReferenceText", { underline = false })
		vim.api.nvim_set_hl(0, "LspReferenceRead", { underline = false })
		vim.api.nvim_set_hl(0, "LspReferenceWrite", { underline = false })

		-- Floating windows (keep transparency consistent)
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

		-- Cursor line number emphasis
		vim.api.nvim_set_hl(0, "CursorLineNr", { bold = true })
	end,
})
