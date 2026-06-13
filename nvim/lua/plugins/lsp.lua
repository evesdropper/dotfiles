return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      local lspConfigPath = require("lazy.core.config").options.root .. "/nvim-lspconfig"
      vim.opt.runtimepath:append(lspConfigPath)
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    config = function()
      local status_ok, lint = pcall(require, "lint")
      if not status_ok then
        return
      end
      lint.linters_by_ft = {
        c = { "clangtidy" },
        lua = { "luac" },
        python = { "ruff" },
        sh = { "shellcheck" },
        tex = { "chktex" },
      }
    end,
    ft = { "c", "lua", "python", "sh", "tex" },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    ---@module "conform"
    ---@type conform.setupOpts
    opts = {
      formatters_by_ft = {
        c = { "clang-format" },
        cpp = { "clang-format" },
        css = { "prettierd" },
        go = { "gofmt" },
        html = { "prettierd" },
        java = { "clang-format" },
        lua = { "stylua" },
        markdown = { "injected" },
        ocaml = { "ocamlformat" },
        python = { "ruff_format", "ruff_organize_imports" },
        rust = { "rustfmt" },
        sh = { "shfmt", "shellharden" },
        tex = { "tex-fmt" },
        ["_"] = { "trim_whitespace", "trim_newlines" },
      },
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = function(bufnr)
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
          return
        end
        return { timeout_ms = 500, lsp_format = "fallback" }
      end,
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
  },
  {
    "folke/trouble.nvim",
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    cmd = "Trouble",
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}
