local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local utils = require("utils")

local index_role_id = "index_role"

local M = {}

local tag_list_buttons = gears.table.join(

  awful.button({}, 1, function(t)
    t:view_only()
  end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({}, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({}, 4, function(t)
    awful.tag.viewnext(t.screen)
  end),
  awful.button({}, 5, function(t)
    awful.tag.viewprev(t.screen)
  end)
)

function M.setup(screen)
  local s = screen or awful.screen.focused()

  return awful.widget.taglist({
    screen = s,
    filter = awful.widget.taglist.filter.noempty,
    layout = wibox.layout.fixed.horizontal,
    widget_template = {
      {
        {
          {

            {
              id = index_role_id,
              widget = wibox.widget.textbox,
            },
            margins = 4,
            widget = wibox.container.margin,
          },
          left = 5,
          right = 5,
          widget = wibox.container.margin,
        },
        id = "inner_shape_role",
        shape = function(cr, width, height)
          gears.shape.partially_rounded_rect(cr, width, height, true, true, false, false, 15)
          -- Parameters: cr, width, height, tl, tr, br, bl, radius
        end,
        widget = wibox.container.background,
      },
      id = "unthemed_background_role",
      widget = wibox.container.background,

      -- layout = wibox.layout.fixed.horizontal,
      create_callback = function(self, tag, _, _)

        local index_role_textbox = self:get_children_by_id(index_role_id)[1]
        local inner_shape = self:get_children_by_id("inner_shape_role")[1]
        local master_task_icon = utils.icons.default

        local update_tag_info_and_style = function(task_icon, tag_color, inner_bg)
          if #tag:clients() == 0 then
            return
          end

          local tag_text = "<b>" .. tostring(tag.index) .. "</b> ".. task_icon .. " "
          index_role_textbox.markup = utils.color_text(tag_text, tag_color)
          inner_shape.bg = inner_bg
        end

        local refresh_tag = function()
          if not tag.selected then
            update_tag_info_and_style(master_task_icon, beautiful.fg_normal, "#3c3c3c")
          else
            local master_client = awful.client.getmaster()

            if utils.icons[master_client.class] then
              master_task_icon = utils.icons[master_client.class]
            end
            update_tag_info_and_style(master_task_icon, beautiful.taglist_fg_focus , beautiful.taglist_bg_focus)
          end
        end

        refresh_tag()

        -- tag reactive
        local signal_handler = function()
          refresh_tag()
        end

        client.connect_signal("list", signal_handler )
        tag:connect_signal("property::selected", signal_handler )
        tag:connect_signal("tagged", signal_handler )
        tag:connect_signal("untagged", signal_handler )
      end,
      update_callback = function(self, tag, _, _)

      end,
    },
    buttons = tag_list_buttons,
  })
end

return M
