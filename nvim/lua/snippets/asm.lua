--[
-- Imports
--]
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local postfix = require("luasnip.extras.postfix").postfix

-- TODO: probably do something with respect to riscv and x86
local function isempty(s) --util
	return s == nil or s == ""
end

local load_save_registers = function (_, snip, _, user_args)
    local register_type = snip.captures[2]
    local num_registers = tonumber(snip.captures[1], 16) -- in hex
    local command
    if user_args == "load" then
        command = "lw"
    elseif user_args == "save" then
        command = "sw"
    end
    local nodes = {}
    for j = 1, num_registers do
        vim.list_extend(nodes, fmta([[
        <> s<> <>(sp)
        ]],
        { t(command), t(tostring(j-1)), t(tostring((j-1) * 4))}
        ))
        table.insert(nodes, t({"", ""}))
    end
    table.insert(nodes, t(command .. " ra, " .. tostring((num_registers) * 4) .. "(sp)"))
    return sn(nil, nodes)
end

local test = function ()
    return "test output"
end


local dynamic_postfix = function(_, parent, _, user_arg1, user_arg2)
    local capture = parent.snippet.env.POSTFIX_MATCH
    if isempty(capture) then
        return sn(nil, fmta([[
        <><><><>
        ]],
        {t(user_arg1), i(1), t(user_arg2), i(0)}))
    else
        return sn(nil, fmta([[
        <><><><>
        ]],
        {t(user_arg1), t(capture), t(user_arg2), i(0)}))
    end
end

return {
    s({ trig='tsw([ab%d])([as])', name='sw saveregs', dscr='RISC-V: store save registers onto the stack', regTrig = true, hidden = true},
    fmta([[
    addi, sp, sp, -<>
    <>
    ]],
    { f(function (_, snip)
        return tostring(tonumber(snip.captures[1], 16) * 4 + 4)
    end), d(1, load_save_registers, {}, { user_args = { "save" } }) }
    )),

    s({ trig='tlw([ab%d])([as])', name='lw saveregs', dscr='RISC-V: load save registers onto the stack', regTrig = true, hidden = true},
    fmta([[
    <>
    addi, sp, sp, <>
    ]],
    { d(1, load_save_registers, {}, { user_args = { "load" } }),
    f(function (_, snip)
        return tostring(tonumber(snip.captures[1], 16) * 4 + 4)
    end)}
    )),
    s("test", {p(test)}
    ),
    postfix({ trig="hat", snippetType = "autosnippet"},
    {d(1, dynamic_postfix, {}, { user_args = {"\\hat{", "}"} })}
    )
}
