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

-- Adapted from Taehl: http://love2d.org/wiki/HSL_color
function colors.toRgbFromHsl(h, s, l)
    if s <= 0 then
        return l, l, l
    end

    h = h * 6
    local c = (1 - math.abs(2 * l - 1)) * s
    local x = (1 - math.abs(h % 2 - 1)) * c
    local m, r, g, b = (l - 0.5 * c), 0, 0, 0

    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end

    return r + m, g + m, b + m
end

return colors
