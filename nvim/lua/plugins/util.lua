-- util plugins: mini/snacks
return {
  -- mini: ai, operators, surround
  {
    "echasnovski/mini.ai",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      branch = "main",
    },
    version = false,
    config = function()
      local status_ok, mai = pcall(require, "mini.ai")
      if not status_ok then
        return
      end
      local ts_spec = mai.gen_spec.treesitter

      mai.setup({
        custom_textobjects = {
          F = ts_spec({
            a = "@function.outer",
            i = "@function.inner",
          }),
          f = ts_spec({
            a = "@call.outer",
            i = "@call.inner",
          }),
          B = ts_spec({
            a = "@block.outer",
            i = "@block.inner",
          }),
          l = ts_spec({
            a = "@loop.outer",
            i = "@loop.inner",
          }),
        },
      })
    end,
  },
  {
    "echasnovski/mini.operators",
    version = false,
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    version = false,
    opts = {},
  },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bufdelete = { enabled = true },
      dashboard = {
        sections = {
          { section = "header" },
          { section = "keys", gap = 1, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Recent Files",
            section = "recent_files",
            indent = 2,
            padding = 1,
          },
          { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
          {
            pane = 2,
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
            action = function()
              Snacks.lazygit()
            end,
            key = "G",
          },
          {
            pane = 2,
            icon = "󱀡",
            title = "Quote of the Day",
            section = "terminal",
            cmd = "/home/revise/dotfiles/scripts/lockscreen-quotes.sh -n",
            height = 8,
            padding = 1,
            ttl = 60 * 60,
          },
          { section = "startup" },
        },
      },
      image = {
        doc = {
          inline = false,
        },
      },
      indent = { enabled = true },
      input = { enabled = true },
      lazygit = { enabled = true },
      picker = {
        layout = {
          preset = "telescope",
        },
      },
      rename = { enabled = true },
      scroll = { enabled = true },
      terminal = { enabled = true },
      styles = {
        snacks_image = {
          border = "single",
        },
      },
    },
    keys = {
      -- bufdelete
      {
        "<leader>bd",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      {
        "zw",
        function()
          Snacks.bufdelete()
        end,
        desc = "Delete Buffer",
      },
      -- lazygit
      {
        "<leader>gg",
        function()
          Snacks.lazygit()
        end,
        desc = "Lazygit",
      },
      -- picker: general
      {
        "<leader><space>",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
      },
      {
        "<leader>,",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<S-w>",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>:",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>fb",
        function()
          Snacks.picker.buffers()
        end,
        desc = "Buffers",
      },
      {
        "<leader>fc",
        function()
          Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config File",
      },
      {
        "<leader>ff",
        function()
          Snacks.picker.files()
        end,
        desc = "Find Files",
      },
      {
        "<leader>fp",
        function()
          Snacks.picker.projects()
        end,
        desc = "Projects",
      },
      {
        "<leader>fr",
        function()
          Snacks.picker.recent()
        end,
        desc = "Recent",
      },
      -- picker: grep
      {
        "<leader>sb",
        function()
          Snacks.picker.lines()
        end,
        desc = "Buffer Lines",
      },
      {
        "<leader>sB",
        function()
          Snacks.picker.grep_buffers()
        end,
        desc = "Grep Open Buffers",
      },
      {
        "<leader>sg",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>sw",
        function()
          Snacks.picker.grep_word()
        end,
        desc = "Visual selection or word",
        mode = { "n", "x" },
      },
      -- picker: search
      {
        '<leader>s"',
        function()
          Snacks.picker.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>s/",
        function()
          Snacks.picker.search_history()
        end,
        desc = "Search History",
      },
      {
        "<leader>sc",
        function()
          Snacks.picker.command_history()
        end,
        desc = "Command History",
      },
      {
        "<leader>sC",
        function()
          Snacks.picker.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>sd",
        function()
          Snacks.picker.diagnostics()
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>sD",
        function()
          Snacks.picker.diagnostics_buffer()
        end,
        desc = "Buffer Diagnostics",
      },
      {
        "<leader>sh",
        function()
          Snacks.picker.help()
        end,
        desc = "Help Pages",
      },
      {
        "<leader>sH",
        function()
          Snacks.picker.highlights()
        end,
        desc = "Highlights",
      },
      {
        "<leader>sj",
        function()
          Snacks.picker.jumps()
        end,
        desc = "Jumps",
      },
      {
        "<leader>sl",
        function()
          Snacks.picker.loclist()
        end,
        desc = "Location List",
      },
      {
        "<leader>sm",
        function()
          Snacks.picker.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>sM",
        function()
          Snacks.picker.man()
        end,
        desc = "Man Pages",
      },
      {
        "<leader>sq",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo History",
      },
      -- picker: Git
      {
        "<leader>gb",
        function()
          Snacks.picker.git_branches()
        end,
        desc = "Git Branches",
      },
      {
        "<leader>gs",
        function()
          Snacks.picker.git_status()
        end,
        desc = "Git Status",
      },
      -- picker: LSP
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },
      {
        "<leader>sS",
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = "LSP Workspace Symbols",
      },
      -- terminal
      {
        "<c-\\>",
        function()
          Snacks.terminal.toggle()
        end,
        mode = { "n", "t" },
        desc = "Toggle Terminal",
      },
      { "<c-h>", [[<C-\><C-n><C-W>h]], mode = "t", desc = "Window Movement: Move Left" },
      { "<c-j>", [[<C-\><C-n><C-W>j]], mode = "t", desc = "Window Movement: Move Down" },
      { "<c-k>", [[<C-\><C-n><C-W>k]], mode = "t", desc = "Window Movement: Move Up" },
      { "<c-l>", [[<C-\><C-n><C-W>l]], mode = "t", desc = "Window Movement: Move Right" },
    },
  },
}
