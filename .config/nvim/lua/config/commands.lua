-- Commands
local function diff_clipboard()

  local clipboard_content = vim.fn.getreg('+')

  local buf_clip = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value('buftype', 'nofile', { buf = buf_clip })
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf_clip })
  vim.api.nvim_buf_set_name(buf_clip, '[Clipboard]')
  local lines = vim.split(clipboard_content, '\n', { plain = true, trimempty = false })
  vim.api.nvim_buf_set_lines(buf_clip, 0, -1, false, lines)

  vim.cmd('only')
  vim.cmd('vsplit')
  vim.api.nvim_set_current_buf(buf_clip)

  vim.cmd('windo diffthis')
  vim.cmd('wincmd p')
end
vim.api.nvim_create_user_command('DiffClipboard', diff_clipboard, {})
