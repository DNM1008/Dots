local awrit = vim.fn.stdpath("data") .. "/lazy/awrit"

return {
	-- not a nvim plugin: lazy only clones it and runs its setup (bun + electron)
	-- so nvjup's <leader>nF works on a fresh install
	{
		"chase/awrit",
		branch = "electron",
		lazy = true,
		build = function(plugin)
			local function run(cmd)
				local r = vim.system(cmd, { cwd = plugin.dir }):wait()
				assert(r.code == 0, table.concat(cmd, " ") .. " failed:\n" .. (r.stderr or ""))
			end
			run({ "./setup.sh" })
			-- electron's postinstall (extract-zip) stops after the first file on
			-- recent node/bun; unpack its verified cached zip with unzip instead
			local electron = plugin.dir .. "/node_modules/electron"
			if vim.uv.fs_stat(electron .. "/dist/electron") then
				return
			end
			local version = vim.json.decode(table.concat(vim.fn.readfile(electron .. "/package.json"), "\n")).version
			-- @electron/get caches under $XDG_CACHE_HOME (default ~/.cache)
			local cache = (vim.env.XDG_CACHE_HOME or vim.fn.expand("~/.cache")) .. "/electron"
			local zip = vim.fn.glob(cache .. "/*/electron-v" .. version .. "-linux-x64.zip", false, true)[1]
			assert(zip, "electron " .. version .. " zip not found in " .. cache)
			run({ "unzip", "-oq", zip, "-d", electron .. "/dist" })
			vim.fn.writefile({ "electron" }, electron .. "/path.txt", "b")
		end,
	},
	{
		"LumbaBalumba/nvjup",
		lazy = false, -- nvjup must register BufReadCmd before an .ipynb is opened
		build = "uv sync --frozen",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"MeanderingProgrammer/render-markdown.nvim",
			"folke/snacks.nvim",
		},
		opts = {
			interactive = { awrit_command = { awrit .. "/awrit" } },
		},
	},
}
