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
	s(
		"snipf",
		fmt(
			[[ 
    <>({ trig='<>', name='<>', dscr='<>'},
    fmta(<>,
    { <> }
    )<>)<>,]],
			{
				c(1, { t("s"), t("autosnippet") }),
				i(2, "trig"),
				i(3, "trig"),
				i(4, "dscr"),
				i(5, "fmt"),
				i(6, "inputs"),
				i(7, "opts"),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),
	-- simple text snippet
	s(
		"snipt",
		fmt(
			[[ 
    <>(<>, {t('<>')}<>
    <>)<>,]],
			{
				c(1, { t("s"), t("autosnippet") }),
				c(2, { i(nil, "trig"), sn(nil, { t("{trig='"), i(1), t("'}") }) }),
				i(3, "text"),
				i(4, "opts"),
				i(5),
				i(0),
			},
			{ delimiters = "<>" }
		)
	),
	-- complex node stuff
	autosnippet(
		{ trig = "sch", name = "choice node", dscr = "add choice node" },
		fmt(
			[[
    c(<>, {<>}) 
    ]],
			{ i(1), i(0) },
			{ delimiters = "<>" }
		)
	),
	autosnippet(
		{ trig = "snode", name = "snippet node", dscr = "snippet node" },
		fmt(
			[[
    sn(<>, {<>}) 
    ]],
			{ i(1, "nil"), i(0) },
			{ delimiters = "<>" }
		)
	),
	-- add snippet conditions
	autosnippet(
		"scond",
		fmt([[{ condition = <>, show_condition = <> }]], { i(1, "math"), rep(1) }, { delimiters = "<>" })
	),
	-- special stuff - snippet regex, hide, switch priority
	autosnippet("sreg", { t("regTrig = true, hidden = true") }),
	autosnippet(
		{ trig = "sprio", name = "snip priority", dscr = "Autosnippet to set snippet priority" },
		fmt(
			[[ 
    priority = <>]],
			{ i(1, "1000") },
			{ delimiters = "<>" }
		)
	),
	autosnippet("shide", { t("hidden = true") }),
    -- postfix(".cc", {l(l.POSTFIX_MATCH:gsub("(%u)", "_%1"):lower())})
}
