local Popper = require(script:WaitForChild("Popper"))
local clamp = math.clamp
local exp = math.exp
local min = math.min
local max = math.max
local cameraMinZoomDistance = nil
local cameraMaxZoomDistance = nil
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
assert(LocalPlayer)

local function updateBounds() -- 1 equivalent call inferred from this helper
	cameraMinZoomDistance = LocalPlayer.CameraMinZoomDistance
	cameraMaxZoomDistance = LocalPlayer.CameraMaxZoomDistance
end

updateBounds() -- inferred equivalent call
LocalPlayer:GetPropertyChangedSignal("CameraMinZoomDistance"):Connect(updateBounds)
LocalPlayer:GetPropertyChangedSignal("CameraMaxZoomDistance"):Connect(updateBounds)
local class = {}
class.__index = class

function class.new(freq: number, p: number, minValue: number, maxValue: number)
	local goal = clamp(p, minValue, maxValue)
	return (setmetatable({
		freq = freq,
		x = goal,
		v = 0,
		minValue = minValue,
		maxValue = maxValue,
		goal = goal
	}, class))
end

function class:Step(p: number)
	local v = self.freq * 2 * 3.141592653589793
	local x = self.x
	local v2 = self.v
	local minValue = self.minValue
	local maxValue = self.maxValue
	local goal = self.goal
	local v3 = goal - x
	local v4 = v * p
	local v5 = exp(-v4)
	local v6 = goal + (v2 * p - v3 * (v4 + 1)) * v5
	local v7 = ((v3 * v - v2) * v4 + v2) * v5

	if v6 < minValue then
		v6 = minValue
		v7 = 0
	elseif maxValue < v6 then
		v6 = maxValue
		v7 = 0
	end

	self.x = v6
	self.v = v7
	return v6
end

local v = class.new(4.5, 12.5, 0.5, cameraMaxZoomDistance)

local function stepTargetZoom(goal: number, p: number, p2: number, p3: number) -- 1 equivalent call inferred from this helper
	local v2 = clamp(goal + p * (goal * 0.0375 + 1), p2, p3)

	if v2 < 1 then
		return p <= 0 and p2 or 1
	end

	return v2
end

local v2 = 0
local ZoomController = {}

function ZoomController.Update(p: number, cframe: CFrame, p2)
	local v3

	if v.goal > 1 then
		local x = v.x
		local goal = v.goal
		local v4 = max(x, stepTargetZoom(goal, v2, cameraMinZoomDistance, cameraMaxZoomDistance)) -- inferred equivalent call
		v3 = Popper(cframe * CFrame.new(0, 0, 0.5), v4 - 0.5, p2) + 0.5
	else
		v3 = 1e999
	end

	v.minValue = 0.5
	v.maxValue = min(cameraMaxZoomDistance, v3)
	return v:Step(p)
end

function ZoomController.GetZoomRadius()
	return v.x
end

function ZoomController.SetZoomParameters(goal, p)
	v.goal = goal
	v2 = p
end

function ZoomController.ReleaseSpring()
	v.x = v.goal
	v.v = 0
end

return ZoomController