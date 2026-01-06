local M = {}

function M.write_if_modified(winid)
	if not winid or not vim.api.nvim_win_is_valid(winid) then
		return
	end

	local bufnr = vim.api.nvim_win_get_buf(winid)

	if
		vim.api.nvim_buf_is_valid(bufnr)
		and vim.bo[bufnr].modifiable
		and vim.bo[bufnr].modified
		and vim.bo[bufnr].buftype == ""
		and vim.api.nvim_buf_get_name(bufnr) ~= ""
	then
		vim.api.nvim_buf_call(bufnr, function()
			vim.cmd("silent write")
		end)
	end
end

return M
