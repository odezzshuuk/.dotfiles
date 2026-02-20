vim.opt.shiftwidth      = 2
-- vim.opt.softtabstop  = 4
vim.opt.tabstop         = 2 -- default tab size, can be override by .editorconfig
vim.opt.expandtab       = true
vim.opt.smarttab        = true
vim.opt.number          = true
vim.opt.cursorline      = true
vim.opt.numberwidth     = 4
vim.opt.hlsearch        = true
vim.opt.ignorecase      = true
vim.opt.smartcase       = true
vim.opt.smartindent     = true
vim.opt.breakindent     = true
vim.opt.autoindent      = true
vim.opt.showmode        = false
vim.opt.backup          = false
vim.opt.showtabline     = 2
vim.opt.swapfile        = false
vim.opt.signcolumn      = "yes"
vim.opt.scrolloff       = 8
vim.opt.pumheight       = 10
vim.opt.autowriteall    = true
vim.opt.termguicolors   = true
vim.opt.relativenumber  = true
vim.opt.mouse           = ""
vim.opt.splitbelow      = true
vim.opt.splitright      = true
vim.opt.showtabline     = 0
vim.opt.timeoutlen      = 500
vim.opt.list            = false
vim.opt.listchars       = {
  tab                   = "▸ ",
  trail                 = "·",
}
vim.opt.fillchars       = { eob = " " }
vim.opt.diffopt         = vim.opt.diffopt + "vertical"
vim.opt.completeopt     = "menu,menuone,noselect"
vim.opt.foldmethod      = "syntax"
vim.opt.foldlevel       = 99
vim.opt.numberwidth     = 4
vim.opt.spelllang       = "en_us"
vim.opt.clipboard       = "unnamedplus"
-- vim.opt.spell           = true
-- vim.opt.spellfile       = vim.fn.getcwd() .. '/en.utf-8.add'

-- Undercurl(not work on alacritty)
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])
vim.filetype.add({
  extension = {
    uss = 'css',
    uxml = 'html'
  }
})

