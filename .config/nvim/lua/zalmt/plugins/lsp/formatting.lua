return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				bash = { "beautysh" },
				css = { "prettierd" },
				html = { "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "markdownlint" },
				["markdown.mdx"] = { "prettier" },
				graphql = { "prettier" },
				liquid = { "prettier" },
				lua = { "stylua" },
				-- python = { "isort", "black" },
				python = { "isort", "ruff" },
			},
			formatters = {
				black = {
					command = "black",
					args = { "--line-length", "79", "$FILENAME" },
					stdin = false,
				},
				isort = {
					command = "isort",
					args = { "$FILENAME" },
					-- stdin = true,
					stdin = false,
				},
				markdownlint = {
					command = "markdownlint-cli2",
					args = { "--fix", "$FILENAME" },
					stdin = false,
				},
				ruff = {
					command = "ruff",
					args = { "format", "$FILENAME" },
					stdin = false,
				},
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 5000,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
