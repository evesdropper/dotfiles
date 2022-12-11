-- LaTeX Snippets
-- TODO: set options for matrix and table snippets (either auto generate or user input)
-- TODO: fix env function; make it for tikz
local postfix = require("luasnip.extras.postfix").postfix
local line_begin = require("luasnip.extras.expand_conditions").line_begin

-- env stuff
local function math()
    -- global p! functions from UltiSnips
    return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end

-- test
local function env(name) 
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end

local function tikz()
    return env("tikzpicture")
end

local function bp()
    return env("itemize") or env("enumerate")
end


-- table of greek symbols 
griss = {
    alpha = "alpha", beta = "beta", delta = "delta", gam = "gamma", eps = "epsilon",
    mu = "mu", lmbd = "lambda", sig = "sigma"
}

-- brackets
brackets = {
    a = {"<", ">"}, b = {"[", "]"}, c = {"{", "}"}, m = {"|", "|"}, p = {"(", ")"}
}

-- LFG tables and matrices work
local tab = function(args, snip)
	local rows = tonumber(snip.captures[1])
    local cols = tonumber(snip.captures[2])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j).."x1", i(1)))
		ins_indx = ins_indx+1
		for k = 2, cols do
			table.insert(nodes, t" & ")
			table.insert(nodes, r(ins_indx, tostring(j).."x"..tostring(k), i(1)))
			ins_indx = ins_indx+1
		end
		table.insert(nodes, t{"\\\\", ""})
        if j == 1 then
            table.insert(nodes, t{"\\midrule", ""})
        end
	end
    nodes[#nodes] = t"\\\\"
    return sn(nil, nodes)
end

-- yes this is a ripoff
local mat = function(args, snip)
	local rows = tonumber(snip.captures[2])
    local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j).."x1", i(1)))
		ins_indx = ins_indx+1
		for k = 2, cols do
			table.insert(nodes, t" & ")
			table.insert(nodes, r(ins_indx, tostring(j).."x"..tostring(k), i(1)))
			ins_indx = ins_indx+1
		end
		table.insert(nodes, t{"\\\\", ""})
	end
	-- fix last node.
	nodes[#nodes] = t"\\\\"
	return sn(nil, nodes)
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

-- snippets go here

return {
    -- templates
    s({ trig='texdoc', name='new tex doc', dscr='Create a general new tex document'},
    fmt([[ 
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
    { delimiters='<>' }
    )),
    s({ trig='hwtex', name='texdoc for hw', dscr='tex template for my homeworks'},
    fmt([[ 
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
    { delimiters='<>' }
    )),
    s({ trig='atoc', name='add toc', dscr='add this to toc line'},
    fmt([[ 
    \addcontentsline{toc}{<>}{<>}
    <>
    ]],
    { i(1, "section"), i(2, "content"), i(0) },
    { delimiters='<>' }
    )),
    -- semantic snippets from markdown
    -- sections
    s({trig="#", hidden=true, priority=250},
    fmt([[
    \section{<>}
    <>]],
    { i(1), i(0) },
    { delimiters="<>" }
    )),
    s({trig="#*", hidden=true, priority=250},
    fmt([[
    \section*{<>}
    <>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({trig="##", hidden=true, priority=500},
    fmt([[
    \subsection{<>}
    <>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({trig="##*", hidden=true, priority=500},
    fmt([[
    \subsection*{<>}
    <>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({trig="###", hidden=true, priority=1000},
    fmt([[ 
    \subsubsection{<>}
    <>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({trig="###*", hidden=true, priority=1000},
    fmt([[ 
    \subsubsection*{<>}
    <>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    -- special sections 
    s({ trig='#l', name='lecture', dscr='fancy section header - lecture #'},
    fmt([[ 
    \lecture[<>]{<>}
    <>]],
    { t(os.date("%d-%m-%Y")), i(1), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='#ch', name='chap', dscr='fancy section header - chapter #'},
    fmt([[ 
    \bookchap[<>]{<>}{<>}
    <>]],
    { t(os.date("%d-%m-%Y")), i(1, "dscr"), i(2, "\\thesection"), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='#f', name='fancy section', dscr='fancy section header - vanilla'},
    fmt([[ 
    \fancysec[<>}{<>}{<>}
    <>]],
    { t(os.date('%d-%m-%Y')), i(1, "dscr"), i(2, "title"), i(0) },
    { delimiters='<>' }
    )),
    -- links images figures
    s({trig="!l", name="link", dscr="Link reference", hidden=true},
    fmt([[\href{<>}{\color{<>}<>}<>]],
    { i(1, "link"), i(3, "blue"), i(2, "title"), i(0) },
    { delimiters='<>' }
    )),
    s({trig="!i", name="image", dscr="Image (no caption, no float)"},
    fmt([[ 
    \begin{center}
    \includegraphics[width=<>\textwidth]{<>}
    \end{center}
    <>]],
    { i(1, "0.5"), i(2), i(0) },
    { delimiters='<>' }
    )),
    s({trig="!f", name="figure", dscr="Float Figure"},
    fmt([[ 
    \begin{figure}[<>] 
    <>
    \end{figure}]],
    { i(1, "htb!"), i(0) },
    { delimiters='<>' }
    )),
    s({trig="gr", name="figure image", dscr="float image"},
    fmt([[
    \centering
    \includegraphics[width=<>\textwidth]{<>}\caption{<>}<>]],
    { i(1, "0.5"), i(2), i(3), i(0) },
    { delimiters='<>' }
    )),
    -- code
    s({ trig='qw', name='inline code', dscr='inline code'},
    fmt([[\mintinline{<>}{<>}<>]],
    { i(1, "text"), i(2), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='qe', name='code', dscr='Code with minted.'},
    fmt([[ 
    \begin{minted}{<>}
    <>
    \end{minted}
    <>]],
    { i(1, "python"), i(2), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='mp', name='minipage', dscr='create minipage env'}, -- choice node
    fmt([[
    \begin{minipage}{<>\textwidth}
    <>
    \end{minipage}]],
    { c(1, {t("0.5"), t("0.33"), i(nil)}), i(0) },
    { delimiters='<>' }
    )),
    -- quotes
    s({ trig='sq', name='single quotes', dscr='single quotes', hidden=true},
    fmt([[`<>'<>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='qq', name='double quotes', dscr='double quotes', hidden=true},
    fmt([[``<>''<>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    -- text changes
    s({ trig='bf', name='bold', dscr='bold text', hidden=true},
    fmt([[\textbf{<>}<>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='it', name='italic', dscr='italic text', hidden=true},
    fmt([[\textit{<>}<>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='tu', name='underline', dscr='underline text', hidden=true},
    fmt([[\underline{<>}<>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='sc', name='small caps', dscr='small caps text', hidden=true},
    fmt([[\textsc{<>}<>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='tov', name='overline', dscr='overline text'},
    fmt([[\overline{<>}<>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    -- environments
    s({trig="beg", name="begin env", dscr="begin/end environment"},
    fmt([[
    \begin{<>}
    <>
    \end{<>}]],
    { i(1), i(0), rep(1) },
    { delimiters="<>" }
    )),
    s({ trig='-i', name='itemize', dscr='bullet points (itemize)'},
    fmt([[ 
    \begin{itemize}
    \item <>
    \end{itemize}]],
    { i(1) },
    { delimiters='<>' }
    )),
    s({ trig='-e', name='enumerate', dscr='numbered list (enumerate)'},
    fmt([[ 
    \begin{enumerate}
    \item <>
    \end{enumerate}]],
    { i(1) },
    { delimiters='<>' }
    )),
    -- item but i cant get this to work
    s({ trig='adef', name='add definition', dscr='add definition box'},
    fmt([[ 
    \begin{definition}[<>]{<>
    }
    \end{definition}]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='aex', name='add example', dscr='add example box'},
    fmt([[ 
    \begin{example}[<>]{<>
    }
    \end{example}]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='athm', name='add theorem', dscr='add theorem box'},
    fmt([[ 
    \begin{theorem}[<>]{<>
    }
    \end{theorem}]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='nb', name='notebox', dscr='add notebox idk why this format is diff'},
    fmt([[ 
    \begin{notebox}[<>]
    <>
    \end{notebox}]],
    { i(1), i(0) },
    { delimiters='<>' }
    )), 
    s({ trig='sol', name='solution', dscr='solution box for homework'},
    fmt([[ 
    \begin{solution}
    <>
    \end{solution}]],
    { i(0) },
    { delimiters='<>' }
    )),
    s({ trig='tab(%d+)x(%d+)', regTrig=true, name='test for tabular', dscr='test', hidden=true},
    fmt([[
    \begin{tabular}{@{}<>@{}}
    \toprule
    <>
    \bottomrule
    \end{tabular}]],
    { f(function(_, snip)
        return string.rep("c", tonumber(snip.captures[2]))
    end), d(1, tab) },
    { delimiters='<>' }
    )),
    s({ trig='([bBpvV])mat(%d+)x(%d+)([ar])', regTrig=true, name='matrix', dscr='matrix trigger lets go', hidden=true},
    fmt([[
    \begin{<>}<>
    <>
    \end{<>}]],
    { f(function (_, snip) return snip.captures[1] .. "matrix" end),
    f(function (_, snip)
        if snip.captures[4] == "a" then
            out = string.rep("c", tonumber(snip.captures[3]) - 1)
            return "[" .. out .. "|c]"
        end
        return ""
    end),
    d(1, mat),
    f(function (_, snip) return snip.captures[1] .. "matrix" end)},
    { delimiters='<>' }
    ), { condition=math, show_condition=math }),
    -- parentheses
    s({ trig='lr', name='left right', dscr='left right'},
    fmt([[\left(<>\right)<>]],
    { i(1), i(0) },
    { delimiters='<>' }
    ), { condition=math }),
    s({ trig='lrv', name='left right', dscr='left right'},
    fmt([[\left(<>\right)<>]],
    { f(function(args, snip)
      local res, env = {}, snip.env
      for _, val in ipairs(env.LS_SELECT_RAW) do table.insert(res, val) end
      return res
      end, {}), i(0) },
    { delimiters='<>' }
    ), { condition=math, show_condition=math }),
    s('tikztest', {t('this works only in tikz')},
    { condition=tikz, show_condition=tikz}),
    
}, {
    -- bullet points 
    s({trig="--", hidden=true}, {t('\\item')},
    { condition=bp, show_condition=bp }),
    -- math mode
    s({ trig='mk', name='math', dscr='inline math'},
    fmt([[$<>$<>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='dm', name='math', dscr='display math'},
    fmt([[ 
    \[ 
    <>
    .\]
    <>]],
    { i(1), i(0) },
    { delimiters='<>' }
    )),
    s({ trig='ali', name='align', dscr='align math'},
    fmt([[ 
    \begin{align<>}
    <>
    .\end{align<>}
    <>]],
    { i(1, "*"), i(2), rep(1), i(0) },
    { delimiters='<>' }
    ), { condition=line_begin, show_condition=line_begin }),
    s({ trig='gat', name='gather', dscr='gather math'},
    fmt([[ 
    \begin{gather<>}
    <>
    .\end{gather<>}
    <>]],
    { i(1, "*"), i(2), rep(1), i(0) },
    { delimiters='<>' }
    ), { condition=line_begin, show_condition=line_begin }),
    s({ trig='tt', name='text', dscr='text in math'},
    fmt([[
    \text{<>}<>
    ]],
    { i(1), i(0) },
    { delimiters='<>' }
    ), { condition=math, show_condition=math }),
    s({ trig='sbf', name='bold math', dscr='sam bankrupt fraud'},
    fmt([[ 
    \symbf{<>}<>
    ]],
    { i(1), i(0) },
    { delimiters='<>' }
    ), { condition=math, show_condition=math }),
    s({ trig='syi', name='italic math', dscr='symit'},
    fmt([[ 
    \symit{<>}<>
    ]],
    { i(1), i(0) },
    { delimiters='<>' }
    ), { condition=math, show_condition=math }),
    -- operators, symbols
    s({trig='**', priority=100}, {t('\\cdot')},
    { condition=math }),
    s('xx', {t('\\times')},
    { condition=math }),
    s({ trig='//', name='fraction', dscr='fraction (autoexpand)'},
    fmt([[\frac{<>}{<>}<>]],
    { i(1), i(2), i(0) },
    { delimiters='<>' }),
    { condition=math }),
    s('==', {t('&='), i(1), t("\\\\")},
    { condition=math }),
    s('!=', {t('\\neq')},
    { condition=math }),
    s({ trig='conj', name='conjugate', dscr='conjugate would have been useful in eecs 126'},
    fmt([[\overline{<>}<>]],
    { i(1), i(0) },
    { delimiters='<>' },
    { condition=math })),
    s('<=', {t('\\leq')},
    { condition=math }),
    s('>=', {t('\\geq')},
    { condition=math }),
    s('>>', {t('\\gg')},
    { condition=math }),
    s('<<', {t('\\ll')},
    { condition=math }),
    s('~~', {t('\\sim')},
    { condition=math }),
    s('~=', {t('\\approx')},
    { condition=math, show_condition=math }),
    -- sub super scripts
    s({ trig='(%a)(%d)', regTrig=true, name='auto subscript', dscr='hi'},
    fmt([[<>_<>]],
    { f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end) },
    { delimiters='<>' }),
    { condition=math }),
    s({ trig='(%a)_(%d%d)', regTrig=true, name='auto subscript 2', dscr='auto subscript for 2+ digits'},
    fmt([[<>_{<>}]],
    { f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end)},
    { delimiters='<>' }),
    { condition=math }),
    s({ trig='__', name='subscript iii', dscr='auto subscript for brackets', wordTrig=false},
    fmt([[ 
    _{<>}<>
    ]],
    { i(1), i(0) },
    { delimiters='<>' }
    ),{ condition=math, show_condition=math }),
    s('xnn', {t('x_n')},
    { condition=math }),
    s('xii', {t('x_i')},
    { condition=math }),
    s('xjj', {t('x_j')},
    { condition=math}),
    s('ynn', {t('y_n')},
    { condition=math }),
    s('yii', {t('y_i')},
    { condition=math }),
    s('yjj', {t('y_j')},
    { condition=math }),
    s({trig='sr', wordTrig=false}, {t('^2')},
    { condition=math }),
    s({trig='cb', wordTrig=false}, {t('^3')},
    { condition=math }),
    s({trig='compl', wordTrig=false}, {t('^{c}')},
    { condition=math }),
    s({trig='vtr', wordTrig=false}, {t('^{T}')},
    { condition=math }),
    s({trig="inv", wordTrig=false}, {t('^{-1}')},
    { condition=math }),
    s({ trig='td', name='superscript', dscr='superscript', wordTrig=false},
    fmt([[^{<>}<>]],
    { i(1), i(0) },
    { delimiters='<>' }
    ), { condition=math }),
    s({ trig='sq', name='square root', dscr='square root'},
    fmt([[\sqrt{<>}]],
    { i(1) },
    { delimiters='<>' }
    ), { condition=math }),
    -- hats and bars (postfixes) 
    postfix("bar", {l("\\bar{" .. l.POSTFIX_MATCH .. "}")}, { condition=math }),
    postfix("hat", {l("\\hat{" .. l.POSTFIX_MATCH .. "}")}, { condition=math }),
    postfix(",.", {l("\\vec{" .. l.POSTFIX_MATCH .. "}")}, { condition=math }),
    postfix("vr", {l("$" .. l.POSTFIX_MATCH .. "$")}),
    postfix("mbb", {l("\\mathbb{" .. l.POSTFIX_MATCH .. "}")}, { condition=math }),
    postfix("vc", {l("\\mintinline{text}{" .. l.POSTFIX_MATCH .. "}")}),
    -- etc
    s({ trig='([clvd])%.', regTrig=true, name='dots', dscr='generate some dots'},
    fmt([[\<>dots]],
    { f(function(_, snip) 
      return snip.captures[1]
      end)},
    { delimiters='<>' }),
    { condition=math }),
    s({ trig='bnc', name='binomial', dscr='binomial (nCR)'},
    fmt([[\binom{<>}{<>}<>]],
    { i(1), i(2), i(0) },
    { delimiters='<>' }),
    { condition=math }),
    -- a living nightmare worth of greek symbols
    -- TODO: replace with regex
    s({ trig='(alpha|beta|delta)', regTrig=true,
    name='griss symbol', dscr='greek letters hi'},
    fmt([[\<>]],
    { f(function(_, snip)
        return griss[snip.captures[1]]
    end) },
    { delimiters='<>' }),
    { condition=math }),
    s("alpha", {t("\\alpha")},
    {condition = math}),
    s('beta', {t('\\beta')},
    { condition=math }),
    s('delta', {t('\\delta')},
    { condition=math }),
    s('gam', {t('\\gamma')},
    { condition=math }),
    s('eps', {t('\\epsilon')},
    { condition=math }),
    s('lmbd', {t('\\lambda')},
    { condition=math }),
    s('mu', {t('\\mu')},
    { condition=math }),
    s('theta', {t('\\theta')},
    { condition=math, show_condition=math }),
    s('sig', {t('\\sigma')},
    { condition=math, show_condition=math }),
    -- stuff i need for m110
    s({ trig='set', name='set', dscr='set'},
    fmt([[\{<>\}<>]],
    { i(1), i(0) },
    { delimiters='<>' }
    ), { condition=math }),
    s('cc', {t('\\subset')},
    { condition=math }),
    s('cq', {t('\\subseteq')},
    { condition=math }),
    s('\\\\\\', {t('\\setminus')},
    { condition=math }),
    s('Nn', {t('\\cap')},
    { condition=math }),
    s('UU', {t('\\cup')},
    { condition=math }),
    -- stuff i need to do calculus 
    s('nabl', {t('\\nabla')},
    { condition=math, show_condition=math }),
    s({ trig='part', name='partial derivative', dscr='partial derivative'},
    fmt([[ 
    \frac{\partial <>}{\partial <>} <>
    ]],
    { i(1, "V"), i(2, "x"), i(0) },
    { delimiters='<>' }
    ),{ condition=math, show_condition=math }),
    s({ trig='elr', name='left right eval', dscr='evaluated at left/right'},
    fmt([[ 
    \left. <> \right|<>
    ]],
    { i(1), i(0) },
    { delimiters='<>' }
    ),{ condition=math, show_condition=math }),
    -- reals and number sets 
    s('RR', {t('\\mathbb{R}')},
    { condition=math }),
    s('CC', {t('\\mathbb{C}')},
    { condition=math }),
    s('ZZ', {t('\\mathbb{Z}')},
    { condition=math }),
    s('QQ', {t('\\mathbb{Q}')},
    { condition=math }),
    -- quantifiers and cs70 n1 stuff
    s('AA', {t('\\forall')},
    { condition=math }),
    s('EE', {t('\\exists')},
    { condition=math }),
    s('inn', {t('\\in')},
    { condition=math }),
    s('notin', {t('\\not\\in')},
    { condition=math }),
    s('ooo', {t('\\infty')},
    { condition=math }),
    s('=>', {t('\\implies')},
    { condition=math, show_condition=math }),
    s('=<', {t('\\impliedby')},
    { condition=math, show_condition=math }),
    s('iff', {t('\\iff')},
    { condition=math, show_condition=math }),
    -- utils
    s('||', {t('\\mid')},
    { condition=math }),
    s('lb', {t('\\\\')},
    { condition=math }),
    s('tcbl', {t('\\tcbline')}),
    s('ctd', {t('%TODO: '), i(1)}
    ),
    s('upar', {t('\\uparrow')},
    { condition=math, show_condition=math }),
    s('dnar', {t('\\downarrow')},
    { condition=math, show_condition=math }),
    s({trig='->', priority=250}, {t('\\to')},
    { condition=math }),
    s({trig='<->', priority=500}, {t('\\leftrightarrow')},
    { condition=math }),
    s('!>', {t('\\mapsto')},
    { condition=math }),
    s({ trig='floor', name='math floor', dscr='math floor'},
    fmt([[\left\lfloor <> \right\rfloor <>]],
    { i(1), i(0) },
    { delimiters='<>' }
    ), { condition=math }),
    s({ trig='ceil', name='math ceiling', dscr='math ceiling'},
    fmt([[\left\lceil <> \right\rfloor <>]],
    { i(1), i(0) },
    { delimiters='<>' }
    ), { condition=math }),
}
