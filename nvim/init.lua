require "random.vimtex"
require "random.options"
require "random.keymaps"
require "random.plugins"
require "random.colorscheme"
require "random.cmp"
require "random.gitsigns"

-- luasnip
ls = require "luasnip"
ls.config.set_config({
	history = true, --keep around last snippet local to jump back
    enable_autosnippets = true,})
require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/luasnip/"})
