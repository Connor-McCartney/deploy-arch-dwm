-- MOVES LINES UP/DOWN KEYMAP
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv")

-- have same cursor position for ctrl-u and ctrl-d
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- clipboard integration 
vim.cmd("set clipboard=unnamed,unnamedplus")

-- prevent copying when deleting 
vim.keymap.set("n", "dd", "\"_dd")
vim.keymap.set({"n", "v"}, "d", "\"_d")
vim.keymap.set("n", "x", "\"_x")
vim.keymap.set("n", "X", "\"_X")
vim.keymap.set("n", "s", "\"_s")

-- quicksave :w alternative (windows `)
vim.keymap.set({"n", "v", "i"}, "<D-`>", "<Esc>:w<CR>")

-- quickclose :wq alternative (windows a)
vim.keymap.set({"n", "v", "i"}, "<D-a>", "<Esc>:wq<CR>")

-- Better indenting in visual mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Highlight yanked text
local augroup = vim.api.nvim_create_augroup("UserConfig", {})
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- alt-y to copy entire file
vim.keymap.set("n", "<A-y>", "ggVGy")

-- alt-d to delete entire file
vim.keymap.set("n", "<A-d>", "ggVG\"_dd")

-- alt-a highlight all
vim.keymap.set("n", "<A-a>", "ggVG")

-- center cursor
vim.keymap.set("n", "<A-w>", ':execute "normal! 0" . (col("$") / 2) . "|"<CR>     :echo ""<CR>')

-- surround-nvim shortcuts
vim.keymap.set("n", "<A-t>", "ysiw", {remap=true}) -- surround word with eg t", t'

-- I keep accidentally hitting 'menu' physical key, just disable it
vim.keymap.set({"n", "i", "v"}, "", "<nop>", { noremap = true })
vim.keymap.set({ "n", "i", "v" }, "<S->", "<nop>", { noremap = true })

-- if autosave is on, no point differeing ZZ and ZQ, just use Z all the time
--vim.keymap.set({ "n", "v" }, "Z", "ZZ", { noremap = true })

-- left and right with alt-h and alt-l in insert mode
vim.keymap.set({ "i" }, "<A-h>", "<Left>", { noremap = true })
vim.keymap.set({ "i" }, "<A-l>", "<Right>", { noremap = true })
