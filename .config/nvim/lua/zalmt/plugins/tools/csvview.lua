return {
	"hat0uma/csvview.nvim",
	ft = { "csv" },
	cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },

	---@module "csvview"
	---@type CsvView.Options
	opts = {
		parser = { comments = { "#", "//" } },
		keymaps = {
			-- Text objects
			textobject_field_inner = { "if", mode = { "o", "x" } },
			textobject_field_outer = { "af", mode = { "o", "x" } },

			-- Navigation
			jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
			jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
			jump_next_row = { "<Enter>", mode = { "n", "v" } },
			jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
		},
	},

	config = function(_, opts)
		require("csvview").setup(opts)

		-- Buffer-local toggle for which-key relevance
		vim.keymap.set("n", "<leader>pc", "<cmd>CsvViewToggle<CR>", {
			desc = "Toggle CSV view",
			buffer = true, -- 🔑 this is what hides it elsewhere
		})
	end,
}
