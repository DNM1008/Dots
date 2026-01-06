return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		vim.diagnostic.config({
			float = { border = "rounded", max_width = 100 },
			severity_sort = true,
			update_in_insert = false,
		})

		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			vim.fn.sign_define("DiagnosticSign" .. type, {
				text = icon,
				texthl = "DiagnosticSign" .. type,
			})
		end

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
