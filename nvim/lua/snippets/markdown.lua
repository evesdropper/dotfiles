-- snippets for markdown
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local postfix = require("luasnip.extras.postfix").postfix

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
