-- https://github.com/VonHeikemen/lsp-zero.nvim



-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig_defaults.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
  end,
})

-- You'll find a list of language servers here:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md
-- These are example language servers. 
require('lspconfig').pyright.setup({
  settings = {
    python = {
      pythonPath = "/home/connor/.p/bin/python",
    },
  },
})

require('lspconfig').lua_ls.setup({
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim' }
      }
    }
  }
})


require('lspconfig').rust_analyzer.setup({})
require('lspconfig').clangd.setup({})
require('lspconfig').asm_lsp.setup({})

-- asm-lsp gen-config
-- put the .asm-lsp.toml in ur proect dir

-- gas:

--[default_config]
--version = "0.10.0"
--assembler = "gas"
--instruction_set = "x86-64"

--[default_config.opts]
--compiler = "/bin/gcc"
--compile_flags_txt = []
--diagnostics = true
--default_diagnostics = true

-- nasm:




local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-o>'] = cmp.mapping.select_next_item(cmp_select),
    ['<Tab>'] = cmp.mapping.confirm({ select = true }),
})


cmp.setup({
    -- https://github.com/hrsh7th/nvim-cmp/blob/main/doc/cmp.txt
    mapping = cmp_mappings,
    experimental = { ghost_text = true },
    window = {
        completion = cmp.config.window.bordered({border = "rounded"}),
        documentation = cmp.config.window.bordered({border = "rounded"}),
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp'},
        { name = 'buffer'},
        { name = 'path'},
    }),
})
