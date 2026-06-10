local vscode = require('vscode')
local opts = { noremap = true, silent = true }

local function find_files()
    vscode.action("workbench.action.quickOpen")
end

local function show_vscode_command()
    vscode.action("workbench.action.showCommands")
end

local function toggle_explorer()
    vscode.action("workbench.action.toggleSidebarVisibility")
end

local function operation_in_split()
end

vim.keymap.set('n', "<leader>f", find_files, opts)
vim.keymap.set('n', ":", show_vscode_command, opts)
vim.keymap.set('n', "<leader>e", toggle_explorer, opts)
