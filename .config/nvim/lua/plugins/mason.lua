local servers = require("config.lsp.general-opts").enabled_servers

local mason_opts = {
  ui = {
    border = "none",
    icons = {
      package_installed = "◍",
      package_pending = "◍",
      package_uninstalled = "◍",
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
  registries = {
    "github:mason-org/mason-registry",
    "github:Crashdummyy/mason-registry"
  }
}

local manually_installed_servers = { "marksman", "clangd", "roslyn_ls", "roslyn" }
local mason_managed_servers = vim.tbl_filter(function(server)
  return not vim.tbl_contains(manually_installed_servers, server)
end, servers)

require("mason").setup(mason_opts)
require("mason-lspconfig").setup({
  ensure_installed = mason_managed_servers,
  -- automatic_installation = true,
  -- automatic_enable = servers
})

