-- load maplocalleaders first
require "random.vimtex"
require "random.telescope"

-- core
require "random.options"
require "random.keymaps"
require "random.plugins"

-- appearance 
require "random.colorscheme"
require "random.icons"
require "random.lualine"
require "random.presence"

-- code editing
require "random.treesitter"
require "random.cmp"
require "random.gitsigns"

-- luasnip
ls = require "luasnip"
ls.config.set_config({
	history = true, --keep around last snippet local to jump back
    enable_autosnippets = true,})
require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/luasnip/"})
