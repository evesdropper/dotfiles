# Neovim Configuration

Goals:
- Efficient LaTeX editing for lectures and assignments
- Stop having to use Visual Studio (i.e. replace all the features I found useful this summer)

Structure: 
```
.
├── lua
│   ├── core # core config: options, keymaps, autocommands, plugin manager
│   ├── plugins # plugin config, split into groups (e.g. LSP, LaTeX utilities, UI)
│   └── snippets # snippets as part of LuaSnip
│       ├── lua
│       └── tex
│           └── utils
└── spell
```

Using `[lazy.nvim](https://github.com/folke/lazy.nvim)`.
