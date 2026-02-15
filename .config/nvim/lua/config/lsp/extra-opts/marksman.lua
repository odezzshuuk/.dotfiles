---@type vim.lsp.Config
return {
  on_attach = function(client, bufnr)
    -- restart marksman when it detaches, because it can get into a bad state where it doesn't restart on its own
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
  end,
}
