local highlight = {
	"IblIndent",
	"IblIndent",
	"IblIndent",
	"IblIndent",
	"IblIndent",
	"IblIndent",
	"IblIndent",
	"IblIndent",
	"IblIndent",
	"IblIndent",
}
-- local hooks = require "ibl.hooks"
-- hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
-- 	vim.api.nvim_set_hl(0, "IblNonIndent", { fg = palette.bg })
-- 	vim.api.nvim_set_hl(0, "IblIndent",    { fg = "#444c5e" })
-- end)

require("ibl").overwrite({
	indent = { highlight = highlight },
	whitespace = {
		remove_blankline_trail = false,
	},
	scope = {
    enabled = true,
    show_start = false,
    show_end = false,
    include = {
      node_type = {
        c_sharp = { "class_declaration" },
      }
    }
  },
	exclude = {
		buftypes = { "terminal" },
		filetypes = {
			"help",
			"dashboard",
			"dashpreview",
			"NvimTree",
			"neo-tree",
			"vista",
			"sagahover",
			"sagasignature",
			"packer",
			"lazy",
			"mason",
			"log",
			"lspsagafinder",
			"lspinfo",
			"dapui_scopes",
			"dapui_breakpoints",
			"dapui_stacks",
			"dapui_watches",
			"dap-repl",
			"toggleterm",
			"alpha",
			"coc-explorer",
		},
	}
})

