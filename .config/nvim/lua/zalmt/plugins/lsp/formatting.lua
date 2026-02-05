return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				-- Web
				javascript = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				svelte = { "prettierd", "prettier" },
				css = { "prettierd", "prettier" },
				html = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				yaml = { "prettierd", "prettier" },
				markdown = { "prettierd", "prettier" },
				graphql = { "prettierd", "prettier" },
				liquid = { "prettierd", "prettier" },

				-- Lua
				lua = { "stylua" },

				-- Python
				-- python = { "isort", "black" }, -- or { "ruff_format" }
				python = { "ruff_format" },

				-- Shell
				sh = { "shfmt" },
				bash = { "shfmt" },

				-- Go
				go = { "gofmt" },

				-- Rust
				rust = { "rustfmt" },

				-- C / C++
				c = { "clang_format" },
				cpp = { "clang_format" },
			},

			format_on_save = {
				lsp_fallback = true,
				timeout_ms = 3000,
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
