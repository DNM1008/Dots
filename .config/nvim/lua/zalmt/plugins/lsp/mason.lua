return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	cmd = "Mason",
	-- mason.nvim has no ensure_installed option; the list is installed in config
	opts = {
		ensure_installed = {
			-- Web / Frontend
			"prettierd", -- fast daemon
			"prettier", -- fallback / CI parity
			"eslint_d",
			"typescript-language-server",
			"htmlhint",

			-- Lua
			"stylua",
			"lua-language-server",

			-- Python
			"pyright",
			"ruff", -- provides ruff_format

			-- Shell
			"shfmt",
			"shellcheck",

			-- Markdown
			"markdownlint-cli2",

			-- C / C++
			"clangd",

			-- Go / Rust / C-C++ formatters: gofmt, rustfmt & clang-format
			-- ship with their toolchains and are already on PATH,
			-- not managed via Mason
		},
	},
	config = function(_, opts)
		local ensure = opts.ensure_installed
		opts.ensure_installed = nil
		require("mason").setup(opts)
		local registry = require("mason-registry")
		registry.refresh(function()
			for _, name in ipairs(ensure) do
				local ok, pkg = pcall(registry.get_package, name)
				if ok and not pkg:is_installed() and not pkg:is_installing() then
					pkg:install()
				end
			end
		end)
	end,
}
