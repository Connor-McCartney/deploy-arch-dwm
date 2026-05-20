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

-- fix annoying indentexpr
vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.indentexpr = ""     -- disable Python indentexpr
    vim.opt_local.smartindent = true
    vim.opt_local.autoindent = true   -- optional: simple linewise auto-indent
  end,
})

vim.g.neovide_opacity = 0.8
vim.g.neovide_normal_opacity = 0.8

-- actually start treesitter
vim.api.nvim_create_autocmd('FileType', {
  pattern = {

        "sage",
        "odin",
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "c",
        "cpp",
        "python",
        "rust",
        "cmake",
        "asm",

  },

  callback = function() vim.treesitter.start() end,
})
