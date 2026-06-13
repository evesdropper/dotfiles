return {
  "saghen/blink.cmp",
  build = "cargo build --release",
  dependencies = {
    "saghen/blink.lib",
    "L3MON4D3/LuaSnip",
  },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      kind_icons = {
        Snippet = " ",
      },
    },
    completion = {
      accept = {
        auto_brackets = { enabled = true },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      ghost_text = { enabled = true },
      menu = {
        draw = {
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "source_name" },
          },
          components = {
            source_name = {
              text = function(ctx)
                return "[" .. ctx.source_name .. "]"
              end,
            },
          },
          treesitter = { "lsp" },
        },
      },
    },
    fuzzy = { implementation = "prefer_rust" },
    keymap = {
      -- similar to prev cmp
      ["<CR>"] = { "accept", "fallback" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<Tab>"] = {
        "select_next",
        function(cmp)
          local luasnip = require("luasnip")
          if luasnip.expandable() then
            cmp.cancel() -- or cmp.hide()
            vim.schedule(function()
              luasnip.expand()
            end) -- wait for blink to close
            return true -- don't execute next command
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
    },
    signature = { enabled = true },
    snippets = {
      preset = "luasnip",
    },
    sources = {
      default = function(ctx)
        local success, node = pcall(vim.treesitter.get_node)
        if vim.bo.filetype == "markdown" or vim.bo.filetype == "text" then
          return { "snippets", "buffer" }
        elseif success and node and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()) then
          return { "buffer" }
        else
          return { "lazydev", "lsp", "path", "snippets", "buffer" }
        end
      end,
      min_keyword_length = function(ctx)
        if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
          return 2
        elseif vim.bo.filetype == "markdown" or vim.bo.filetype == "text" then
          return 2
        end
        return 0
      end,
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 50,
        },
        snippets = {
          opts = {
            show_autosnippets = false,
          },
        },
      },
    },
  },
}
