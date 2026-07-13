-- Commands
local diff_clipboard = require('funcset.diff_clipboard')
local notify_file_detail_info = require('funcset.notify_file_detail_info')

vim.api.nvim_create_user_command('DiffClipboard', diff_clipboard, {})
vim.api.nvim_create_user_command("FileDetail", notify_file_detail_info, {})
vim.api.nvim_create_user_command("RemoveInactivePlugins", function()
  vim.pack.del(vim.iter(vim.pack.get()):filter(function(x) return not x.active end) :map(function(x) return x.spec.name end):totable())
end, {})

vim.api.nvim_create_user_command("BufferAbsolutePath", function()
  local full_path = vim.fn.expand('%:p')
  vim.fn.setreg('+', full_path)
  print(full_path)
end, {desc = "Copy the full path of the current buffer to the clipboard"})

vim.api.nvim_create_user_command("BufferWorkspacePath", function()
  local workspace_path = vim.fn.expand('%:.:p')
  vim.fn.setreg('+', workspace_path)
  print(workspace_path)
end, {desc = "Copy the workspace path of the current buffer to the clipboard"})
