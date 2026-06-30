require("core.functions")

M = {}

-- fuck table.unpack
unpack = table.unpack or unpack

-- wrapper
local wrap = function(func, ...)
  local args = { ... }
  return function()
    func(unpack(args))
  end
end

-- function: move the window in direction shown or create new split (adapted to lua from: https://pastebin.com/ya9hWSbY)
local win_move = function(key)
  local cur_win = vim.fn.winnr()
  vim.cmd.wincmd(key)
  if cur_win == vim.fn.winnr() then
    if key == "j" or key == "k" then
      vim.cmd.wincmd("s")
    else
      vim.cmd.wincmd("v")
    end
    vim.cmd.wincmd(key)
  end
end

-- keymap opts
local opts = { noremap = true, silent = true }
local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- Remap space as leader key
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
-- "use tabs" they said, so I did
keymap("n", "<S-t>", "<cmd>tabnew<CR>", opts)
keymap("n", "<A-l>", "<cmd>tabnext<CR>", opts)
keymap("n", "<A-h>", "<cmd>tabprev<CR>", opts)
keymap("n", "<A-S-l>", "<cmd>tabmove<CR>", opts)
keymap("n", "<A-S-h>", "<cmd>tabmove 0<CR>", opts)
keymap("n", "<A-o>", "<cmd>tabonly<CR>", opts)

-- Better window navigation
keymap("n", "<C-h>", wrap(win_move, "h"), opts)
keymap("n", "<C-j>", wrap(win_move, "j"), opts)
keymap("n", "<C-k>", wrap(win_move, "k"), opts)
keymap("n", "<C-l>", wrap(win_move, "l"), opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize +2<CR>", opts)
keymap("n", "<C-Down>", ":resize -2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
-- keymap("n", "<S-w>", ":bd<CR>", opts) -- snacks.bufdelete

-- line mover
keymap("n", "K", ":m .-2<CR>==", opts)
keymap("n", "J", ":m .+1<CR>==", opts)

-- misc
-- keymap("n", "zz", ":w<CR>", opts) -- save
keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")
keymap("n", "zx", ":w<CR>", opts) -- save
keymap("n", "xz", ":x<CR>", opts) -- save
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

return M
