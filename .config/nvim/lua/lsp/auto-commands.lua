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
        buffer = e.buf,
        callback = vim.lsp.buf.clear_references
      })

      vim.api.nvim_create_autocmd("CursorHold", {
        group = group,
        buffer = e.buf,
        callback = vim.lsp.buf.document_highlight
      })

      vim.api.nvim_create_autocmd("LspDetach", {
        group = group,
        buffer = e.buf,
        callback = function(e2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = group, buffer = e2.buf })
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
