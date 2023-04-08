--[
-- Imports
--]
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

-- idontevenusejavaijustwantanexcusetoprocrastinate
return {
    s({ trig='imp', name='import', dscr='import package'},
    fmta([[
    import <>;
    ]],
    { i(1) }
    )),
    s({ trig='package', name='package', dscr='package'},
    fmta([[
    package <>
    ]],
    { f(function (_, _)
        pwdstring = vim.api.nvim_call_function('fnamemodify', {vim.loop.cwd(), ":t"})
    return pwdstring
    end) }
    )),
    s({ trig='class', name='class', dscr='class'},
    fmta([[
    public class <> {
        <>
    }
    ]],
    { f(function (_, _)
        filestring = vim.api.nvim_call_function('fnamemodify', {vim.fn.expand("%"), ":t:r"})
        return filestring
    end), i(0)}
    )),
    s({ trig='func', name='function', dscr='function'},
    fmta([[
    <> <> <> <>(<>) {
        <>
    }
    ]],
    { c(1, {t("public"), t("private")}), c(2, {t("") , t("static")}), i(3, "void"), i(4, "main"), i(5), i(0) }
    )),
}
