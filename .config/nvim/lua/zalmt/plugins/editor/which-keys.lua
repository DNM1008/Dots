return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 500
	end,
	opts = {
		spec = {
			{ "<leader>a", group = "claude" },
			{ "<leader>c", group = "code" },
			{ "<leader>e", group = "explorer" },
			{ "<leader>f", group = "find" },
			{ "<leader>g", group = "git" },
			{ "<leader>l", group = "lazy/mason" },
			{ "<leader>m", group = "swap" },
			{ "<leader>n", group = "noice" },
			{ "<leader>o", group = "notes" },
			{ "<leader>p", group = "preview" },
			{ "<leader>s", group = "splits" },
			{ "<leader>t", group = "tabs" },
			{ "<leader>v", group = "view" },
			{ "<leader>x", group = "trouble" },
			{ "<leader>z", group = "zen" },
			{ "<leader><CR>", group = "terminal" },
		},
	},
}
