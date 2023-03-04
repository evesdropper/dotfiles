-- Python Snippets, which I never use.

--[
-- Imports/Functions
--]
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local conds = require("luasnip.extras.expand_conditions")
local make_condition = require("luasnip.extras.conditions").make_condition
local ft_conds = require("snippets.all.conditions")

-- conditions / condition objects 
local function mintedPython()
	return vim.fn["vimtex#syntax#in"]("texMintedZonePython") == 1
end

local is_pyfile = make_condition(ft_conds.is_pyfile)
local is_texfile = make_condition(ft_conds.is_texfile)
local is_mintedPython = make_condition(mintedPython)

-- personal utils / dynamics 
local function isempty(s)
	return s == nil or s == ""
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
    { condition = is_pyfile + (is_texfile * is_mintedPython), show_condition = is_pyfile + (is_texfile * is_mintedPython) }),
}
