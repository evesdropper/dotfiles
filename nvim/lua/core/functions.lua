-- globals
_G.dd = function(...)
  Snacks.debug.inspect(...)
end

_G.dl = function(...)
  Snacks.debug.log(...)
end

_G.bt = function()
  Snacks.debug.backtrace()
end

vim.print = _G.dd

M = {}

function M.isempty(s)
  return s == nil or s == ""
end

function M.get_buf_option(opt)
  local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
  if not status_ok then
    return nil
  else
    return buf_option
  end
end

return M
