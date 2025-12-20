local enabled_servers = require("config.lsp.general-opts").enabled_servers
local general_client_opts = require("config.lsp.general-opts").general_client_opts

local diagnostic_config = {
  virtual_text = true,
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style     = "minimal",
    border    = "rounded",
    source    = "always",
    header    = "",
    prefix    = "",
  },
  signs = {
    priority = 10,
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.INFO]  = "",
      [vim.diagnostic.severity.HINT]  = "",
    },
    -- linehl = {
    --   [vim.diagnostic.severity.ERROR] = 'ErrorMsg',
    -- },
    numhl = {
      [vim.diagnostic.severity.ERROR] = 'DiagnosticError',
    },
  },
}

vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
})

local signature_help_config = {
  offset_x = 300
}

vim.diagnostic.config(diagnostic_config)

for _, server_name in pairs(enabled_servers) do
  server_name = vim.split(server_name, "@")[1]
  -- local is_ok, custom_config = pcall(require, "config.lsp.opts." .. server_name)
  local custom_config = require("config.lsp.opts." .. server_name)

  -- if not is_ok then
  --   print("No custom config found for " .. server_name .. ", using default config.")
  --   custom_config = {}
  -- end

  local server_config = vim.tbl_deep_extend("force", general_client_opts, custom_config)
  vim.lsp.config(server_name, server_config)
  vim.lsp.enable(server_name)
end
