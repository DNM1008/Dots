
local M = {}

-- Count non-floating, non-NvimTree, non-terminal editor windows
function M.count_visible_editor_windows(term_buf)
  local count = 0

  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)

    if
      vim.api.nvim_win_get_config(win).relative == ""
      and vim.bo[buf].filetype ~= "NvimTree"
      and buf ~= term_buf
    then
      count = count + 1
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

return M
