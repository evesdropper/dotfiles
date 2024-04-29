local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- core
    {
        "windwp/nvim-autopairs",
    },
    {
        "nvim-lua/plenary.nvim", -- Useful lua functions used in lots of plugins
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" },
    },
    {
        "nvim-telescope/telescope-media-files.nvim",
    },
    {
        "ThePrimeagen/harpoon",
    },
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    {
        "nvim-treesitter/playground",
    },
    {
        "kylechui/nvim-surround",
    },
    {
        "numToStr/Comment.nvim"
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring"
    },
    {
        "windwp/nvim-ts-autotag"
    },

    -- lsp
    {
        "neovim/nvim-lspconfig",
    },
    {
        "williamboman/mason.nvim",
    },
    {
        "williamboman/mason-lspconfig.nvim",
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
    },
    {
        "RRethy/vim-illuminate",
    },

    -- cmp / snippets
    {
        "hrsh7th/nvim-cmp", -- The completion plugin
    },
    {
        "hrsh7th/cmp-buffer", -- buffer completions
    },
    {
        "hrsh7th/cmp-path", -- path completions
    },
    {
        "hrsh7th/cmp-cmdline", -- cmdline completions
    },
    {
        "saadparwaiz1/cmp_luasnip", -- snippet completions
    },
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "hrsh7th/cmp-emoji",
    },
    {
        "hrsh7th/cmp-nvim-lua",
    },
    {
        "hrsh7th/cmp-omni"
    },
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp"
    },

    -- code editing
    {
        'stevearc/oil.nvim',
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "akinsho/toggleterm.nvim",
    },

    -- git 
    {
        "lewis6991/gitsigns.nvim",
    },

    -- colors / appearance
    {
        "phha/zenburn.nvim", -- colorscheme
    },
    {
        "nvim-tree/nvim-web-devicons",
    },
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "akinsho/bufferline.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        "fgheng/winbar.nvim",
    },
    {
        "SmiteshP/nvim-navic",
        dependencies = "neovim/nvim-lspconfig",
    },
    {
        'goolord/alpha-nvim',
        dependencies = {
            "BlakeJC94/alpha-nvim-fortune",
        }
    },

    -- tex / markdown
    {
        "lervag/vimtex",
        ft = "tex",
    },
    {
        "dkarter/bullets.vim",
        ft = { "tex", "markdown", "text" },
    },
    {
        "toppair/peek.nvim",
        ft = { "markdown" },
        event = { "VeryLazy" },
        build = "deno task --quiet build:fast",
    },
})
