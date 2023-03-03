M = {}
local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set 
--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- display file tree
keymap("n", "<leader>e", ":Lex 30<cr>", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
keymap("n", "<S-w>", ":bd<CR>", opts)

-- line mover
keymap("n", "K", ":m .-2<CR>==", opts)
keymap("n", "J", ":m .+1<CR>==", opts)

-- misc
-- keymap("n", "zz", ":w<CR>", opts) -- save
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
keymap("n", "zq", ":q!<CR>", opts) -- saven't
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts) -- nohl
keymap("v", "p", '"_dP', opts) -- paste

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- not an enjoyer of autosave? :nomaidens: & other typesetting utils
keymap("i", "<C-s>", "<ESC>:update<CR>gi", opts) --save
keymap("i", "<M-z>", "<Esc>:set wrap! linebreak<cr>gi", opts) --wrap for TeX
keymap("i", "<C-l>", "<c-g>u<Esc>[s1z=`]a<c-g>u", opts) -- spellcheck

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- Telescope --
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fh", ":Telescope help_tags<CR>", opts)

-- nvim-tree
keymap("n", "<C-e>", ":NvimTreeToggle<CR>", opts)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", term_opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', {})

-- mkdp
keymap("n", "<C-s>", ":MarkdownPreview<CR>", opts)
keymap("n", "<M-s>", ":MarkdownPreviewStop<CR>", opts)
keymap("n", "<C-p>", ":MarkdownPreviewToggle<CR>", opts)

keymap("i", "<C-f>", "<Plug>luasnip-next-choice", {})
keymap("s", "<C-f>", "<Plug>luasnip-next-choice", {})
keymap("i", "<C-d>", "<Plug>luasnip-prev-choice", {})
keymap("s", "<C-d>", "<Plug>luasnip-prev-choice", {})

return M
