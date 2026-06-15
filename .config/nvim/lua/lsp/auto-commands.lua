local general_lsp_on_attach_group_id = vim.api.nvim_create_augroup("LspOnAttach", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = general_lsp_on_attach_group_id,
  pattern = "*",
  callback = function(e)
    ---@type vim.lsp.Client?
    local client = vim.lsp.get_client_by_id(e.data.client_id)

    if not client then
      return
    end

  if not client:supports_method('textDocument/documentHighlight') then
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

-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = "LspOnAttach",
--   pattern = "*",
--   callback = function(e)
--     local client = vim.lsp.get_client_by_id(e.data.client_id)
--
--     if not client then
--       return
--     end
--
--     if client.server_capabilities.signatureHelpProvider then
--       require("lsp-overloads").setup(client, require("lsp.opts.overloads"))
--     end
--   end,
-- })
