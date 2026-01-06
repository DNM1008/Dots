-- Lazygit launcher via Snacks
local M = {}

function M.open()
	local Snacks = require("snacks")

	-- Guard: must be inside a git repo
	if vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):find("true") == nil then
		vim.notify("Not inside a git repository", vim.log.levels.WARN)
		return
	end

	local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]

	Snacks.terminal.open("lazygit", {
		name = "lazygit",
		reuse = true,
		cwd = root,
		env = { GIT_EDITOR = "nvim" },
		border = "rounded",
		win = {
			position = "float",
			width = 0.9,
			height = 0.9,
		},
	})
end

return M
