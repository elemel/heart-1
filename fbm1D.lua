local function fbm(x, noise, octave, lacunarity, gain)
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

return {fbm = fbm}
