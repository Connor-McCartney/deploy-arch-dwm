require'nvim-treesitter.configs'.setup {
  ensure_installed = { "python", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "rust", "cpp", "javascript", "typescript", "html", "css", "cmake", "dockerfile", },
  sync_install = false,
  auto_install = false,

  highlight = {
    enable = true,
  },
}
