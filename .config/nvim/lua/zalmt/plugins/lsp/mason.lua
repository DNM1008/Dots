return {
	"williamboman/mason.nvim",
	build = ":MasonUpdate",
	cmd = "Mason",
	config = true,
	opts = {
		ensure_installed = {
			-- Web / Frontend
			"prettierd", -- fast daemon
			"prettier", -- fallback / CI parity
			"eslint_d",
			"htmlhint",

			-- Lua
			"stylua",
			"lua-language-server",

			-- Python
			"pyright",
			"ruff", -- provides ruff_format
			"flake8",

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
}
