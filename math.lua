local math_ = {}

function math_.sign(x)
    return x < 0 and -1 or 1
end

function math_.clamp(x, x1, x2)
    return math.min(math.max(x, x1), x2)
end

function math_.mix(x1, x2, t)
    return x1 + t * (x2 - x1)
end

function math_.smoothstep(x1, x2, x)
    x = math_.clamp((x - x1) / (x2 - x1), 0, 1)
    return 3 * x * x - 2 * x * x * x
end

function math_.toByte(x)
    return math_.clamp(math.floor(x * 256), 0, 255)
end

function math_.toByte2(x, y)
    return math_.clamp(math.floor(x * 256), 0, 255),
        math_.clamp(math.floor(y * 256), 0, 255)
end

function math_.toByte3(x, y, z)
    return math_.clamp(math.floor(x * 256), 0, 255),
        math_.clamp(math.floor(y * 256), 0, 255),
        math_.clamp(math.floor(z * 256), 0, 255)
end

function math_.toByte4(x, y, z, w)
    return math_.clamp(math.floor(x * 256), 0, 255),
        math_.clamp(math.floor(y * 256), 0, 255),
        math_.clamp(math.floor(z * 256), 0, 255),
        math_.clamp(math.floor(w * 256), 0, 255)
end

function math_.toHexColor4(x, y, z, w)
    return math_.clamp(17 * math.floor(x * 16), 0, 255),
        math_.clamp(17 * math.floor(y * 16), 0, 255),
        math_.clamp(17 * math.floor(z * 16), 0, 255),
        math_.clamp(17 * math.floor(w * 16), 0, 255)
end

function math_.toWebColor4(x, y, z, w)
    return math_.clamp(51 * math.floor(x * 6), 0, 255),
        math_.clamp(51 * math.floor(y * 6), 0, 255),
        math_.clamp(51 * math.floor(z * 6), 0, 255),
        math_.clamp(51 * math.floor(w * 6), 0, 255)
end

function math_.fromByte(x)
    return x / 255
end

function math_.fromByte2(x, y)
    return x / 255, y / 255
end

function math_.fromByte3(x, y, z)
    return x / 255, y / 255, z / 255
end

function math_.fromByte4(x, y, z, w)
    return x / 255, y / 255, z / 255, w / 255
end

function math_.length2(x, y)
    return math.sqrt(x * x + y * y)
end

function math_.normalize2(x, y)
    local length = math_.length2(x, y)
    return x / length, y / length, length
end

function math_.shuffle(array, random)
    random = random or love.math.random
    for i = #array, 1, -1 do
        local j = random(1, i)
        array[i], array[j] = array[j], array[i]
    end
end

function math_.resolveRectangles2(x1, y1, x2, y2, x3, y3, x4, y4)
    local distanceX = math.min(x4 - x1, x2 - x3)
    local distanceY = math.min(y4 - y1, y2 - y3)

    if distanceX < distanceY then
        if x4 - x1 < x2 - x3 then
            return 1, 0, distanceX
        else
            return -1, 0, distanceX
        end
    else
        if y4 - y1 < y2 - y3 then
            return 0, 1, distanceY
        else
            return 0, -1, distanceY
        end
    end
end

-- Adapted from Taehl: http://love2d.org/wiki/HSL_color
function math_.toRgbFromHsl(h, s, l)
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

function math_.fbm(x, noise, octave, lacunarity, gain)
    noise = noise or love.math.noise
    octave = octave or 3
    lacunarity = lacunarity or 2
    gain = gain or 1 / lacunarity

    local integralOctave, fractionalOctave = math.modf(octave)
    local amplitude = 1

    local totalNoise = 0
    local totalAmplitude = 0

    for i = 1, integralOctave do
        totalNoise = totalNoise + amplitude * noise(x, 0)
        totalAmplitude = totalAmplitude + amplitude

        x = x * lacunarity
        amplitude = amplitude * gain
    end

    if fractionalOctave > 0 then
        totalNoise = totalNoise + fractionalOctave * amplitude * noise(x)
        totalAmplitude = totalAmplitude + fractionalOctave * amplitude
    end

    return totalNoise / totalAmplitude
end

function math_.fbm2(x, y, noise, octave, lacunarityX, lacunarityY, gain)
    noise = noise or love.math.noise
    octave = octave or 3
    lacunarityX = lacunarityX or 2
    lacunarityY = lacunarityY or 2
    gain = gain or 2 / (lacunarityX + lacunarityY)

    local integralOctave, fractionalOctave = math.modf(octave)
    local amplitude = 1

    local totalNoise = 0
    local totalAmplitude = 0

    for i = 1, integralOctave do
        totalNoise = totalNoise + amplitude * noise(x, y)
        totalAmplitude = totalAmplitude + amplitude

        x = x * lacunarityX
        y = y * lacunarityY
        amplitude = amplitude * gain
    end

    if fractionalOctave > 0 then
        totalNoise = totalNoise + fractionalOctave * amplitude * noise(x, y)
        totalAmplitude = totalAmplitude + fractionalOctave * amplitude
    end

    return totalNoise / totalAmplitude
end

function math_.fbm3(
    x, y, z, noise, octave, lacunarityX, lacunarityY, lacunarityZ, gain)

    noise = noise or love.math.noise
    octave = octave or 3
    lacunarityX = lacunarityX or 2
    lacunarityY = lacunarityY or 2
    lacunarityZ = lacunarityZ or 2
    gain = gain or 3 / (lacunarityX + lacunarityY + lacunarityZ)

    local integralOctave, fractionalOctave = math.modf(octave)
    local amplitude = 1

    local totalNoise = 0
    local totalAmplitude = 0

    for i = 1, integralOctave do
        totalNoise = totalNoise + amplitude * noise(x, y, z)
        totalAmplitude = totalAmplitude + amplitude

        x = x * lacunarityX
        y = y * lacunarityY
        z = z * lacunarityZ
        amplitude = amplitude * gain
    end

    if fractionalOctave > 0 then
        totalNoise = totalNoise + fractionalOctave * amplitude * noise(x, y, z)
        totalAmplitude = totalAmplitude + fractionalOctave * amplitude
    end

    return totalNoise / totalAmplitude
end

function math_.fbm4(
    x, y, z, w, noise, octave, lacunarityX, lacunarityY, lacunarityZ,
    lacunarityW, gain)

    noise = noise or love.math.noise
    octave = octave or 3
    lacunarityX = lacunarityX or 2
    lacunarityY = lacunarityY or 2
    lacunarityZ = lacunarityZ or 2
    lacunarityW = lacunarityW or 2
    gain = gain or 4 / (lacunarityX + lacunarityY + lacunarityZ + lacunarityW)

    local integralOctave, fractionalOctave = math.modf(octave)
    local amplitude = 1

    local totalNoise = 0
    local totalAmplitude = 0

    for i = 1, integralOctave do
        totalNoise = totalNoise + amplitude * noise(x, y, z, w)
        totalAmplitude = totalAmplitude + amplitude

        x = x * lacunarityX
        y = y * lacunarityY
        z = z * lacunarityZ
        w = w * lacunarityW
        amplitude = amplitude * gain
    end

    if fractionalOctave > 0 then
        totalNoise = totalNoise + fractionalOctave * amplitude * noise(x, y, z, w)
        totalAmplitude = totalAmplitude + fractionalOctave * amplitude
    end

    return totalNoise / totalAmplitude
end

return math_
