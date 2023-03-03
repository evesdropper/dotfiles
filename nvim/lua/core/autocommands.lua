local filetype_settings = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = filetype_settings,
    pattern = { "NeogitCommitMessage", "gitcommit", "html", "markdown", "org", "pug", "tex", "text" },
    callback = function()
        vim.cmd.setlocal "spell"
        vim.cmd.setlocal "wrap linebreak"
    end,
})
