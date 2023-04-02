ls = require("luasnip")
ls.setup({
	region_check_events = "InsertEnter",
})
ls.config.set_config({
    history = true, -- keep around last snippet local to jump back
    enable_autosnippets = true,
    store_selection_keys = "<Tab>",
})
require("luasnip.loaders.from_lua").load({ paths = {"~/.config/nvim/lua/snippets/", "~/.config/nvim/lua/localsnippets/"} })
ls.filetype_extend("tex", { "cpp", "python" })
vim.cmd([[silent command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()]])

-- keymaps
M = {}
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

keymap("i", "<C-f>", "<Plug>luasnip-next-choice", {})
keymap("s", "<C-f>", "<Plug>luasnip-next-choice", {})
keymap("i", "<C-d>", "<Plug>luasnip-prev-choice", {})
keymap("s", "<C-d>", "<Plug>luasnip-prev-choice", {})

return M
