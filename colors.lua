local path = (...):match(".+%.") or ""

local math1D = require(path .. "math1D")

local colors = {}

function colors.toByteColor(r, g, b, a)
    local f = math1D.toByteFromFloat
    return f(r), f(g), f(b), f(a)
end

function colors.toFloatColor(r, g, b, a)
    local f = math1D.toFloatFromByte
    return f(r), f(g), f(b), f(a)
end

return colors
