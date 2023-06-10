-- Python Snippets, which I never use.

--[
-- Imports/Functions
--]
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local conds = require("luasnip.extras.expand_conditions")
local make_condition = require("luasnip.extras.conditions").make_condition

-- conditions / condition objects 
local function is_texfile()
    return vim.bo.filetype == "tex"
end

local function is_pyfile()
    return vim.bo.filetype == "python"
end

local function in_mintedPython()
	return vim.fn["vimtex#syntax#in"]("texMintedZonePython") == 1
end

local function in_pyfile_or_in_mintedPython()
    return vim.bo.filetype == "python" or vim.fn["vimtex#syntax#in"]("texMintedZonePython") == 1
end

-- personal utils / dynamics 
local generate_matchcase_dynamic = function(args, snip)
    if not snip.num_cases then
        snip.num_cases = tonumber(snip.captures[1]) or 1 -- default start at 1
    end
    local nodes = {}
    local ins_idx = 1
    for j = 1, snip.num_cases do
        vim.list_extend(nodes, fmta([[
        case <>:
            <>
        ]], {r(ins_idx, "var" .. j, i(1)), r(ins_idx+1, "next" .. j, i(0))}))
        table.insert(nodes, t({"", ""}))
        ins_idx = ins_idx + 2
    end
    table.remove(nodes, #nodes)
    return isn(nil, nodes, "$PARENT_INDENT\t")
end

--[
-- Snippets go here
--]

return {
 	s({ trig = "imp", name = "import", dscr = "import" },
	fmta([[ 
    <>
    ]],
	{c(1, {
		sn(nil, { t("import "), i(1, "package"), c(2, {t(""), sn(nil, t(" as "), i(1))}) }),
		sn(nil, { t("from "), i(1, "package"), t(" import "), i(2, "*") }),
	})}),
    { condition = in_pyfile_or_in_mintedPython, show_condition = in_pyfile_or_in_mintedPython }
    ),
    s({ trig='def', name='define function', dscr='define function'},
    fmta([[
    def <>(<>)<>:
        <>
    ]],
    { i(1), i(2), c(3, {t(""), sn(nil, {t(" -> "), i(1)})}), i(0) })
    ),
    s({ trig='mc(%d*)', name='match case', dscr='match n cases', regTrig = true, hidden = true},
    fmta([[
    match <>:
        <>
        <>
    ]],
    { i(1), d(2, generate_matchcase_dynamic, {}, {
	user_args = {
		function(snip) snip.num_cases = snip.num_cases + 1 end,
		function(snip) snip.num_cases = math.max(snip.num_cases - 1, 1) end
	}
    }),
    c(3, {t(""), isn(nil, fmta([[
    case _:
        <>
    ]], {i(1, "pass")}), "$PARENT_INDENT\t")})}),
    { condition = in_pyfile_or_in_mintedPython, show_condition = in_pyfile_or_in_mintedPython }
    ),
}
