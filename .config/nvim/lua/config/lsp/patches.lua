
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
