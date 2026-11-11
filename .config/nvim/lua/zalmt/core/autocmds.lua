vim.opt.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  callback = function()
    vim.cmd("checktime")
  end,
})

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = "*.pdf",
  callback = function(args)
    require("zalmt.core.pdf").attach(args.buf)
  end,
})

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "*.mp4", "*.mkv", "*.webm", "*.mov", "*.avi", "*.m4v" },
  callback = function(args)
    require("zalmt.utils.video").attach(args.buf)
  end,
})
