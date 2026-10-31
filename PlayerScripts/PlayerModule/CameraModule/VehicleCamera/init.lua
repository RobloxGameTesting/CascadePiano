local v = { 0, 15, 30 }
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local BaseCamera = require(script.Parent:WaitForChild("BaseCamera"))
local CameraInput = require(script.Parent:WaitForChild("CameraInput"))
local CameraUtils = require(script.Parent:WaitForChild("CameraUtils"))
require(script.Parent:WaitForChild("ZoomController"))
local VehicleCameraCore = require(script:WaitForChild("VehicleCameraCore"))
local VehicleCameraConfig = require(script:WaitForChild("VehicleCameraConfig"))
local LocalPlayer = Players.LocalPlayer
local map = CameraUtils.map
local Spring = CameraUtils.Spring
local mapClamp = CameraUtils.mapClamp
local sanitizeAngle = CameraUtils.sanitizeAngle

local function pitchVelocity(subjectRotVelocity, subjectCFrame) -- 1 equivalent call inferred from this helper
	return (math.abs((subjectCFrame.XVector:Dot(subjectRotVelocity))))
end

local function yawVelocity(subjectRotVelocity, subjectCFrame) -- 1 equivalent call inferred from this helper
	return (math.abs((subjectCFrame.YVector:Dot(subjectRotVelocity))))
end

local v2 = 1 / 60
RunService.Stepped:Connect(function(_, dt)
	v2 = dt
end)
local object = setmetatable({}, BaseCamera)
object.__index = object

function object.new()
	local self = setmetatable(BaseCamera.new(), object)
	self:Reset()
	return self
end

function object:Reset()
	self.vehicleCameraCore = VehicleCameraCore.new(self:GetSubjectCFrame())
	self.pitchSpring = Spring.new(0, -math.rad(VehicleCameraConfig.pitchBaseAngle))
	self.yawSpring = Spring.new(0, 0)
	self.lastPanTick = 0
	local currentCamera = workspace.CurrentCamera
	local cameraSubject = currentCamera and currentCamera.CameraSubject
	assert(currentCamera)
	assert(cameraSubject)
	assert(cameraSubject:IsA("VehicleSeat"))
	local connectedParts = cameraSubject:GetConnectedParts(true)
	local looseBoundingSphere, v3 = CameraUtils.getLooseBoundingSphere(connectedParts)
	self.assemblyRadius = math.max(v3, 5)
	self.assemblyOffset = cameraSubject.CFrame:Inverse() * looseBoundingSphere
	self.gamepadZoomLevels = {}

	for _, v4 in v do
		table.insert(self.gamepadZoomLevels, v4 * self.assemblyRadius / 10)
	end

	self:SetCameraToSubjectDistance(self.gamepadZoomLevels[#self.gamepadZoomLevels])
end

function object:_StepRotation(p, p2)
	local yawSpring = self.yawSpring
	local pitchSpring = self.pitchSpring
	local rotation = CameraInput.getRotation(p, true)
	local v3 = -rotation.X
	local v4 = -rotation.Y
	yawSpring.pos = sanitizeAngle(yawSpring.pos + v3)
	pitchSpring.pos = sanitizeAngle((math.clamp(pitchSpring.pos + v4, -1.3962634015954636, 1.3962634015954636)))

	if CameraInput.getRotationActivated() then
		self.lastPanTick = os.clock()
	end

	local goal = -math.rad(VehicleCameraConfig.pitchBaseAngle)
	local pitchDeadzoneAngle = math.rad(VehicleCameraConfig.pitchDeadzoneAngle)

	if os.clock() - self.lastPanTick > VehicleCameraConfig.autocorrectDelay then
		local freq = mapClamp(
			p2,
			VehicleCameraConfig.autocorrectMinCarSpeed,
			VehicleCameraConfig.autocorrectMaxCarSpeed,
			0,
			VehicleCameraConfig.autocorrectResponse
		)
		yawSpring.freq = freq
		pitchSpring.freq = freq

		if yawSpring.freq < 0.001 then
			yawSpring.vel = 0
		end

		if pitchSpring.freq < 0.001 then
			pitchSpring.vel = 0
		end

		if math.abs((sanitizeAngle(goal - pitchSpring.pos))) <= pitchDeadzoneAngle then
			pitchSpring.goal = pitchSpring.pos
		else
			pitchSpring.goal = goal
		end
	else
		yawSpring.freq = 0
		yawSpring.vel = 0
		pitchSpring.freq = 0
		pitchSpring.vel = 0
		pitchSpring.goal = goal
	end

	return CFrame.fromEulerAnglesYXZ(pitchSpring:step(p), yawSpring:step(p), 0)
end

function object:_GetThirdPersonLocalOffset()
	return self.assemblyOffset + Vector3.new(0, self.assemblyRadius * VehicleCameraConfig.verticalCenterOffset, 0)
end

function object:_GetFirstPersonLocalOffset(cframe: CFrame)
	local character = LocalPlayer.Character

	if character and character.Parent then
		local head = character:FindFirstChild("Head")

		if head and head:IsA("BasePart") then
			return cframe:Inverse() * head.Position
		end
	end

	return self:_GetThirdPersonLocalOffset()
end

function object:Update()
	local currentCamera = workspace.CurrentCamera
	local cameraSubject = currentCamera and currentCamera.CameraSubject
	local vehicleCameraCore = self.vehicleCameraCore
	assert(currentCamera)
	assert(cameraSubject)
	assert(cameraSubject:IsA("VehicleSeat"))
	local v3 = v2
	v2 = 0
	local subjectCFrame = self:GetSubjectCFrame()
	local subjectVelocity = self:GetSubjectVelocity()
	local subjectRotVelocity = self:GetSubjectRotVelocity()
	local v4 = math.abs((subjectVelocity:Dot(subjectCFrame.ZVector)))
	local v5 = yawVelocity(subjectRotVelocity, subjectCFrame) -- inferred equivalent call
	local v6 = pitchVelocity(subjectRotVelocity, subjectCFrame) -- inferred equivalent call
	local v7 = self:StepZoom()
	local v8 = self:_StepRotation(v3, v4)
	local v9 = mapClamp(v7, 0.5, self.assemblyRadius, 1, 0)
	local lerped = self:_GetThirdPersonLocalOffset():Lerp(self:_GetFirstPersonLocalOffset(subjectCFrame), v9)
	vehicleCameraCore:setTransform(subjectCFrame)
	local v10 = vehicleCameraCore:step(v3, v6, v5, v9)
	local v11 = CFrame.new(subjectCFrame * lerped) * v10 * v8
	return v11 * CFrame.new(0, 0, v7), v11
end

function object.ApplyVRTransform(_) end

return object