local filetype_settings = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })

vim.on_key(function(char)
  if vim.fn.mode() == "n" then
    local new_hlsearch = vim.tbl_contains({ "<CR>", "n", "N", "*", "#", "?", "/" }, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end, vim.api.nvim_create_namespace("auto_hlsearch"))

vim.api.nvim_create_autocmd("FileType", {
  group = filetype_settings,
  pattern = { "NeogitCommitMessage", "gitcommit", "html", "markdown", "org", "pug", "tex", "text" },
  callback = function()
    vim.cmd.setlocal("spell")
    vim.cmd.setlocal("wrap linebreak")
    vim.cmd.setlocal("conceallevel=2")
  end,
})

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("VimEnter", {
  group = augroup("autoupdate"),
  callback = function()
    local status_ok, lazy = pcall(require, "lazy")
    if not status_ok then
      return
    end
    if require("lazy.status").has_updates then
      lazy.update({ show = false })
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    if event.data.actions.type == "move" then
      Snacks.rename.on_rename_file(event.data.actions.src_url, event.data.actions.dest_url)
    end
  end,
})
