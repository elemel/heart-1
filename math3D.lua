local math3D = {}

function math3D.fbm(
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

return math3D
