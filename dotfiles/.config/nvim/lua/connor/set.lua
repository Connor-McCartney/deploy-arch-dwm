--indentation
vim.opt.tabstop = 4
vim.softtapstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.termguicolors = true
vim.opt.guicursor = ""        --match terminal cursor
vim.opt.nu = true             --line numbers
vim.opt.mouse = "a"           --mouse support
vim.opt.hlsearch = false      --disable search highlighting after searching
vim.opt.incsearch = true      --highlight as you search
vim.opt.wrap = false          --disable line wrapping
vim.opt.scrolloff = 8         --line from top/bottom until scrolling
vim.opt.cursorline = true     --highlight current line
vim.opt.swapfile = false      --disable annoying swapfiles
vim.treesitter.language.register('python', 'sage')  -- treesitter highlighting for sagemath

-- disable history popup
vim.cmd("nnoremap q: <nop>")

-- https://www.reddit.com/r/neovim/comments/13585hy/trying_to_disable_autocomments_on_new_line_eg
vim.cmd('autocmd BufEnter * set formatoptions-=cro')
