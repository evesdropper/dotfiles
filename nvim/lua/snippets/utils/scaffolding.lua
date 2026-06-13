local M = {}

-- LuaSnip
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })
local postfix = require("luasnip.extras.postfix").postfix
local helpers = require("snippets.tex.utils.helpers")

-- Match case. Surprisingly more than one language needs it
local matchcase_textnodes = {
    ocaml = {
        "|", " ->", "_", ""
    },
    python = {
        "case", ":\n", "_", "pass"
    }
}

M.generate_matchcase_dynamic = function(args, snip)
    if not snip.num_cases then
        snip.num_cases = tonumber(snip.captures[1]) or 1
    end
    local nodes = {}
    local ins_idx = 1
    for j = 1, snip.num_cases do
        vim.list_extend(nodes, fmt([[
        {} {}{} {}
        ]], {t(matchcase_textnodes[vim.bo.filetype][1]), r(ins_idx, "var" .. j, i(1)), t(matchcase_textnodes[vim.bo.filetype][2]), r(ins_idx+1, "next" .. j, i(0))}))
        table.insert(nodes, t({"", ""}))
        ins_idx = ins_idx + 2
    end
    table.remove(nodes, #nodes) -- removes the extra line break
    return isn(nil, nodes, "\t")
end

return M
