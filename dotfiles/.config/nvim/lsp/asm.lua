-- asm-lsp gen-config
-- put the .asm-lsp.toml in ur project dir

-- gas (.s):

--[default_config]
--version = "0.10.0"
--assembler = "gas"
--instruction_set = "x86-64"

--[default_config.opts]
--compiler = "/bin/gcc"
--compile_flags_txt = []
--diagnostics = true
--default_diagnostics = true

-- nasm (.asm):

--[default_config]
--version = "0.10.0"
--assembler = "nasm"
--instruction_set = "x86-64"

--[default_config.opts]
--compiler = "/bin/nasm"
--compile_flags_txt = []
--diagnostics = true
--default_diagnostics = true

return {
  cmd = { 'asm-lsp' },
  filetypes = { 'asm' },
  --root_dir = "..." -- specify if it doesn't find .asm-lsp.toml
}
