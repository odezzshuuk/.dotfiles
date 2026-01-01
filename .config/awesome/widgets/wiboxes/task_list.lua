local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local client = client

local M = {}

local tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    if c == client.focus then
      c.minimized = true
    else
      c:emit_signal("request::activate", "tasklist", {
        raise = true,
      })
    end
  end),
  awful.button({}, 3, function()
    local instance = nil

    return function()
      if instance and instance.wibox.visible then
        instance:hide()
        instance = nil
      else
        instance = awful.menu.clients({
          theme = {
            width = 250,
          },
        })
      end
    end
  end),
  awful.button({}, 4, function()
    awful.client.focus.byidx(1)
  end),
  awful.button({}, 5, function()
    awful.client.focus.byidx(-1)
  end)
)

function M.setup(s)
  return awful.widget.tasklist({
    screen = s,
    filter = awful.widget.tasklist.filter.currenttags,
    buttons = tasklist_buttons,
    style = {
      border_width = 1,
      border_color = "#777777",
      shape = gears.shape.rounded_bar,
    },
    layout = {
      spacing = 10,
      spacing_widget = {
        {
          forced_width = 5,
          shape = gears.shape.circle,
          widget = wibox.widget.separator,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place,
      },
      layout = wibox.layout.flex.horizontal,
    },
    -- Notice that there is *NO* wibox.wibox prefix, it is a template,
    -- not a widget instance.
    widget_template = {
      {
        {
          {
            {
              id = "icon_role",
              widget = wibox.widget.imagebox,
            },
            margins = 2,
            widget = wibox.container.margin,
          },
          {
            id = "text_role",
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.horizontal,
        },
        left = 10,
        right = 10,
        widget = wibox.container.margin,
      },
      id = "background_role",
      widget = wibox.container.background,
    },
  })
end

return M
