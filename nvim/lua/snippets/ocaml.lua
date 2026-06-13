--[
-- Imports
--]
local ls = require("luasnip")
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local generate_matchcase_dynamic = require("snippets.utils").scaffolding.generate_matchcase_dynamic

-- [
-- Oh boy here we go again
-- ]
local M = {
    s({ trig='mc(%d*)', name='match case', dscr='match n cases', regTrig = true, hidden = true},
    fmta([[
    match <> with
        <>
        <>
    ]],
    { i(1), d(2, generate_matchcase_dynamic, {}, {
	user_args = {
		function(snip) snip.num_cases = snip.num_cases + 1 end,
		function(snip) snip.num_cases = math.max(snip.num_cases - 1, 1) end -- don't drop below 1 case, probably can be modified but it seems reasonable to me :shrug:
	}
    }),
    c(3, {t(""), isn(nil, fmt([[
    | _ -> {}
    ]], {i(1)}), "\t")})}
    )),
}

return M
