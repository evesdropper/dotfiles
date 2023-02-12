-- LaTeX Snippets
-- TODO:
-- set options for matrix and table snippets (either auto generate or user input)
-- fix integral snippet
-- clean up snippets

--[
-- Setup: LuaSnip imports, define conditions/additional functions for function/dynamic nodes.
--]
local postfix = require("luasnip.extras.postfix").postfix
local line_begin = require("luasnip.extras.conditions.expand").line_begin
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local utils = require("snippets.tex.utils")

-- condition envs
-- global p! functions from UltiSnips
local function math()
	return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end

local function in_text()
    return not math()
end

local function env(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end

local function tikz()
	return env("tikzpicture")
end

local function bp()
	return env("itemize") or env("enumerate")
end

local function beamer()
	return vim.b.vimtex["documentclass"] == "beamer"
end

-- brackets
brackets = {
	a = { "angle", "angle" },
	A = { "Angle", "Angle" },
	b = { "brack", "brack" },
	B = { "Brack", "Brack" },
	c = { "brace", "brace" },
	m = { "|", "|" },
	p = { "(", ")" },
}

-- util 
local function isempty(s) --util 
  return s == nil or s == ''
end

-- dynamic stuff
-- LFG tables and matrices work
local tab = function(args, snip)
	local rows = tonumber(snip.captures[1])
	local cols = tonumber(snip.captures[2])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ "\\\\", "" }))
		if j == 1 then
			table.insert(nodes, t({ "\\midrule", "" }))
		end
	end
	nodes[#nodes] = t("\\\\")
	return sn(nil, nodes)
end

-- yes this is a ripoff
-- thanks L3MON4D3!
local mat = function(args, snip)
	local rows = tonumber(snip.captures[2])
	local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ "\\\\", "" }))
	end
	-- fix last node.
	nodes[#nodes] = t("\\\\")
	return sn(nil, nodes)
end

-- update for cases
local case = function(args, snip)
	local rows = tonumber(snip.captures[1]) or 2 -- default option 2 for cases
	local cols = 2 -- fix to 2 cols
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
		ins_indx = ins_indx + 1
		for k = 2, cols do
			table.insert(nodes, t(" & "))
			table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
			ins_indx = ins_indx + 1
		end
		table.insert(nodes, t({ "\\\\", "" }))
	end
	-- fix last node.
	nodes[#nodes] = t("\\\\")
	return sn(nil, nodes)
end

-- add table/matrix/case row
local tr = function(args, snip)
	local cols = tonumber(snip.captures[1])
	local nodes = {}
	local ins_indx = 1
	table.insert(nodes, r(ins_indx, "1", i(1)))
	ins_indx = ins_indx + 1
	for k = 2, cols do
		table.insert(nodes, t(" & "))
		table.insert(nodes, r(ins_indx, tostring(k), i(1)))
		ins_indx = ins_indx + 1
	end
	table.insert(nodes, t({ "\\\\", "" }))
	-- fix last node.
	nodes[#nodes] = t("\\\\")
	return sn(nil, nodes)
end

-- integral functions
local int1 = function(args, snip)
	local vars = tonumber(snip.captures[1])
	local nodes = {}
	for j = 1, vars do
		table.insert(nodes, t("\\int_{"))
		table.insert(nodes, r(2*j-1, "lb" .. tostring(j), i(1)))
		table.insert(nodes, t("}^{"))
		table.insert(nodes, r(2*j, "ub" .. tostring(j), i(1)))
		table.insert(nodes, t("} "))
	end
	return sn(nil, nodes)
end

local int2 = function(args, snip)
	local vars = tonumber(snip.captures[1])
	local nodes = {}
	for j = 1, vars do
		table.insert(nodes, t(" \\dd "))
		table.insert(nodes, r(j, "var" .. tostring(j), i(1)))
	end
	return sn(nil, nodes)
end

-- visual util to add insert node
-- thanks ejmastnak!
local get_visual = function(args, parent)
	if #parent.snippet.env.SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
	else -- If SELECT_RAW is empty, return a blank insert node
		return sn(nil, i(1))
	end
end

-- cite util 
local generate_label = function(args, parent, _, user_arg1, user_arg2)
    if user_arg2 ~= "xargs" then
        delims = {"\\label{", "}"}
    else
        delims = {"[", "]"}
    end
    if isempty(user_arg1) then
        return sn(nil, fmta([[
        \label{<>}
        ]], {i(1)}))
    else
        return sn(nil, fmta([[
        <><>:<><>
        ]], {t(delims[1]), t(user_arg1), i(1), t(delims[2])}))
    end
end

-- jokar arc of luasnip breaking
local generate_label_snode = function(label_head, xargs)
    if xargs == false then
        delims = {"\\label{", "}"}
    else
        delims = {"[", "]"}
    end
    if isempty(label_head) then
        return sn(nil, fmta([[
        \label{<>}
        ]], {i(1)}))
    else
        return sn(nil, fmta([[
        <><>:<><>
        ]], {t(delims[1]), t(label_head), i(1), t(delims[2])}))
    end
end

-- single command \cmd{$1}$0 
local single_command = function(cmd)
    offset = 0
    if cmd.opt == true then
        cmd.opt = c(1, { t(""), sn(nil, { t("["), i(1, "opt"), t("]") }) })
        offset = offset + 1
    else
        cmd.opt = t("")
    end
    if cmd.slash == false then
        cmd.slash = ""
    else
        cmd.slash = "\\"
    end
    if cmd.ast == true then
        cmd.ast = "*"
    else
        cmd.ast = ""
    end
    return sn(1, fmta([[
    <><>{<>}<>
    ]], {t(cmd.slash .. cmd.string .. cmd.ast), cmd.opt, i(1 + offset), i(0)}))
end

local create_latex_env = function(opts)

end

-- return arbitrary snip captures + string concatenate
local get_capture = function(_, snip, user_arg1, user_arg2, user_arg3)
    -- define arguments 
    idx = user_arg1 or 1
    pre = user_arg2 or ""
    post = user_arg3 or ""
    return snip.captures[idx]
end

-- TODO: itemize/enumerate
--[[ rec_ls = function() ]]
--[[ 	return sn(nil, { ]]
--[[ 		c(1, { ]]
--[[ 			-- important!! Having the sn(...) as the first choice will cause infinite recursion. ]]
--[[ 			t({""}), ]]
--[[ 			-- The same dynamicNode as in the snippet (also note: self reference). ]]
--[[ 			sn(nil, {t({"", "\t\\item "}), i(1), d(2, rec_ls, {})}), ]]
--[[ 		}), ]]
--[[ 	}); ]]
--[[ end ]]
--[[]]

--[
-- Snippets go here
--]

local M = {
	--[
	-- Templates: Stuff for lecture notes, homeworks, and draft documents
	--]
	s(
		{ trig = "texdoc", name = "new tex doc", dscr = "Create a general new tex document" },
		fmt(
			[[ 
    \documentclass{article}
    \usepackage{iftex}
    \ifluatex
    \directlua0{
    pdf.setinfo (
        table.concat (
        {
           "/Title (<>)",
           "/Author (Evelyn Koo)",
           "/Subject (<>)",
           "/Keywords (<>)"
        }, " "
        )
    )
    }
    \fi
    \usepackage{graphicx}
    \graphicspath{{figures/}}
    \usepackage[lecture]{random}
    \pagestyle{fancy}
    \fancyhf{}
    \rhead{\textsc{Evelyn Koo}}
    \chead{\textsc{<>}}
    \lhead{<>}
    \cfoot{\thepage}
    \begin{document}
    \title{<>}
    \author{Evelyn Koo}
    \date{<>}
    \maketitle
    \tableofcontents
    \section*{<>}
    \addcontentsline{toc}{section}{<>}
    <>
    \subsection*{Remarks}
    <>
    \end{document}
    ]],
			{ i(3), i(2), i(7), i(1), rep(2), rep(3), i(4), i(5), rep(5), i(6), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "hwtex", name = "texdoc for hw", dscr = "tex template for my homeworks" },
		fmt(
			[[ 
    \documentclass{article}
    \usepackage{iftex}
    \ifluatex
    \directlua0{
    pdf.setinfo (
        table.concat (
        {
           "/Title (<> <>)",
           "/Author (Evelyn Koo)",
           "/Subject (<>)",
           "/Keywords (<>)"
        }, " "
        )
    )
    }
    \fi
    \usepackage{graphicx}
    \graphicspath{{figures/}}
    \usepackage[lecture]{random}
    \pagestyle{fancy}
    \fancyhf{}
    \rhead{\textsc{Evelyn Koo}}
    \chead{\textsc{Homework <>}}
    \lhead{<>}
    \cfoot{\thepage}
    \begin{document}
    \homework[<>]{<>}{<>}
    <>
    \end{document}
    ]],
			{ t("Homework"), i(1), i(2), i(3), rep(1), rep(2), t(os.date("%d-%m-%Y")), rep(2), rep(1), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "texbook", name = "tex book", dscr = "make a new tex book", hidden = true },
		fmt(
			[[
    \documentclass[twoside]{book}
    \usepackage[utf8]{inputenc}
    \usepackage{makeidx}
    \usepackage{tocbibind}
    \usepackage[totoc]{idxlayout} 
    \input{pre/preamble.tex}

    \begin{document}
    <>
    \end{document}
    ]],
			{ i(1) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "draft", name = "draft", dscr = "draft", hidden = true },
		fmt(
			[[ 
    \documentclass{article}
    \usepackage{random}
    \begin{document}
    <>
    \end{document}
    ]],
			{ i(0) },
			{ delimiters = "<>" }
		),
		{ condition = line_begin, show_condition = line_begin }
	),
    s({ trig='lectex', name='lecture template', dscr='lecture template'},
        fmt([[
        \documentclass[<>]{subfiles}
        \begin{document}
        \lecture[<>]{<>}
        <>
        \end{document}
        ]],
    { i(1, "./master.tex"), t(os.date("%Y-%m-%d")), i(2), i(0) },
    { delimiters='<>' }
    )),

	-- [
	-- Introductory Stuff: e.g. table of contents, packages, other setup Stuff
	-- think templates but modular
	-- ]
	s(
		{ trig = "pac", name = "add package", dscr = "add package" },
		single_command({string="usepackage", opt=true})
	),
	s(
		{ trig = "atoc", name = "add toc", dscr = "add this to toc line" },
		fmt(
			[[ 
    \addcontentsline{toc}{<>}{<>}
    <>
    ]],
			{ i(1, "section"), i(2, "content"), i(0) },
			{ delimiters = "<>" }
		)
	),

	--[
	-- Semantic Snippets: sections n stuff, mostly stolen from markdown
	--]

	-- sections from LaTeX
	s(
		{ trig = "#", hidden = true, priority = 250 },
		fmt(
			[[
    \section{<>}<>
    <>]],
			{ i(1), c(2, {t(""), generate_label_snode("sec", false)
            }), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "#*", hidden = true, priority = 250 },
		fmt(
			[[
    \section*{<>}<>
    <>]],
			{ i(1), c(2, {t(""), d(1, generate_label, {}, {user_args={"sec"}} ),
            }), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "##", hidden = true, priority = 500 },
		fmt(
			[[
    \subsection{<>}<>
    <>]],
			{ i(1), c(2, {t(""), d(1, generate_label, {}, {user_args={"subsec"}} ),
            }), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "##*", hidden = true, priority = 500 },
		fmt(
			[[
    \subsection*{<>}<>
    <>]],
			{ i(1), c(2, {t(""), d(1, generate_label, {}, {user_args={"subsec"}} ),
            }), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "###", hidden = true, priority = 1000 },
		fmt(
			[[ 
    \subsubsection{<>}
    <>]],
			{ i(1), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "###*", hidden = true, priority = 1000 },
		fmt(
			[[ 
    \subsubsection*{<>}
    <>]],
			{ i(1), i(0) },
			{ delimiters = "<>" }
		)
	),

	-- custom sections
	s(
		{ trig = "#l", name = "lecture", dscr = "fancy section header - lecture #", hidden = true },
		fmt(
			[[ 
    \lecture[<>]{<>}
    <>]],
			{ t(os.date("%Y-%m-%d")), i(1), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "#ch", name = "chap", dscr = "fancy section header - chapter #", hidden = true },
		fmt(
			[[ 
    \bookchap[<>]{<>}{<>}
    <>]],
			{ t(os.date("%d-%m-%Y")), i(1, "dscr"), i(2, "\\thesection"), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "#f", name = "fancy section", dscr = "fancy section header - vanilla", hidden = true },
		fmt(
			[[ 
    \fancysec[<>]{<>}{<>}
    <>]],
			{ t(os.date("%d-%m-%Y")), i(1, "dscr"), i(2, "title"), i(0) },
			{ delimiters = "<>" }
		)
	),

	-- links images figures
	s(
		{ trig = "!l", name = "link", dscr = "Link reference", hidden = true },
		fmt([[\href{<>}{\color{<>}<>}<>]], { i(1, "link"), i(3, "blue"), i(2, "title"), i(0) }, { delimiters = "<>" })
	),
	s(
		{ trig = "!i", name = "image", dscr = "Image (no caption, no float)" },
		fmt(
			[[ 
    \begin{Center}
    \includegraphics[width=<>\textwidth]{<>}
    \end{Center}
    <>]],
			{ i(1, "0.5"), i(2), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "!f", name = "figure", dscr = "Float Figure" },
		fmt(
			[[ 
    \begin{figure}[<>] 
    <>
    \end{figure}]],
			{ i(1, "htb!"), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "gr", name = "figure image", dscr = "float image" },
		fmt(
			[[
    \centering
    \includegraphics[width=<>\textwidth]{<>}\caption{<>}<>]],
			{ i(1, "0.5"), i(2), i(3), i(0) },
			{ delimiters = "<>" }
		)
	),

	-- code highlighting
	s(
		{ trig = "qw", name = "inline code", dscr = "inline code, ft escape" },
		fmt(
			[[\mintinline{<>}<>]],
			{ i(1, "text"), c(2, { sn(nil, { t("{"), i(1), t("}") }), sn(nil, { t("|"), i(1), t("|") }) }) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "qe", name = "code", dscr = "Code with minted." },
		fmt(
			[[ 
    \begin{minted}{<>}
    <>
    \end{minted}
    <>]],
			{ i(1, "python"), i(2), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "mp", name = "minipage", dscr = "create minipage env" }, -- choice node
		fmt(
			[[
    \begin{minipage}{<>\textwidth}
    <>
    \end{minipage}]],
			{ c(1, { t("0.5"), t("0.33"), i(nil) }), i(0) },
			{ delimiters = "<>" }
		)
	),

	-- Book Club
	-- references
	autosnippet(
		{ trig = "alab", name = "labels", dscr = "add a label" },
		fmt(
			[[
    \label{<>:<>}<>
    ]],
			{ i(1), i(2), i(0) },
			{ delimiters = "<>" }
		)
	),
	autosnippet(
		{ trig = "aref", name = "references", dscr = "add a reference" },
		fmt(
			[[
    \Cref{<>:<>}<>
    ]],
			{ i(1), i(2), i(0) },
			{ delimiters = "<>" }
		)
	),

	--[
	-- Environments
	--]
	-- generic
	s(
		{ trig = "beg", name = "begin env", dscr = "begin/end environment" },
		fmt(
			[[
    \begin{<>}
    <>
    \end{<>}]],
			{ i(1), i(0), rep(1) },
			{ delimiters = "<>" }
		)
	),

	-- Bullet Points
	s(
		{ trig = "-i", name = "itemize", dscr = "bullet points (itemize)" },
		fmt(
			[[ 
    \begin{itemize}
    \item <>
    \end{itemize}]],
			{ c(1, {i(0), sn(nil, fmta([[
            [<>] <>
            ]], {i(1), i(0)}))}) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "-e", name = "enumerate", dscr = "numbered list (enumerate)" },
		fmt(
			[[ 
    \begin{enumerate}<>
    \item <>
    \end{enumerate}]],
			{ c(1, {t(""),
            sn(nil, fmta([[
            [label=<>]
            ]], {c(1, {t("(\\alph*)"), t("(\\roman*)"), i(1)})}))
            }), c(2, {i(0), sn(nil, fmta([[
            [<>] <>
            ]], {i(1), i(0)}))}) },
			{ delimiters = "<>" }
		)
	),
	-- label n stuff
	-- autosnippet(
	-- 	{ trig = "-l", name = "add label", dscr = "add labeling" },
	-- 	fmt(
	-- 		[[
 --    [label=<>]
 --    ]],
	-- 		{ i(1) },
	-- 		{ delimiters = "<>" }
	-- 	),
	-- 	{ condition = bp, show_condition = bp }
	-- ),
	-- generate new bullet points
	autosnippet(
		{ trig = "--", hidden = true },
		{ t("\\item") },
		{ condition = bp * line_begin, show_condition = bp * line_begin }
	),
	autosnippet(
		{ trig = "!-", name = "bp custom", dscr = "bullet point" },
		fmt(
			[[ 
    \item [<>]<>
    ]],
			{ i(1), i(0) },
			{ delimiters = "<>" }
		),
		{ condition = bp * line_begin, show_condition = bp * line_begin }
	),

	-- tcolorboxes
	s(
		{ trig = "adef", name = "add definition", dscr = "add definition box" },
		fmt(
			[[ 
    \begin{definition}[<>]<>{<>
    }
    \end{definition}]],
			{ i(1), c(2, {t(""), d(1, generate_label, {}, {user_args={"def", "xargs"}}) }), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "aex", name = "add example", dscr = "add example box" },
		fmt(
			[[ 
    \begin{example}[<>]<>{<>
    }
    \end{example}]],
            { i(1), c(2, {t(""), d(1, generate_label, {}, {user_args={"ex", "xargs"}}) }), i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "athm", name = "add theorem", dscr = "add theorem box" },
		fmt(
			[[ 
    \begin{theorem}[<>]<>{<>
    }
    \end{theorem}]],
            { i(1), c(2, {t(""), d(1, generate_label, {}, {user_args={"thm", "xargs"}}) }),  i(0) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "nb", name = "notebox", dscr = "add notebox idk why this format is diff" },
		fmt(
			[[ 
    \begin{notebox}[<>]<>{<>
    }
    \end{notebox}]],
			{ i(1), c(2, {t(""), d(1, generate_label, {}, {user_args={"note", "xargs"}}) }), i(0) },
			{ delimiters = "<>" }
		)
	),
    s({ trig='rmb', name='remarkbox', dscr='ahsjd'},
    fmt([[
    \begin{remark}[<>]<>{<>
    }
    \end{remark}
    ]],
    { i(1, "title"), c(2, {t(""), d(1, generate_label, {}, {user_args={"rmk", "xargs"}}) }), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='aprop', name='propbox', dscr='add proposition box'},
        fmt([[
        \begin{proposition}[<>]<>{<>
        }
        \end{proposition}
        ]],
    { i(1), c(2, {t(""), d(1, generate_label, {}, {user_args={"prop", "xargs"}}) }), i(0) },
    { delimiters='<>' }
    )),

	-- tables/matrices
	s(
		{ trig = "tab(%d+)x(%d+)", regTrig = true, name = "test for tabular", dscr = "test", hidden = true },
		fmt(
			[[
    \begin{tabular}{@{}<>@{}}
    \toprule
    <>
    \bottomrule
    \end{tabular}]],
			{ f(function(_, snip)
				return string.rep("c", tonumber(snip.captures[2]))
			end), d(1, tab) },
			{ delimiters = "<>" }
		)
	),
	s(
		{ trig = "([bBpvV])mat(%d+)x(%d+)([ar])", regTrig = true, name = "matrix", dscr = "matrix trigger lets go", hidden = true },
		fmt(
			[[
    \begin{<>}<>
    <>
    \end{<>}]],
			{
				f(function(_, snip)
					return snip.captures[1] .. "matrix"
				end),
				f(function(_, snip)
					if snip.captures[4] == "a" then
						out = string.rep("c", tonumber(snip.captures[3]) - 1)
						return "[" .. out .. "|c]"
					end
					return ""
				end),
				d(1, mat),
				f(function(_, snip)
					return snip.captures[1] .. "matrix"
				end),
			},
			{ delimiters = "<>" }
		),
		{ condition = math, show_condition = math }
	),

	-- etc
	s(
		{ trig = "sol", name = "solution", dscr = "solution box for homework" },
		fmt(
			[[ 
    \begin{solution}
    <>
    \end{solution}]],
			{ i(0) },
			{ delimiters = "<>" }
		)
	),

	--[
	-- Math Snippets - Environments/Setup Commands
	--]

	-- entering math mode
	autosnippet(
		{ trig = "mk", name = "math", dscr = "inline math", regTrig=true, hidden=true, wordTrig=false },
		fmt([[$<>$<>]], { i(1), i(0) }, { delimiters = "<>" })
	),
	autosnippet(
		{ trig = "dm", name = "math", dscr = "display math", regTrig=true, hidden=true, wordTrig=false },
		fmt(
			[[ 
    \[ 
    <>
    .\]
    <>]],
			{ i(1), i(0) },
			{ delimiters = "<>" }
		),
		{ condition = line_begin, show_condition = line_begin }
	),
	autosnippet(
		{ trig = "ali", name = "align", dscr = "align math" },
		fmt(
			[[ 
    \begin{align<>}
    <>
    .\end{align<>}
    ]],
			{ i(1, "*"), i(2), rep(1) },
			{ delimiters = "<>" }
		),
		{ condition = line_begin, show_condition = line_begin }
	),
	autosnippet(
		{ trig = "gat", name = "gather", dscr = "gather math" },
		fmt(
			[[ 
    \begin{gather<>}
    <>
    .\end{gather<>}
    ]],
			{ i(1, "*"), i(2), rep(1) },
			{ delimiters = "<>" }
		),
		{ condition = line_begin, show_condition = line_begin }
	),
	autosnippet(
		{ trig = "eqn", name = "equation", dscr = "equation math" },
		fmt(
			[[
    \begin{equation<>}
    <>
    .\end{equation<>}
    ]],
			{ i(1, "*"), i(2), rep(1) },
			{ delimiters = "<>" }
		),
		{ condition = line_begin, show_condition = line_begin }
	),
	autosnippet(
		{ trig = "(%d?)cases", name = "cases", dscr = "cases", regTrig = true, hidden = true },
		fmt(
			[[
    \begin{cases}
    <>
    .\end{cases}
    ]],
			{ d(1, case) },
			{ delimiters = "<>" }
		),
		{ condition = math, show_condition = math }
	),

	-- delimiters
	s(
		{ trig = "lr", name = "left right", dscr = "left right" },
		fmt([[\left(<>\right)<>]], { i(1), i(0) }, { delimiters = "<>" }),
		{ condition = math }
	),
	autosnippet(
		{ trig = "lr([aAbBcmp])", name = "left right", dscr = "left right delimiters", regTrig = true, hidden = true },
		fmt(
			[[
    \left<> <> \right<><>
    ]],
			{
				f(function(_, snip)
					cap = snip.captures[1]
					if brackets[cap] == nil then
						cap = "p"
					end -- set default to parentheses
					return brackets[cap][1]
				end),
				d(1, get_visual),
				f(function(_, snip)
					cap = snip.captures[1]
					if brackets[cap] == nil then
						cap = "p"
					end
					return brackets[cap][2]
				end),
				i(0),
			},
			{ delimiters = "<>" }
		),
		{ condition = math, show_condition = math }
	),

	-- operators, symbols
	autosnippet(
		{ trig = "//", name = "fraction", dscr = "fraction (autoexpand)" },
		fmt([[\frac{<>}{<>}<>]], { i(1), i(2), i(0) }, { delimiters = "<>" }),
		{ condition = math }
	),
    autosnippet({ trig='(%d)/', name='fraction 2', dscr='fraction autoexpand 2', regTrig=true, hidden=true},
    fmt([[
    \frac{<>}{<>}<>
    ]],
    { f(get_capture, {}, {user_args={1}}), i(1), i(0) },
    { delimiters='<>' }
    ), { condition=math, show_condition=math }),
	autosnippet("==", { t("&="), i(1), t("\\\\") }, { condition = math }),
	autosnippet("!+", { t("\\oplus") }, { condition = math, show_condition = math }),
	autosnippet("!*", { t("\\otimes") }, { condition = math, show_condition = math }),
	autosnippet({ trig = "!!+", priority = 500 }, { t("\\bigoplus") }, { condition = math, show_condition = math }),
	autosnippet({ trig = "!!*", priority = 500 }, { t("\\bigotimes") }, { condition = math, show_condition = math }),
	autosnippet({ trig = "Oo", priority = 50 }, { t("\\circ") }, { condition = math, show_condition = math }),
    autosnippet("::", {t('\\colon')},
    { condition=math, show_condition=math }),
    autosnippet({ trig='adot', name='dot', dscr='dot above'},
    {single_command({string="dot"})}, { condition=math, show_condition=math }),

	-- sub super scripts
	autosnippet(
		{ trig = "([%a%)%]%}])(%d)", regTrig = true, name = "auto subscript", dscr = "hi" },
		fmt(
			[[<>_<>]],
			{ f(get_capture, {}, {user_args = {1}}),
            f(get_capture, {}, {user_args = {2}}) },
			{ delimiters = "<>" }
		),
		{ condition = math }
	),
	autosnippet(
		{ trig = "([%a%)%]%}])_(%d%d)", regTrig = true, name = "auto subscript 2", dscr = "auto subscript for 2+ digits" },
		fmt(
			[[<>_{<>}]],
            { f(get_capture, {}, {user_args = {1}}),
            f(get_capture, {}, {user_args = {2}}) },
			{ delimiters = "<>" }
		),
		{ condition = math }
	),
	autosnippet("xnn", { t("x_n") }, { condition = math }),
	autosnippet("xii", { t("x_i") }, { condition = math }),
	autosnippet("xjj", { t("x_j") }, { condition = math }),
	autosnippet("ynn", { t("y_n") }, { condition = math }),
	autosnippet("yii", { t("y_i") }, { condition = math }),
	autosnippet("yjj", { t("y_j") }, { condition = math }),
	autosnippet({ trig = "sr", wordTrig = false }, { t("^2") }, { condition = math }),
	autosnippet({ trig = "cb", wordTrig = false }, { t("^3") }, { condition = math }),
	autosnippet({ trig = "compl", wordTrig = false }, { t("^{c}") }, { condition = math }),
	autosnippet({ trig = "vtr", wordTrig = false }, { t("^{T}") }, { condition = math }),
	autosnippet({ trig = "inv", wordTrig = false }, { t("^{-1}") }, { condition = math }),
	autosnippet(
		{ trig = "td", name = "superscript", dscr = "superscript", wordTrig = false },
		fmt([[^{<>}<>]], { i(1), i(0) }, { delimiters = "<>" }),
		{ condition = math }
	),

	-- (greek) symbols
	-- TODO: add greek symbol thing
	autosnippet("lll", { t("\\ell") }, { condition = math, show_condition = math }),

	-- stuff i need to do calculus
	autosnippet("dd", { t("\\dd") }, { condition = math, show_condition = math }),
	autosnippet("nabl", { t("\\nabla") }, { condition = math, show_condition = math }),
	autosnippet("grad", { t("\\grad") }, { condition = math, show_condition = math }),
	autosnippet(
		{ trig = "lim", name = "lim(sup|inf)", dscr = "lim(sup|inf)" },
		fmt(
			[[ 
    \lim<><><>
    ]],
            { c(1, { t(""), t("sup"), t("inf") }), c(2, {t(""), fmta([[_{<> to <>}]], {i(1, "n"), i(2, "\\infty")})}), i(0) },
			{ delimiters = "<>" }
		),
		{ condition = math, show_condition = math }
	),
	autosnippet(
		{ trig = "part", name = "partial derivative", dscr = "partial derivative" },
		fmt(
			[[ 
    \frac{\ddp <>}{\ddp <>}<>
    ]],
			{ i(1, "V"), i(2, "x"), i(0) },
			{ delimiters = "<>" }
		),
		{ condition = math, show_condition = math }
	),
	autosnippet(
		{ trig = "dint", name = "integrals", dscr = "integrals but cooler" },
		fmt(
			[[
    \<>int_{<>}^{<>} <> <> <>
    ]],
			{ c(1, { t(""), t("o") }), i(2, "-\\infty"), i(3, "\\infty"), i(4), t("\\dd"), i(0) },
			{ delimiters = "<>" }
		),
		{ condition = math, show_condition = math }
	),
	autosnippet(
		{ trig = "(%d)int", name = "multi integrals", dscr = "please work", regTrig = true, hidden = false },
		fmt(
			[[ 
    <> <> <> <>
    ]],
			{
				c(1, {
					fmta(
						[[
    \<><>nt_{<>}
    ]],
						{
							c(1, { t(""), t("o") }),
							f(function(_, parent, snip)
								inum = tonumber(parent.parent.captures[1]) -- this guy's lineage looking like a research lab's
								res = string.rep("i", inum)
								return res
							end),
							i(2),
						}
					),
					d(nil, int1),
				}),
				i(2),
				d(3, int2),
				i(0),
			},
			{ delimiters = "<>" }
		),
		{ condition = math, show_condition = math }
	),
	autosnippet(
		{ trig = "elr", name = "eval left right", dscr = "eval left right" },
        {single_command({string="eval"})},
		{ condition = math, show_condition = math }
	),
	autosnippet(
		{ trig = "sum", name = "summation", dscr = "summation" },
		fmt(
			[[
    \sum_{<>}^{<>} <>
    ]],
			{ i(1, "i = 0"), i(2, "\\infty"), i(0) },
			{ delimiters = "<>" }
		),
		{ condition = math, show_condition = math }
	),
	autosnippet(
		{ trig = "prod", name = "product", dscr = "summation" },
		fmt(
			[[
    \prod_{<>}^{<>} <>
    ]],
			{ i(1, "i = 0"), i(2, "\\infty"), i(0) },
			{ delimiters = "<>" }
		),
		{ condition = math, show_condition = math }
	),

	-- linalg stuff minus matrices
	autosnippet(
		{ trig = "norm", name = "norm", dscr = "norm" },
        {single_command({string="norm"})},
		{ condition = math, show_condition = math }
	),
	autosnippet(
		{ trig = "iprod", name = "inner product", dscr = "inner product" },
        {single_command({string="vinner"})},
		{ condition = math, show_condition = math }
	),

	-- discrete maf

	-- quantifiers and cs70 n1 stuff
	autosnippet("||", { t("\\divides") }, { condition = math }),
	autosnippet("!|", { t("\\notdivides") }, { condition = math, show_condition = math }),
	autosnippet({ trig = "-->", priority= 500 }, { t("\\longrightarrow") }, { condition = math }),
	autosnippet({ trig = "<->", priority = 500 }, { t("\\leftrightarrow") }, { condition = math }),
    autosnippet({trig='2>', priority=400}, {t('\\rightrightarrows')},
    { condition=math, show_condition=math }),

	-- sets
	autosnippet(
		{ trig = "set", name = "set", dscr = "set" }, -- overload with set builder notation
		fmt([[\{<>\}<>]], { c(1, { r(1, ""), sn(nil, { r(1, ""), t(" \\mid "), i(2) }) }), i(0) }, { delimiters = "<>" }),
		{ condition = math }
	),
    autosnippet({ trig='nnn', name='bigcap', dscr='bigcaps'},
    fmt([[
    \bigcap_{<>}^{<>} <>
    ]],
    { i(1, "i=0"), i(2, "\\infty"), i(0) },
    { delimiters='<>' }
    ),{ condition=math, show_condition=math }),
    autosnippet({ trig='uuu', name='bigcup', dscr='bigcaps'},
    fmt([[
    \bigcup_{<>}^{<>} <>
    ]],
    { i(1, "i=0"), i(2, "\\infty"), i(0) },
    { delimiters='<>' }
    ),{ condition=math, show_condition=math }),


	-- counting, probability
	autosnippet(
		{ trig = "bnc", name = "binomial", dscr = "binomial (nCR)" },
		fmt([[\binom{<>}{<>}<>]], { i(1), i(2), i(0) }, { delimiters = "<>" }),
		{ condition = math }
	),

	-- etc: utils and stuff
	autosnippet(
		{ trig = "([clvda])%.", regTrig = true, name = "dots", dscr = "generate some dots" },
		fmt([[\<>dots]], { f(get_capture, {}, {user_args={1}}) }, { delimiters = "<>" }),
		{ condition = math }
	),
	autosnippet("lb", { t("\\\\") }, { condition = math }),
	autosnippet("tcbl", { t("\\tcbline") }),
	autosnippet("ctd", { t("%TODO: "), i(1) }),
	autosnippet("upar", { t("\\uparrow") }, { condition = math, show_condition = math }),
	autosnippet("dnar", { t("\\downarrow") }, { condition = math, show_condition = math }),
	autosnippet("dag", { t("\\dagger") }, { condition = math, show_condition = math })
}
-- 	{
-- 		-- hats and bars (postfixes)
-- 		postfix(
-- 			{ trig = "bar", snippetType = "autosnippet" },
-- 			{ l("\\overline{" .. l.POSTFIX_MATCH .. "}") },
-- 			{ condition = math }
-- 		),
-- 		postfix("hat", { l("\\hat{" .. l.POSTFIX_MATCH .. "}") }, { condition = math }),
-- 		postfix("..", { l("\\" .. l.POSTFIX_MATCH .. " ") }, { condition = math, show_condition = math }),
-- 		postfix({ trig = ",.", priority = 500 }, { l("\\vec{" .. l.POSTFIX_MATCH .. "}") }, { condition = math }),
-- 		postfix(",,.", { l("\\mat{" .. l.POSTFIX_MATCH .. "}") }, { condition = math }),
-- 		postfix("vr", { l("$" .. l.POSTFIX_MATCH .. "$") }),
-- 		postfix("mbb", { l("\\mathbb{" .. l.POSTFIX_MATCH .. "}") }, { condition = math }),
-- 		postfix("vc", { l("\\mintinline{text}{" .. l.POSTFIX_MATCH .. "}") }),
-- 		postfix("tld", { l("\\tilde{" .. l.POSTFIX_MATCH .. "}") }, { condition=math, show_condition=math }),
-- 		-- etc
-- 		-- a living nightmare worth of greek symbols
-- 		-- stuff i need for m110
-- }
--
--

-- {
-- Text Mode Scaffolding Snippets
-- }

local single_command_snippet = require('snippets.tex.utils').scaffolding.single_command_snippet

local single_command_specs = {
    sq = {
        context = {
            name = 'enquote*',
            dscr = 'single quotes',
        },
        command = [[\enquote*]],
    },
    qq = {
        context = {
            name = 'enquote',
            dscr = 'double quotes'
        }, 
        command = [[\enquote]],
    },
    bf = {
        context = {
            name = "textbf",
            dscr = "bold text",
            hidden = true,
        },
        command = [[\textbf]],
    },
    it = {
        context = {
            name = "textit",
            dscr = "italic text",
            hidden = true,
        },
        command = [[\textit]],
    },
    sc = {
        context = {
            name = "textsc",
            dscr = "small caps",
            hidden = true,
        },
        command = [[\textsc]]
    },
    tu = {
        context = {
            name = "underline (text)",
            dscr = "underlined text in non-math mode",
            hidden = true,
        },
        command = [[\underline]],
    },
    tov = {
        context = {
            name = "overline (text)",
            dscr = "overline text in non-math mode",
            hidden = true,
        },
        command = [[\overline]],
        ext = { choice = true },
    },
}

local single_command_snippets = {}
for k, v in pairs(single_command_specs) do
    table.insert(
        single_command_snippets,
        single_command_snippet(vim.tbl_deep_extend('keep', { trig = k }, v.context), v.command, { condition = in_text }, v.ext or {} )
    )
end
vim.list_extend(M, single_command_snippets)

--{
-- Math Mode Snippets
--}

-- Auto backslashes
local auto_backslash_snippet = require("snippets.tex.utils").scaffolding.auto_backslash_snippet

local auto_backslash_specs = {
    'arcsin', 'sin', 'arccos', 'cos', 'arctan', 'tan',
    'cot','csc', 'sec', 'log', 'ln', 'exp', 'ast', 'star',
    'perp', "sup", "inf", "det", 'max', 'min', 'argmax',
    'argmin'
}

local auto_backslash_snippets = {}
for _, v in ipairs(auto_backslash_specs) do
    table.insert(auto_backslash_snippets, auto_backslash_snippet({ trig = v }, { condition = math }))
end
vim.list_extend(M, auto_backslash_snippets)

-- Symbols/Commands
local symbol_snippet = require('snippets.tex.utils').scaffolding.symbol_snippet

local greek_specs = {
    alpha = { context = { name = 'α' }, command = [[\alpha]] },
    beta = { context = { name = 'β' }, command = [[\beta]] },
    omega = { context = { name = 'ω' }, command = [[\omega]] },
    Omega = { context = { name = 'Ω' }, command = [[\Omega]] },
    delta = { context = { name = 'δ' }, command = [[\delta]] },
    DD = { context = { name = 'Δ' }, command = [[\Delta]] },
    eps = { context = { name = 'ε' }, command = [[\epsilon]] },
    theta = { context = { name = 'θ' }, command = [[\theta]] },
    lmbd = { context = { name = 'λ' }, command = [[\lambda]] },
    Lmbd = { context = { name = 'Λ' }, command = [[\Lambda]] },
    mu = { context = { name = 'μ' }, command = [[\mu]] },
    pi = { context = { name = 'π' }, command = [[\pi]] },
    sig = { context = { name = 'σ' }, command = [[\sigma]] },
    Sig = { context = { name = 'Σ' }, command = [[\Sigma]] },
    vphi = { context = { name = 'φ' }, command = [[\varphi]] },
    veps = { context = { name = 'ε' }, command = [[\varepsilon]] },
}

local greek_snippets = {}
for k, v in pairs(greek_specs) do
    table.insert(
        greek_snippets,
        symbol_snippet(vim.tbl_deep_extend('keep', { trig = k }, v.context), v.command, { condition = math })
    )
end
vim.list_extend(M, greek_snippets)

local symbol_specs = {
    -- operators
    ['!='] = { context = { name = "!=" }, command = [[\neq]] },
    leq = { context = { name = "≤" }, command = [[\leq]] },
    geq = { context = { name = "≥" }, command = [[\geq]] },
    ll = { context = { name = "<<" }, command = [[\ll]] },
    gg = { context = { name = ">>" }, command = [[\gg]] },
    ['~~'] = { context = { name = "~" }, command = [[\sim]] },
    ['~='] = { context = { name = "≈" }, command = [[\approx]] },
    ['~-'] = { context = { name = "≃" }, command = [[\simeq]] },
    ['-~'] = { context = { name = "⋍" }, command = [[\backsimeq]] },
    ['-='] = { context = { name = "≡" }, command = [[\equiv]] },
    ['=~'] = { context = { name = "≅" }, command = [[\cong]] },
    [':='] = { context = { name = "≔" }, command = [[\definedas]] },
    ['**'] = { context = { name = "·", priority = 100 }, command = [[\cdot]] },
    xx = { context = { name = "×" }, command = [[\times]] },
    -- sets 
    NN = { context = { name = "ℕ" }, command = [[\mathbb{N}]] },
    ZZ = { context = { name = "ℤ" }, command = [[\mathbb{Z}]] },
    QQ = { context = { name = "ℚ" }, command = [[\mathbb{Q}]] },
    RR = { context = { name = "ℝ" }, command = [[\mathbb{R}]] },
    CC = { context = { name = "ℂ" }, command = [[\mathbb{C}]] },
    OO = { context = { name = "∅" }, command = [[\emptyset]] },
    pwr = { context = { name = "P" }, command = [[\powerset]] },
    cc = { context = { name = "⊂" }, command = [[\subset]] },
    cq = { context = { name = "⊆" }, command = [[\subseteq]] },
    qq = { context = { name = "⊃" }, command = [[\supset]] },
    qc = { context = { name = "⊇" }, command = [[\supseteq]] },
    ['\\\\\\'] = { context = { name = "⧵" }, command = [[\setminus]] },
    Nn = { context = { name = "∩" }, command = [[\cap]] },
    UU = { context = { name = "∪" }, command = [[\cup]] },
    -- quantifiers and logic stuffs 
    AA = { context = { name = "∀" }, command = [[\forall]] },
    EE = { context = { name = "∃" }, command = [[\exists]] },
    inn = { context = { name = "∈" }, command = [[\in]] },
    notin = { context = { name = "∉" }, command = [[\not\in]] },
    ['!-'] = { context = { name = "¬" }, command = [[\lnot]] },
    ['VV'] = { context = { name = "∨" }, command = [[\lor]] },
    ['WW'] = { context = { name = "∧" }, command = [[\land]] },
    ['=>'] = { context = { name = "⇒" }, command = [[\implies]] },
    ['=<'] = { context = { name = "⇐" }, command = [[\impliedby]] },
    iff = { context = { name = "⟺" }, command = [[\iff]] },
    ['->'] = { context = { name = "→", priority = 250 }, command = [[\to]] },
    ['!>'] = { context = { name = "↦" }, command = [[\mapsto]] },
    -- etc 
    ooo = { context = { name = "∞" }, command = [[\infty]] },
    lll = { context = { name = "∞" }, command = [[\ell]] },
}

local symbol_snippets = {}
for k, v in pairs(symbol_specs) do
    table.insert(
        symbol_snippets,
        symbol_snippet(vim.tbl_deep_extend('keep', { trig = k }, v.context), v.command, { condition = math })
    )
end
vim.list_extend(M, symbol_snippets)

local single_command_math_specs = {
    tt = {
        context = {
            name = "text (math)",
            dscr = "text in math mode",
        },
        command = [[\text]],
    },
    sbf = {
        context = {
            name = "symbf",
            dscr = "bold math text",
        },
        command = [[\symbf]],
    },
    syi = {
        context = {
            name = "symit",
            dscr = "italic math text",
        },
        command = [[\symit]],
    },
    udd = {
        context = {
            name = "underline (math)",
            dscr = "underlined text in math mode",
        },
        command = [[\underline]],
    },
    floor = {
        context = {
            name = "floor",
            dscr = "math floor",
        },
        command = [[\floor]],
    },
    ceil = {
        context = {
            name = "ceil",
            dscr = "math ceiling",
        },
        command = [[\ceil]],
    },
    conj = {
        context = {
            name = "conjugate",
            dscr = "conjugate (overline)",
        },
        command = [[\overline]],
    },
    abs = {
        context = {
            name = "abs",
            dscr = "absolute value",
        },
        command = [[\abs]],
    },
    ['__'] = {
        context = {
            name = "subscript",
            dscr = "auto subscript 3",
        },
        command = [[_]],
    },
    td = {
        context = {
            name = "superscript",
            dscr = "auto superscript alt",
            wordTrig = false,
        },
        command = [[^]]
    },
    sbt = {
        context = {
            name = "substack",
            dscr = "substack for sums/products",
        },
        command = [[\substack]],
    },
}

local single_command_math_snippets = {}
for k, v in pairs(single_command_math_specs) do
    table.insert(
        single_command_math_snippets,
        single_command_snippet(vim.tbl_deep_extend('keep', { trig = k, snippetType = "autosnippet" }, v.context), v.command, { condition = math }, v.ext or { } )
    )
end
vim.list_extend(M, single_command_math_snippets)

return M
