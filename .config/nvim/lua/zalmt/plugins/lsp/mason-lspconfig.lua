return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/lazydev.nvim", opts = {} },
	},
	config = function()
		-- ─────────────────────────────────────────────
		-- Mason: install servers only
		-- ─────────────────────────────────────────────
		require("mason").setup()

		require("mason-lspconfig").setup({
			ensure_installed = {
				"pyright",
				"lua_ls",
				"clangd",
			},
		})

		-- ─────────────────────────────────────────────
		-- LSP (Neovim 0.11+ API)
		-- ─────────────────────────────────────────────
		vim.lsp.config("pyright", {})
		vim.lsp.enable("pyright")

		vim.lsp.config("clangd", {})
		vim.lsp.enable("clangd")

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
				},
			},
		})
		vim.lsp.enable("lua_ls")

		-- ─────────────────────────────────────────────
		-- Diagnostics UI
		-- ─────────────────────────────────────────────
		vim.diagnostic.config({
			float = { border = "rounded", max_width = 100 },
			severity_sort = true,
			update_in_insert = false,
		})
		-- Faster CursorHold for hover
		vim.o.updatetime = 250

		-- Show diagnostics only for the current cursor position
		vim.api.nvim_create_autocmd("CursorHold", {
			callback = function()
				local cursor_diagnostics = vim.diagnostic.get(0, { scope = "cursor" })
				if #cursor_diagnostics == 0 then
					return
				end

				vim.diagnostic.open_float(nil, {
					focus = false,
					scope = "cursor",
					border = "rounded",
				})
			end,
		})

		local signs = {
			Error = " ",
			Warn = " ",
			Hint = "󰠠 ",
			Info = " ",
		}

		for type, icon in pairs(signs) do
			vim.fn.sign_define("DiagnosticSign" .. type, {
				text = icon,
				texthl = "DiagnosticSign" .. type,
			})
		end

		-- ─────────────────────────────────────────────
		-- LSP keymaps
		-- ─────────────────────────────────────────────
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local map = vim.keymap.set
				local opts = { buffer = ev.buf, silent = true }

				map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
				map("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)
				map("n", "K", vim.lsp.buf.hover, opts)
				map("n", "<leader>rn", vim.lsp.buf.rename, opts)
				map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
				map("n", "[d", vim.diagnostic.goto_prev, opts)
				map("n", "]d", vim.diagnostic.goto_next, opts)
			end,
		})
	end,
}
