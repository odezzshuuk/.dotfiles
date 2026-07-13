
return function()

  local file_name = vim.fn.expand('%:t')

  local file_path = vim.api.nvim_buf_get_name(0)
  local relative_path = vim.fn.expand('%:.:p')

  local filetype = vim.fn.fnamemodify(file_path, ':e')
  local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
  local encoding = vim.api.nvim_get_option_value("fileencoding", { buf = 0 })

  local file_size = vim.fn.getfsize(file_path)
  local file_size_kb = math.ceil(file_size / 1024)

  local message = "\n" ..
    "File Name: " .. file_name .. "\n" ..
    "Relative Path: " .. relative_path .. "\n" ..
    "File Path: " .. file_path .. "\n" ..
    "File Type: " .. filetype .. "\n" ..
    "Shift Width: " .. shiftwidth .. "\n" ..
    "Encoding: " .. encoding .. "\n" ..
    "File Size: " .. file_size_kb .. "KB"

  local id = require('mini.notify').add(message, "WARN", "Data")

  vim.api.nvim_create_autocmd(
    { "CursorMoved" },
    {
      buffer = 0,
      once = true,
      callback = function()
        require('mini.notify').remove(id)
      end
    }
  )

end
