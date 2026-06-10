--- cmds and autocmds
require("lsp.auto-commands")
require("lsp.commands")

--- diagnostic
local diagnostic_opts = require("lsp.opts.diagnostic")
vim.diagnostic.config(diagnostic_opts)

--- LSP servers
local enabled_servers = require("lsp.enabled_servers")
local client_cmp_opts = require("lsp.opts.cmp")
for _, server_name in pairs(enabled_servers) do
  server_name = vim.split(server_name, "@")[1]

  local lspconfig_client_opts = require("lsp.server-opts." .. server_name)  -- options copied from https://github.com/neovim/nvim-lspconfig/lsp/
  local client_opts = vim.tbl_deep_extend("keep", client_cmp_opts, lspconfig_client_opts)

  vim.lsp.config(server_name, client_opts)
  vim.lsp.enable(server_name)
end

--- extension to filetype
vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})
