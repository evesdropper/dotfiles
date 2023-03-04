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

local function cpp()
	return vim.bo.filetype == "cpp"
end

-- tex in python
local function env(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end

local function minted()
	return env("minted")
end

local function mintedCpp()
	return vim.fn["vimtex#syntax#in"]("texMintedZoneCpp") == 1
end

local cppfile = make_condition(cpp)
local texfile = make_condition(tex)
local in_minted = make_condition(minted)
local cppmint = make_condition(mintedCpp)

--[
-- Snippets go here
--]

return {
	autosnippet(
		"cpptest",
		{ t("this triggers only in cpp files, or in tex files with minted and cpp enabled") },
		{ condition = cppfile + (texfile * cppmint), show_condition = cppfile + (texfile * cppmint) }
	),
}
