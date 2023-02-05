# Advanced LuaSnip: Modular Snippets with Choice/Dynamic Nodes

> :warning: This is a work in progress! Updates will be posted from time to time.

## Acknowledgement/Notes

This is a more advanced guide surrounding some of the specifics of LuaSnip I learned recently. To fully appreciate this, you need a fairly good understanding of LuaSnip; I'd recommend taking a look at my [general guide](https://github.com/evesdropper/dotfiles/tree/main/nvim/luasnip) which also has some more resources linked.

Additionally, while a majority of the snippets are for LaTeX (and one in Python), they can be adapted for any use case in other languages as well - I hope to have some snippets in other languages in the future. A majority of snippet development comes from using the language a lot and finding places where I can improve functionality; as I am taking more math-heavy courses, I'm mostly using LaTeX. Perhaps when I move to software engineering in the summer, I can pick up a new language and share new snippets.

### Updates
- 2023-02-04: This guide was created.

<hr>

I feel like I didn’t do choice and dynamic nodes as much justice as I should have in my original guide - these nodes are probably the two most useful parts of LuaSnip yet I ironically had the least to say about these features. Both provide *a lot* of modularity to the snippet-creation process, allowing you to reuse/modify a snippet based on your needs through means like regex captures and Dynamic Node's `user_args`. In this guide, I'll be going more in-depth on these nodes and providing a couple examples to showcase their power.

## Choice Nodes: Introducing Modularity
Initially, as an Ultisnips user, I found Choice Nodes to be quite useless - what could I really use them for? Eventually, I saw [this issue](https://github.com/L3MON4D3/LuaSnip/issues/618), which gave me the initial inspiration for some choice node use cases. While I had originally thought of choice nodes as something to switch between some choices (e.g. something like a color picker that switched through colors), I realized this applied to far more than a basic option switcher - this could be used to create modularity within snippets.

The whole idea of Choice Nodes is creating options for your snippets - instead of having two (or $\forall n \in \mathbb{N}, n > 1$ snippets, if you're into induction) very similar snippets perform very closely related tasks, a single snippet with a Choice Node could perform the same task. And as a bonus, it saves on your rather limited set of easy-to-use triggers.

Not sure what I mean? Let's go through a couple examples. Since these snippets are more straightforward, I'll also introduce some related side characters into the scene - the Snippet Node and Restore Node.

### Example 1: `minted` Delimiters - Modularity with Snippet Nodes

### Example 2: Set Overloading - Adding Restore Nodes

As a quick summary, here's a short list of when (not) to use Choice Nodes:
- **Do**: Use for adding a few optional choices, or when trying to build on to a more generalized snippet (e.g. docstrings, optional arguments are some solid choices).
- **Don't**: use it as a menu for multiple snippets, let alone unrelated snippets (e.g. making `greek` expand to a Choice Node containing all the Greek symbols in LaTeX). Remember, the idea is to build modularity, not to make a dropdown menu.

As you may have noticed, the previous examples seem bit tame. Let's spice it up by adding Dynamic Nodes into the mix.

## Dynamic Nodes: Leveling Up Your Snippets
Choice Node snippets may be a bit limited if we only deal with preset node outputs, but what if we could generate the output to custom fit our snippet? Enter the dynamic node.

I've said it once and I'll say it again - Dynamic Nodes are probably the single most powerful feature in LuaSnip. But with great power comes great responsibility (in this case, to read up and understand the documentation), and for this reason, Dynamic Nodes are also quite difficult to get accustomed to.

Like Choice Nodes, Dynamic Nodes can be broken down into one main idea: it generates custom snippet output as opposed to a singular node. Recall that a snippet is made up of multiple nodes, so essentially, it allows you to string together multiple nodes and return the result as a snippet node. That being said, if the return value of a potential snippet can be described as a snippet node, then you can make it happen with a Dynamic Node.

Well, in that case, how can we create and modify snippet nodes to our liking? Two common ways I use are captures with Lua Patterns (regex) and using the `user_args` argument of a Dynamic Node. Let's take a look at some examples:

### Example 1: Matrix Snippets - Regex Dynamic Snippets 

### Example 2: Visual Python For Loop - Utilizing `user_args`

> Special thanks to [@medwatt](https://github.com/medwatt) for the inspiration behind this snippet.

As you've seen, Dynamic Nodes can unlock a whole new dimension in creating snippets. Let's expand on this even further by adding Choice Nodes back into the equation.

## Choice x Dynamic Nodes: The Collaboration We Needed
Now that we have two of the most powerful nodes in LuaSnip, let’s combine them together with a few examples to truly harness their power. Again, I'll provide an example with regex and one with `user_args`.

### Example 1: Integral Snippets
I honestly don't know why I came up with this snippet - I was working on something during break and thought to add snippets to help me with multiple integrals despite the fact that I don't think I'll be using multivariable calculus for a while. In general, I wanted a regex capture to take in the number of integrals we needed in total, then have it deal with two choices: iterated integrals and multiple integrals. Let's break down the cases:

- Iterated Integrals: We want something like `\int_{<>}^{<>}` repeated as many times as the user wants (call that $n$), as well as $n$ iterations of `\dd <>` for the differential.
    * Since the number of text/insert nodes changes with $n$, we want to use a dynamic node to generate each of these outputs.
- Multiple Integrals: We want something like `\<>nt_{<>}`, where the first blank repeats `i` a total of $n$ times.
    * This can be easily resolved with a function node.

Using a similar structure to the matrix snippet, we end up with the following code:
```lua
-- integral functions
-- generate \int_{<>}^{<>}
local int1 = function(args, snip)
    local vars = tonumber(snip.captures[1])
    local nodes = {}
    for j = 1, vars do
	table.insert(nodes, t("\\int_{"))
	table.insert(nodes, r(2*j-1, "lb" .. tostring(j), i(1))) -- thanks L3MON4D3 for finding the index issue
	table.insert(nodes, t("}^{"))
	table.insert(nodes, r(2*j, "ub" .. tostring(j), i(1))) -- please remember to count and don't be like me
	table.insert(nodes, t("} "))
    end
    return sn(nil, nodes)
end

-- generate \dd <>
local int2 = function(args, snip)
    local vars = tonumber(snip.captures[1])
    local nodes = {}
    for j = 1, vars do
	table.insert(nodes, t(" \\dd "))
	table.insert(nodes, r(j, "var" .. tostring(j), i(1)))
    end
    return sn(nil, nodes)
end

autosnippet(
    { trig = "(%d)int", name = "multi integrals", dscr = "please work", regTrig = true, hidden = false },
    fmt([[ 
    <> <> <> <>
    ]],{c(1, { fmta([[
    \<><>nt_{<>}
    ]], {c(1, { t(""), t("o") }),
	f(function(_, parent, snip)
	    inum = tonumber(parent.parent.captures[1]) -- this guy's lineage looking like a research lab's
	    res = string.rep("i", inum)
	    return res
	end), i(2),}), d(nil, int1),}),
	i(2), d(3, int2), i(0),},
        { delimiters = "<>" }),
	{ condition = math, show_condition = math }),
```

![Integral Snippet GIF](./assets/integral.gif)

### Example 2: Label Generation
I attended a LaTeX workshop at my university a while back, and I was introduced to the world of labels and references. And while taking notes for my abstract algebra course, I realized quickly that I needed something to keep track of propositions and theorems and cross-reference them. However, at the same time, I didn’t want labels to clutter my screen when I was just testing something out or writing up homework assignments.

A choice node took care of this problem easily; now I could add labels in a couple keypresses when needed while keeping them out of my screen for most general typesetting.

Now onto the labels. Generally, using `\label{<>}` would suffice for most cases; however, there were two changes I needed to implement:

- I also wanted more descriptions for my labels - e.g. `\section{}` labeled with `sec:#` and Definitions/Theorems with `def:#, thm:#` respectively.
    * This could be resolved using `user_args`, so `user_arg1` served as the source to collect label prefixes.
- `\label{<>}` did not make sense for the definition/theorem boxes made with `tcolorbox` - for those - I wanted to have a single optional argument `[<>]`.
    * Again, `user_args` came to the rescue, and I included a second option `xargs` (for the tcolorbox library) to denote that it would user a different set of opening/closing delimiters.

With that, here is the code and the snippet in action:
```lua
-- personal util 
local function isempty(s) --util 
    return s == nil or s == ''
end

-- label util 
local generate_label = function(args, parent, _, user_arg1, user_arg2)
    if user_arg2 ~= "xargs" then
        delims = {"\\label{", "}"} -- chooses surrounding environment based on arg2 - tcolorboxes use xargs
    else
        delims = {"[", "]"}
    end
    if isempty(user_arg1) then  -- creates a general label
        return sn(nil, fmta([[
        \label{<>}
        ]], {i(1)}))
    else  -- creates a specialized label
        return sn(nil, fmta([[
        <><>:<><>
        ]], {t(delims[1]), t(user_arg1), i(1), t(delims[2])}))
    end
end

-- generates \section{$1}(\label{sec:$1})?
s(
    { trig = "#", hidden = true, priority = 250 },
    fmt(
    [[
    \section{<>}<>
    <>]],
    { i(1), c(2, {t(""), d(1, generate_label, {}, {user_args={"sec"}} )
    }), i(0) },
    { delimiters = "<>" }
    )
),

-- generates \begin{definition}[$1]([def:$2])?{ ...
s(
    { trig = "adef", name = "add definition", dscr = "add definition box" },
    fmt(
    [[ 
    \begin{definition}[<>]<>{<>
    }
    \end{definition}]],
    { i(1), c(2, {t(""), d(1, generate_label, {}, {user_args={"def", "xargs"}})}), i(0) },
    { delimiters = "<>" }
    )
),
```
![Label Snippet GIF](./assets/labels.gif)


## Outro
Thanks for reading - I hope you learned something new and can find a way to implement these changes. Note that this guide is in no way comprehensive; rather, I just referenced techniques I commonly use as inspiration. If I find a new use case, I'll be sure to update this guide.
