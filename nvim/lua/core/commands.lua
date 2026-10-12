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

-- one of these is not like the others; modified from https://zignar.net/2024/11/20/template-files-for-nvim/
vim.api.nvim_create_user_command("Template", function()
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)
  local filename = vim.fn.fnamemodify(file, ":t")
  local ext = vim.fn.fnamemodify(file, ":e")

  local project_root = vim.fs.root(buf, { ".git" }) or vim.fn.getcwd()
  local directories = {
    project_root .. "/templates",
    vim.fn.stdpath("config") .. "/templates",
  }

  local templates = {}

  for _, directory in ipairs(directories) do
    if vim.fn.isdirectory(directory) == 1 then
      for name in vim.fs.dir(directory) do
        local stem = name:match("^(.*)%.tpl$") or name:match("^(.*)%.stpl$")

        local matches = stem and (stem == filename or (ext ~= "" and (stem == ext or vim.endswith(stem, "." .. ext))))

        local path = directory .. "/" .. name
        if matches and vim.fn.filereadable(path) == 1 then
          table.insert(templates, {
            name = name,
            path = path,
            snippet = vim.endswith(name, ".stpl"),
          })
        end
      end
    end

    -- Use global templates only if no project templates match.
    if #templates > 0 then
      break
    end
  end

  if #templates == 0 then
    vim.notify("No matching template found", vim.log.levels.WARN)
    return
  end

  table.sort(templates, function(a, b)
    return a.name < b.name
  end)

  local function apply(template)
    -- Cancel if dismissed or the user switched buffers.
    if not template or vim.api.nvim_get_current_buf() ~= buf then
      return
    end

    if template.snippet then
      local content = table.concat(vim.fn.readfile(template.path), "\n")
      content = content:gsub("{{DATE}}", function()
        return os.date("%Y-%m-%d")
      end)
      vim.snippet.expand(content)
    else
      vim.cmd("0read " .. vim.fn.fnameescape(template.path))
    end
  end

  -- Defer UI interaction until the FileType autocmd has finished.
  vim.schedule(function()
    if vim.api.nvim_get_current_buf() ~= buf then
      return
    end

    if #templates == 1 then
      apply(templates[1])
    else
      vim.ui.select(templates, {
        prompt = "Choose a template:",
        format_item = function(template)
          return template.name
        end,
      }, apply)
    end
  end)
end, { desc = "Choose a project or global template" })

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("template_autoload", { clear = true }),
  pattern = { "sh" },
  desc = "Load templates for selected filetypes",
  callback = function(args)
    local buf = args.buf
    local file = vim.api.nvim_buf_get_name(buf)

    -- Only apply to new, named, normal files.
    if file == "" or vim.bo[buf].buftype ~= "" or vim.uv.fs_stat(file) then
      return
    end

    -- Only insert into an empty buffer.
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    if #lines ~= 1 or lines[1] ~= "" then
      return
    end

    vim.cmd("Template")
  end,
})
