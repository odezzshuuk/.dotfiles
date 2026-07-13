return function()
  local current_tab = vim.api.nvim_get_current_tabpage()
  local wins = vim.api.nvim_tabpage_list_wins(current_tab)
  local normal_wins = {}

  for _, win_id in ipairs(wins) do
    if vim.api.nvim_win_is_valid(win_id) and is_normal_window(win_id) then
      table.insert(normal_wins, win_id)
    end
  end

  if #normal_wins <= 1 then
    return
  end

  local maximized = false;

  if vim.fn.winwidth(0) < vim.api.nvim_get_option_value("columns", {}) * 0.95 then
    vim.cmd('wincmd |')
    maximized = true
  end

  if vim.fn.winheight(0) < vim.api.nvim_get_option_value("lines", {}) * 0.95 then
    vim.cmd('wincmd _')
    maximized = true
  end

  if not maximized then
    vim.cmd('wincmd =')
  end
end
