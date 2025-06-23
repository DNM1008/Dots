return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		-- Define linters for different file types
		lint.linters_by_ft = {
			bash = { "shellcheck" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			markdown = { "markdownlint-cli2" },
			typescriptreact = { "eslint_d" },
			sh = { "shellcheck" },
			svelte = { "eslint_d" },
			-- python = { "pylint" },
			python = { "ruff" },
		}

		-- Configure diagnostic signs to replace deprecated sign_define()
		vim.diagnostic.config({
			signs = {
				severity = {
					min = vim.diagnostic.severity.HINT,
				},
			},
			virtual_text = true, -- Show diagnostic messages directly in the code
			update_in_insert = false, -- Disable diagnostics in insert mode
			underline = true, -- Underline diagnostics
		})

		-- Optional: Define custom symbols for diagnostics
		local signs = { Error = "✘", Warn = "▲", Info = "●", Hint = "▪" }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		-- Create an autocommand group for linting
		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		-- Keybinding to manually trigger linting
		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
