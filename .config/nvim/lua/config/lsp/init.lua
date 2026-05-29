require("config.lsp.auto-commands")
require("config.lsp.commands")

local enabled_servers = require("config.lsp.enabled_servers")
local client_cmp_opts = require("config.lsp.plugin-opts.cmp")
local diagnostic_opts = require("config.lsp.opts.diagnostic")

vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})

vim.diagnostic.config(diagnostic_opts)

for _, server_name in pairs(enabled_servers) do
  server_name = vim.split(server_name, "@")[1]

  local lspconfig_client_opts = require("config.lsp.server-opts." .. server_name)  -- options copied from https://github.com/neovim/nvim-lspconfig/lsp/
  local client_opts = vim.tbl_deep_extend("keep", client_cmp_opts, lspconfig_client_opts)

  vim.lsp.config(server_name, client_opts)
  vim.lsp.enable(server_name)
end

require("config.lsp.plugin-autocmds.overloads")

