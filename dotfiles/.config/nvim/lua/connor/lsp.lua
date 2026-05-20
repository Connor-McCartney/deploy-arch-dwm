-- https://neovim.io/doc/user/news-0.11.html#_defaults
--grn rename
--grr references
--gD declaration
--gd definition
vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<F3>', '<cmd>lua vim.diagnostic.open_float({border = "rounded"})<cr>', {noremap = true, silent = true}) -- shows errors/warnings

vim.lsp.enable({
    "lua_ls",
    "basedpyright",
    "rustanalyzer",
    "clangd",
    "asm",
})

vim.opt.winborder = 'rounded'

vim.diagnostic.config({
    --virtual_lines = true,
    virtual_text = true,
    underline = true,
    update_in_insert = false,

    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "E ",
            [vim.diagnostic.severity.WARN] = "W ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = { -- number highlight
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})



