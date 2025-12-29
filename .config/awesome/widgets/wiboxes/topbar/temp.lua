local customize = require("customize")
local awful = require("awful")
local beautiful = require("beautiful")
local markup  = require("lain.util").markup

local temp_customize = customize.widget.temp({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, " " .. result .. "°C "))
    end
})

temp_customize.widget:buttons(awful.util.table.join(awful.button({}, 1, function()
    awful.spawn.with_shell("~/scripts/powersave.sh")
end), awful.button({}, 3, function()
    awful.spawn.with_shell("~/scripts/performance.sh")
end)))

return temp_customize.widget
