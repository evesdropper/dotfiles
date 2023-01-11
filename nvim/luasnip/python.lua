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

-- visual util to add insert node
-- thanks ejmastnak!
local function isempty(s)
  return s == nil or s == ''
end

local get_visual = function(args, parent, _, user_args)
    if isempty(user_args) then
        ret = "" -- edit if needed
    else
        ret = user_args
    end
	if #parent.snippet.env.SELECT_RAW > 0 then
		return sn(nil, i(1, parent.snippet.env.SELECT_RAW))
	else -- If SELECT_RAW is empty, return a blank insert node
        return sn(nil, i(1, ret))
	end
end

local function reused_func(_,_, user_arg1)
    return user_arg1
end

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
			{c(1,{
						sn(nil, { t("import "), i(1, "package") }),
						sn(nil, { t("from "), i(1, "package"), t(" import "), i(2, "*") }),
				}),}, { delimiters = "<>" } )
    ),
	autosnippet(
		"pytest",
		{ t("this triggers only in python files, or in tex files with minted enabled with python") },
		{ condition = pyfile + (texfile * pymint), show_condition = pyfile + (texfile * pymint) }
	),
    autosnippet({ trig='testvis', name='trig', dscr='dscr'},
    fmt([[
    for <> in <>: 
        <>
    ]],
    { i(1), i(2), d(3, get_visual, {}, {user_args = {"pass"}}) },
    { delimiters='<>' }
    )),
    autosnippet({ trig='bruh', name='trig', dscr='dscr'},
    fmt([[
    <>
    ]],
    { d(1, get_visual, {}, {user_args = {"pass1"}}) },
    { delimiters='<>' }
    )),
}
