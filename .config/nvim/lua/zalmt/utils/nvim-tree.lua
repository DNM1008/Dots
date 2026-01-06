local M = {}

function M.auto_close_on_last_window()
	vim.api.nvim_create_autocmd({ "WinClosed", "BufWinLeave" }, {
		callback = function()
			vim.schedule(function()
				local has_file = false
				local tree_open = false

				for _, win in ipairs(vim.api.nvim_list_wins()) do
					if vim.api.nvim_win_get_config(win).relative == "" then
						local buf = vim.api.nvim_win_get_buf(win)
						if vim.bo[buf].filetype == "NvimTree" then
							tree_open = true
						elseif vim.bo[buf].buftype == "" then
							has_file = true
							break
						end
					end
				end

				if tree_open and not has_file then
					require("nvim-tree.api").tree.close()
				end
			end)
		end,
	})
end

function M.open_on_startup()
	vim.api.nvim_create_autocmd("VimEnter", {
		callback = function()
			require("nvim-tree.api").tree.open({ focus = false })
			for _, win in ipairs(vim.api.nvim_list_wins()) do
				local buf = vim.api.nvim_win_get_buf(win)
				if vim.bo[buf].filetype ~= "NvimTree" then
					vim.api.nvim_set_current_win(win)
					break
				end
			end
		end,
	})
end

return M
