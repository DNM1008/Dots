return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local mason_lspconfig = require("mason-lspconfig")
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local capabilities = cmp_nvim_lsp.default_capabilities()

		-- Diagnostic signs
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
		end

		vim.diagnostic.config({
			float = {
				border = "rounded",
				max_width = 100,
			},
			severity_sort = true,
			update_in_insert = false,
		})

		-- LSP keybindings on attach
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }
				local keymap = vim.keymap

				keymap.set(
					"n",
					"gR",
					"<cmd>Telescope lsp_references<CR>",
					{ desc = "Show LSP references", buffer = ev.buf }
				)
				keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration", buffer = ev.buf })
				keymap.set(
					"n",
					"gd",
					"<cmd>Telescope lsp_definitions<CR>",
					{ desc = "Go to definition", buffer = ev.buf }
				)
				keymap.set(
					"n",
					"gi",
					"<cmd>Telescope lsp_implementations<CR>",
					{ desc = "Go to implementation", buffer = ev.buf }
				)
				keymap.set(
					"n",
					"gt",
					"<cmd>Telescope lsp_type_definitions<CR>",
					{ desc = "Go to type definition", buffer = ev.buf }
				)
				keymap.set(
					{ "n", "v" },
					"<leader>ca",
					vim.lsp.buf.code_action,
					{ desc = "Code action", buffer = ev.buf }
				)
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename", buffer = ev.buf })
				keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Hover", buffer = ev.buf })
				keymap.set("n", "<leader>df", function()
					vim.diagnostic.open_float(nil, {
						focusable = true,
						scope = "line",
						border = "rounded",
						max_width = 100,
					})
				end, { desc = "Float diagnostics", buffer = ev.buf })
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics", buffer = ev.buf })
				keymap.set(
					"n",
					"<leader>D",
					"<cmd>Telescope diagnostics bufnr=0<CR>",
					{ desc = "Buffer diagnostics", buffer = ev.buf }
				)
				keymap.set("n", "[d", function()
					vim.diagnostic.goto_prev({ float = true })
				end, { desc = "Prev diagnostic", buffer = ev.buf })
				keymap.set("n", "]d", function()
					vim.diagnostic.goto_next({ float = true })
				end, { desc = "Next diagnostic", buffer = ev.buf })
				keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", { desc = "Restart LSP", buffer = ev.buf })
			end,
		})

		-- Setup servers via mason
		mason_lspconfig.setup()
		local servers = mason_lspconfig.get_installed_servers()

		for _, server in ipairs(servers) do
			local opts = { capabilities = capabilities }

			if server == "svelte" then
				opts.on_attach = function(client, _)
					vim.api.nvim_create_autocmd("BufWritePost", {
						pattern = { "*.js", "*.ts" },
						callback = function(ctx)
							client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
						end,
					})
				end
			elseif server == "graphql" then
				opts.filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" }
			elseif server == "emmet_ls" then
				opts.filetypes = {
					"html",
					"typescriptreact",
					"javascriptreact",
					"css",
					"sass",
					"scss",
					"less",
					"svelte",
				}
			elseif server == "lua_ls" then
				opts.settings = {
					Lua = {
						diagnostics = {
							globals = { "vim" },
						},
						completion = {
							callSnippet = "Replace",
						},
					},
				}
			elseif server == "pyright" or server == "tsserver" then
				opts.on_attach = function(client, _)
					-- Disable default diagnostics (if using ruff or eslint instead)
					client.handlers["textDocument/publishDiagnostics"] = function() end
				end
				-- elseif server == "ruff_lsp" then
				-- 	opts.init_options = {
				-- 		settings = {
				-- 			args = {}, -- Custom ruff args here if needed
				-- 		},
				-- 	}
			end

			lspconfig[server].setup(opts)
		end
	end,
}
