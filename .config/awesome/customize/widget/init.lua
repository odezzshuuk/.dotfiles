function wrequire(t, k)
    return rawget(t, k) or require(t._NAME .. '.' .. k)
end
local widget = { _NAME = "customize.widget" }
return setmetatable(widget, { __index = wrequire })
