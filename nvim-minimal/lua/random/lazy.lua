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
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    {
        "nvim-treesitter/playground",
    },

    -- cmp / snippets
    {
        "L3MON4D3/LuaSnip",
        build = "make install_jsregexp"
    },
    {
        "evesdropper/luasnip-latex-snippets.nvim", dev = true,
    },

    -- colors / appearance
    {
        "phha/zenburn.nvim", -- colorscheme
    },
    {
        "nvim-tree/nvim-web-devicons",
    },

    -- tex / markdown
    {
        "lervag/vimtex",
    },
    -- die (respectfully)
    {
        "bfredl/nvim-luadev",
    },

}, {
    dev = {
        -- directory where you store your local plugin projects
        path = "~/Documents/code/",
        ---@type string[] plugins that match these patterns will use your local versions instead of being fetched from GitHub
        patterns = {'ls-plugin'}, -- For example {"folke"}
        fallback = false, -- Fallback to git when local plugin doesn't exist
    },
})
