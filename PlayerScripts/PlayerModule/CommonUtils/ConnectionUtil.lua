local ConnectionUtil = {}
ConnectionUtil.__index = ConnectionUtil

function ConnectionUtil.new()
	local self = setmetatable({}, ConnectionUtil)
	self._connections = {}
	return self
end

function ConnectionUtil:trackConnection(p, connection)
	if self._connections[p] then
		self._connections[p]()
	end

	self._connections[p] = function()
		connection:Disconnect()
	end
end

function ConnectionUtil:trackBoundFunction(p, p2)
	if self._connections[p] then
		self._connections[p]()
	end

	self._connections[p] = p2
end

function ConnectionUtil:disconnect(p)
	if self._connections[p] then
		self._connections[p]()
		self._connections[p] = nil
	end
end

function ConnectionUtil:disconnectAll()
	for _, connection in pairs(self._connections) do
		connection()
	end

	self._connections = {}
end

return ConnectionUtil