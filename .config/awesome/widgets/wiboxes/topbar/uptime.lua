local customize = require("customize")
local beautiful = require("beautiful")
local markup  = require("lain.util").markup

local uptime_widget_customize = customize.widget.uptime({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, " " .. result))
    end
})

return uptime_widget_customize.widget

