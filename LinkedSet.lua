local LinkedSet = {}
LinkedSet.__index = LinkedSet

function LinkedSet.new()
    local set = {}
    setmetatable(set, LinkedSet)

    set._next = {}
    set._previous = {}

    return set
end

function LinkedSet.fromArray(values)
    local set = LinkedSet.new()

    for i, value in ipairs(values) do
        set:addLast(value)
    end

    return set
end

function LinkedSet:addFirst(value)
    if value == nil then
        error("Can't add nil value")
    end

    if value ~= self._first then
        self:remove(value)

        if self._first == nil then
            self._first = value
            self._last = value
        else
            self._next[value] = self._first
            self._previous[self._first] = value

            self._first = value
        end
    end
end

function LinkedSet:addLast(value)
    if value == nil then
        error("Can't add nil value")
    end

    if value ~= self._last then
        self:remove(value)

        if self._last == nil then
            self._first = value
            self._last = value
        else
            self._next[self._last] = value
            self._previous[value] = self._last

            self._last = value
        end
    end
end

function LinkedSet:addBefore(value, next_)
    error("Not implemented")
end

function LinkedSet:addAfter(value, previous)
    error("Not implemented")
end

function LinkedSet:removeFirst()
    if self._first == nil then
        return nil
    elseif self._first == self._last then
        local first = self._first

        self._first = nil
        self._last = nil

        return first
    else
        local first = self._first
        local next_ = self._next[first]

        self._first = next_

        self._next[first] = nil
        self._previous[next_] = nil

        return first
    end
end

function LinkedSet:removeLast()
    if self._last == nil then
        return nil
    elseif self._first == self._last then
        local last = self._last

        self._first = nil
        self._last = nil

        return last
    else
        local last = self._last
        local previous = self._previous[last]

        self._last = previous

        self._next[previous] = nil
        self._previous[last] = nil

        return last
    end
end

function LinkedSet:remove(value)
    if self:contains(value) then
        local previous = self._previous[value]
        local next_ = self._next[value]

        if previous == nil then
            self._first = next_
        else
            self._next[previous] = next_
            self._previous[value] = nil
        end

        if next_ == nil then
            self._last = previous
        else
            self._next[value] = nil
            self._previous[next_] = previous
        end
    end
end

function LinkedSet:iterate()
    local next_ = self._first

    return function()
        local value = next_
        next_ = self._next[next_]
        return value
    end
end

function LinkedSet:contains(value)
    return value ~= nil and (value == self._first or self._previous[value] ~= nil)
end

function LinkedSet:isEmpty()
    return self._first == nil
end

function LinkedSet:getFirst()
    return self._first
end

function LinkedSet:getLast()
    return self._last
end

function LinkedSet:getNext(value)
    return self._next[value]
end

function LinkedSet:getPrevious(value)
    return self._previous[value]
end

return LinkedSet
