--[
-- LuaSnip Conditions
--]

local M = {}

-- math / not math zones
M.in_math = function()
	return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end

M.in_text = function()
    return not math()
end

-- comment detection
M.in_comment = function()
  return vim.fn['vimtex#syntax#in_comment']() == 1
end

-- document class
M.in_beamer = function()
	return vim.b.vimtex["documentclass"] == "beamer"
end

-- general env function
local function env(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end

M.preamble = function()
    return not env("document")
end

M.tikz = function()
	return env("tikzpicture")
end

M.bp = function()
	return env("itemize") or env("enumerate")
end

M.in_align = function()
    return env("align") or env("align*") or env("aligned")
end

return M
