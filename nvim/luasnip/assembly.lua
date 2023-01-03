-- snippets for markdown
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
},
	{
		s({ trig = "mk", name = "math", dscr = "inline math" }, fmt([[$<>$<>]], { i(1), i(0) }, { delimiters = "<>" })),
		-- s({ trig='dm', name='math 2', dscr='display math'},
		-- fmt([[$$<>$$]],
		-- { i(1), i(0) },
		-- { delimiters='<>' }
		-- )),
		postfix("qw", { l("`" .. l.POSTFIX_MATCH .. "`") }),
		postfix("vr", { l("$" .. l.POSTFIX_MATCH .. "$") }),
	}
