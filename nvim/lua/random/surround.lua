local status_ok, surround = pcall(require, "nvim-surround")
if not status_ok then
    return
end

vim.keymap.set("o", "ir", "i[")
vim.keymap.set("o", "ar", "a[")
vim.keymap.set("o", "ia", "i<")
vim.keymap.set("o", "aa", "a<")

surround.setup({
    -- TODO: add
})
