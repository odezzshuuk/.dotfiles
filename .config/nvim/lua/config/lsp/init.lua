local enabled_servers = require("config.lsp.enabled_servers")
local general_client_opts = require("config.lsp.general-opts")

local diagnostic_config = {
  virtual_text = true,
  update_in_insert = true,
  underline = true,
  severity_sort = true, float = {
    focusable = false,
    style     = "minimal",
    border    = "rounded", source    = "always",
    header    = "", prefix    = "",
  }, signs = { priority = 10,
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

---@param ... function
local function merged_functions(...)

  local funcs = { ... }

  return function(client, bufnr)
    for _, func in ipairs(funcs) do
      if func then
        func(client, bufnr)
      end
    end
  end
end

for _, server_name in pairs(enabled_servers) do
  server_name = vim.split(server_name, "@")[1]

  local has_extra, extra_opts = pcall(require, "config.lsp.extra-opts." .. server_name)  -- extra options when special configuration is needed
  local lspconfig_client_opts = require("config.lsp.opts." .. server_name) -- options copied from https://github.com/neovim/nvim-lspconfig/lsp/

  if not has_extra then
    extra_opts = { }
  end

  local client_opts = vim.tbl_deep_extend("keep", extra_opts, lspconfig_client_opts, general_client_opts)

  -- merge on_attach options, because on_attach value is a function and cannot be merged with vim.tbl_deep_extend
  client_opts.on_attach = merged_functions(lspconfig_client_opts.on_attach, general_client_opts.on_attach, extra_opts.on_attach)

  vim.lsp.config(server_name, client_opts)
  vim.lsp.enable(server_name)
end
