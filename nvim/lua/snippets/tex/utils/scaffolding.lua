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
local postfix = require("luasnip.extras.postfix").postfix

-- brackets
local brackets = {
	b = { "[", "]" },
	c = { "{", "}" },
	m = { "|", "|" },
	p = { "(", ")" },
}

-- postfix helper function - generates dynamic node
local generate_postfix_dynamicnode = function(_, parent, _, user_arg1, user_arg2)
    local capture = parent.snippet.env.POSTFIX_MATCH
    if #capture > 0 then
        return sn(nil, fmta([[
        <><><><>
        ]],
        {t(user_arg1), t(capture), t(user_arg2), i(0)}))
    else
        local visual_placeholder = parent.snippet.env.SELECT_RAW
        return sn(nil, fmta([[
        <><><><>
        ]],
        {t(user_arg1), i(1, visual_placeholder), t(user_arg2), i(0)}))
    end
end

-- Auto backslash - thanks kunzaatko! (ref: https://github.com/kunzaatko/nvim-dots/blob/trunk/lua/snippets/tex/utils/snippet_templates.lua)
M.auto_backslash_snippet = function(context, opts)
	opts = opts or {}
	if not context.trig then
		error("context doesn't include a `trig` key which is mandatory", 2)
	end
	context.dscr = context.dscr or (context.trig .. "with automatic backslash")
	context.name = context.name or context.trig
	context.docstring = context.docstring or ([[\]] .. context.trig)
	return autosnippet(context, t([[\]] .. context.trig), opts)
end

-- Auto symbol
M.symbol_snippet = function(context, command, opts)
	opts = opts or {}
	if not context.trig then
		error("context doesn't include a `trig` key which is mandatory", 2)
	end
	context.dscr = context.dscr or command
	context.name = context.name or command:gsub([[\]], "")
	context.docstring = context.docstring or (command .. [[{0}]])
	context.wordTrig = context.wordTrig or false
	return autosnippet(context, t(command), opts)
end

-- single command with option
M.single_command_snippet = function(context, command, opts, ext)
	opts = opts or {}
	if not context.trig then
		error("context doesn't include a `trig` key which is mandatory", 2)
	end
	context.dscr = context.dscr or command
	context.name = context.name or context.dscr
	local docstring, offset, cnode, lnode
	if ext.choice == true then
		docstring = "[" .. [[(<1>)?]] .. "]" .. [[{]] .. [[<2>]] .. [[}]] .. [[<0>]]
		offset = 1
		cnode = c(1, { t(""), sn(nil, { t("["), i(1, "opt"), t("]") }) })
	else
		docstring = [[{]] .. [[<1>]] .. [[}]] .. [[<0>]]
	end
	if ext.label == true then
		docstring = [[{]] .. [[<1>]] .. [[}]] .. [[\label{(]] .. ext.short .. [[:<2>)?}]] .. [[<0>]]
		ext.short = ext.short or command
		lnode =
			c(2 + (offset or 0), { t(""), sn(
				nil,
				fmta(
					[[
        \label{<>:<>}
        ]],
					{ t(ext.short), i(1) }
				)
			) })
	end
	context.docstring = context.docstring or (command .. docstring)
	-- stype = ext.stype or s
	return s(
		context,
		fmta(command .. [[<>{<>}<><>]], { cnode or t(""), i(1 + (offset or 0)), (lnode or t("")), i(0) }),
		opts
	)
end

-- TODO: environment: add choices for opts
M.env_snippet = function(context, command, opts, ext)
	opts = opts or {}
	if not context.trig then
		error("context doesn't include a `trig` key which is mandatory", 2)
	end
	context.dscr = context.dscr or command
	context.name = context.name or context.dscr
	local docstring, offset, delim, anode
	if ext.opt == true then
		docstring = ""
		offset = 1
		delim = ext.delim or "b"
		anode = sn(1, { t(brackets[delim][1]), i(1), t(brackets[delim][2]) })
	else
		docstring = ""
	end
	return s(
		context,
		fmta(
			[[
    \begin{<>}<>
    <>
    \end{<>}
    ]],
			{ t(command), (anode or t("")), i(1 + (offset or 0)), t(command) }
		),
		opts
	)
end

-- tcolorbox snippets
M.tcolorbox_snippet = function(context, command, opts)
	opts = opts or {}
	if not context.trig then
		error("context doesn't include a `trig` key which is mandatory", 2)
	end
	context.dscr = context.dscr or command
	context.name = context.name or context.dscr
	context.docstring = (
		[[\begin{]]
		.. context.name
		.. [[}[<1>][]]
		.. command
		.. [[(<2>)?]{<3>]]
		.. string.char(10)
		.. [[}]]
		.. string.char(10)
		.. [[\end{]]
		.. context.name
		.. [[}]]
	) or context.dscr
	-- return s(context, t(command), opts)
	return s(
		context,
		fmta(
			[[
    \begin{<>}[<>]<>{<>
    }
    \end{<>}
    ]],
			{
				t(context.name),
				i(1),
				c(2, { t(""), fmta(
					[[
    [<>:<>]
    ]],
					{ t(command), i(1) }
				) }),
				i(0),
				t(context.name),
			}
		),
		opts
	)
end

M.postfix_snippet = function (context, command, opts)
    opts = opts or {}
	if not context.trig then
		error("context doesn't include a `trig` key which is mandatory", 2)
	end
	if not context.trig then
		error("context doesn't include a `trig` key which is mandatory", 2)
	end
	context.dscr = context.dscr
	context.name = context.name or context.dscr
    context.docstring = command.pre .. [[(POSTFIX_MATCH|VISUAL|<1>)]] .. command.post
    return postfix(context, {d(1, generate_postfix_dynamicnode, {}, { user_args = {command.pre, command.post} })}, opts)
end

return M
