# From UltiSnips to LuaSnip: A Comprehensive Guide

> <strong>Update:</strong> You can now find this on [my website](https://evesdropper.github.io/files/luasnip/).

## Table of Contents 
- [From UltiSnips to LuaSnip: A Comprehensive Guide](#from-ultisnips-to-luasnip--a-comprehensive-guide)
    - [Acknowledgement/Notes](#acknowledgementnotes)
        - [Updates](#updates)
    - [Intro/Differences](#introdifferences)
    - [Basic Configuration](#basic-configuration)
        - [Setup](#setup)
        - [Understanding Snippet Anatomy](#understanding-snippet-anatomy)
        - [Your First Snippets](#your-first-snippets)
        - [Expediting the Snippet Creating Process](#expediting-the-snippet-creating-process)
    - [Advanced Snippets](#advanced-snippets)
        - [Regex Triggers and Function Nodes: Parsing Auto Subscript Snippets](#regex-triggers-and-function-nodes--parsing-auto-subscript-snippets)
            - [[Extra] Postfix Snippets and Lambdas](#-extra--postfix-snippets-and-lambdas)
        - [`LS_SELECT_RAW/LS_SELECT_DEDENT`: Visual Mode Snippets](#ls_select_rawls_select_dedent-visual-mode-snippets)
        - [Choice Nodes: Fun Side Utility with Potential](#choice-nodes-fun-side-utility-with-potential)
            - [Aside: Snippet Nodes](#aside-snippet-nodes)
        - [Dynamic Nodes: Generating Tables and Matrices](#dynamic-nodes-generating-tables-and-matrices)
        - [Conditions/Context-Dependent Snippets](#conditionscontext-dependent-snippets)
    - [Additional Resources](#additional-resources)

## Acknowledgement/Notes

This is a guide centered around moving snippets from UltiSnips to LuaSnip. While a majority of snippets discussed will be LaTeX snippets, I will not be discussing practices for creating LaTeX snippets or anything of the like - that seems better suited for a future guide.

I'd also like to thank the following people for providing help:
- L3MON4D3, lervag, ejmastnak on Github.
- u/Doltonius, u/epsilontik on r/Neovim.

These users' help on figuring out how to start with LuaSnip as well as a group effort to figure out how to create conditional snippets using VimTeX syntax highlighting has been incredibly crucial for this guide.

I have not yet figured out an efficient screen capturing system; once I have that figured out, I will also try to add GIFs for better visual demonstration.

### Updates
- 2022-11-25: Moved to website.
- 2022-12-19: Added new example for Choice Nodes.
- 2022-12-31: Added examples for Choice Nodes, improved explanations.
<hr>

UltiSnips is one of the most well-known snippet engines, and it’s what I was introduced to and often used as I started my Neovim + LaTeX journey. However, as time went on, I decided to switch to a more Lua-based configuration, and UltiSnips, while trusty, was in need of an upgrade. That’s when I found LuaSnip.

However, unlike UltiSnips, which was fairly easy to set up within a day, LuaSnip had me incredibly confused - after reading the docs and watching videos, I was still lost. But through some community help and more research, I was able to successfully convert most of my snippets from UltiSnips to LuaSnip, and my LaTeX typesetting experience has never been better.

So here’s a summary of my journey through moving to LuaSnip. With this article, I hope to provide a more detailed written guide/framework for creating snippets in LuaSnip. While the main focus is on moving snippets from UltiSnips to LuaSnip (mostly with LaTeX), those with little to no experience in creating snippets and/or LaTeX typesetting may find this guide helpful as well.

## Intro/Differences
Why not start off with a small introduction of LuaSnip and UltiSnips? LuaSnip, like UltiSnips, is a snippet plugin for (Neo)vim which allows for faster code writing. However, the two have a few main differences.

While UltiSnips is quite simple in format, only using plain text and dollar signs (`$0`, `$1`) to denote inputs, LuaSnip opts for different “nodes”, making the format more verbose. (You'll later find out that this can be remedied with a format add-on, but for most users, seeing nodes might be a little off-putting and perhaps even confusing at first.)

And secondly, as the name implies, LuaSnip is heavily based on Lua parsing, whereas UltiSnips uses Python. For the most part, there is very little difference between the two save for a few syntax changes. However, the Achilles’ heel of Lua parsing is probably its more limited regex parsing - Lua only supports its own Lua patterns, which are not as complete as Python’s full suite of regex features. The lack of such regex support may make a few commonly defined snippets in UltiSnips a bit harder to convert, but in general, LuaSnip should be able to replicate most, if not all functionality of UltiSnips and add its own flair. Here’s a reference of all the snippet types/conditions I commonly used in UltiSnips and their LuaSnip counterparts as a reference and a preview as to what’s next:

| UltiSnips                          | LuaSnip                                                  |
|------------------------------------|----------------------------------------------------------|
| `a` Snippets                       | `autoexpand = true`, put on separate snip table or `autosnippet`          |
| `b` Snippets                       | `require("luasnip.extras.expand_conditions").line_begin` |
| `i`/`w` Snippets                   | `wordTrig = (true\|false)` Set to true by default        |
| `r` Snippets                       | `regTrig = true`                                         |
| `e`/`context` Snippets             | LuaSnip conditions                                       |
| Visual Mode Snippets               | `LS_SELECT_RAW/LS_SELECT_DEDENT`                         |
| Autoexpand/parsing heavy snippets  | Function/Choice/Dynamic Nodes                            |

Now, let’s get started by setting up LuaSnip.

## Basic Configuration

### Setup 

Setting up LuaSnip is a short process - you can get your snippets going in no time. Start by installing the plugin:

```lua
use "L3MON4D3/LuaSnip" -- assuming you use packer.nvim
```
Then, set up LuaSnip. I have the following options on:
- `autosnippets = true` for automatically triggering snippets. 
- `history = true` to keep around the last snippet to jump back easily.
- sourcing snippets from a custom path; mine is `~/.config/nvim/luasnip`. You can also LuaSnip parse snippets from other engines, such as VSCode and Snipmate, but I will not be covering that.

Here's my setup configuration: 
```lua
ls.config.set_config({
    history = true, -- keep around last snippet local to jump back
    enable_autosnippets = true,})
require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/luasnip/"})
```

Feel free to adjust the configuration to your needs by taking a look at [official documentation](https://github.com/L3MON4D3/LuaSnip).

Of course, make sure to set up some keybinds so that you can quickly navigate through snippets. A common choice is to use something like `<Tab>` and `<S-Tab>` to go forwards and backwards respectively.

```vim
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>
snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>
```

> Sourced from the plugin README.md; I have something different set up with `nvim-cmp`.

Now let's get ready to write snippets. Navigate to the folder you're sourcing your snippets from; to create snippets of a certain filetype, open `<filetype>.lua`, or use `all.lua` for global snippets. As I use LaTeX snippets, I'll be using `tex.lua`. Now, let's learn about snippets.

### Understanding Snippet Anatomy
A snippet consists of three parts:

- Trigger: Denote the key combination to get LuaSnip to expand the snippet. You can also define other settings, such as the snippet description as it appears in completion engines.
- Nodes: The body of the snippet - what the snippet returns, in terms of nodes.
- Condition/Callbacks: Determines the conditions on which the snippet expands and any other actions.

Combining each of the separate parts, a snippet should look somewhat like this:
```
s(<trigger|trigger table>, <nodes>, <condition,callbacks>)
```

This should provide enough background information to get started with creating a snippet of your own.

### Your First Snippets 
For LaTeX typesetting, text is often enclosed in environments, so a handy snippet is something that quickly inserts an environment. In UltiSnips, it is defined as the following:

```vim
snippet beg "begin/end environments"
\begin{$1}
$0
\end{$1}
endsnippet
```

Let's try to replicate that with LuaSnip. A possible solution looks to be the following:
```lua
s("beg", { t("\\begin{"), i(1), t("}"), i(0), t("\\end{"), i(1), t("}") })
```

But if you go and try it out, it doesn't work and the formatting is all messy. This is because of two things:
- Lack of format and newlines - even with newlines, the format is far from ideal and still very messy.
- The node number acts like an ID - it is unique, so having 2 `i(1)` nodes confuses LuaSnip.

This can be easily remedied by introducing the `fmt` utility and the repeat node. The `fmt` utility is used in the nodes slot, changing the initial snippet format to something like this:

```text
s(<trigger>, fmt(<formatted snippet>, {<nodes>}, <options>), <condition,callbacks>)
```

> **Note:** `fmta` also works but sets default delimiters to angled brackets.

As for the repeat node, it should be pretty self-explanatory: `rep(<num>)` repeats the node specified. With this, we have our new snippet:

```lua
s("beg", fmt([[
    \begin{<>}
    <>
    \end{<>}]], 
    {i(1), i(0), rep(1)}, -- repeat node 1
    {delimeters='<>'}
))
```

#### Expediting the Snippet Creating Process

Well, that was a lot of work to write a first snippet. Writing dozens of different snippets must take a lot of time. Not if you use snippets - yep, snippets to generate snippets. With this current knowledge, it's enough to make something that might be helpful to generating snippets. Two of my snippets to expedite snippet creation are the following:

```lua
-- format snippet 
s("snipf", fmt([[ 
    <>({ trig='<>', name='<>', dscr='<>'},
    fmt(<>,
    { <> },
    { delimiters='<>' }
    )<>)<>,]],
    { c(1, {t("s"), t("autosnippet")}), i(2, "trig"), i(3, "trig"), i(4, "dscr"), i(5, "fmt"), i(6, "inputs"), i(7, "<>"), i(8, "opts"), i(0)},
    { delimiters='<>' }
    )),

-- simple text snippet 
s("snipt", fmt([[ 
    <>(<>, {t('<>')}<>
    <>)<>,]],
    { c(1, {t("s"), t("autosnippet")}), c(2, {i(nil, "trig"), sn(nil, {t("{trig='"), i(1), t("'}")})}), i(3, "text"), i(4, "opts"), i(5), i(0)},
    { delimiters='<>' }
    )),
```

> The current version adds a choice node feature; we'll get to that later on in this guide. You can also find more snippet-creating snippets [in my Lua snippets file](https://github.com/evesdropper/dotfiles/blob/main/nvim/luasnip/lua.lua).

With the knowledge of text, insert, and repeat nodes as well as the snippet-creating snippets to speed up the snippet-writing process, you should be able to quickly implement a majority of the snippets you will ever want to use.

## Advanced Snippets
It's time to introduce more snippet types and create more complicated snippets. Here we'll discuss Regex, Function Nodes, Choice Nodes, Dynamic Nodes, and Conditions.

### Regex Triggers and Function Nodes: Parsing Auto Subscript Snippets
A cool snippet and a huge time saver for those who do math work is the auto subscript snippet from UltiSnips, turning something like `x1` to `x_1` and `x_1` to `x_{10}`.

Here's how it can be implemented in UltiSnips:

```vim
snippet '([A-Za-z])(\d)' "auto subscript" wrA
`!p snip.rv = match.group(1)`_`!p snip.rv = match.group(2)`
endsnippet

snippet '([A-Za-z])_(\d\d)' "auto subscript2" wrA
`!p snip.rv = match.group(1)`_{`!p snip.rv = match.group(2)`}
endsnippet
```

Looking at the snippet signature, it requires word triggers and regex triggers. Word trigger is built-in for LuaSnip, and using regex is almost as simple - simply append `regTrig=true` to the trigger table, and use a Lua pattern style trigger.

What about the next lines - returning the matched text back and editing the snippet? As mentioned previously, this was done with Python parsing in UltiSnips, but now is done with Lua parsing in LuaSnip. However, recall LuaSnip has a lot of snippet types - and here, we're introducing one that specifically deals with parsing - the function node.

For the most part, parsing snippets usually rely on captured values as arguments that are passed in or something that is saved and returned in the snippet output, which can be accessed through the `snip.captures` argument. Each of the captures in parentheses is like a Python match group and can be accessed as if they were in a Lua table (which unfortunately happens to use 1-indexing like MATLAB).

This gives our function nodes some general format like so:

```lua
f(function(_, snip) -- ignore all other arguments
    -- do some cool stuff with snip.captures[i]
    return  -- return whatever you just parsed
end)
```

For our auto subscript function, all we want to do is hold on to the values, so we just return `snip.captures[1]` and `snip.captures[2]` as needed. Here's the final implementation:

```lua
-- sub super scripts
s({ trig='(%a)(%d)', regTrig=true, name='auto subscript', dscr='hi'},
    fmt([[<>_<>]],
    { f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end) },
    { delimiters='<>' }),
    { condition=math })
s({ trig='(%a)_(%d%d)', regTrig=true, name='auto subscript 2', dscr='auto subscript for 2+ digits'},
    fmt([[<>_{<>}]],
    { f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end)},
    { delimiters='<>' }),
    { condition=math })
```
What's the bit about `snip.captures`? Well, that has to do with Lua parsing. This is quite similar to the Python version as well.

#### [Extra] Postfix Snippets and Lambdas
For certain snippets, LuaSnip has some perfect edge case functions in postfix snippets and lambdas - previously in UltiSnips, this was done with regex triggers and a lot of parsing. For example, appending hats to symbols can be done with ease like so:

```lua
-- IMPORTANT: add to your config!
local postfix = require("luasnip.extras.postfix").postfix

-- fast implementation
postfix("hat", {l("\\hat{" .. l.POSTFIX_MATCH .. "}")}, { condition=math }) -- lambdas are basically function nodes but perform very simple tasks, e.g. string concatenation/modification

-- a possible implementation using regex triggers and function nodes
s({ trig='(%a)+hat', regTrig=true, name='hats', dscr='hats'},
    fmt([[\hat{<>}]],
    { f(function(_, snip) return snip.captures[1] end)},
    { delimiters='<>' }
    ))
```

### `LS_SELECT_RAW/LS_SELECT_DEDENT`: Visual Mode Snippets

A less commonly used set of snippets are those in Visual mode. Usually they look something like this in UltiSnips:
```vim
context "math()"
snippet () "left( right)" iA
\left( ${1:${VISUAL}} \right) $0
endsnippet
```

This similar behavior can be replicated in LuaSnip using the `LS_SELECT_RAW/LS_SELECT_DEDENT` variables. To have this work, make sure you have something like `store_selection_keys="<Tab>"` somewhere in your config to store the values. After your configuration is set up, it's time to create the snippet.

The idea behind this is very similar - use `LS_SELECT_RAW`, but instead of directly using the snippet, use the `store_selection_keys` trigger to save it to the `LS_SELECT_RAW` variable, then apply the snippet. And how do we get the values from `LS_SELECT_RAW` to show up with the snippet? This is done with a function node that retrieves the values we want. Here's the finished snippet:
```lua
s({ trig='lrv', name='left right', dscr='left right'},
    fmt([[\left(<>\right)<>]],
    { f(function(args, snip)
      local res, env = {}, snip.env
      for _, val in ipairs(env.LS_SELECT_RAW) do table.insert(res, val) end
      return res
      end, {}), i(0) },
    { delimiters='<>' }
    ), { condition=math, show_condition=math }),
```

### Choice Nodes: A Neat Utility and Modularity Maker

> There isn't much that parallels with UltiSnips in this section, but nevertheless, this is a great utility to learn and implement.

With choice nodes and the next topic, dynamic nodes, we start moving away from simple inputs and towards even more complex functions. Through this, the extensibility and customizability of LuaSnip really starts to shine. However, the more complex and awe-inducing the plugin gets, the harder it gets to understand - because these nodes lack concrete output, it can be difficult to visualize and experiment with. Fortunately, for most use cases, everything from before should be more than sufficient, but it’s nice to learn more and have some truly powerful snippets.

Let's focus on choice nodes. As the name suggests, this node allows you to select between a list of nodes. Of course, you can just use text nodes to emulate stationary values, but with the option to include more complex nodes - the possibilities are endless.

A simple example is the usage of choice nodes is a snippet that toggles between different delimiters with `minted/lstlistings` code listings. If you want to use code highlighting in LaTeX, trying to highlight something like `{code}` is a hassle as LaTeX ends the command with the bracket delimiter, so in those cases, it might be wise to switch over to the upright delimiter.

The main part of the snippet is in the choice node - let's define our choices:
- Use default delimiters `{}` and insert code in the middle.
- Use alternate delimiters `||` and insert code in the middle.

Now, to execute our choices, we'll need to know a bit more about the snippet node.

#### Aside: Snippet Nodes

Snippet nodes are pretty crucial in choice nodes and the next topic, dynamic nodes. While the concept may seem a bit strange at first, it might be easier to think of a snippet as a "nested snippet" or a way to express multiple inputs with one node. For instance, in the above choices, a choice node provides us one space for an action (before the comma separation pushes us to the next choice), but we have three snippet actions: add opening delimiter as text, add code listing as input, add closing delimiter as text. The solution is to nest them all in a snippet node which allows all three actions to be processed with one choice.

A snippet node has the following formatting: `sn(index, {nodes})`. Typically in choice (and dynamic) nodes, the jump index will be `nil` as it is often nested within a function/choice.

Now that we have our choices and a way to execute them using the snippet node, the snippet comes together pretty quickly:
```lua 
s({ trig='qw', name='inline code', dscr='inline code, ft escape'},
    fmt([[\mintinline{<>}<>]],
    { i(1, "text"), c(2, {sn(nil, {t("{"), i(1), t("}")}), sn(nil, {t("|"), i(1), t("|")})})},
    { delimiters='<>' }
    )),
```

Along with being an incredibly useful side tool, choice nodes also introduce modularity into snippets, which allows them to adapt to your needs. Previously, in UltiSnips, to implement some form of modularity, it would make sense to make one more general snippet (e.g. one for the `figure` environment), and a more specific snippet to be inputted inside the more general snippet (e.g. `tikzpicture` or `\includegraphics` defaults).

Although I don't have that snippet written out right now, another nice example is a snippet I showcased earlier - the snippet to make a short text snippet. For some snippets, I might only need the trigger keyword to initialize a snippet, while other times, I might want to add other information to the trigger table, such as snippet priority values to prevent the snippet from improperly triggering. 

As with the previous snippet, we have the main snippet body and the choice: 
- Snippet Body: `<>(<>, {t('<>')}<> <>)<>,`, where each `<>` denotes the following: snippet type (tab-triggered or autosnippet), choice of trigger or trigger table, text entry, options.
- Choices: either just the snippet trigger or a full trigger table.
    - Default: most of the time we only need a trigger, which only requires an insert node.
    - Trigger Table: we need a table of the form `{trig=<>, <>}`, where the `<>` denote the trigger word and other possible trigger options we might want. This is done through a combination of text and insert nodes, which can be implemented with a snippet node.

Combining the choices with the snippet setup, we have our finished snippet here:
```lua 
s("snipt", fmt([[ 
    <>(<>, {t('<>')}<>
    <>)<>,]],
    { c(1, {t("s"), t("autosnippet")}), c(2, {i(nil, "trig"), sn(nil, {t("{trig='"), i(1), t("'}")})}), i(3, "text"), i(4, "opts"), i(5), i(0)},
    { delimiters='<>' }
    ))
```

If you want to use choice nodes often, make sure to include this in your config for quick and easy mapping.
```vim
" feel free to change mappings - these were just defaults
imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-prev-choice' : '<C-W>'
```

### Dynamic Nodes: Generating Tables and Matrices

<!--We've made it to the grand finale of the snippet node types: the dynamic nodes. In essence, these powerful nodes allow for custom snippet node return values (think text/insert nodes depending on user input), building upon function nodes (limited to string nodes), and choice nodes (limited to only the choices defined by the user) to offer a more generalized output.

Let's rectify the sloppy introduction in v1 of this guide with a simple example before we build up to the matrix snippet example. Recently, I was updating my snippets and felt the need to make some calculus-based snippets, which extended to multiple integrals. As I updated my single integral snippet, I realized that a simple set of text and insert nodes would not cut it would multiple integrals. For instance, a single integral looks like so:

$$\int_0^1 x dx$$

Compare to a double and triple integral:

$$\int_0^1 \int_0^1 x^2 y^2 dx dy \quad \iiint_0^1 x^2 y^2 z^2 dx dy dz$$

Since the content for a single integral is only `\(o)int_{lower}^{upper} <expr> d <variable>`; however for multiple integrals, while the integral, bounds, and expression stay as one constant expression, the amount of `\int_{lower}^{upper}` (for the iterated integral)  and `d <variable>` clauses changes depending on the integral. -->

A constant complaint of LaTeX users is generating something like tables and matrices, which can often be very tedious to typeset by hand. Previously, this was done using auto-expand snippets with UltiSnips, but what about with LuaSnip?

```python
global !p 

def create_matrix(snip):
	matrix_str = (snip.buffer[snip.line].split('mat')[0]+'matrix').strip()
	rows = '.'.join(snip.buffer[snip.line].split(".", 2)[:-1])
	cols = '.'.join(snip.buffer[snip.line].split(".", 2)[-1:])
	augment = True if (snip.buffer[snip.line])[-1] == 'a' else False
	int_val = lambda string: int(''.join(s for s in string if s.isdigit()))
	rows = int_val(rows)
	cols = int_val(cols)
	offset = cols + 1
	old_spacing = snip.buffer[snip.line][:snip.buffer[snip.line].rfind('\t') + 1]
	snip.buffer[snip.line] = ''
	final_str = old_spacing + "\\begin{"+matrix_str+"}[" + ('c' * (cols - 1)) + "|c]\n" if augment else old_spacing + "\\begin{"+matrix_str+"}\n"
	for i in range(rows):
		final_str += old_spacing + '\t'
		final_str += " & ".join(['$' + str(i * cols + j + offset) for j in range(cols)])
		final_str += " \\\\\\\n"
	final_str += old_spacing + "\\end{"+matrix_str+"}\n$0"
	snip.expand_anon(final_str)

endglobal 

pre_expand "create_matrix(snip)"
snippet "(small|[bBpvV])?mat(\d+).(\d+)(a?)" "Generate (small|[bBpvV])?matrix of *rows* by *columns*" wr
endsnippet
```

Well, as this suggests, we can use Dynamic Nodes. But what are dynamic nodes? These are the most powerful nodes that can exist in LuaSnip. While other nodes usually have set-in-stone outputs (e.g. strings, function outputs), dynamic nodes return snippet nodes, which is basically another snippet. This allows us to create snippets that depend on user input, such as tables and matrices. For reference, here's a nice way I can think of function nodes as opposed to dynamic nodes.

```lua
-- quick side by side of function nodes: 
f(function(_, snip) -- ignore all other arguments
    -- do some cool stuff
    return  -- return whatever cool stuff you just did with a function - input "dies" here and becomes static
end)

d(idx, function(args)
    nodes = {} -- make a table of nodes to make things a little more clear
    -- do some more cool stuff 
    return sn(nil, nodes))
```

To create the matrix, the dynamic node comes into play as we construct the body of the matrix. A basic matrix in LaTeX looks something like this:
```latex
\begin{matrix}
a & b & c \\ 
d & e & f \\ 
g & h & i \\
\end{matrix}
```
The focus is on the body of the matrix, which requires an insert node at each letter and the bordering text (` & ` between entries and ` \\` at the end). As for rows and columns, this is determined by user input (at least for my snippet - plugin creator L3MON4D3 uses a different dynamic scheme). Since we now the nodes we need to place and where to input them, creating a dynamic node becomes easier.

With this, we can ~~yank code from L3MON4D3's example in the wiki and modify it slightly~~ construct something based on the Python code to generate the matrix body. Here's the finished product:

```lua
-- dynamic matrix 
local mat = function(args, snip)
	local rows = tonumber(snip.captures[2])
    local cols = tonumber(snip.captures[3])
	local nodes = {}
	local ins_indx = 1
	for j = 1, rows do
		table.insert(nodes, r(ins_indx, tostring(j).."x1", i(1)))
		ins_indx = ins_indx+1
		for k = 2, cols do
			table.insert(nodes, t" & ")
			table.insert(nodes, r(ins_indx, tostring(j).."x"..tostring(k), i(1)))
			ins_indx = ins_indx+1
		end
		table.insert(nodes, t{"\\\\", ""})
	end
	return sn(nil, nodes)
end

-- full snippet
s({ trig='([bBpvV])mat(%d+)x(%d+)([ar])', regTrig=true, name='matrix', dscr='matrix trigger lets go'},
    fmt([[
    \begin{<>}<>
    <>
    \end{<>}]],
    { f(function (_, snip) return snip.captures[1] .. "matrix" end),
    f(function (_, snip) -- augments
        if snip.captures[4] == "a" then
            out = string.rep("c", tonumber(snip.captures[3]) - 1)
            return "[" .. out .. "|c]"
        end
        return ""
    end),
    d(1, mat),
    f(function (_, snip) return snip.captures[1] .. "matrix" end)},
    { delimiters='<>' }
    ))
```
> In essence, dynamic nodes and pre-expand snippets are quite similar, at least in this case - while the Python script adds `$idx` inputs for the user to fill in later as well as text, LuaSnip uses nodes to denote inputs ands strings.

### Conditions/Context-Dependent Snippets 

> <strong>Note:</strong> This requires [VimTeX](https://github.com/lervag/vimtex) to do LaTeX syntax highlighting.

Now, it's time to address the elephant in the room: context-dependent snippets. With so many snippets and triggers, it’s important that snippets are only expanded under proper conditions - for example, math snippets should only expand in math environments, and the same goes for other specialized conditions like TikZ environments. We can take advantage of VimTeX syntax highlighting and LuaSnip conditional snippets. Here's the functions for checking if something is in a math or specific environment:

```lua 
-- similar to global p! functions from UltiSnips
local function math()
    return vim.api.nvim_eval('vimtex#syntax#in_mathzone()') == 1
end 

local function env(name) 
    local is_inside = vim.fn['vimtex#env#is_inside'](name)
    return (is_inside[1] > 0 and is_inside[2] > 0)
end

-- for TikZ environments. Note that you will need to define new helper functions with this setup
local function tikz()
    return env("tikzpicture")
end

-- sample snippet 
s('tikztest', {t('this works only in tikz')},
{ condition=tikz, show_condition=tikz}),
```

It’s important to note how snippet engines differ in their ways of evaluating a condition - UltiSnips passes in the function call and verifies the return value, while LuaSnip only accepts the function to evaluate it on its own. So to check for environments, instead of doing something like `context("env(name)")` with UltiSnips, you need to define your own helpers. However, to alleviate things, LuaSnip has condition objects, which allow you to use boolean algebra to combine different conditions.

> <strong>Note:</strong> If you are also using a working completion engine that integrates with LuaSnip such as `nvim-cmp`, make sure to also set the `show_condition` parameter for tab-triggered snippets so that the completion engine does not show invalid snippets.

## Additional Resources
Here are some resources I found incredibly helpful for learning more about how LuaSnip worked.

- Solid Beginner Guide: [Ultimate LuaSnip Tutorial](https://www.youtube.com/watch?v=ub0REXjhpmk). It’s a video that goes through a lot of the snippet triggers in depth and gives a lot of explanation - the perfect gentle intro for someone who might not know too much about snippets and LuaSnip. I watched this many times to really understand how snippets worked with LuaSnip.
- A more in-depth guide for complex snippets: TJ Devries’s LuaSnip guides ([Intro](https://www.youtube.com/watch?v=Dn800rlPIho]), [Advanced Config](https://www.youtube.com/watch?v=KtQZRAkgLqo)), especially the advanced configuration guide. While the Ultimate Guide does touch upon Function Nodes and Dynamic Nodes, TJ provides a more elaborate explanation on these and introduces Choice Nodes.
- Official Documentation through the [Doc](https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md) and showcases of advanced usages of snippets on the [Wiki](https://github.com/L3MON4D3/LuaSnip/wiki). These have some of the most impressive showcases of snippets I've ever come across - if you've outgrown guides, you should definitely give the wiki a look!
    - Fair warning that these are more complicated and can be hard to digest at first; I spent a lot of time looking at the video guides before I came back and referenced the official resources.

<hr>

And that’s a wrap! Hopefully this guide was helpful as an introduction to LuaSnip and a reference for moving your snippets over. If you want to check out some of my snippets, they are linked [here](https://github.com/evesdropper/dotfiles/tree/main/nvim/luasnip).

