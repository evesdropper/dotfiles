return {
  -- comment stuff
  {
    "numToStr/Comment.nvim",
    opts = {
      pre_hook = function(ctx)
        -- Only calculate commentstring for tsx filetypes
        if vim.bo.filetype == "typescriptreact" then
          local U = require("Comment.utils")

          -- Determine whether to use linewise or blockwise commentstring
          local type = ctx.ctype == U.ctype.linewise and "__default" or "__multiline"

          -- Determine the location where to calculate commentstring from
          local location = nil
          if ctx.ctype == U.ctype.blockwise then
            location = require("ts_context_commentstring.utils").get_cursor_location()
          elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require("ts_context_commentstring.utils").get_visual_start_location()
          end

          return require("ts_context_commentstring.internal").calculate_commentstring({
            key = type,
            location = location,
          })
        end
      end,
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
  },
  -- autopairs/autotag
  {
    "windwp/nvim-autopairs",
    opts = {
      check_ts = true,
      ts_config = {
        lua = { "string", "source" },
        javascript = { "string", "template_string" },
        java = false,
      },
      disable_filetype = { "TelescopePrompt", "spectre_panel" },
      fast_wrap = {
        map = "<M-e>",
        chars = { "{", "[", "(", '"', "'" },
        pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], "%s+", ""),
        offset = 0, -- Offset from pattern match
        end_key = "$",
        keys = "qwertyuiopzxcvbnmasdfghjkl",
        check_comma = true,
        highlight = "PmenuSel",
        highlight_grey = "LineNr",
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "javascript", "markdown", "xml" },
  },
  -- yazi enjoyer
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      "folke/snacks.nvim",
    },
    keys = {
      {
        "-",
        mode = { "n", "v" },
        "<cmd>Yazi<cr>",
        desc = "Open yazi at the current file",
      },
      {
        "<leader>cw",
        "<cmd>Yazi cwd<cr>",
        desc = "Open the file manager in nvim's working directory",
      },
      {
        "<c-up>",
        "<cmd>Yazi toggle<cr>",
        desc = "Resume the last yazi session",
      },
    },
    ---@type YaziConfig | {}
    opts = {
      keymaps = {
        show_help = "<f1>",
      },
    },
    init = function()
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  -- Harpoon
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local status_ok, harpoon = pcall(require, "harpoon")
      if not status_ok then
        return
      end
      harpoon:setup()

      -- picker
      local function generate_harpoon_picker()
        local file_paths = {}
        for j, item in ipairs(harpoon:list().items) do
          table.insert(file_paths, {
            text = item.value,
            file = item.value,
          })
        end
        return file_paths
      end
      vim.keymap.set("n", "<leader>a", function()
        harpoon:list():add()
      end)
      vim.keymap.set("n", "<C-e>", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end)
      vim.keymap.set("n", "<leader>fh", function()
        Snacks.picker({
          finder = generate_harpoon_picker,
          win = {
            input = {
              keys = {
                ["dd"] = { "harpoon_delete", mode = { "n", "x" } },
              },
            },
            list = {
              keys = {
                ["dd"] = { "harpoon_delete" or "bufdelete", mode = { "n", "x" } },
              },
            },
          },
          actions = {
            harpoon_delete = function(picker, item)
              local to_remove = item or picker:selected()
              Snacks.debug.log("Harpoon List Before Delete:", harpoon:list())
              Snacks.debug.log(to_remove.file)
              table.remove(harpoon:list().items, to_remove.idx)
              Snacks.debug.log("Harpoon List After Delete:", harpoon:list())
              picker:find({
                refresh = true,
              })
            end,
          },
        })
      end)
    end,
  },
  -- Flash
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },
  -- -- smh 2 tab and 4 tab enjoyers cannot agree on something fr
  -- {
  --     "https://github.com/tpope/vim-sleuth"
  -- }
}
