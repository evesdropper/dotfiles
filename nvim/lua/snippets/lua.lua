-- Lua Snippets, 90% of which are for neovim/luasnip config.

--[
-- Imports
--]
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

--[
-- dynamic setup
--]

return {
	--[
	-- LuaSnip Snippets
	--]
	-- format snippet
	s("snipf",
	fmta([[ 
    <>({ trig='<>', name='<>', dscr='<>'},
    fmta(<>,
    { <> }
    )<>)<>,]],
	{ c(1, { t("s"), t("autosnippet") }), i(2, "trig"), i(3, "trig"), i(4, "dscr"),
    i(5, "fmt"), i(6, "inputs"), i(7, "opts"), i(0) })
	),
	-- simple text snippet
	s("snipt",
	fmta([[ 
    <>(<>, {t('<>')}<>
    <>)<>,]],
    { c(1, { t("s"), t("autosnippet") }),
    c(2, { i(nil, "trig"), sn(nil, { t("{trig='"), i(1), t("'}") }) }),
    i(3, "text"), i(4, "opts"), i(5), i(0) })
	),
	-- complex node stuff
	autosnippet({ trig = "sch", name = "choice node", dscr = "add choice node" },
    fmta([[
    c(<>, {<>}) 
    ]],
    { i(1), i(0) })
	),
	autosnippet({ trig = "snode", name = "snippet node", dscr = "snippet node" },
    fmta([[
    sn(<>, {<>}) 
    ]],
    { i(1, "nil"), i(0) })
	),
	-- add snippet conditions
	autosnippet("scond",
    fmta([[{ condition = <>, show_condition = <> }]], 
    { i(1, "math"), rep(1) })
	),
	-- special stuff - snippet regex, hide, switch priority
    autosnippet({ trig='sreg', name='snip regex', dscr='snip regex (trigEngine, hide from LSP)'},
    fmta([[
    trigEngine="<>", hidden=true
    ]],
    { c(1, {t("pattern"), t("ecma")}) }
    )),
	autosnippet({ trig = "sprio", name = "snip priority", dscr = "Autosnippet to set snippet priority" },
    fmta([[ 
    priority = <>
    ]],
	{ i(1, "1000") })
	),
	autosnippet("shide", { t("hidden = true") }),
}
