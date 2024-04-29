-- snippets for markdown
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local postfix = require("luasnip.extras.postfix").postfix
local get_visual = function(_, parent)
    return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
end

return {
	s(
		{ trig = "qe", name = "code", dscr = "code" },
		fmt(
			[[
    ```<>
    <>
    ```]],
			{ i(1, "text"), i(0) },
			{ delimiters = "<>" }
		)
	),
	autosnippet(
		{ trig = "qw", name = "trig", dscr = "code" },
		fmt(
			[[
    `<>`<>
    ]],
			{ i(1), i(0) },
			{ delimiters = "<>" }
		)
	),
	autosnippet(
		{ trig = "!-", name = "checkbox bp", dscr = "checkbox bullet point" },
		fmt(
			[[
    - [<>] <>
    ]],
			{ c(1, { t(" "), t("x") }), i(0) },
			{ delimiters = "<>" }
		)
	),
    autosnippet({ trig='!l', name='link', dscr='link'},
    fmta([[
    [<>](<>)
    ]],
    { d(1, get_visual), i(0) }
    )),
	autosnippet(
		{ trig = "dm", name = "math 2", dscr = "display math" },
		fmt(
			[[
    $$<>$$<>
    ]],
			{ i(1), i(0) },
			{ delimiters = "<>" }
		)
	),
    s({ trig='sdoc', name='trig', dscr='dscr'},
    fmta([[
    ## <>

    - <>

    ### Reflection
    <>
    ]],
    { os.date("%d-%m-%Y"), i(1), i(0) }
    )),
}, {
	s({ trig = "mk", name = "math", dscr = "inline math" }, fmt([[$<>$<>]], { i(1), i(0) }, { delimiters = "<>" })),
	-- s({ trig='dm', name='math 2', dscr='display math'},
	-- fmt([[$$<>$$]],
	-- { i(1), i(0) },
	-- { delimiters='<>' }
	-- )),
	postfix("vc", { l("`" .. l.POSTFIX_MATCH .. "`") }),
	postfix("vr", { l("$" .. l.POSTFIX_MATCH .. "$") }),
}
