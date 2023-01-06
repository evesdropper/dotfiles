-- load maplocalleaders first
require("random.vimtex")
require("random.telescope")
require("random.dashboard")

-- core
require("random.options")
require("random.keymaps")
require("random.plugins")
require("random.lsp")

-- appearance
require("random.colorscheme")
require("random.icons")
require("random.scrollbar")
require("random.lualine")
require("random.bufferline")
require "random.winbar"
require("random.navic")
require("random.presence")

-- code editing
require("random.comments")
require("random.treesitter")
require("random.autopairs")
require("random.illuminate")
require("random.cmp")
require("random.gitsigns")
require("random.toggleterm")

-- markdown moment 
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = {'*.md', "*.tex", "*.sty"},
  group = group,
  command = 'setlocal wrap linebreak'
})

-- luasnip
ls = require("luasnip")
ls.config.set_config({
	history = true, -- keep around last snippet local to jump back
	enable_autosnippets = true,
	store_selection_keys = "<Tab>",
})
ls.filetype_extend("tex", { "cpp", "python" })
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/luasnip/" })
local types = require("luasnip.util.types")
-- require'luasnip'.config.setup({
-- 	ext_opts = {
-- 		[types.choiceNode] = {
-- 			active = {
-- 				virt_text = {{"⊙", "GruvboxOrange"}}
-- 			}
-- 		},
-- 		[types.insertNode] = {
-- 			active = {
-- 				virt_text = {{"●", "GruvboxBlue"}}
-- 			}
-- 		}
-- 	},
-- })
vim.cmd([[silent command! LuaSnipEdit :lua require("luasnip.loaders").edit_snippet_files()]])
