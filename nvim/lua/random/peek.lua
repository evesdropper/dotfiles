local status_ok, peek = pcall(require, "peek")
if not status_ok then
	return
end

vim.g.maplocalleader = ","
local opts = { noremap = true, silent = true }
vim.api.nvim_create_user_command('PeekOpen', peek.open, {})
vim.api.nvim_create_user_command('PeekClose', peek.close, {})
vim.keymap.set("n", "<leader>ll", peek.open, opts)
vim.keymap.set("n", "<leader>lc", peek.close, opts)
