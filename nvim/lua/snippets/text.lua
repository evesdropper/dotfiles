-- [
-- Imports
-- ]
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

-- [
-- Snippets
-- ]

return {
    s({ trig='vb', name='vidblock regex', dscr='dscr'},
    fmta([[
    /(?=.*<>)/i
    ]],
    { i(1) }
    )),
}
