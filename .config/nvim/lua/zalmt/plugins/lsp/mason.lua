return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"cssls",
				"emmet_ls",
				"graphql",
				"html",
				"lua_ls",
				"prismals",
				"pyright",
				"pylsp",
				"svelte",
				"tailwindcss",
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"black", -- python formatter
				"isort", -- python formatter
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"eslint_d", -- js linter
				"pylint", -- python linter
				"markdownlint-cli2",
				"markdown-toc",
			},
		})
	end,
}
