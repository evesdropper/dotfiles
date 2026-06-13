local vimtex_spec = {
  "lervag/vimtex",
  ft = { "tex" },
  lazy = false,
  init = function()
    -- sioyek
    vim.g.vimtex_view_method = "sioyek"
    vim.g.vimtex_quickfix_mode = 0

    -- compiler
    vim.g.vimtex_compiler_latexmk = {
      build_dir = "out",
      options = {
        "-shell-escape",
        "-verbose",
        "-file-line-error",
        "-interaction=nonstopmode",
        "-synctex=1",
      },
    }

    vim.g.vimtex_compiler_latexmk_engines = {
      ["_"] = "-lualatex",
    }
  end,
}

-- futureproofing
if vim.uv.os_uname().sysname == "Linux" then
  return vimtex_spec
end
