local nvim_treesitter = require("nvim-treesitter")

vim.api.nvim_create_autocmd("FileType", {
  pattern = nvim_treesitter.get_available(),
  callback = function()
    if not vim.tbl_contains(nvim_treesitter.get_installed(), vim.bo.filetype) then
      nvim_treesitter.install({ vim.bo.filetype })
    else
      vim.treesitter.start()
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo.foldmethod = 'expr'
      -- indentation, provided by nvim-treesitter
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end
})

nvim_treesitter.setup()
nvim_treesitter.install({
  "bash",
  "c_sharp",
  "css",
  "html",
  "javascript",
  "json",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "rust",
  "typescript",
  "yaml",
})

-- context fold
require("treesitter-context").setup({
  enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
  max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
  min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
  line_numbers = true,
  multiline_threshold = 20, -- Maximum number of lines to show for a single context
  trim_scope = "outer",     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
  mode = "cursor",          -- Line used to calculate context. Choices: 'cursor', 'topline'
  -- Separator between context and content. Should be a single character string, like '-'.
  -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
  separator = nil,
  zindex = 20,     -- The Z-index of the context window
  on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
})
require("ts_context_commentstring").setup({})

vim.g.skip_ts_context_commentstring_module = true
