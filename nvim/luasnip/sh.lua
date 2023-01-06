-- [
-- Imports
-- ]
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

-- [
-- Snippets
-- ]

return {
    s({ trig='case', name='cases', dscr='cases'},
    fmt([[ 
    case <> in 
        <>
        *) <> ;; 
    esac
    ]],
    { i(1, "expr"), i(2), i(3, "exit 1") },
    { delimiters='<>' }
    )),
}
