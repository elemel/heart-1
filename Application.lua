local Application = {}
Application.__index = Application

function Application.new()
    local application = {}
    setmetatable(application, Application)
    return application
end

function Application:getScreen()
    return self._screen
end

function Application:setScreen(screen)
    if self._screen then
        self._screen:destroy()
    end
    self._screen = screen
    if self._screen then
        self._screen:create()
    end
end

function Application:update(dt)
    if self._screen then
        self._screen:update(dt)
    end
end

function Application:draw()
    if self._screen then
        self._screen:draw()
    end
end

return Application
