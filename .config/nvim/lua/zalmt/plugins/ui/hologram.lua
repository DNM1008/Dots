-- ~/.config/nvim/lua/plugins/hologram.lua
return {
	"edluffy/hologram.nvim",
	event = "BufReadPre", -- load when opening any file
	config = function()
		require("hologram").setup({
			auto_display = true,
		})
	end,
}
