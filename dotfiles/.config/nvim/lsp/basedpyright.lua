return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },

  settings = {
    python = {
      pythonPath = "/home/connor/.p/bin/python",
      analysis = {
        typeCheckingMode = "standard"
      }
    }
  }

}
