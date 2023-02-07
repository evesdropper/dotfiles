local M = {}

-- LuaSnip
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

-- Auto backslash - thanks kunzaatko! (ref: https://github.com/kunzaatko/nvim-dots/blob/trunk/lua/snippets/tex/utils/snippet_templates.lua)
M.auto_backslash_snippet = function(context, opts)
    opts = opts or {}
    if not context.trig then
        error("context doesn't include a `trig` key which is mandatory", 2)
    end
    context.dscr = context.dscr or (context.trig .. 'with automatic backslash')
    context.name = context.name or context.trig
    context.docstring = context.docstring or ([[\]] .. context.trig)
    return autosnippet(context, t([[\]] .. context.trig), opts)
end

return M
