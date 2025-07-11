return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'VonHeikemen/lsp-zero.nvim'
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'

  use 'hrsh7th/cmp-buffer'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'hrsh7th/cmp-path'

  use 'sainnhe/sonokai'
  use 'sphamba/smear-cursor.nvim'
  use 'karb94/neoscroll.nvim'
  use 'max397574/better-escape.nvim'
  use 'code-biscuits/nvim-biscuits'


  use {
    'nvim-treesitter/nvim-treesitter',
    run = function()
        local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
        ts_update()
    end,
  }
end)
