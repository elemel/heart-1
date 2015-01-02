local Camera = require "heart.Camera"
local Scene = require "heart.Scene"
local WorldView = require "heart.WorldView"

local Game = {}
Game.__index = Game

function Game.new(config)
    local game = {}
    setmetatable(game, Game)

    config = config or {}

    game._time = 0

    local cameraScale = config.cameraScale or 0.1
    game._camera = Camera.new({scale = cameraScale})

    game._scene = Scene.new()

    game._entityFactories = {}
    game._entities = heart.collection.newLinkedSet()
    game._entitiesByType = {}

    game._images = {}
    game._shaders = {}
    game._sounds = {}

    return game
end

function Game:update(dt)
    self._time = self._time + dt

    for entity in self._entities:iterate() do
        entity:update(dt)
    end
end

function Game:draw()
    local width, height = love.window.getDimensions()
    self._camera:setViewport(0, height, width, 0)
    self._camera:draw()
    love.graphics.setLineWidth(2 * self._camera:getPixelWorldSize())

    for entity in self._entities:iterate() do
        entity:draw()
    end

    self._scene:draw()
end

function Game:getTime()
    return self._time
end

function Game:getScene()
    return self._scene
end

function Game:getEntityFactory(type_)
    return self._entityFactories[type_]
end

function Game:setEntityFactory(type_, factory)
    self._entityFactories[type_] = factory
end

function Game:addEntity(entity)
    self._entities:addLast(entity)

    local type_ = entity:getType()
    if not self._entitiesByType[type_] then
        self._entitiesByType[type_] = {}
    end
    self._entitiesByType[type_][entity] = true
end

function Game:removeEntity(entity)
    self._entities:remove(entity)

    local type_ = entity:getType()
    self._entitiesByType[type_][entity] = nil
    if not next(self._entitiesByType[type_]) then
        self._entitiesByType[type_] = nil
    end
end

function Game:getEntitiesByType(type_)
    return self._entitiesByType[type_]
end

function Game:getCamera()
    return self._camera
end

function Game:getImage(name)
    return self._images[name]
end

function Game:setImage(name, image)
    self._images[name] = image
end

function Game:getShader(name)
    return self._shaders[name]
end

function Game:setShader(name, shader)
    self._shaders[name] = shader
end

function Game:getSound(name)
    return self._sounds[name]
end

function Game:setSound(name, sound)
    self._sounds[name] = sound
end

function Game:playSound(name)
    local sound = self._sounds[name]
    if sound then
        love.audio.play(sound:clone())
    end
end

return Game
