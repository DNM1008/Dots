local buffer = require("zalmt.utils.buffer")

local M = {}

---------------------------------------------------------------------
-- Window counting / layout introspection
---------------------------------------------------------------------

-- Count non-floating, non-NvimTree editor windows
-- Optional: exclude a specific terminal buffer
function M.count_visible_editor_windows(term_buf)
	local count = 0

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		if vim.api.nvim_win_get_config(win).relative == "" then
			local buf = vim.api.nvim_win_get_buf(win)
			local ft = vim.bo[buf].filetype
			local bt = vim.bo[buf].buftype

			if ft ~= "NvimTree" and bt ~= "terminal" and buf ~= term_buf then
				count = count + 1
			end
		end
	end

	return count
end

-- Get width of NvimTree window if present
function M.get_nvimtree_width()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "NvimTree" then
			return vim.api.nvim_win_get_width(win)
		end
	end
	return 0
end

---------------------------------------------------------------------
-- Window filtering & picking
---------------------------------------------------------------------

function M.get_valid_file_windows()
	return vim.tbl_filter(function(win)
		if vim.api.nvim_win_get_config(win).relative ~= "" then
			return false
		end

		local buf = vim.api.nvim_win_get_buf(win)
		local ft = vim.bo[buf].filetype
		local bt = vim.bo[buf].buftype

		local excluded_ft = { "NvimTree", "neo-tree", "notify" }
		local excluded_bt = { "terminal", "quickfix" }

		return not vim.tbl_contains(excluded_ft, ft) and not vim.tbl_contains(excluded_bt, bt)
	end, vim.api.nvim_list_wins())
end

-- Picker used by nvim-tree (and reusable elsewhere)
function M.pick_or_create_window()
	local ok, picker = pcall(require, "window-picker")
	local wins = M.get_valid_file_windows()

	-- No valid windows -> split next to tree or fallback vsplit
	if #wins == 0 then
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			local buf = vim.api.nvim_win_get_buf(win)
			if vim.bo[buf].filetype == "NvimTree" then
				vim.api.nvim_set_current_win(win)
				vim.cmd("wincmd l")
				vim.cmd("vsplit")
				local new_win = vim.api.nvim_get_current_win()
				buffer.write_if_modified(new_win)
				return new_win
			end
		end

		vim.cmd("vsplit")
		return vim.api.nvim_get_current_win()
	end

	-- Exactly one window -> use it
	if #wins == 1 then
		buffer.write_if_modified(wins[1])
		return wins[1]
	end

	-- Multiple windows -> picker
	if ok then
		local picked = picker.pick_window()
		buffer.write_if_modified(picked)
		return picked
	end

	-- Fallback
	return wins[1]
end

return M
