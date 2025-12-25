local awful = require("awful")
local gears = require("gears")

return gears.table.join(
  awful.button(
    {},
    1,
    function(c)
      c:emit_signal(
        "request::activate",
        "mouse_click",
        {
          raise = true
        }
      )
    end
  ),
  awful.button(
    { modkey },
    1,
    function(c)
      c:emit_signal(
        "request::activate",
        "mouse_click",
        {
          raise = true
        }
      )
      awful.mouse.client.move(c)
    end
  ),

  -- Middle click key
  -- awful.button(
  --   { modkey },
  --   2,
  --   function(c)
  --     c:emit_signal(
  --       "request::activate",
  --       "mouse_click",
  --       {
  --         raise = true
  --       }
  --     )
  --     awful.mouse.client.resize(c)
  --   end
  -- ),

  -- right click key
  awful.button(
    { modkey },
    3,
    function(c)
      c:emit_signal(
        "request::activate",
        "mouse_click",
        {
          raise = true
        }
      )
      awful.mouse.client.resize(c)
    end
  )

  -- scroll up
  -- awful.button({}, 4, awful.tag.viewnext),
  -- scroll down
  -- awful.button({}, 5, awful.tag.viewprev)
)
