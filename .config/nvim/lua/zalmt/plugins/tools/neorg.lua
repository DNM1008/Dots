-- neorg normally gets its deps and norg parsers from luarocks, but luarocks'
-- downloads fail here, and nvim-treesitter can't build norg's C++ scanner.
-- So: plain plugin deps, and the parsers compiled straight into site/parser.
local function parser(name, tag)
	return {
		"nvim-neorg/tree-sitter-" .. name:gsub("_", "-"),
		tag = tag,
		lazy = true,
		build = function(plugin)
			local function run(cmd)
				local r = vim.system(cmd, { cwd = plugin.dir }):wait()
				assert(r.code == 0, table.concat(cmd, " ") .. " failed:\n" .. (r.stderr or ""))
			end
			local out = vim.fn.stdpath("data") .. "/site/parser"
			vim.fn.mkdir(out, "p")
			local objs = {}
			if vim.uv.fs_stat(plugin.dir .. "/src/scanner.cc") then
				run({ "c++", "-fPIC", "-O2", "-Isrc", "-c", "src/scanner.cc", "-o", "scanner.o" })
				objs = { "scanner.o", "-lstdc++" }
			end
			run(vim.list_extend(
				{ "cc", "-shared", "-fPIC", "-O2", "-Isrc", "src/parser.c", "-o", out .. "/" .. name .. ".so" },
				objs
			))
		end,
	}
end

return {
	parser("norg", "v0.2.4"),
	parser("norg_meta", "v0.1.0"),
	{
		"nvim-neorg/neorg",
		version = "*",
		ft = "norg",
		cmd = "Neorg",
		keys = {
			{ "<leader>oo", "<cmd>Neorg index<CR>", desc = "Notes index" },
			{ "<leader>or", "<cmd>Neorg return<CR>", desc = "Close notes, back to previous buffers" },
			{ "<leader>oj", "<cmd>Neorg journal today<CR>", desc = "Journal: today" },
		},
		init = function()
			-- name neorg's <localleader> prefixes (its keymaps are buffer-local)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "norg",
				callback = function(args)
					require("which-key").add({
						{ "<localleader>", group = "neorg", buffer = args.buf },
						{ "<localleader>c", group = "code", buffer = args.buf },
						{ "<localleader>i", group = "insert", buffer = args.buf },
						{ "<localleader>l", group = "list", buffer = args.buf },
						{ "<localleader>n", group = "note", buffer = args.buf },
						{ "<localleader>t", group = "todo", buffer = args.buf },
					})
				end,
			})
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-neorg/lua-utils.nvim",
			"nvim-neotest/nvim-nio",
			"pysan3/pathlib.nvim",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.completion"] = { config = { engine = "nvim-cmp" } },
				["core.dirman"] = {
					config = {
						workspaces = { notes = "~/notes" },
						default_workspace = "notes",
					},
				},
			},
		},
	},
}
