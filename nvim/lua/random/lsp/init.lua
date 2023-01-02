local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "random.lsp.mason"
require("random.lsp.handlers").setup()
require "random.lsp.null-ls"
