-- lualine helpers
local git_prompt_string = {
  "git_prompt_string",
  prompt_config = {
    color_clean = { fg = "7f9f7f" },
    color_delta = { fg = "dfcfaf" },
    color_dirty = { fg = "cc9393" },
    color_untracked = { fg = "dca3a3" },
    color_no_upstream = { fg = "b2b2a0" },
    color_merging = { fg = "8cd0d3" },
  },
}

local filetype = {
  "filetype",
  colored = false,
}

local location = {
  "location",
  padding = 0,
}

local mode = {
  "mode",
  fmt = function(str)
    return "-- " .. str .. " --"
  end,
}

local progress = function()
  local current_line = vim.fn.line(".")
  local total_lines = vim.fn.line("$")
  local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

local lint_progress = function()
  local linters = require("lint").get_running()
  if #linters == 0 then
    return "󰦕"
  end
  return "󱉶 " .. table.concat(linters, ", ")
end

-- tabby helpers
local theme = {
  fill = "TabLineFill",
  head = "StatusLineNC",
  current_tab = { style = "bold", fg = "#dcdccc", bg = "#434443" },
  inactive_tab = { style = "bold", fg = "#dcdccc", bg = "#5d6262" },
  win = "Tabline",
  tail = "StatusLine",
}

local tab_name = function(tab)
  return string.gsub(tab, "%[..%]", "")
end

local tab_modified = function(tab)
  local wins = require("tabby.module.api").get_tab_wins(tab)
  for i, x in pairs(wins) do
    if vim.bo[vim.api.nvim_win_get_buf(x)].modified then
      return ""
    end
  end
  return "󰆣"
end

local lsp_diag = function(buf)
  local diagnostics = vim.diagnostic.get(buf)
  local count = { 0, 0, 0, 0 }

  for _, diagnostic in ipairs(diagnostics) do
    count[diagnostic.severity] = count[diagnostic.severity] + 1
  end
  if count[1] > 0 then
    return vim.bo[buf].modified and "" or ""
  elseif count[2] > 0 then
    return vim.bo[buf].modified and "" or ""
  end
  return vim.bo[buf].modified and "" or ""
end

vim.keymap.set("n", "<A-j>", "<CMD>Tabby jump_to_tab<CR>")

-- dropbar keymaps
local status_ok, dropbar_api = pcall(require, "dropbar.api")
if status_ok then
  vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
  vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
  vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
end

return {
  -- colorscheme
  {
    "phha/zenburn.nvim",
    opts = {
      disable_background = true,
    },
    init = function()
      local color = color or "zenburn"
      vim.cmd.colorscheme(color)
      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
  },
  -- lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "mikesmithgh/git-prompt-string-lualine.nvim",
    },
    opts = {
      options = {
        icons_enabled = true,
        theme = "zenburn",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
          statusline = 1000,
          tabline = 1000,
          winbar = 1000,
        },
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { git_prompt_string, "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype", "lsp_status" },
        lualine_y = { location },
        lualine_z = { progress },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = { "lazy", "man", "oil", "trouble" },
    },
  },
  -- where are the tabs? enter unix philosophy debate (we found a sick ACTUAL tabline plugin thankfully)
  {
    "nanozuki/tabby.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
    opts = {
      line = function(line)
        return {
          {
            { "  ", hl = theme.head },
            line.sep("", theme.head, theme.fill),
          },
          line.tabs().foreach(function(tab)
            local hl = tab.is_current() and theme.current_tab or theme.inactive_tab
            return {
              line.sep("", hl, theme.fill),
              tab_modified(tab.id),
              tab.in_jump_mode() and tab.jump_key() or tab.number(),
              "",
              tab_name(tab.name()),
              line.sep("", hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          line.spacer(),
          line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
            local hl = win.is_current() and theme.current_tab or theme.inactive_tab
            return {
              line.sep("", hl, theme.fill),
              win.file_icon(),
              "",
              win.buf_name(),
              lsp_diag(win.buf().id),
              line.sep("", hl, theme.fill),
              hl = hl,
              margin = " ",
            }
          end),
          {
            line.sep("", theme.tail, theme.fill),
            { "  ", hl = theme.tail },
          },
          hl = theme.fill,
        }
      end,
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    -- optional, but required for fuzzy finder support
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
    },
    opts = {
      bar = {
        enable = function(buf, win, _)
          if
            not vim.api.nvim_buf_is_valid(buf)
            or not vim.api.nvim_win_is_valid(win)
            or vim.fn.win_gettype(win) ~= ""
            or vim.wo.winbar ~= ""
            or vim.bo[buf].ft == "help"
          then
            return false
          end

          local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
          if stat and stat.size > 1024 * 1024 then
            return false
          end

          return vim.bo[buf].ft == "markdown"
            or vim.bo[buf].ft == "oil" -- enable in oil buffers
            or pcall(vim.treesitter.get_parser, buf)
            or not vim.tbl_isempty(vim.lsp.get_clients({
              bufnr = buf,
              method = "textDocument/documentSymbol",
            }))
        end,
      },
      sources = {
        path = {
          relative_to = function(buf, win)
            -- Show full path in oil or fugitive buffers
            local bufname = vim.api.nvim_buf_get_name(buf)
            if vim.startswith(bufname, "oil://") then
              local root = bufname:gsub("^%S+://", "", 1)
              while root and root ~= vim.fs.dirname(root) do
                root = vim.fs.dirname(root)
              end
              return root
            end

            local ok, cwd = pcall(vim.fn.getcwd, win)
            return ok and cwd or vim.fn.getcwd()
          end,
        },
      },
    },
  },
}
