local enabled_servers = {
  "lua_ls",
  "pyright",
  "jsonls",
  "ts_ls",
  "marksman",
  "bashls",
  "tailwindcss",
  "clangd",
  -- "omnisharp",
  "roslyn_ls",
  -- "roslyn",
  "html",
  "cssls",
  "vue_ls",
  "vtsls",
  "rust_analyzer",
  "eslint",
}

local lsp_overloads_opts = {
  ui = {
    border = "single", -- The border to use for the signature popup window. Accepts same border values as |nvim_open_win()|.
    height = nil,      -- Height of the signature popup window (nil allows dynamic sizing based on content of the help)
    width = nil,       -- Width of the signature popup window (nil allows dynamic sizing based on content of the help)
    wrap = true,       -- Wrap long lines
    wrap_at = nil,     -- Character to wrap at for computing height when wrap enabled
    max_width = nil,   -- Maximum signature popup width
    max_height = nil,  -- Maximum signature popup height
    -- Events that will close the signature popup window: use {"CursorMoved", "CursorMovedI", "InsertCharPre"} to hide the window when typing
    close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
    focusable = true,                       -- Make the popup float focusable
    focus = false,                          -- If focusable is also true, and this is set to true, navigating through overloads will focus into the popup window (probably not what you want)
    offset_x = 0,                           -- Horizontal offset of the floating window relative to the cursor position
    offset_y = 0,                           -- Vertical offset of the floating window relative to the cursor position
    floating_window_above_cur_line = false, -- Attempt to float the popup above the cursor position
    -- (note, if the height of the float would be greater than the space left above the cursor, it will default
    -- to placing the float below the cursor. The max_height option allows for finer tuning of this)
    silent = true, -- Prevents noisy notifications (make false to help debug why signature isn't working)
    -- Highlight options is null by default, but this just shows an example of how it can be used to modify the LspSignatureActiveParameter highlight property
    highlight = {
      italic = true,
      bold = true,
      fg = "#ffffff",
      ... -- Other options accepted by the `val` parameter of vim.api.nvim_set_hl()
    }
  },
  keymaps = {
    next_signature = "<C-n>",
    previous_signature = "<C-p>",
    next_parameter = "<C-l>",
    previous_parameter = "<C-h>",
    close_signature = "<A-s>"
  },
  display_automatically = true -- Uses trigger characters to automatically display the signature overloads when typing a method signature

}

local function general_on_attach(client, bufnr)
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

  if (client.server_capabilities.signatureHelpProvider) then
    require("lsp-overloads").setup(client, lsp_overloads_opts)
  end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.workspace = {
  didChangeWatchedFiles = {
    dynamicRegistration = true,
  }
}

return {
  general_client_opts = {
    on_attach = general_on_attach,
    capabilities = capabilities,
  },
  enabled_servers = enabled_servers,
}
