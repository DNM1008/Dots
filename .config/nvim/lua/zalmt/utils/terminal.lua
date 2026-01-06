
local win_utils = require("zalmt.utils.window")

local M = {}

-- Internal state
local term_buf = nil
local term_win = nil

function M.toggle(size)
  -- Hide if visible
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.cmd("hide")
    term_win = nil
    return
  end

  local is_vertical =
    win_utils.count_visible_editor_windows(term_buf) == 1

  if is_vertical then
    vim.cmd("botright vnew")

    local usable_width =
      vim.o.columns - win_utils.get_nvimtree_width()
    local half_width = math.floor(usable_width * 0.5)

    vim.cmd("vertical resize " .. half_width)
  else
    vim.cmd("botright new")
    vim.cmd("resize " .. size)
  end

  local scratch_buf = vim.api.nvim_get_current_buf()

  if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
    vim.cmd("buffer " .. term_buf)
    vim.cmd("bd " .. scratch_buf)
  else
    vim.cmd("terminal")
    term_buf = vim.api.nvim_get_current_buf()

    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = "no"
  end

  vim.cmd("startinsert!")
  term_win = vim.api.nvim_get_current_win()
end

return M
