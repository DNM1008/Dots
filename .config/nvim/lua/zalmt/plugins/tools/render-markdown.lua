return {
	"MeanderingProgrammer/render-markdown.nvim",
	ft = { "markdown" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	config = function()
		vim.keymap.set("n", "<leader>pt", "<cmd>RenderMarkdown preview<CR>", {
			desc = "Render Markdown Preview Toggle",
			buffer = true, -- THIS is the key
		})
	end,
}
