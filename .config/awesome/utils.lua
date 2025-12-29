local M = {}

M.icons = {

  Alacritty = "",
  kitty = "",
  kitty_quick_access = "",

  google_chrome = "",
  firefox = "",
  ["Brave-browser"] = "",
  slack = "",
  Code = "",

  jetbrains_idea_ce = "",
  default = "",
  simplenote = "",
  dbeaver = "",
  trello_desktop = "",
  postman = "",
  install4j_com_kafkatool_ui_mainapp = "󱀏",
  sublime_text = "",
  joplin = "󰚹",
  gpclient = "󰖂",
  thunar = "",
}

M.color_text = function(text, foreground_color)
  return '<span foreground="' .. foreground_color .. '">' .. text .. "</span>"
end

return M
