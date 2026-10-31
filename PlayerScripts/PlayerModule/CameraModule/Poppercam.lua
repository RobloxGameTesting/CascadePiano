local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local ZoomController = require(script.Parent:WaitForChild("ZoomController"))
local userFlag = FlagUtil.getUserFlag("UserFixCameraFPError")
local class = {}
class.__index = class
local cframe = CFrame.new()

local function cframeToAxis(cframe2: CFrame) -- 1 equivalent call inferred from this helper
	local axisAngle, v = cframe2:ToAxisAngle()
	return axisAngle * v
end

local function axisToCFrame(vector: Vector3) -- 1 equivalent call inferred from this helper
	local magnitude = vector.Magnitude

	if magnitude > 0.00001 then
		return CFrame.fromAxisAngle(vector, magnitude)
	end

	return cframe
end

local function extractRotation(lastCFrame: CFrame) -- 2 equivalent calls inferred from this helper
	local _, _, _, v, v2, v3, v4, v5, v6, v7, v8, v9 = lastCFrame:GetComponents()
	return CFrame.new(0, 0, 0, v, v2, v3, v4, v5, v6, v7, v8, v9)
end

function class.new()
	return (setmetatable({ lastCFrame = nil }, class))
end

function class:Step(p: number, lastCFrame: CFrame)
	local lastCFrame2 = self.lastCFrame or lastCFrame
	self.lastCFrame = lastCFrame
	local position = lastCFrame.Position
	local rotation = extractRotation(lastCFrame) -- inferred equivalent call
	local p2 = lastCFrame2.p
	local rotation2 = extractRotation(lastCFrame2) -- inferred equivalent call
	local posVelocity = (position - p2) / p
	local rotVelocity = cframeToAxis(rotation * rotation2:inverse()) / p -- inferred equivalent call
	return {
		extrapolate = function(p3)
			local v = posVelocity * p3 + position
			return axisToCFrame(rotVelocity * p3) * rotation + v -- inferred equivalent call
		end,
		posVelocity = posVelocity,
		rotVelocity = rotVelocity
	}
end

function class:Reset()
	self.lastCFrame = nil
end

local BaseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local object = setmetatable({}, BaseOcclusion)
object.__index = object

function object.new()
	local self = setmetatable(BaseOcclusion.new(), object)
	self.focusExtrapolator = class.new()
	return self
end

function object.GetOcclusionMode(_)
	return Enum.DevCameraOcclusionMode.Zoom
end

function object.Enable(p, _)
	p.focusExtrapolator:Reset()
end

function object.Update(p, p2, p3, p4, _)
	local v

	if userFlag then
		v = CFrame.lookAlong(p4.p, -p3.LookVector) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	else
		v = CFrame.new(p4.p, p3.p) * CFrame.new(0, 0, 0, -1, 0, 0, 0, 1, 0, 0, 0, -1)
	end

	local v2 = p.focusExtrapolator:Step(p2, v)
	local v3 = ZoomController.Update(p2, v, v2)
	return v * CFrame.new(0, 0, v3), p4
end

function object.CharacterAdded(_, _, _) end

function object.CharacterRemoving(_, _, _) end

function object.OnCameraSubjectChanged(_, _) end

return object