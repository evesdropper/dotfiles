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
		tag = "0.1.1",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"nvim-telescope/telescope-media-files.nvim",
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
		"L3MON4D3/LuaSnip",
	},

	-- code editing
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	{
		"akinsho/toggleterm.nvim",
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
        'glepnir/dashboard-nvim',
        event = 'VimEnter',
        dependencies = {'nvim-tree/nvim-web-devicons'},
    },

    -- tex / markdown
    {
        "lervag/vimtex",
    },
    {
        "dkarter/bullets.vim",
    },
})
