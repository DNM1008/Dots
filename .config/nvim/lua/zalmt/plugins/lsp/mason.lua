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

			-- Lua
			"stylua",
			"lua-language-server",

			-- Python
			"black",
			"isort",
			"pyright",
			-- "ruff", -- optional if you switch to ruff_format

			-- Shell
			"shfmt",

			-- Go
			"gofmt",
			"goimports",

			-- Rust
			"rustfmt",

			-- C / C++
			"clang-format",
			"clangd",
		},
	},
}
