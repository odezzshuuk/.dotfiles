require("strudelPWA").setup({
  -- Strudel web user interface related options
  ui = {
    -- Maximise the menu panel
    -- (optional, default: true)
    maximise_menu_panel = true,
    -- Hide the Strudel menu panel (and handle)
    -- (optional, default: false)
    hide_menu_panel = false,
    -- Hide the default Strudel top bar (controls)
    -- (optional, default: false)
    hide_top_bar = false,
    -- Hide the Strudel code editor
    -- (optional, default: false)
    hide_code_editor = false,
    -- Hide the Strudel eval error display under the editor
    -- (optional, default: false)
    hide_error_display = false,
  },

  browser = {
    headless = false,
    user_data_dir = vim.fn.expand("~/.cache/strudelPWA-nvim"),
    browser_exec_path = "/opt/brave-bin/brave",
  },

  editor = {
    update_on_save = false,
    sync_cursor = true,
    update_on_attach = false,
  },
  -- Report evaluation errors from Strudel as Neovim notifications
  -- (optional, default: true)
  report_eval_errors = true,
})
