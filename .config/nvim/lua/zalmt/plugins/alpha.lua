return {
	"goolord/alpha-nvim",
	event = "VimEnter",
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

			"                                                                                          __  ",
			" ___ ___ ___ ___      ___ ___ ___ ___ ___   ___ ___ ___ ___ ___   ___ ___ ___ ___ ___    / /  ",
			"|____________,-. |_______________ |_______________ |_______________  / /   ",
			"                 '-'                                                __                 /_/    ",
			"     ___         ___ ___      ___ ___   ___     ___     ___ ___    / /                        ",
			" ,-.|___,-. ,-.|______,-. |______ |___,-.|___,-.|______  / /                         ",
			" '-'     '-' '-'         '-'                '-'     '-'          /_/                          ",
			" ___            ___ ___ ___   ___ ___ ___   ___ ___   ___     ___     ___ ___                 ",
			"|___,-.,-.,-. |_________ |_________ |______ |___,-.|___,-.|______                ",
			"     '-''-''-'                                            '-'     '-'                         ",
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
			local input = require("dressing").input or vim.ui.input
			input({ prompt = "Enter new file name: " }, function(filename)
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
