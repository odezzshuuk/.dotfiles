local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")
local client_keys = require("keybindings.client_keys")
local mouse_keys = require("keybindings.mouse_bindings")

awful.rules.rules = {
  {
    rule = {},
    properties = {
        border_width = beautiful.border_width,
        border_color = beautiful.border_normal,
        focus = awful.client.focus.filter,
        raise = true,
        keys = client_keys,
        buttons = mouse_keys,
        screen = awful.screen.preferred,
        placement = awful.placement.no_overlap + awful.placement.no_offscreen,
        --size_hints_honor = false,
    }
  }
}
