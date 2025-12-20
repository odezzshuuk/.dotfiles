---@brief
---
--- https://github.com/artempyanykh/marksman
---
--- Marksman is a Markdown LSP server providing completion, cross-references, diagnostics, and more.
---
--- Marksman works on MacOS, Linux, and Windows and is distributed as a self-contained binary for each OS.
---
--- Pre-built binaries can be downloaded from https://github.com/artempyanykh/marksman/releases

local general_on_attach = require('config.lsp.general-opts').general_client_opts.on_attach

local bin_name = 'marksman'
local cmd = { bin_name, 'server' }

-- Autocommand to restart Marksman on detach
local function restart_marksman_on_detach()
  vim.api.nvim_create_autocmd('LspDetach', {
    group = vim.api.nvim_create_augroup('marksman_restart_autocmd', { clear = true }),
    callback = function(args)
      print("marksman detached, restarting...")
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client or client.name ~= 'marksman' then
        return
      end
      local buffer_clients = vim.lsp.get_clients({ bufnr = args.buf })
      for _, c in ipairs(buffer_clients) do
        if c.name == 'marksman' then
          vim.lsp.stop_client(c.id)
        end
      end
      vim.lsp.start(client.config)
    end,
  })
end

return {
  cmd = cmd,
  filetypes = { 'markdown', 'markdown.mdx' },
  root_markers = { '.marksman.toml', '.git' },
  on_attach = function(client, bufnr)
    general_on_attach(client, bufnr)
    restart_marksman_on_detach()
  end,
}
