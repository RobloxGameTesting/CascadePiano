local createVector = vector.create
local ClickToMoveDisplay = {}
local image = "rbxasset://textures/ui/traildot.png"
local image2 = "rbxasset://textures/ui/waypoint.png"
local alwaysOnTop = false
local udim = UDim2.new(0, 42, 0, 50)
local vector = Vector2.new(0, 0.5)
local vector2 = Vector2.new(0, 1)
local vector3 = Vector2.new(0, 0.5)
local vector4 = Vector2.new(0.1, 0.5)
local vector5 = Vector2.new(-0.1, 0.5)
local vector6 = Vector2.new(1.5, 1.5)
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local userFlag = FlagUtil.getUserFlag("UserRaycastUpdateAPI2")
local LocalPlayer = Players.LocalPlayer

local function CreateWaypointTemplates()
	local part = Instance.new("Part")
	part.Size = createVector(1, 1, 1)
	part.Anchored = true
	part.CanCollide = false
	part.Name = "TrailDot"
	part.Transparency = 1
	local imageHandleAdornment = Instance.new("ImageHandleAdornment")
	imageHandleAdornment.Name = "TrailDotImage"
	imageHandleAdornment.Size = vector6
	imageHandleAdornment.SizeRelativeOffset = createVector(0, 0, -0.1)
	imageHandleAdornment.AlwaysOnTop = alwaysOnTop
	imageHandleAdornment.Image = image
	imageHandleAdornment.Adornee = part
	imageHandleAdornment.Parent = part
	local part2 = Instance.new("Part")
	part2.Size = createVector(2, 2, 2)
	part2.Anchored = true
	part2.CanCollide = false
	part2.Name = "EndWaypoint"
	part2.Transparency = 1
	local imageHandleAdornment2 = Instance.new("ImageHandleAdornment")
	imageHandleAdornment2.Name = "TrailDotImage"
	imageHandleAdornment2.Size = vector6
	imageHandleAdornment2.SizeRelativeOffset = createVector(0, 0, -0.1)
	imageHandleAdornment2.AlwaysOnTop = alwaysOnTop
	imageHandleAdornment2.Image = image
	imageHandleAdornment2.Adornee = part2
	imageHandleAdornment2.Parent = part2
	local billboardGui = Instance.new("BillboardGui")
	billboardGui.Name = "EndWaypointBillboard"
	billboardGui.Size = udim
	billboardGui.LightInfluence = 0
	billboardGui.SizeOffset = vector
	billboardGui.AlwaysOnTop = true
	billboardGui.Adornee = part2
	billboardGui.Parent = part2
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Image = image2
	imageLabel.BackgroundTransparency = 1
	imageLabel.Size = UDim2.new(1, 0, 1, 0)
	imageLabel.Parent = billboardGui
	local part3 = Instance.new("Part")
	part3.Size = createVector(2, 2, 2)
	part3.Anchored = true
	part3.CanCollide = false
	part3.Name = "FailureWaypoint"
	part3.Transparency = 1
	local imageHandleAdornment3 = Instance.new("ImageHandleAdornment")
	imageHandleAdornment3.Name = "TrailDotImage"
	imageHandleAdornment3.Size = vector6
	imageHandleAdornment3.SizeRelativeOffset = createVector(0, 0, -0.1)
	imageHandleAdornment3.AlwaysOnTop = alwaysOnTop
	imageHandleAdornment3.Image = image
	imageHandleAdornment3.Adornee = part3
	imageHandleAdornment3.Parent = part3
	local billboardGui2 = Instance.new("BillboardGui")
	billboardGui2.Name = "FailureWaypointBillboard"
	billboardGui2.Size = udim
	billboardGui2.LightInfluence = 0
	billboardGui2.SizeOffset = vector3
	billboardGui2.AlwaysOnTop = true
	billboardGui2.Adornee = part3
	billboardGui2.Parent = part3
	local frame = Instance.new("Frame")
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.new(0, 0, 0, 0)
	frame.Position = UDim2.new(0.5, 0, 1, 0)
	frame.Parent = billboardGui2
	local imageLabel2 = Instance.new("ImageLabel")
	imageLabel2.Image = image2
	imageLabel2.BackgroundTransparency = 1
	imageLabel2.Position = UDim2.new(0, -udim.X.Offset / 2, 0, -udim.Y.Offset)
	imageLabel2.Size = udim
	imageLabel2.Parent = frame
	return part, part2, part3
end

local v, v2, v3 = CreateWaypointTemplates()

local function getTrailDotParent() -- 2 equivalent calls inferred from this helper
	local currentCamera = Workspace.CurrentCamera
	local v4 = currentCamera:FindFirstChild("ClickToMoveDisplay")

	if not v4 then
		v4 = Instance.new("Model")
		v4.Name = "ClickToMoveDisplay"
		v4.Parent = currentCamera
	end

	return v4
end

local function placePathWaypoint(clone, vector7: Vector3) -- 1 equivalent call inferred from this helper
	if userFlag then
		raycastParams.FilterDescendantsInstances = { Workspace.CurrentCamera, LocalPlayer.Character }
		local raycastResult = Workspace:Raycast(
			vector7 + createVector(0, 2.5, 0),
			createVector(-0, -10, -0),
			raycastParams
		)

		if raycastResult then
			clone.CFrame = CFrame.lookAlong(raycastResult.Position, raycastResult.Normal)
			clone.Parent = getTrailDotParent() -- inferred equivalent call
		end
	else
		local part, v4, v5 = Workspace:FindPartOnRayWithIgnoreList(
			Ray.new(vector7 + createVector(0, 2.5, 0), createVector(0, -10, 0)),
			{ Workspace.CurrentCamera, LocalPlayer.Character }
		)

		if part then
			clone.CFrame = CFrame.new(v4, v4 + v5)
			clone.Parent = getTrailDotParent() -- inferred equivalent call
		end
	end
end

local class = {}
class.__index = class

function class:Destroy()
	self.DisplayModel:Destroy()
end

function class:NewDisplayModel(p)
	local clone = v:Clone()
	placePathWaypoint(clone, p)
	return clone
end

function class.new(p, closestWayPoint)
	local self = setmetatable({}, class)
	self.DisplayModel = self:NewDisplayModel(p)
	self.ClosestWayPoint = closestWayPoint
	return self
end

local class2 = {}
class2.__index = class2

function class2:Destroy()
	self.Destroyed = true
	self.Tween:Cancel()
	self.DisplayModel:Destroy()
end

function class2:NewDisplayModel(p)
	local clone = v2:Clone()
	placePathWaypoint(clone, p)
	return clone
end

function class2:CreateTween()
	local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, -1, true)
	local tween = TweenService:Create(self.DisplayModel.EndWaypointBillboard, tweenInfo, {
		SizeOffset = vector2
	})
	tween:Play()
	return tween
end

function class2:TweenInFrom(vector7: Vector3)
	local v4 = vector7 - self.DisplayModel.Position
	self.DisplayModel.EndWaypointBillboard.StudsOffset = Vector3.new(0, v4.Y, 0)
	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local tween = TweenService:Create(self.DisplayModel.EndWaypointBillboard, tweenInfo, {
		StudsOffset = createVector(0, 0, 0)
	})
	tween:Play()
	return tween
end

function class2.new(vector7: Vector3, closestWayPoint: number?, vector8: Vector3?)
	local object = setmetatable({}, class2)
	object.DisplayModel = object:NewDisplayModel(vector7)
	object.Destroyed = false

	if vector8 and (vector8 - vector7).Magnitude > 5 then
		object.Tween = object:TweenInFrom(vector8)
		coroutine.wrap(function()
			object.Tween.Completed:Wait()

			if not object.Destroyed then
				object.Tween = object:CreateTween()
			end
		end)()
	else
		object.Tween = object:CreateTween()
	end

	object.ClosestWayPoint = closestWayPoint
	return object
end

local class3 = {}
class3.__index = class3

function class3:Hide()
	self.DisplayModel.Parent = nil
end

function class3:Destroy()
	self.DisplayModel:Destroy()
end

function class3:NewDisplayModel(p)
	local clone = v3:Clone()
	placePathWaypoint(clone, p)
	placePathWaypoint(clone, p) -- inferred equivalent call
	return clone
end

function class3:RunFailureTween()
	wait(0.125)
	local tweenInfo = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local tween = TweenService:Create(self.DisplayModel.FailureWaypointBillboard, tweenInfo, {
		SizeOffset = vector4
	})
	tween:Play()
	TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame, tweenInfo, {
		Rotation = 10
	}):Play()
	tween.Completed:wait()
	local tweenInfo2 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true)
	local tween2 = TweenService:Create(self.DisplayModel.FailureWaypointBillboard, tweenInfo2, {
		SizeOffset = vector5
	})
	tween2:Play()
	local tweenInfo3 = TweenInfo.new(0.125, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 3, true)
	TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame.ImageLabel, tweenInfo3, {
		ImageColor3 = Color3.new(0.75, 0.75, 0.75)
	}):Play()
	TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame, tweenInfo3, {
		Rotation = -10
	}):Play()
	tween2.Completed:wait()
	local tweenInfo4 = TweenInfo.new(0.0625, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local tween3 = TweenService:Create(self.DisplayModel.FailureWaypointBillboard, tweenInfo4, {
		SizeOffset = vector3
	})
	tween3:Play()
	TweenService:Create(self.DisplayModel.FailureWaypointBillboard.Frame, tweenInfo4, {
		Rotation = 0
	}):Play()
	tween3.Completed:wait()
	wait(0.125)
end

function class3.new(p)
	local self = setmetatable({}, class3)
	self.DisplayModel = self:NewDisplayModel(p)
	return self
end

local animation = Instance.new("Animation")
animation.AnimationId = "rbxassetid://2874840706"
local track = nil

local function getFailureAnimationTrack(playerHumanoid) -- 1 equivalent call inferred from this helper
	if playerHumanoid == nil then
		return track
	end

	track = playerHumanoid:LoadAnimation(animation)
	assert(track, "")
	track.Priority = Enum.AnimationPriority.Action
	track.Looped = false
	return track
end

local function findPlayerHumanoid() -- 1 equivalent call inferred from this helper
	local character = LocalPlayer.Character

	if character then
		return character:FindFirstChildOfClass("Humanoid")
	end
end

local function createTrailDots(list, vector7: Vector3)
	local v4 = {}
	local v5 = 1

	for i = 1, #list - 1 do
		local v6 = (list[i].Position - list[#list].Position).Magnitude < 3
		local v7

		if i % 2 == 0 then
			v7 = not v6
		else
			v7 = false
		end

		if not v7 then
			continue
		end

		v4[v5] = class.new(list[i].Position, i)
		v5 += 1
	end

	table.insert(v4, (class2.new(list[#list].Position, #list, vector7)))
	local result = {}
	local v6 = 1

	for i = #v4, 1, -1 do
		result[v6] = v4[i]
		v6 += 1
	end

	return result
end

local function getTrailDotScale(p: number, point: Vector2) -- 1 equivalent call inferred from this helper
	return point * (math.clamp(p - 10, 0, 90) / 90 * 1.5 + 1)
end

local count = 0

function ClickToMoveDisplay.CreatePathDisplay(list, p)
	count += 1
	local trailDots = createTrailDots(list, p)

	local function removePathBeforePoint(p2)
		for i = #trailDots, 1, -1 do
			local trailDot = trailDots[i]

			if trailDot.ClosestWayPoint <= p2 then
				trailDot:Destroy()
				trailDots[i] = nil
			else
				break
			end
		end
	end

	local v4 = "ClickToMoveResizeTrail" .. count

	local function resizeTrailDots()
		if #trailDots == 0 then
			RunService:UnbindFromRenderStep(v4)
			return
		end

		local p2 = Workspace.CurrentCamera.CFrame.p

		for i = 1, #trailDots do
			local trailDotImage = trailDots[i].DisplayModel:FindFirstChild("TrailDotImage")

			if trailDotImage then
				trailDotImage.Size = getTrailDotScale((trailDots[i].DisplayModel.Position - p2).Magnitude, vector6) -- inferred equivalent call
			end
		end
	end

	RunService:BindToRenderStep(v4, Enum.RenderPriority.Camera.Value - 1, resizeTrailDots)

	local function removePath()
		removePathBeforePoint(#list)
	end

	return removePath, removePathBeforePoint
end

local v4 = nil

function ClickToMoveDisplay.DisplayFailureWaypoint(p)
	if v4 then
		v4:Hide()
	end

	local v5 = class3.new(p)
	v4 = v5
	coroutine.wrap(function()
		v5:RunFailureTween()
		v5:Destroy()
		v5 = nil
	end)()
end

function ClickToMoveDisplay.CreateEndWaypoint(p)
	return class2.new(p)
end

function ClickToMoveDisplay.PlayFailureAnimation()
	local playerHumanoid = findPlayerHumanoid() -- inferred equivalent call

	if playerHumanoid then
		getFailureAnimationTrack(playerHumanoid):Play() -- inferred equivalent call
	end
end

function ClickToMoveDisplay.CancelFailureAnimation()
	if track ~= nil and track.IsPlaying then
		track:Stop()
	end
end

function ClickToMoveDisplay.SetWaypointTexture(p)
	image = p
	v, v2, v3 = CreateWaypointTemplates()
end

function ClickToMoveDisplay.GetWaypointTexture()
	return image
end

function ClickToMoveDisplay.SetWaypointRadius(p)
	vector6 = Vector2.new(p, p)
	v, v2, v3 = CreateWaypointTemplates()
end

function ClickToMoveDisplay.GetWaypointRadius()
	return vector6.X
end

function ClickToMoveDisplay.SetEndWaypointTexture(p)
	image2 = p
	v, v2, v3 = CreateWaypointTemplates()
end

function ClickToMoveDisplay.GetEndWaypointTexture()
	return image2
end

function ClickToMoveDisplay.SetWaypointsAlwaysOnTop(p)
	alwaysOnTop = p
	v, v2, v3 = CreateWaypointTemplates()
end

function ClickToMoveDisplay.GetWaypointsAlwaysOnTop()
	return alwaysOnTop
end

return ClickToMoveDisplay