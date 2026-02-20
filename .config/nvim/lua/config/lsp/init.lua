local enabled_servers = require("config.lsp.enabled_servers")
local client_cmp_opts = require("config.lsp.plugin-opts.cmp")

local diagnostic_config = {
  virtual_text = true,
  update_in_insert = true,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
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

local general_lsp_on_attach_group_id = vim.api.nvim_create_augroup("LspOnAttach", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = general_lsp_on_attach_group_id,
  pattern = "*",
  callback = function(e)
    local client = vim.lsp.get_client_by_id(e.data.client_id)

    if not client then
      return
    end

    if client.server_capabilities.documentHighlightProvider then
      local group = vim.api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
      vim.api.nvim_create_autocmd("CursorMoved", {
        group = group,
        buffer = 0,
        callback = function()
          vim.lsp.buf.clear_references()
          vim.lsp.buf.document_highlight()
        end
      })
    end
  end,
})

for _, server_name in pairs(enabled_servers) do
  server_name = vim.split(server_name, "@")[1]

  local lspconfig_client_opts = require("config.lsp.server-opts." .. server_name)  -- options copied from https://github.com/neovim/nvim-lspconfig/lsp/
  local has_extra, extra_opts = pcall(require, "config.lsp.server-extras." .. server_name) -- extra options when special configuration is needed
  if not has_extra then
    extra_opts = {}
  end

  local client_opts = vim.tbl_deep_extend("keep", extra_opts, client_cmp_opts, lspconfig_client_opts)

  vim.lsp.config(server_name, client_opts)
  vim.lsp.enable(server_name)
end

require("config.lsp.plugin-autocmds.overloads")

