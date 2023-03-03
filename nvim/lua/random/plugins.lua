local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- general settings
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used in lots of plugins
	use("windwp/nvim-autopairs")
    use({
        "kylechui/nvim-surround",
        tag = "*", -- Use for stability; omit to use `main` branch for the latest features
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    })

    -- lsp
    use("neovim/nvim-lspconfig")
    use("williamboman/mason.nvim")
    use("williamboman/mason-lspconfig.nvim")
    use("jose-elias-alvarez/null-ls.nvim")
    use("RRethy/vim-illuminate")

    -- tex/mdp moment
    use("lervag/vimtex")
    use({
        "iamcco/markdown-preview.nvim",
        run = function()
            vim.fn["mkdp#util#install"]()
        end,
        ft = "markdown",
    })
    use('dkarter/bullets.vim')

    -- cmp plugins
    use("hrsh7th/nvim-cmp") -- The completion plugin
    use("hrsh7th/cmp-buffer") -- buffer completions
    use("hrsh7th/cmp-path") -- path completions
    use("hrsh7th/cmp-cmdline") -- cmdline completions
    use("saadparwaiz1/cmp_luasnip") -- snippet completions
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-emoji")
    use("hrsh7th/cmp-nvim-lua")
    use("zbirenbaum/copilot-cmp")

    -- Snippet
    use("L3MON4D3/LuaSnip") --snippet engine

    -- telescope/treesitter
    use("nvim-telescope/telescope.nvim")
    use("nvim-telescope/telescope-media-files.nvim")
    use({'nvim-treesitter/nvim-treesitter', run = ':TSUpdate'})
    use('nvim-treesitter/playground')
    use('mrjones2014/nvim-ts-rainbow')
    use("windwp/nvim-ts-autotag")

    -- comments
    use("numToStr/Comment.nvim") -- Easily comment stuff
    use("JoosepAlviste/nvim-ts-context-commentstring")

    -- git
    use({ "lewis6991/gitsigns.nvim" })

    -- extinctifying vscode
    use({ "nvim-tree/nvim-tree.lua" })
    require("nvim-tree").setup()
    use({ "akinsho/toggleterm.nvim", tag = "*" })
    use { 'dccsillag/magma-nvim', run = ':UpdateRemotePlugins' } -- data science 
    use { 'GCBallesteros/jupytext.vim' }
    use { 'kana/vim-textobj-user' }
    use { 'GCBallesteros/vim-textobj-hydrogen' }

    -- appearance
    use({
        "phha/zenburn.nvim",
    })
    use({ "Mofiqul/vscode.nvim" }) -- code dark scheme
    use({ "petertriho/nvim-scrollbar" })
    use({ "nvim-lualine/lualine.nvim", requires = { "nvim-tree/nvim-web-devicons", opt = true } })
    use({ "akinsho/bufferline.nvim", tag = "v3.*", requires = "nvim-tree/nvim-web-devicons" })
    use({ 'nvim-tree/nvim-web-devicons' })
    use({ "fgheng/winbar.nvim" })
    use({ "SmiteshP/nvim-navic", requires = "neovim/nvim-lspconfig" })
    use({ "glepnir/dashboard-nvim" })
    use("andweeb/presence.nvim") -- to remind discord users that i am a superior being

    -- utils + git good
    use({ "ThePrimeagen/vim-be-good" })
    use({
        "max397574/better-escape.nvim",
        config = function()
            require("better_escape").setup({ mapping = { "jk", "kj" } })
        end,
    })

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if PACKER_BOOTSTRAP then
        require("packer").sync()
    end
end)
