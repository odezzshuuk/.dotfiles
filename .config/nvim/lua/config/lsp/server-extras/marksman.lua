
local marksman_on_attach_group_id = vim.api.nvim_create_augroup("MarksmanOnAttach", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
  group = marksman_on_attach_group_id,
  pattern = { ".md", ".markdown", ".mdx" },
  callback = function(e0)

    local client_name = vim.lsp.get_client_by_id(e0.data.client_id).name
    if client_name ~= "marksman" then
      return
    end

    -- restart marksman when it detaches, because it can get into a bad state where it doesn't restart on its own
    vim.api.nvim_create_autocmd('LspDetach', {
      group = vim.api.nvim_create_augroup('marksman_restart_autocmd', { clear = true }),
      pattern = { ".md", ".markdown", ".mdx" },
      callback = function(e)
        print("marksman detached, restarting...")
        local client = vim.lsp.get_client_by_id(e.data.client_id)
        if not client or client.name ~= 'marksman' then
          return
        end
        local buffer_clients = vim.lsp.get_clients({ bufnr = e.buf })
        for _, c in ipairs(buffer_clients) do
          if c.name == 'marksman' then
            vim.lsp.stop_client(c.id)
          end
        end
        vim.lsp.start(client.config)
      end,
    })

  end,
})

---@type vim.lsp.Config
return { }
