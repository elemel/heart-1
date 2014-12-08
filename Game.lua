local Camera = require "heart.Camera"
local Scene = require "heart.Scene"
local WorldView = require "heart.WorldView"

local Game = {}
Game.__index = Game

function Game.new(config)
    local game = {}
    setmetatable(game, Game)

    config = config or {}

    game._nextId = 1
    game._time = 0

    local cameraScale = config.cameraScale or 0.03
    game._camera = Camera.new({scale = cameraScale})

    local gravityX, gravityY = unpack(config.gravity or {0, 0})
    game._world = love.physics.newWorld(gravityX, gravityY, true)
    game._world:setCallbacks(
        function(...) game:_beginContact(...) end,
        function(...) game:_endContact(...) end,
        function(...) game:_preSolve(...) end,
        function(...) game:_postSolve(...) end)
    game._worldView = WorldView.new(game._world)

    game._scene = Scene.new()

    game._modelCreators = {}
    game._models = {}
    game._modelsByType = {}

    game._contactHandlers = {}

    game._viewCreators = {}
    game._views = {}

    game._images = {}
    game._shaders = {}
    game._sounds = {}

    game._worldViewEnabled = false

    return game
end

function Game:update(dt)
    self._time = self._time + dt

    for id, model in pairs(self._models) do
        model:update(dt)
    end

    self._world:update(dt)

    if self._cameraSubjectId then
        local subject = self._models[self._cameraSubjectId]
        if subject then
            local x, y = subject:getPosition()
            self._camera:setPosition(x, 0)
        end
    end
end

function Game:draw()
    local width, height = love.window.getDimensions()
    self._camera:setViewport(0, height, width, 0)
    self._camera:draw()
    love.graphics.setLineWidth(2 * self._camera:getPixelWorldSize())

    for id, view in pairs(self._views) do
        view:draw()
    end

    self._scene:draw()

    if self._worldViewEnabled then
        love.graphics.setLineWidth(2 * self._camera:getPixelWorldSize())
        love.graphics.setColor(255, 255, 255)
        self._worldView:draw()
    end
end

function Game:getTime()
    return self._time
end

function Game:getWorld()
    return self._world
end

function Game:getScene()
    return self._scene
end

function Game:setModelCreator(type, creator)
    self._modelCreators[type] = creator
end

function Game:getContactHandler(type1, type2)
    local handlers = self._contactHandlers
    if handlers[type1] and handlers[type1][type2] then
        return handlers[type1][type2], false
    elseif handlers[type2] and handlers[type2][type1] then
        return handlers[type2][type1], true
    else
        return nil, false
    end
end

function Game:setContactHandler(type1, type2, handler)
    local handlers = self._contactHandlers
    if not handlers[type1] then
        handlers[type1] = {}
    end
    handlers[type1][type2] = handler
end

function Game:setViewCreator(type, creator)
    self._viewCreators[type] = creator
end

function Game:isWorldViewEnabled()
    return self._worldViewEnabled
end

function Game:setWorldViewEnabled(enabled)
    self._worldViewEnabled = enabled
end

function Game:newModel(type, config)
    local creator = self._modelCreators[type]
    local id = self:generateId()
    local model = creator(self, id, config)
    self:addModel(model)
    return model
end

function Game:addModel(model)
    local modelType = model:getType()
    local id = model:getId()
    self._models[id] = model
    if not self._modelsByType[modelType] then
        self._modelsByType[modelType] = {}
    end
    self._modelsByType[modelType][id] = model
    model:create()

    local viewCreator = self._viewCreators[modelType]
    if viewCreator then
        local view = viewCreator(self, model)
        self._views[id] = view
        view:create()
    end
end

function Game:removeModel(model)
    local id = model:getId()
    local view = self._views[id]
    if view then
        view:destroy()
        self._views[id] = nil
    end

    local modelType = model:getType()
    model:destroy()
    self._modelsByType[modelType][id] = nil
    self._models[id] = nil
end

function Game:getModelByType(modelType)
    local models = self._modelsByType[modelType]
    if models then
        for id, model in pairs(models) do
            return model
        end
    end
    return nil
end

function Game:getModelsByType(modelType)
    local modelArray = {}
    local models = self._modelsByType[modelType]
    if models then
        for id, model in pairs(models) do
            table.insert(modelArray, model)
        end
    end
    return modelArray
end

function Game:generateId()
    local id = self._nextId
    self._nextId = self._nextId + 1
    return id
end

function Game:getCamera()
    return self._camera
end

function Game:getCameraSubjectId()
    return self._cameraSubjectId
end

function Game:setCameraSubjectId(id)
    self._cameraSubjectId = id
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

function Game:_beginContact(fixture1, fixture2, contact)
    local userData1 = fixture1:getUserData()
    local userData2 = fixture2:getUserData()
    local model1 = userData1 and userData1.model
    local model2 = userData2 and userData2.model
    if model1 and model1.beginContact then
        model1:beginContact(fixture1, fixture2, contact, false)
    end
    if model2 and model2.beginContact then
        model2:beginContact(fixture2, fixture1, contact, true)
    end

    local type1 = model1 and model1:getType()
    local type2 = model2 and model2:getType()
    if type1 and type2 then
        local handler, reversed = self:getContactHandler(type1, type2)
        if handler then
            if reversed then
                handler:beginContact(fixture2, fixture1, contact, true)
            else
                handler:beginContact(fixture1, fixture2, contact, false)
            end
        end
    end
end

function Game:_endContact(fixture1, fixture2, contact)
    local userData1 = fixture1:getUserData()
    local userData2 = fixture2:getUserData()
    local model1 = userData1 and userData1.model
    local model2 = userData2 and userData2.model
    if model1 and model1.endContact then
        model1:endContact(fixture1, fixture2, contact, false)
    end
    if model2 and model2.endContact then
        model2:endContact(fixture2, fixture1, contact, true)
    end

    local type1 = model1 and model1:getType()
    local type2 = model2 and model2:getType()
    if type1 and type2 then
        local handler, reversed = self:getContactHandler(type1, type2)
        if handler then
            if reversed then
                handler:endContact(fixture2, fixture1, contact, true)
            else
                handler:endContact(fixture1, fixture2, contact, false)
            end
        end
    end
end

function Game:_preSolve(fixture1, fixture2, contact)
    local userData1 = fixture1:getUserData()
    local userData2 = fixture2:getUserData()
    local model1 = userData1 and userData1.model
    local model2 = userData2 and userData2.model
    if model1 and model1.preSolve then
        model1:preSolve(fixture1, fixture2, contact, false)
    end
    if model2 and model2.preSolve then
        model2:preSolve(fixture2, fixture1, contact, true)
    end

    local type1 = model1 and model1:getType()
    local type2 = model2 and model2:getType()
    if type1 and type2 then
        local handler, reversed = self:getContactHandler(type1, type2)
        if handler then
            if reversed then
                handler:preSolve(fixture2, fixture1, contact, true)
            else
                handler:preSolve(fixture1, fixture2, contact, false)
            end
        end
    end
end

function Game:_postSolve(fixture1, fixture2, contact,
    normalImpulse1, tangentImpulse1, normalImpulse2, tangentImpulse2)

    local userData1 = fixture1:getUserData()
    local userData2 = fixture2:getUserData()
    local model1 = userData1 and userData1.model
    local model2 = userData2 and userData2.model
    if model1 and model1.postSolve then
        model1:postSolve(fixture1, fixture2, contact,
            normalImpulse1, tangentImpulse1, normalImpulse2, tangentImpulse2,
            false)
    end
    if model2 and model2.postSolve then
        model2:postSolve(fixture2, fixture1, contact,
            normalImpulse1, tangentImpulse1, normalImpulse2, tangentImpulse2,
            true)
    end

    local type1 = model1 and model1:getType()
    local type2 = model2 and model2:getType()
    if type1 and type2 then
        local handler, reversed = self:getContactHandler(type1, type2)
        if handler then
            if reversed then
                handler:postSolve(
                    fixture2, fixture1, contact, normalImpulse1,
                    tangentImpulse1, normalImpulse2, tangentImpulse2, true)
            else
                handler:postSolve(
                    fixture1, fixture2, contact, normalImpulse1,
                    tangentImpulse1, normalImpulse2, tangentImpulse2, false)
            end
        end
    end
end

return Game
