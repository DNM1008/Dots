vim.api.nvim_create_autocmd("BufUnload", {
  pattern = "*.md",
  callback = function(ev)
    local md = ev.file
    local pdf = md:gsub("%.md$", ".pdf")
    local md_dir = vim.fn.fnamemodify(md, ":h")
    vim.fn.jobstart({
      "pandoc", "--defaults", "pdf", md, "-o", pdf, "--resource-path", md_dir,
    }, { detach = true })
  end,
})
