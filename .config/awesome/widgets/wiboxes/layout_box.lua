local customize = require("customize")
local gears = require("gears")
local awful = require("awful")
local M = {}

function M.setup(s)
  -- local widget = customize.widget.layoutbox(s)
  local widget = awful.widget.layoutbox(s)
  widget:buttons(gears.table.join(
    awful.button({}, 1, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 3, function()
      awful.layout.inc(-1)
    end),
    awful.button({}, 4, function()
      awful.layout.inc(1)
    end),
    awful.button({}, 5, function()
      awful.layout.inc(-1)
    end)
  ))
  return widget
end

return M
