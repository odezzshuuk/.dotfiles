local lualine = require("lualine")
local palette = require("plugins.mini").palette

local show_in_width = function()
  return vim.fn.winwidth(0) > vim.api.nvim_get_option("columns") * 0.6
end

local git_hash_suffix = "%[([0-9a-fA-F]+)%]$"

local theme = {
  normal = {
    a = { fg = palette.blue_bg, bg = palette.blue },
    b = { fg = palette.fg_edge2, bg = palette.bg_mid },
    c = { fg = palette.fg_edge2, bg = palette.bg_edge },
    x = { fg = palette.fg_edge2, bg = palette.bg_edge },
    y = { fg = palette.fg_edge2, bg = palette.bg_edge },
    z = { fg = palette.fg_edge2, bg = palette.bg_edge },
  },
  insert = {
    a = { fg = palette.green_bg, bg = palette.green },
  },
  visual = {
    a = { fg = palette.purple_bg, bg = palette.purple },
  },
  command = {
    a = { fg = palette.red_bg, bg = palette.red },
  },
}

local diagnostics = {
  "diagnostics",
  separator = { right = "" },
  sources = { "nvim_lsp", "vim_lsp" },
  symbols = { error = " ", warn = " ", info = " " },
  sections = { "error", "warn", "info" },
  update_in_insert = false,
  always_visible = true,
  -- color = { fg = palette.fg_mid, bg = palette.bg_mid },
  diagnostics_color = {
    -- error = { fg = palette.red },
    -- warn = { fg = palette.yellow },
    -- info = { fg = palette.cyan },
    error = 'DiagnosticError', -- Changes diagnostics' error color.
    warn  = 'DiagnosticWarn',  -- Changes diagnostics' warn color.
    info  = 'DiagnosticInfo',  -- Changes diagnostics' info color.
    hint  = 'DiagnosticHint',  -- Changes diagnostics' hint color.
  },
  cond = function() return not vim.wo.diff end,
}

local diff = {
  "diff",
  colored = false,
  symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
  paddind = 0,
  cond = show_in_width,
}

-- section
local mode = {
  "mode",
  separator = { right = "" },
  fmt = function(str)
    return string.sub(str, 1, 3)
  end,
}

local filetype = {
  "filetype",
  cond = show_in_width,
  icons_enabled = true,
  icon = nil,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
  separator = { right = "" },
}

local location = {
  "location",
  cond = show_in_width,
}

local file_path = {
  function()
    local full_path = vim.fn.expand('%:p')
    local file_name = full_path:match("([^/\\]+)$")
    -- local _, _, dir_file = string.find(path, "([^/]+/[^/]+)$")
    if vim.wo.diff then
      return file_name
    end

    local workspace = vim.fn.getcwd()
    local function escape_pattern(pattern)
      return pattern:gsub('[%-%.%+%[%]%(%)%$%^%%%?%*]', '%%%1')  -- Escape magic characters
    end

    local escaped_workspace = escape_pattern(workspace)
    local file_path = string.gsub(full_path, escaped_workspace .. "/", "")

    return file_path
  end,

  -- color = { fg = "#11b849", gui = "bold" },
  color = function()
    local full_path = vim.fn.expand('%:p')

    if full_path:find('/%.git/') then -- git directory
      return { fg="#efefef", bg = '#4a0b6e' }
    elseif full_path:find(git_hash_suffix) then -- fzf commit history
      return { fg="#efefef", bg = '#005f87' }
    end

    return { fg = '#11b849', gui = "bold" }
  end,
  fmt = function(str)
    return str .. " "
  end,
}

local super_git_mark = {
  function()
    local full_path = vim.fn.expand('%:p')

    local commit_branch = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null"):read("*l")

    local commit_hash
    -- local is_from_git = io.popen("git rev-parse --is-inside-work-tree 2>/dev/null"):read("*l")
    local is_from_git = full_path:match("/%.git/") or full_path:match("/%.git$")

    if is_from_git then
      commit_hash = full_path:match('/%.git/([0-9a-fA-F]+)/')  -- Adapt DiffView
      if not commit_hash then
        commit_hash = "HEAD"
      end
    else
      commit_hash = full_path:match("^.-" .. git_hash_suffix)  -- Adapt Fzf file commits history
      if not commit_hash then
        return ""
      end
    end

    local commit_date = io.popen("git show -s --format=%ci " .. commit_hash .. " 2>/dev/null")
      :read("*l")
      :gsub("(%d%d%d%d%-%d%d%-%d%d) (%d%d:%d%d:%d%d) %S+", "%1T%2")

    return "[" .. commit_branch:gsub("\n", "") .. "][@" .. commit_hash:gsub("\n", "") .. "](" .. commit_date:gsub("\n", "") .. ")"
  end,
  color = { fg = palette.yellow },
  separator = { right = "" },
  cond = function() return vim.wo.diff end,
}

local workspace = {
  function()
    local workspace = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    return workspace
  end,
  icon = '',
  color = { fg = palette.yellow },
  padding = 0,
  cond = show_in_width,
}

-- local progress = function()
-- 	local current_line = vim.fn.line(".")
-- 	local total_lines = vim.fn.line("$")
-- 	local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
-- 	local line_ratio = current_line / total_lines
-- 	local index = math.ceil(line_ratio * #chars)
-- 	return chars[index]
-- end

local progress = {
  "progress",
  padding = 0,
  fmt = function(str)
    return " " .. str
  end
}


local function rgb_escaper(hex)
  local dec = tonumber(hex:sub(2), 16)
  local b = math.fmod(dec, 256)
  local g = math.fmod((dec - b) / 256, 256)
  local r = math.floor(dec / (256 * 256))

  return string.format("\27[38;2;%d;%d;%dm", r, g, b)
end

local color_reset = "\27[0m"

local copilot_indicator = {
  function()
    local client = vim.lsp.get_clients({ name = "GitHub Copilot" })[1]
    if client == nil then
      return ""
      -- return rgb_escaper(palette.red) .. "" .. color_reset
    end

    if vim.tbl_isempty(client.requests) then
      return "" -- default icon whilst copilot is idle
      -- return rgb_escaper(palette.cyan) .. "" .. color_reset
    end

    -- local spinners = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }
    -- local ms = vim.loop.hrtime() / 1000000
    -- local frame = math.floor(ms / 120) % #spinners

    return ""
    -- return rgb_escaper(palette.green) .. "" .. color_reset
    -- return spinners[frame + 1]
  end,

  cond = show_in_width,
  color = function()
    local client = vim.lsp.get_clients({ name = "GitHub Copilot" })[1]
    if client == nil then
      return { fg = palette.red }
    end

    if vim.tbl_isempty(client.requests) then
      return { fg = palette.blue }
    end

    return { fg = palette.green }
  end
}


local spaces = {
  function()
    return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
  end,
  cond = show_in_width,
}

local encoding = {
  "encoding",
  cond = show_in_width,
}

-- configuration
lualine.setup({
  options = {
    icons_enabled = true,
    -- theme = 'auto',
    theme = theme,
    component_separators = { left = "", right = "" },
    -- component = '|',
    section_separators = { left = "", right = "" },
    disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline" },
    always_divide_middle = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 500,
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    }
  },
  sections = {
    lualine_a = { mode },
    lualine_b = { diagnostics, super_git_mark },
    lualine_c = { file_path, workspace },
    -- lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_x = { diff, spaces, encoding, filetype, copilot_indicator },
    lualine_y = { location },
    lualine_z = { progress },
  },
  inactive_sections = {
    lualine_a = { mode },
    lualine_b = { super_git_mark },
    lualine_c = { file_path },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
})
