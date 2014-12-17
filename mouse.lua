local mouse = {}

local function _getWindowCenter()
    local width, height = love.window.getDimensions()
    return math.floor(0.5 * width), math.floor(0.5 * height)
end

function mouse.readPosition()
    local mouseX, mouseY = love.mouse.getPosition()
    local windowX, windowY = _getWindowCenter()
    local x, y = mouseX - windowX, mouseY - windowY
    love.mouse.setPosition(windowX, windowY)
    return x, y
end

return mouse
