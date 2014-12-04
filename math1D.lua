local math1D = {}

function math1D.clamp(x, x1, x2)
    return math.min(math.max(x, x1), x2)
end

function math1D.smoothstep(x1, x2, x)
    x = math1D.clamp((x - x1) / (x2 - x1), 0, 1)
    return 3 * x * x - 2 * x * x * x
end

function math1D.toByteFromFloat(x)
    return math1D.clamp(math.floor(x * 256), 0, 255)
end

function math1D.toFloatFromByte(x)
    return x / 255
end

function math1D.fbm(x, noise, octave, lacunarity, gain)
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

return math1D
