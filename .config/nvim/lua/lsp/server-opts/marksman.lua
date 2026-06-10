---@brief
---
--- https://github.com/artempyanykh/marksman
---
--- Marksman is a Markdown LSP server providing completion, cross-references, diagnostics, and more.
---
--- Marksman works on MacOS, Linux, and Windows and is distributed as a self-contained binary for each OS.
---
--- Pre-built binaries can be downloaded from https://github.com/artempyanykh/marksman/releases

return {
  cmd = { 'marksman', 'server' },
  filetypes = { 'markdown', 'markdown.mdx' },
  root_markers = { '.marksman.toml', '.git' },
  on_exit = function(client)
    print("marksman detached, restarting...")
    local buffer_clients = vim.lsp.get_clients({ bufnr = client.bufnr })
    for _, c in ipairs(buffer_clients) do
      if c.name == 'marksman' then
        c:stop();
      end
    end
    vim.lsp.start(client.config)
  end
}
