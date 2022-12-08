-- map localleader please
vim.g.maplocalleader = ","

-- zathura
vim.g.vimtex_view_method = "sioyek"
vim.g.vimtex_quickfix_mode = 0

vim.cmd([[ 
let g:vimtex_compiler_latexmk = { 'build_dir' : 'out' }
let g:vimtex_compiler_latexmk_engines = { '_' : '-lualatex' }
let g:vimtex_syntax_packages = {'minted': {'load': 2}}
]])
