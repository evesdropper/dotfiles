vim.cmd([[
try
  colorscheme zenburn
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]])
