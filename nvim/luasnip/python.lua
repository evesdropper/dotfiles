-- Python Snippets, which I never use.

--[
-- Imports
--]
local autosnippet = ls.extend_decorator.apply(s, {snippetType = "autosnippet"})

--[
-- Snippets go here
--]

return {
    s({ trig='imp', name='import', dscr='import'},
    fmt([[
    <>
    ]],
    { c(1, {sn(nil, {t("import "), i(1, "package")}), sn(nil, {t("from "), i(1, "package"), t(" import "), i(2, "*")}) }) },
    { delimiters='<>' }
    )),
}
