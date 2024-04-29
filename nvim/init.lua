-- core 
require("core.options")
require("core.keymaps")
require("core.lazy") -- plugin manager
require("core.autocommands")

-- core plugins 
require("random.lsp")
require("random.cmp")
require("random.luasnip")
require("random.telescope")
require("random.treesitter")
require("random.autopairs")
require("random.surround")
require("random.comments")

-- code editing 
require("random.toggleterm")

-- git
require("random.gitsigns")

-- appearance 
require("random.colorscheme")
require("random.lualine")
require("random.bufferline")
require("random.winbar")
require("random.navic")
require("random.alpha")

-- ft specific 
require("random.vimtex") -- latex
require("random.peek")
