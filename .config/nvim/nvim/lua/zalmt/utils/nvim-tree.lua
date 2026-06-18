local M = {}

-- Write buffer in a target window if needed
function M.write_buffer_in_window(winid)
	if not winid or not vim.api.nvim_win_is_valid(winid) then
		return
	end

	local bufnr = vim.api.nvim_win_get_buf(winid)

	if
		vim.api.nvim_buf_is_valid(bufnr)
		and vim.bo[bufnr].modifiable
		and vim.bo[bufnr].modified
		and vim.bo[bufnr].buftype == ""
	then
		vim.api.nvim_buf_call(bufnr, function()
			vim.cmd("silent write")
		end)
	end
end

-- Find the NvimTree window, if present
function M.find_tree_window()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local bufnr = vim.api.nvim_win_get_buf(win)
		if vim.bo[bufnr].filetype == "NvimTree" then
			return win
		end
	end
end

-- Get valid target windows for opening files
function M.get_valid_windows()
	local excluded_ft = { "NvimTree", "neo-tree", "notify" }
	local excluded_bt = { "terminal", "quickfix" }

	return vim.tbl_filter(function(win_id)
		local bufnr = vim.api.nvim_win_get_buf(win_id)
		local ft = vim.bo[bufnr].filetype
		local bt = vim.bo[bufnr].buftype

		return not vim.tbl_contains(excluded_ft, ft) and not vim.tbl_contains(excluded_bt, bt)
	end, vim.api.nvim_list_wins())
end

-- Custom window picker logic
function M.pick_window()
	local ok, window_picker = pcall(require, "window-picker")
	if not ok then
		return nil
	end

	local wins = M.get_valid_windows()

	-- No valid windows → create split
	if #wins == 0 then
		local tree_win = M.find_tree_window()

		if tree_win then
			vim.api.nvim_set_current_win(tree_win)
			vim.cmd("rightbelow vsplit")
		else
			vim.cmd("vsplit")
		end

		local win = vim.api.nvim_get_current_win()
		M.write_buffer_in_window(win)
		return win
	end

	-- Exactly one window
	if #wins == 1 then
		M.write_buffer_in_window(wins[1])
		return wins[1]
	end

	-- Multiple windows → picker
	local picked = window_picker.pick_window()
	M.write_buffer_in_window(picked)
	return picked
end

return M
