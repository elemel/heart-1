local Application = require "Application"
local Game = require "Game"
local GameScreen = require "GameScreen"

function love.load()
    application = Application.new()

    local game = Game.new()

    local screen = GameScreen.new(application, game)
    application:setScreen(screen)
end

function love.update(dt)
    application:update(dt)
end

function love.draw()
    application:draw()
end
