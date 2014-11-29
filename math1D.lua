local math1D = {}

function math1D.clamp(x, x1, x2)
    return math.min(math.max(x, x1), x2)
end

function math1D.smoothstep(x1, x2, x)
    x = clamp((x - x1) / (x2 - x1), 0, 1)
    return 3 * x * x - 2 * x * x * x
end

function math1D.toByteFromFloat(x)
    return math1D.clamp(math.floor(x * 256), 0, 255)
end

function math1D.toFloatFromByte(x)
    return x / 255
end

return math1D
