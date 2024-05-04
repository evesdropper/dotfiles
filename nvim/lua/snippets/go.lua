--[
-- Imports/Functions
--]
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local conds = require("luasnip.extras.expand_conditions")
local make_condition = require("luasnip.extras.conditions").make_condition

-- snippets
return {
    s({ trig='iferr', name='trig', dscr='dscr'},
    fmta([[
    if err != nil {
        return <>
    }
    ]],
    { i(1, "err") }
    )),
}
