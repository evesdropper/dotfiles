---
author: evesdropper
date: YYYY-mm-dd
paging: Slide %d / %d
---

# LaTeX Snippets in LuaSnip
Here are a few common types of snippets to be used in LaTeX. For each snippet type, I'll discuss their uses and my implementations, as well as provide a demo.

Contents:
- Semantic Snippets ft. Labels/References
- Environments
- Single-Argument Commands
    * Scaffolding Snippets
    * Postfix Snippets
- Math Mode
    * Subscripts/Superscripts
    * Fractions
    * Matrices
- Context

---

# Semantic Snippets, ft. Labels/References
For `(sub)*section\*`s. We also want to stay on top of things with labels, so we'll add those as well.

## Labels/References
Labels and references are commonly brought up when working with LaTeX. It's good to keep track of specific parts of your work and provide quick links to them later, which labels and references can help do. Personally, I like using labels of the form `\label{type:short}`, where `type` is the label type (e.g. section, item) and `short` is the named label. Here are some snippets to manually add labels and references with ease.
```lua
-- Labels/References
local reference_snippet_table = {
    a = "auto",
    c = "c",
    C = "C",
    e = "eq",
    r = ""
}

autosnippet({ trig='alab', name='label', dscr='add a label'},
    fmta([[
    \label{<>:<>}
    ]],
    { i(1), i(0) })),

autosnippet({ trig='([acCer])ref', name='(acC|eq)?ref', dscr='add a reference (with autoref, cref, eqref)', regTrig = true, hidden = true},
    fmta([[
    \<>ref{<>:<>}
    ]],
    { f(function (_, snip)
        return reference_snippet_table[snip.captures[1]]
    end),
    i(1), i(0) }),
    { condition = tex.in_text, show_condition = tex.in_text }),
```

---

# Environments
LaTeX uses environments for different behavior than plain text. Create frequently used environments with ease or opt to create a general environment.

# Single-Argument Commands
Most commands in LaTeX deal with a single argument; it's nice to have a snippet that can easily insert a command.

---

# Math Mode Snippets
The first two are pretty important in helping making writing math a smooth experience and are derived from Gilles Castel's UltiSnips snippets.

## Subscripts/Superscripts

## Fractions

---

# Math Mode Snippets (cont.)
Let's continue with an important snippet, one for generating matrices, and discuss some general tips on writing math snippets.

## Matrices

## General Advice

---

# Context
You may have noticed `condition = tex.<>` popping up from time to time. This is the power of LuaSnip conditions, which allow us to evaluate snippets in a "smart" manner. For instance, we can set snippets to evaluate in specific environments or only in math mode.Here's my implementation for a general setup:
```lua
-- math / not math zones
function M.in_math()
    return vim.api.nvim_eval("vimtex#syntax#in_mathzone()") == 1
end

-- comment detection
function M.in_comment()
	return vim.fn["vimtex#syntax#in_comment"]() == 1
end

-- document class
function M.in_beamer()
	return vim.b.vimtex["documentclass"] == "beamer"
end

-- general env function
local function env(name)
	local is_inside = vim.fn["vimtex#env#is_inside"](name)
	return (is_inside[1] > 0 and is_inside[2] > 0)
end

function M.in_tikz()
	return env("tikzpicture")
end
```
