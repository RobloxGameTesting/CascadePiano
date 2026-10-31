local thread = nil

local function acquireRunnerThreadAndCallEventHandler(callback, ...)
	local v = thread
	thread = nil
	callback(...)
	thread = v
end

local function runEventHandlerInFreeThread()
	while true do
		acquireRunnerThreadAndCallEventHandler(coroutine.yield())
	end
end

local class = {}
class.__index = class

function class.new(signal, fn)
	return (setmetatable({ _connected = true, _signal = signal, _fn = fn, _next = false }, class))
end

function class:Disconnect()
	self._connected = false

	if self._signal._handlerListHead == self then
		self._signal._handlerListHead = self._next
		return
	end

	local handlerListHead = self._signal._handlerListHead

	while handlerListHead and handlerListHead._next ~= self do
		handlerListHead = handlerListHead._next
	end

	if handlerListHead then
		handlerListHead._next = self._next
	end
end

class.Destroy = class.Disconnect
setmetatable(class, {
	__index = function(_, p)
		error(("Attempt to get Connection::%s (not a valid member)"):format((tostring(p))), 2)
	end,
	__newindex = function(_, p, _)
		error(("Attempt to set Connection::%s (not a valid member)"):format((tostring(p))), 2)
	end
})
local GoodSignal = {}
GoodSignal.__index = GoodSignal

function GoodSignal.new()
	return (setmetatable({ _handlerListHead = false }, GoodSignal))
end

function GoodSignal:Connect(p)
	local handlerListHead = class.new(self, p)

	if not self._handlerListHead then
		self._handlerListHead = handlerListHead
		return handlerListHead
	end

	handlerListHead._next = self._handlerListHead
	self._handlerListHead = handlerListHead
	return handlerListHead
end

function GoodSignal:DisconnectAll()
	self._handlerListHead = false
end

GoodSignal.Destroy = GoodSignal.DisconnectAll

function GoodSignal:Fire(...)
	local handlerListHead = self._handlerListHead

	while handlerListHead do
		if handlerListHead._connected then
			if not thread then
				thread = coroutine.create(runEventHandlerInFreeThread)
				coroutine.resume(thread)
			end

			task.spawn(thread, handlerListHead._fn, ...)
		end

		handlerListHead = handlerListHead._next
	end
end

function GoodSignal:Wait()
	local thread2 = coroutine.running()
	local connection = nil
	connection = self:Connect(function(...)
		connection:Disconnect()
		task.spawn(thread2, ...)
	end)
	return coroutine.yield()
end

function GoodSignal:Once(callback)
	local connection = nil
	connection = self:Connect(function(...)
		if connection._connected then
			connection:Disconnect()
		end

		callback(...)
	end)
	return connection
end

setmetatable(GoodSignal, {
	__index = function(_, p)
		error(("Attempt to get Signal::%s (not a valid member)"):format((tostring(p))), 2)
	end,
	__newindex = function(_, p, _)
		error(("Attempt to set Signal::%s (not a valid member)"):format((tostring(p))), 2)
	end
})
return GoodSignal