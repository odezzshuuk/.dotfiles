local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.workspace = {
  didChangeWatchedFiles = {
    dynamicRegistration = true,
  }
}

return {
  capabilities = capabilities,
}
