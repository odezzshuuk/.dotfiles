local fzf_lua = require('fzf-lua')
local gitsigns = require('gitsigns')
local hop = require("hop")
local mini_comment = require("mini.comment")

local diagnostic_goto_opts = require('utils').diagnostic_goto_opts
local toggle_inlay_hints = require('utils').toggle_inlay_hints
local operation_in_split = require('utils').operation_in_split
local toggle_diagnostic_virtual_text = require("utils").toggle_diagnostic_virtual_text
local fzf_lua_opts = require('plugins.fzf-lua').opts

local toggle_mini_files = require("plugins.mini").toggle_mini_files
local borders = require('utils').listed_borders

local opts_desc = function(desc) if desc then
    return { noremap = true, silent = true, desc = desc }
  end
  return { noremap = true, silent = true }
end

local toggle_current_line_or_with_count = function()
  return vim.v.count == 0
      and '<Plug>(comment_toggle_linewise_current)'
      or '<Plug>(comment_toggle_linewise_count)'
end

--Remap space as leader key
vim.keymap.set("", "<Space>", "<Nop>", opts_desc())
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i", visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Window Navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts_desc())
-- keymap("n", "<C-j>", "<C-w>j", opts_desc())
-- keymap("n", "<C-k>", "<C-w>k", opts_desc())
vim.keymap.set("n", "<C-l>", "<C-w>l", opts_desc())
vim.keymap.set('n', '<C-j>', '10j', opts_desc())
vim.keymap.set('n', '<C-k>', '10k', opts_desc())

-- Window Resize
vim.keymap.set("n", "<C-Up>", ":resize +2<CR>", opts_desc())
vim.keymap.set("n", "<C-Down>", ":resize -2<CR>", opts_desc())
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts_desc())
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts_desc())
vim.keymap.set("n", "<c-w>z", ":vertical resize | windcmd =<CR>", opts_desc("Maximize window width"))

vim.keymap.set("n", "^", 'v%<C-v>', opts_desc()) -- vertical select by match bracket/parentheses/braces
vim.keymap.set("n", "ge", "gi", opts_desc())

-- Visual --
vim.keymap.set('v', '<C-j>', '10j', opts_desc())
vim.keymap.set('v', '<C-k>', '10k', opts_desc())

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", opts_desc())
vim.keymap.set("v", ">", ">gv", opts_desc())
vim.keymap.set("v", "<D-c>", '"+y', opts_desc())

-- Visual Block --
-- Move text up and down
vim.keymap.set("x", "J", ":move '>+1<CR>gv-gv", opts_desc())
vim.keymap.set("x", "K", ":move '<-2<CR>gv-gv", opts_desc())
vim.keymap.set("x", "<A-j>", ":move '>+1<CR>gv-gv", opts_desc())
vim.keymap.set("x", "<A-k>", ":move '<-2<CR>gv-gv", opts_desc())

vim.keymap.set({ "n", "v", "i" }, "<Del>", "<Nop>", opts_desc()) -- disable <Del> key
-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

-- leader key essential keymaps
vim.keymap.set("n", "<leader>e", toggle_mini_files, opts_desc("Files Explorer"))
vim.keymap.set('n', "<leader>f", fzf_lua.files, opts_desc("Find Files"))
vim.keymap.set('n', "<leader>b", fzf_lua.buffers, opts_desc("Buffers"))
vim.keymap.set('n', "<leader>a", "<cmd>SymbolsOutline<cr>", opts_desc("File Outline"))
vim.keymap.set('n', '<leader>F', function() fzf_lua.live_grep(fzf_lua_opts.live_grep) end, { nowait = true, noremap = true, desc = 'Find Text' })
-- vim.keymap.set('n', "<leader>/", mini_comment.toggle_lines, opts_desc("Comment"))

-- Lsp ---------------------
vim.keymap.set('n', 'gd', fzf_lua.lsp_definitions, opts_desc("Go To Definition"))
vim.keymap.set('n', 'gr', function() fzf_lua.lsp_references(fzf_lua_opts.lsp.references) end, opts_desc("Go To Reference"))
vim.keymap.set('n', 'gh', function() vim.lsp.buf.hover({ border = borders[1] }) end, opts_desc("Hover"))
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts_desc("Declaration"))
vim.keymap.set('n', 'gi', function() fzf_lua.lsp_implementations(fzf_lua_opts.lsp.reference) end, opts_desc("Go To Implementation"))

vim.keymap.set('n', 'gvd',
  function() operation_in_split(fzf_lua.lsp_definitions) end,
  opts_desc("Goto definition in split")
)
vim.keymap.set('n', 'gvr',
  function() operation_in_split(require('plugins.fzf-lua').fzf_lua_references_with_opts) end,
  opts_desc("Goto reference in split")
)
vim.keymap.set('n', 'gl', function() vim.diagnostic.open_float() end, opts_desc())
vim.keymap.set('n', 'gs', function() require('fzf-lua').lsp_live_workspace_symbols() end,
  opts_desc("Workspace Symbols"))
vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format() end, opts_desc('Format'))
vim.keymap.set('n', '<leader>lj', function() vim.diagnostic.jump(diagnostic_goto_opts(1)) end,
  opts_desc("Next Diagnostic"))
vim.keymap.set('n', '<leader>lk', function() vim.diagnostic.jump(diagnostic_goto_opts(-1)) end,
  opts_desc("Prev Disgnostic"))
vim.keymap.set('n', '<leader>ld', function() require('fzf-lua').lsp_document_diagnostics() end,
  opts_desc("Document Diagnostics"))
vim.keymap.set('n', '<leader>la', function() require('fzf-lua').lsp_code_actions() end, opts_desc("Code Actions"))
vim.keymap.set('n', '<leader>lD', toggle_diagnostic_virtual_text,
  { noremap = true, silent = true, desc = "Toggle disgnostic virtual text" })
vim.keymap.set('n', '<leader>lw', function() require('fzf-lua').diagnostics_workspace() end,
  opts_desc("Workspace Diagnostics"))
vim.keymap.set('n', "<leader>lr", vim.lsp.buf.rename, opts_desc("Rename"))
vim.keymap.set('n', "<leader>lq", "<cmd>FzfLua lsp_document_symbols<cr>", opts_desc("Document Symbols"))
vim.keymap.set('n', "<leader>ls", "<cmd>FzfLua lsp_live_workspace_symbols<cr>", opts_desc("Workspace Symbols"))
vim.keymap.set('n', "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", opts_desc("CodeLens Action"))
vim.keymap.set('n', '<leader>lh', toggle_inlay_hints, opts_desc("Toggle Inlay Hints"))

-- VCS ------------------
vim.keymap.set('n', '<leader>vb', fzf_lua.git_branches, opts_desc("Git Branchs"))
vim.keymap.set('n', '<leader>vc', fzf_lua.git_commits, opts_desc("Git Commits"))
vim.keymap.set('n', '<leader>vC', fzf_lua.git_bcommits, opts_desc("Git Buffer Commits"))
vim.keymap.set('n', '<leader>vh', fzf_lua.git_hunks, opts_desc("Git Hunks"))
vim.keymap.set('n', '<leader>vf', fzf_lua.git_status, opts_desc("Changed File"))

vim.keymap.set('n', '<leader>vR', gitsigns.reset_buffer, opts_desc("Reset Buffer"))
vim.keymap.set('n', '<leader>vd', gitsigns.diffthis, opts_desc("Diff"))
vim.keymap.set('n', '<leader>vD', function() gitsigns.diffthis('~') end, opts_desc("Diff with HEAD"))
vim.keymap.set('n', ']c', gitsigns.next_hunk, opts_desc('Next Hunk'))
vim.keymap.set('n', '[c', gitsigns.prev_hunk, opts_desc('Prev Hunk'))
vim.keymap.set('n', '<leader>vl', gitsigns.blame_line, opts_desc("Blame"))
vim.keymap.set('n', '<leader>vL', gitsigns.toggle_current_line_blame, opts_desc("Toggle Current Line Blame"))
vim.keymap.set('n', '<leader>vi', gitsigns.preview_hunk_inline, opts_desc("Preview Hunk Inline"))
-- vim.keymap.set('n', '<leader>vI', mini_diff.toggle_overlay, opts_desc("Toggle Preview Diff Overlay"))
vim.keymap.set('n', '<leader>vp', gitsigns.preview_hunk, opts_desc("Preview Hunk"))
vim.keymap.set('n', '<leader>vr', gitsigns.reset_hunk, opts_desc("Reset Hunk"))
vim.keymap.set('n', '<leader>vs', gitsigns.stage_hunk, opts_desc("Toggle Hunk Stage"))
vim.keymap.set('n', '<leader>vS', gitsigns.stage_buffer, opts_desc("Toggle Buffer Stage"))
-- vim.keymap.set('n', '<leader>vu', gitsigns.undo_stage_hunk, opts_desc("Undo Stage Hunk"))

-- Searching -----------
vim.keymap.set('n', "<leader>sj", "<cmd>FzfLua jumps<cr>", opts_desc("Jump List"))
vim.keymap.set('n', "<leader>sC", "<cmd>FzfLua commands<cr>", opts_desc("Commands"))
vim.keymap.set('n', "<leader>sM", "<cmd>FzfLua man_pages<cr>", opts_desc("Man Pages"))
vim.keymap.set('n', "<leader>sR", "<cmd>FzfLua registers<cr>", opts_desc("Registers"))
vim.keymap.set('n', "<leader>sc", "<cmd>FzfLua colorschemes<cr>", opts_desc("Colorscheme"))
vim.keymap.set('n', "<leader>sh", "<cmd>FzfLua helptags<cr>", opts_desc("Find Help"))
vim.keymap.set('n', "<leader>sk", "<cmd>FzfLua keymaps<cr>", opts_desc("Keymaps"))
vim.keymap.set('n', "<leader>sr", "<cmd>FzfLua oldfiles<cr>", opts_desc("Open Recent File"))

-- hop -------
---@diagnostic disable: missing-parameter
vim.keymap.set("n", "s", function() hop.hint_char2() end, { remap = true })

-- comment -----------

vim.keymap.del('n', 'grn')
vim.keymap.del('n', 'gra')
vim.keymap.del('n', 'grr')
vim.keymap.del('n', 'gri')
vim.keymap.del('n', 'gO')
vim.keymap.del('n', 'grt')
