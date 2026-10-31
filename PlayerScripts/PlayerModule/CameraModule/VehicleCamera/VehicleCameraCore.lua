local CameraUtils = require(script.Parent.Parent.CameraUtils)
local VehicleCameraConfig = require(script.Parent.VehicleCameraConfig)
local map = CameraUtils.map
local mapClamp = CameraUtils.mapClamp
local sanitizeAngle = CameraUtils.sanitizeAngle

local function getYaw(cframe) -- 3 equivalent calls inferred from this helper
	local _, v = cframe:toEulerAnglesYXZ()
	return sanitizeAngle(v)
end

local function getPitch(cframe) -- 3 equivalent calls inferred from this helper
	return sanitizeAngle((cframe:toEulerAnglesYXZ()))
end

local function stepSpringAxis(value, p, p2, p3, p4) -- 2 equivalent calls inferred from this helper
	local v = sanitizeAngle(p3 - p2)
	local v2 = math.exp(-p * value)
	return
		sanitizeAngle((v * (1 + p * value) + p4 * value) * v2 + p2),
		(p4 * (1 - p * value) - v * (p * p * value)) * v2
end

local class = {}
class.__index = class

function class.new(fRising, fFalling, p)
	return (setmetatable({
		fRising = fRising,
		fFalling = fFalling,
		g = p,
		p = p,
		v = p * 0
	}, class))
end

function class:step(p)
	local fRising = self.fRising
	local fFalling = self.fFalling
	local g = self.g
	local p2 = self.p
	local v = self.v

	if v > 0 then
		fFalling = fRising or fFalling
	end

	local v2 = 6.283185307179586 * fFalling
	local v3 = p2 - g
	local v4 = math.exp(-v2 * p)
	local v5 = (v3 * (1 + v2 * p) + v * p) * v4 + g
	local v6 = (v * (1 - v2 * p) - v3 * (v2 * v2 * p)) * v4
	self.p = v5
	self.v = v6
	return v5
end

local class2 = {}
class2.__index = class2

function class2.new(cframe)
	assert(typeof(cframe) == "CFrame")
	local v = {
		yawG = getYaw(cframe), -- inferred equivalent call
		yawP = getYaw(cframe), -- inferred equivalent call
		yawV = 0,
		pitchG = getPitch(cframe), -- inferred equivalent call
		pitchP = getPitch(cframe), -- inferred equivalent call
		pitchV = 0,
		fSpringYaw = class.new(
			VehicleCameraConfig.yawReponseDampingRising,
			VehicleCameraConfig.yawResponseDampingFalling,
			0
		),
		fSpringPitch = class.new(
			VehicleCameraConfig.pitchReponseDampingRising,
			VehicleCameraConfig.pitchResponseDampingFalling,
			0
		)
	}
	return (setmetatable(v, class2))
end

function class2:setGoal(cframe)
	assert(typeof(cframe) == "CFrame")
	self.yawG = getYaw(cframe) -- inferred equivalent call
	self.pitchG = getPitch(cframe) -- inferred equivalent call
end

function class2:getCFrame()
	return CFrame.fromEulerAnglesYXZ(self.pitchP, self.yawP, 0)
end

function class2:step(value, value2, value3, value4)
	assert(typeof(value) == "number")
	assert(typeof(value3) == "number")
	assert(typeof(value2) == "number")
	assert(typeof(value4) == "number")
	local fSpringYaw = self.fSpringYaw
	local fSpringPitch = self.fSpringPitch
	fSpringYaw.g = mapClamp(
		map(value4, 0, 1, value3, 0),
		math.rad(VehicleCameraConfig.cutoffMinAngularVelYaw),
		math.rad(VehicleCameraConfig.cutoffMaxAngularVelYaw),
		1,
		0
	)
	fSpringPitch.g = mapClamp(
		map(value4, 0, 1, value2, 0),
		math.rad(VehicleCameraConfig.cutoffMinAngularVelPitch),
		math.rad(VehicleCameraConfig.cutoffMaxAngularVelPitch),
		1,
		0
	)
	local v = 6.283185307179586 * VehicleCameraConfig.yawStiffness * fSpringYaw:step(value)
	local v2 = 6.283185307179586 * VehicleCameraConfig.pitchStiffness * fSpringPitch:step(value) * map(
		value4,
		0,
		1,
		1,
		VehicleCameraConfig.firstPersonResponseMul
	)
	local yawP, yawV = stepSpringAxis( -- inferred equivalent call
		value,
		v * map(value4, 0, 1, 1, VehicleCameraConfig.firstPersonResponseMul),
		self.yawG,
		self.yawP,
		self.yawV
	)
	self.yawP = yawP
	self.yawV = yawV
	local pitchP, pitchV = stepSpringAxis(value, v2, self.pitchG, self.pitchP, self.pitchV) -- inferred equivalent call
	self.pitchP = pitchP
	self.pitchV = pitchV
	return self:getCFrame()
end

local VehicleCameraCore = {}
VehicleCameraCore.__index = VehicleCameraCore

function VehicleCameraCore.new(p)
	return (setmetatable({ vrs = class2.new(p) }, VehicleCameraCore))
end

function VehicleCameraCore:step(p, p2, p3, p4)
	return self.vrs:step(p, p2, p3, p4)
end

function VehicleCameraCore.setTransform(p, p2)
	p.vrs:setGoal(p2)
end

return VehicleCameraCore