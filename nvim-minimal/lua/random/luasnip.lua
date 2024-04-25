ls = require("luasnip")
ls.setup({
	region_check_events = "InsertEnter",
})
ls.config.set_config({
    history = true, -- keep around last snippet local to jump back
    enable_autosnippets = true,
    store_selection_keys = "<Tab>",
})
require("luasnip.loaders.from_lua").load({ paths = {"~/.config/nvim-minimal/lua/snippets/", "~/.config/nvim-minimal/lua/localsnippets/"} })
ls.filetype_extend("tex", { "cpp", "python" })
ls.filetype_extend("markdown", { "tex" })
vim.cmd([[silent command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()]])
ls.log.set_loglevel("debug")

-- keymaps
M = {}
local opts = { noremap = true, silent = true }
local keymap = vim.keymap.set

keymap("i", "<Tab>", function()
    if ls.expand_or_locally_jumpable() then
        return "<Plug>luasnip-expand-or-jump"
    else
        return "<Tab>"
    end
end, { silent = true, expr = true })
keymap("i", "<S-Tab>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)
keymap("s", "<Tab>", "<cmd>lua require'luasnip'.jump(1)<CR>", opts)
keymap("s", "<S-Tab>", "<cmd>lua require'luasnip'.jump(-1)<CR>", opts)

keymap("i", "<C-f>", "<Plug>luasnip-next-choice", {})
keymap("s", "<C-f>", "<Plug>luasnip-next-choice", {})
keymap("i", "<C-d>", "<Plug>luasnip-prev-choice", {})
keymap("s", "<C-d>", "<Plug>luasnip-prev-choice", {})

return M
