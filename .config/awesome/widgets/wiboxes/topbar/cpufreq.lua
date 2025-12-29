local customize = require("customize")
local markup  = require("lain.util").markup
local beautiful = require("beautiful")

local cpufreq = customize.widget.cpufreq({
    settings = function()
        widget:set_markup(markup.font(beautiful.font,  governor  .. " " .. freqv.ghz .. " Ghz"))
    end
})

return cpufreq
