if vim.g.vscode then
  -- for vscode-neovim only
  require "vscode-neovim"
else
  -- require "plugins.lazynvim"
  -- require "config.plugins"
  -- require "config.options"
  -- require "config.keymaps"
  -- require "config.color-scheme"
  -- require "config.private"
  -- require "config.commands"
  -- require "config.auto-commands"
  -- require "config.lsp"

  require "auto-commands"
  require "add-plugins"
  require "plugins"
  require "keymaps"
  require "options"
  require "color-scheme"
  require "commands"
  require "lsp"

end

-- debug plugin inactivate
-- require "plugins.nvim-dap"
-- require "plugins.nvim-dap-ui"

