local GameScreen = {}
GameScreen.__index = GameScreen

function GameScreen.new(application, game)
    local screen = {}
    setmetatable(screen, GameScreen)

    screen._application = application
    screen._game = game

    return screen
end

function GameScreen:create()
end

function GameScreen:destroy()
end

function GameScreen:update(dt)
    self._game:update(dt)
end

function GameScreen:draw()
    self._game:draw()
end

return GameScreen
