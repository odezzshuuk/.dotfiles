-- Auto commands
local line_numbers_group_id = vim.api.nvim_create_augroup("LineNumbers", { clear = true })
vim.api.nvim_create_autocmd(
  { "FocusGained", "InsertLeave", "CmdlineLeave", "BufEnter" },
  {
    group = line_numbers_group_id,
    pattern = "*",
    callback = function()
      if vim.bo.buftype ~= '' and vim.bo.buftype ~= 'help' then return end
      vim.opt.relativenumber = true
    end,
  }
)

vim.api.nvim_create_autocmd(
  { "FocusLost", "InsertEnter", "CmdlineEnter" },
  {
    group = line_numbers_group_id,
    pattern = "*",
    callback = function(e)
      if vim.bo.buftype ~= '' and vim.bo.buftype ~= 'help' then return end
      vim.opt.relativenumber = false
      vim.opt.number = true
      if e.event == "CmdlineEnter" then
        vim.cmd("redraw")
      end
    end,
  }
)

--- Disable auto comment on new line
local no_auto_comment_group_id = vim.api.nvim_create_augroup("NoAutoComment", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = no_auto_comment_group_id,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions = vim.opt_local.formatoptions:remove { "c", "r", "o" }
  end,
})

--- when window minimized, lose focus
--- impossible to implement, "focusable" is not supported property for widow
-- vim.api.nvim_create_autocmd("WinResized", {
--   pattern = "*",
--   callback = function()
--     local resized_windows = vim.v.event.windows or {}
--     local current_win = vim.api.nvim_get_current_win()
--     local MIN_WIDTH = 10
--     local MIN_HEIGHT = 5
--
--     for _, win in ipairs(resized_windows) do
--       -- Only act if the resized window is the one currently focused
--       if win == current_win and vim.api.nvim_win_is_valid(win) then
--         local width = vim.api.nvim_win_get_width(win)
--         local height = vim.api.nvim_win_get_height(win)
--
--       end
--     end
--   end,
-- })
