local Camera = require "Camera"
local WorldView = require "WorldView"

local Game = {}
Game.__index = Game

function Game.new()
    local game = {}
    setmetatable(game, Game)

    game._camera = Camera.new()
    game._world = love.physics.newWorld()
    game._worldView = WorldView.new(game._world)

    game._models = {}

    return game
end

function Game:getWorld()
    return self._world
end

function Game:addModel(model)
    self._models[model] = true
    model:create()
end

function Game:removeModel(model)
    model:destroy()
    self._models[model] = nil
end

function Game:update(dt)
    for model, _ in pairs(self._models) do
        model:update(dt)
    end
end

function Game:draw()
    local windowWidth, windowHeight = love.window.getDimensions()
    self._camera:setViewport(0, windowHeight, windowWidth, 0)

    self._camera:draw()
    self._worldView:draw()
end

return Game
