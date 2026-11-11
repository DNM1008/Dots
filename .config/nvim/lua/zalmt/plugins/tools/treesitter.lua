-- main branch: setup() only takes install_dir; highlighting, installs and
-- autotag are wired up here instead of through master's opts
local ensure = {
	"bash",
	"comment",
	"css",
	"gitignore",
	"html",
	"javascript",
	"json",
	"lua",
	"markdown",
	"markdown_inline",
	"prisma",
	"python",
	"query",
	"svelte",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	event = { "BufReadPre", "BufNewFile" },
	build = ":TSUpdate",
	dependencies = {
		"windwp/nvim-ts-autotag",
	},
	config = function()
		local ts = require("nvim-treesitter")
		-- async; already-installed parsers are skipped
		ts.install(ensure)
		require("nvim-ts-autotag").setup()

		local function start(buf, lang)
			local name = vim.api.nvim_buf_get_name(buf)
			if name ~= "" and vim.fn.getfsize(name) > 100 * 1024 then
				return
			end
			pcall(vim.treesitter.start, buf, lang)
		end

		local function attach(buf, ft)
			local lang = vim.treesitter.language.get_lang(ft)
			if not lang then
				return
			end
			if vim.treesitter.language.add(lang) then
				return start(buf, lang)
			end
			-- auto-install parsers nvim-treesitter knows about
			if vim.tbl_contains(ts.get_available(), lang) then
				ts.install(lang):await(function()
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(buf) then
							start(buf, lang)
						end
					end)
				end)
			end
		end

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("zalmt_treesitter", {}),
			callback = function(args)
				attach(args.buf, args.match)
			end,
		})
		-- buffers opened before this plugin loaded
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].filetype ~= "" then
				attach(buf, vim.bo[buf].filetype)
			end
		end
	end,
}
