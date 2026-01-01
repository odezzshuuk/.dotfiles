local customize = require("customize")
local markup  = require("lain.util").markup
local beautiful = require("beautiful")

local mygpu = customize.widget.nvidia({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, " " .. gpu.usage .. " " .. gpu.temp .. "°C"))
    end
})
