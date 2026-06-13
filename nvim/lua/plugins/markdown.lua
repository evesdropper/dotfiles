return {
  {
    "dkarter/bullets.vim",
    ft = { "tex", "markdown", "text" },
  },
  {
    "toppair/peek.nvim",
    ft = { "markdown" },
    event = { "VeryLazy" },
    build = "deno task --quiet build:fast",
    config = function()
      local status_ok, peek = pcall(require, "peek")
      if not status_ok then
        return
      end

      local opts = { noremap = true, silent = true }
      vim.api.nvim_create_user_command("PeekOpen", peek.open, {})
      vim.api.nvim_create_user_command("PeekClose", peek.close, {})
      vim.keymap.set("n", "<localleader>ml", peek.open, opts)
      vim.keymap.set("n", "<localleader>mc", peek.close, opts)
    end,
  },
}
