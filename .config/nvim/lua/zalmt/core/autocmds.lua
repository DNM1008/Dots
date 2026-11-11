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


-- :Play [file] — play a video in the current window (defaults to this buffer's file)
vim.api.nvim_create_user_command("Play", function(opts)
	local file = opts.args ~= "" and opts.args or vim.api.nvim_buf_get_name(0)
	require("zalmt.utils.video").play(file)
end, { nargs = "?", complete = "file", desc = "Play video in current window" })
