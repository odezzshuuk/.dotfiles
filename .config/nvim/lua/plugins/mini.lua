local mini_files = require("mini.files")
local mini_hues = require("mini.hues")
local hipatterns = require("mini.hipatterns")

--- mini.nvim config
--- config information leverage mini.nvim
local M = {}

local mini_align_config = {
  -- No need to copy this inside `setup()`. Will be used automatically.
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    start = "ga",              -- abc
    start_with_preview = "gA", -- abc
  },

  -- Default options controlling alignment process
  options = {
    split_pattern = "",
    justify_side = "left",
    merge_delimiter = "",
  },

  -- Default steps performing alignment (if `nil`, default is used)
  steps = {
    pre_split = {},
    split = nil,
    pre_justify = {},
    justify = nil,
    pre_merge = {},
    merge = nil,
  },

  -- Whether to disable showing non-error feedback
  silent = false,
}

-- mini.comment config
local mini_comment_config = {
  options = {
    custom_commentstring = function()
      return require('ts_context_commentstring.internal').calculate_commentstring() or vim.bo.commentstring
    end
  }
}


-- mini.hues config
local mini_hues_config = {
  background = "#1d1a1f",
  foreground = "#efe9dc",
  -- foreground = "#1d242f",
  -- background = "#efe9dc",
  n_hues     = 8,
  saturation = 'high',
  accent     = 'bg',
}

-- mini.hlpatterns config
local hipatterns_config = {
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
}

local mini_files_opts = {
  -- Customization of shown content
  content = {
    -- Predicate for which file system entries to show
    filter = nil,
    -- What prefix to show to the left of file system entry
    prefix = nil,
    -- In which order to show file system entries
    sort = nil,
  },

  -- Module mappings created only inside explorer.
  -- Use `''` (empty string) to not create one.
  mappings = {
    close       = '<ESC>',
    go_in       = 'l',
    go_in_plus  = 'L',
    go_out      = 'h',
    go_out_plus = 'H',
    mark_goto   = "'",
    mark_set    = 'm',
    reset       = '<BS>',
    -- reveal_cwd  = '<leader>e',
    show_help   = 'g?',
    synchronize = '<CR>',
    trim_left   = '<',
    trim_right  = '>',
  },

  -- General options
  options = {
    -- Whether to delete permanently or move into module-specific trash
    permanent_delete = false,
    -- Whether to use for editing directories
    use_as_default_explorer = true,
  },

  -- Customization of explorer windows
  windows = {
    -- Maximum number of windows to show side by side
    max_number = math.huge,
    -- Whether to show preview of file/directory under cursor
    preview = true,
    -- Width of focused window
    width_focus = 50,
    -- Width of non-focused window
    width_nofocus = 15,
    -- Width of preview window
    width_preview = 25,
  },
}

-- mini.diff config
local mini_diff_config = {
  -- clear default mappings
  mappings = {
    apply = '',
    reset = '',
    textobject = '',
    goto_first = '',
    goto_prev = '',
    goto_next = '',
    goto_last = '',
  },
}

-- setup
require("mini.align").setup(mini_align_config)
require("mini.comment").setup(mini_comment_config)
-- mini_hues.setup(mini_hues_config)
mini_files.setup(mini_files_opts)
hipatterns.setup(hipatterns_config)

M.toggle_mini_files = function()
  if mini_files.close() then
    return;
  end
  if vim.bo.buftype ~= '' then return end
  mini_files.open(vim.api.nvim_buf_get_name(0), false)
  mini_files.reveal_cwd()
end

-- {
--   accent = "#e7b7ff",
--   accent_bg = "#1d1a1f",
--   azure = "#94d0ff",
--   azure_bg = "#004c79",
--   bg = "#1d1a1f",
--   bg_edge = "#131015",
--   bg_edge2 = "#070508",
--   bg_mid = "#3d393f",
--   bg_mid2 = "#5d5a60",
--   blue = "#bfb6ff",
--   blue_bg = "#260061",
--   cyan = "#84faff",
--   cyan_bg = "#01787c",
--   fg = "#efe9dc",
--   fg_edge = "#f6f0e3",
--   fg_edge2 = "#fef7ea",
--   fg_mid = "#cac4b7",
--   fg_mid2 = "#a49f93",
--   green = "#9bffbe",
--   green_bg = "#006133",
--   orange = "#ffc790",
--   orange_bg = "#754300",
--   purple = "#ffb8f7",
--   purple_bg = "#510048",
--   red = "#ffadae",
--   red_bg = "#610015",
--   yellow = "#f2f266",
--   yellow_bg = "#636200"
-- }

M.palette = mini_hues.make_palette(mini_hues_config)


return M
