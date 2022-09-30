return {
    -- format snippet 
    s("snipf", fmt([[ 
    s({ trig='<>', name='<>', dscr='<>'},
    fmt(<>,
    { <> },
    { delimiters='<>' }
    )<>)<>,]],
    { i(1, "trig"), i(2, "trig"), i(3, "dscr"), i(4, "fmt"), i(5, "inputs"), i(6, "<>"), i(7, "opts"), i(0)},
    { delimiters='<>' }
    )),
    -- simple text snippet 
    s("snipt", fmt([[ 
    s('<>', {t('<>')}<>
    <>)<>,]],
    { i(1, "trig"), i(2, "text"), i(3, "opts"), i(4), i(0)},
    { delimiters='<>' }
    )),
}, {
    -- add snippet conditions
    s({ trig='sacd', name='snippet conditions for autosnippets', dscr='snippet condition for autosnippets'},
    fmt([[{ condition=<> }]],
    { i(1, math) },
    { delimiters='<>' }
    )),
    s('scond', fmt([[{ condition=<>, show_condition=<> }]],
    { i(1, "math"), rep(1) },
    { delimiters='<>' }
    )),
    s({ trig='sprio', name='snip priority', dscr='Autosnippet to set snippet priority' },
    fmt([[ 
    priority=<>]],
    { i(1, '1000') },
    { delimiters='<>' }
    )),
    s('shide', {t('hidden=true')}
    ),
    -- add nvim keybinds
    s({ trig='nkey', name='nvim keybinds', dscr='add a nvim keybinds'},
    fmt([[keymap("<>", "<>", "<>", "<>")]],
    { i(1, "n"), i(2, "keybind"), i(3, "command"), i(4, "options") },
    { delimiters='<>' }
    ))
}
