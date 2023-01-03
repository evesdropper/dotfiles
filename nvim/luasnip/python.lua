-- Python Snippets, which I never use.

--[
-- Imports/Functions
--]
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local conds = require("luasnip.extras.expand_conditions")
local make_condition = require("luasnip.extras.conditions").make_condition

local function tex()
	return vim.bo.filetype == "tex"
end

local function python()
	return vim.bo.filetype == "python"
end

-- tex in python
local function env(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end

local function minted()
	return env("minted")
end

local function mintedPython()
    return vim.fn['vimtex#syntax#in']("texMintedZonePython") == 1
end

local pyfile = make_condition(python)
local texfile = make_condition(tex)
local in_minted = make_condition(minted)
local pymint = make_condition(mintedPython)

--[
-- Snippets go here
--]

return {
	s(
		{ trig = "imp", name = "import", dscr = "import" },
		fmt(
			[[
    <>
    ]],
			{
				c(
					1,
					{
						sn(nil, { t("import "), i(1, "package") }),
						sn(nil, { t("from "), i(1, "package"), t(" import "), i(2, "*") }),
					}
				),
			},
			{ delimiters = "<>" }
		)
	),
	autosnippet(
		"pytest",
		{ t("this triggers only in python files, or in tex files with minted enabled with python") },
		{ condition = pyfile + (texfile * pymint), show_condition = pyfile + (texfile * pymint) }
	),
}
