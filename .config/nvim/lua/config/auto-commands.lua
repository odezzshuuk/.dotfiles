-- Auto commands
local line_numbers_group_id = vim.api.nvim_create_augroup("LineNumbers", { clear = true })
vim.api.nvim_create_autocmd(
  { "FocusGained", "InsertLeave", "CmdlineLeave", "BufEnter" },
  {
    group = line_numbers_group_id,
    pattern = "*",
    callback = function()
      if vim.bo.buftype ~= '' and vim.bo.buftype ~='help' then return end
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
      if vim.bo.buftype ~= '' and vim.bo.buftype ~='help' then return end
      vim.opt.relativenumber = false
      vim.opt.number = true
      if e.event == "CmdlineEnter" then
        vim.cmd("redraw")
      end
    end,
  }
)

local no_auto_comment_group_id = vim.api.nvim_create_augroup("NoAutoComment", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = no_auto_comment_group_id,
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions = vim.opt_local.formatoptions:remove { "c", "r", "o" }
  end,
})

