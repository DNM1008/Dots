return {
	"goolord/alpha-nvim",
	event = "VimEnter",
	cond = function()
		return vim.fn.argc() == 0
	end,
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set header
		dashboard.section.header.val = {
			-- "                                                     ",
			-- "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
			-- "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
			-- "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
			-- "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
			-- "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
			-- "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
			-- "                                                     ",

			"  ______   ______ ______   ______             ______         ______ ______ ______    ______          ",
			" |______| |______|______| |______|           |______|       |______|______|______|  |______|         ",
			"  _  / /                        _ _ _   _ _            _ _                          _ _       _ _ _  ",
			" (_)/ /   ______        ______ (_|_|_)_(_|_)          (_|_)                        (_|_)     (_|_|_) ",
			"   / /__ |______|      |______| |______|                                                             ",
			"  / // /       _ _ _   _ _                                                                           ",
			" /_// /   ____(_|_|_)_(_|_)  ______       ______                                                     ",
			"   / /   |______|  |______| |______|     |______|                                                    ",
			"  / /     _    _   _ _            _ _ _        _ _ _   _ _   _ _ _   _ _ _ _                         ",
			" /_/     (_)  (_) (_|_)          (_|_|_)      (_|_|_) (_|_) (_|_|_) (_|_|_|_)                        ",
			"                                                                                                     ",
    }
	

		-- Set menu
		dashboard.section.buttons.val = {
			dashboard.button("e", "  > New File", ":lua NewFileWithPrompt()<CR>"),
			dashboard.button("SPC ee", "  > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
			dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
			dashboard.button("SPC fs", "  > Find Word", "<cmd>Telescope live_grep<CR>"),
			dashboard.button("SPC wr", "󰁯  > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
			dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
		}

		function NewFileWithPrompt()
			vim.ui.input({ prompt = "Enter new file name: " }, function(filename)
				if filename and filename ~= "" then
					vim.cmd("edit " .. vim.fn.fnameescape(filename))
				end
			end)
		end

		-- Send config to alpha
		alpha.setup(dashboard.opts)

		-- Disable folding on alpha buffer
		vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
	end,
}
