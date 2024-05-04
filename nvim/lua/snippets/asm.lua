--[
-- Imports
--]
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local postfix = require("luasnip.extras.postfix").postfix

-- TODO: probably do something with respect to riscv and x86
local function isempty(s) --util
	return s == nil or s == ""
end

local generate_stack_regs_dynamic = function (_, snip, _, user_args)
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

return {
    s({ trig='tsw([ab%d])([as])', name='sw saveregs', dscr='RISC-V: store save registers onto the stack', regTrig = true, hidden = true},
    fmta([[
    addi, sp, sp, -<>
    <>
    ]],
    { f(function (_, snip)
        return tostring(tonumber(snip.captures[1], 16) * 4 + 4)
    end), d(1, generate_stack_regs_dynamic, {}, { user_args = { "save" } }) }
    )),

    s({ trig='tlw([ab%d])([as])', name='lw saveregs', dscr='RISC-V: load save registers onto the stack', regTrig = true, hidden = true},
    fmta([[
    <>
    addi, sp, sp, <>
    ]],
    { d(1, generate_stack_regs_dynamic, {}, { user_args = { "load" } }),
    f(function (_, snip)
        return tostring(tonumber(snip.captures[1], 16) * 4 + 4)
    end)}
    )),
    s("test", {p(test)}
    ),
}
