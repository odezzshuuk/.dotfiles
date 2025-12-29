function wrequire(t, k)
    return rawget(t, k) or require(t._NAME .. '.' .. k)
end
local setmetatable = setmetatable

local layout       = { _NAME = "customize.layout" }

return setmetatable(layout, { __index = wrequire })
