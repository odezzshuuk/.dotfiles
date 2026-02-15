-- require('onedark').setup({
--   style = 'darker',
--   diagnostics = {
--     darker = false,    -- darker colors for diagnostic
--     undercurl = true,  -- use undercurl instead of underline for diagnostics
--     background = true, -- use background color for virtual text
--   }
-- })
-- require('onedark').load()

require('ayu').setup({
  overrides = {
    -- Normal = { bg = "None" }
  }
})


vim.cmd('colorscheme ayu-dark')
local mini_palette = require('plugins.mini').palette
-- {
--   accent = "#E6B450",
--   bg = "#0B0E14",
--   black = "#000000",
--   comment = "#636A72",
--   constant = "#D2A6FF",
--   entity = "#59C2FF",
--   error = "#D95757",
--   fg = "#BFBDB6",
--   fg_idle = "#565B66",
--   func = "#FFB454",
--   -- generate = <function 1>,
--   guide_active = "#3C414A",
--   guide_normal = "#1E222A",
--   gutter_active = "#626975",
--   gutter_normal = "#454B55",
--   keyword = "#FF8F40",
--   line = "#11151C",
--   lsp_inlay_hint = "#969696",
--   lsp_parameter = "#CB9FF8",
--   markup = "#F07178",
--   operator = "#F29668",
--   panel_bg = "#0F131A",
--   panel_border = "#000000",
--   panel_shadow = "#05070A",
--   regexp = "#95E6CB",
--   selection_bg = "#1B3A5B",
--   selection_border = "#304357",
--   selection_inactive = "#122132",
--   special = "#E6B673",
--   string = "#AAD94C",
--   tag = "#39BAE6",
--   ui = "#565B66",
--   vcs_added = "#7FD962",
--   vcs_added_bg = "#1D2214",
--   vcs_modified = "#73B8FF",
--   vcs_removed = "#F26D78",
--   vcs_removed_bg = "#2D2220",
--   warning = "#FF8F40",
--   white = "#FFFFFF"
-- }
local ayu_palette = require('ayu.colors').generate()


local colors_overwrite = {
  Visual          = { bg = mini_palette.green, fg = mini_palette.bg_edge2 },
  LineNr          = { fg = "#626975" },
  WinSeparator    = { fg = "#73f8b1" },

  FloatBorder     = { fg = "#fda339", bg = mini_palette.bg_edge },
  NormalFloat     = { bg = mini_palette.bg_edge },

  DiagnosticError = { fg = "#eb403a" },
  DiffAdd    = { fg = nil, bg = mini_palette.green_bg },
  DiffChange = { fg = nil, bg = mini_palette.cyan_bg },
  DiffDelete = { fg = nil, bg = mini_palette.red_bg },
  DiffText   = { fg = nil, bg = mini_palette.yellow_bg },

  --lsp
  LspReferenceRead = { bg = "#2c2c0c" },
  LspReferenceText = { bg = "#2c2c0c" },

  --- FzfLua
  FzfLuaNormal                = { fg = mini_palette.fg_edge, bg = mini_palette.bg_edge2 },
  FzfLuaBorder                = { fg = mini_palette.fg_edge, bg = mini_palette.bg_edge2 },
  FzfLuaTitle                 = { fg = mini_palette.bg_edge2, bg = mini_palette.red },

  FzfLuaPreviewNormal         = { fg = mini_palette.fg_mid2, bg = mini_palette.bg_edge2 },
  FzfLuaPreviewTitle          = { fg = mini_palette.bg_edge2, bg = mini_palette.cyan },
  FzfLuaPreviewBorder         = { fg = mini_palette.bg_edge, bg = mini_palette.bg_edge2 },
  FzfLuaCursor                = { fg = mini_palette.bg_edge2, bg = mini_palette.orange },
  FzfLuaCursorLine            = { fg = mini_palette.bg_edge2, bg = mini_palette.green },

  --- WhichKey
  WhichKeyFloat               = { fg = mini_palette.bg_mid },

  --- hop
  HopNextKey                  = { fg = "#fa2f4e", bold = true, underline = true },

  --- gitsigns
  GitSignsAdd                 = { fg = "#00fd3f" },
  GitSignsChange              = { fg = "#fdea00" },
  GitSignsDelete              = { fg = "#eb403a" },
  GitSignsStagedAdd           = { fg = "#00fd3f" },
  GitSignsStagedChange        = { fg = "#fdea00" },
  GitSignsStagedDelete        = { fg = "#eb403a" },
  GitSignsStagedUntracked     = { fg = "#00fd3f" },
  GitSignsStagedChangeddelete = { fg = "#fdea00" },
  GitSignsStagedTopdelete     = { fg = "#eb403a" },

  --- indent line ---
  IblScope                    = { fg = "#f1611c" },
  IblNonIndent                = { fg = mini_palette.bg },
  IblIndent                   = { fg = "#444c5e" }
}

-- vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = palette.bg_mid })

for hl, col in pairs(colors_overwrite) do
  vim.api.nvim_set_hl(0, hl, col)
end
