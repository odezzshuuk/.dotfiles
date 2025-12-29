local customize = require("customize")
local beautiful = require("beautiful")
local markup  = require("lain.util").markup

return customize.widget.notification({
    settings = function()
        widget:set_markup(markup.font(beautiful.font, result))
    end
})
