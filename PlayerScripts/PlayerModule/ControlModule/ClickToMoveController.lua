local createVector = vector.create
local success, result = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserExcludeNonCollidableForPathfinding")
end)
local v = success and result
local success2, result2 = pcall(function()
	return UserSettings():IsUserFeatureEnabled("UserClickToMoveSupportAgentCanClimb2")
end)
local v2 = success2 and result2
local UserInputService = game:GetService("UserInputService")
local PathfindingService = game:GetService("PathfindingService")
local Players = game:GetService("Players")
game:GetService("Debris")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local GuiService = game:GetService("GuiService")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local userFlag = FlagUtil.getUserFlag("UserRaycastUpdateAPI2")
local v3 = true
local v4 = true
local v5 = false
local v6 = 1
local v7 = 8
local v8 = {
	[Enum.KeyCode.W] = true,
	[Enum.KeyCode.A] = true,
	[Enum.KeyCode.S] = true,
	[Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true,
	[Enum.KeyCode.Down] = true
}
local LocalPlayer = Players.LocalPlayer
local ClickToMoveDisplay = require(script.Parent:WaitForChild("ClickToMoveDisplay"))
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
local v9 = {}

if not userFlag then
	local function FindCharacterAncestor(parent)
		if not parent then
			return
		end

		local humanoid = parent:FindFirstChildOfClass("Humanoid")

		if humanoid then
			return parent, humanoid
		end

		return FindCharacterAncestor(parent.Parent)
	end

	v9.FindCharacterAncestor = FindCharacterAncestor
	local function Raycast(p, flag: boolean, parts)
		local parts2 = parts or {}
		local part, v10, v11, v12 = Workspace:FindPartOnRayWithIgnoreList(p, parts2)

		if not part then
			return nil, nil
		end

		if not flag or part.CanCollide ~= false then
			return part, v10, v11, v12
		end

		local humanoid

		if part then
			humanoid = part:FindFirstChildOfClass("Humanoid")

			if not humanoid then
				local _
				_, humanoid = FindCharacterAncestor(part.Parent)
			end
		end

		if humanoid == nil then
			table.insert(parts2, part)
			return Raycast(p, flag, parts2)
		end

		return part, v10, v11, v12
	end

	v9.Raycast = Raycast
end

local v10 = {}

local function findPlayerHumanoid(player)
	local character = player and player.Character

	if not character then
		return
	end

	local v11 = v10[player]

	if v11 and v11.Parent == character then
		return v11
	end

	v10[player] = nil
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		v10[player] = humanoid
	end

	return humanoid
end

local result3 = nil
local v11 = nil
local connection = nil
local connection2 = nil

local function GetCharacter() -- 4 equivalent calls inferred from this helper
	return LocalPlayer and LocalPlayer.Character
end

local function UpdateIgnoreTag(p)
	if p == v11 then
		return
	end

	if connection then
		connection:Disconnect()
		connection = nil
	end

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

	v11 = p
	result3 = { GetCharacter() } -- inferred equivalent call

	if v11 ~= nil then
		local tagged = CollectionService:GetTagged(v11)

		for _, v12 in ipairs(tagged) do
			table.insert(result3, v12)
		end

		connection = CollectionService:GetInstanceAddedSignal(v11):Connect(function(p2)
			table.insert(result3, p2)
		end)
		connection2 = CollectionService:GetInstanceRemovedSignal(v11):Connect(function(p2)
			for i = 1, #result3 do
				if result3[i] ~= p2 then
					continue
				end

				result3[i] = result3[#result3]
				table.remove(result3)
				break
			end
		end)
	end
end

local function getIgnoreList() -- 4 equivalent calls inferred from this helper
	if result3 then
		return result3
	end

	result3 = {}
	assert(result3, "")
	table.insert(result3, GetCharacter()) -- inferred equivalent call
	return result3
end

local function minV(vector: Vector3, vector2: Vector3) -- 1 equivalent call inferred from this helper
	return (Vector3.new(math.min(vector.X, vector2.X), math.min(vector.Y, vector2.Y), (math.min(vector.Z, vector2.Z))))
end

local function maxV(data, data2) -- 1 equivalent call inferred from this helper
	return (Vector3.new(math.max(data.X, data2.X), math.max(data.Y, data2.Y), (math.max(data.Z, data2.Z))))
end

local function getCollidableExtentsSize(folder)
	if folder == nil or folder.PrimaryPart == nil then
		return
	end

	assert(folder, "")
	assert(folder.PrimaryPart, "")
	local inverse = folder.PrimaryPart.CFrame:Inverse()
	local v12 = createVector(1e999, 1e999, 1e999)
	local v13 = createVector(-1e999, -1e999, -1e999)

	for _, part in pairs(folder:GetDescendants()) do
		if not (part:IsA("BasePart") and part.CanCollide) then
			continue
		end

		local v14 = inverse * part.CFrame
		local vector = Vector3.new(part.Size.X / 2, part.Size.Y / 2, part.Size.Z / 2)
		local v15 = {
			Vector3.new(vector.X, vector.Y, vector.Z),
			Vector3.new(vector.X, vector.Y, -vector.Z),
			Vector3.new(vector.X, -vector.Y, vector.Z),
			Vector3.new(vector.X, -vector.Y, -vector.Z),
			Vector3.new(-vector.X, vector.Y, vector.Z),
			Vector3.new(-vector.X, vector.Y, -vector.Z),
			Vector3.new(-vector.X, -vector.Y, vector.Z),
			(Vector3.new(-vector.X, -vector.Y, -vector.Z))
		}

		for _, v16 in ipairs(v15) do
			local v17 = v14 * v16
			v12 = minV(v12, v17) -- inferred equivalent call
			v13 = maxV(v13, v17) -- inferred equivalent call
		end
	end

	local v14 = v13 - v12

	if v14.X < 0 or v14.Y < 0 or v14.Z < 0 then
		return nil
	end

	return v14
end

local function Pather(p, targetSurfaceNormal, directPath: boolean?)
	local class = {}
	local directPath2

	if directPath == nil then
		directPath2 = v5
		directPath = true
	else
		directPath2 = directPath
	end

	class.Cancelled = false
	class.Started = false
	class.Finished = Instance.new("BindableEvent")
	class.PathFailed = Instance.new("BindableEvent")
	class.PathComputing = false
	class.PathComputed = false
	class.OriginalTargetPoint = p
	class.TargetPoint = p
	class.TargetSurfaceNormal = targetSurfaceNormal
	class.DiedConn = nil
	class.SeatedConn = nil
	class.BlockedConn = nil
	class.TeleportedConn = nil
	class.CurrentPoint = 0
	class.HumanoidOffsetFromPath = createVector(0, 0, 0)
	class.CurrentWaypointPosition = nil
	class.CurrentWaypointPlaneNormal = createVector(0, 0, 0)
	class.CurrentWaypointPlaneDistance = 0
	class.CurrentWaypointNeedsJump = false
	class.CurrentHumanoidPosition = createVector(0, 0, 0)
	class.CurrentHumanoidVelocity = 0
	class.NextActionMoveDirection = createVector(0, 0, 0)
	class.NextActionJump = false
	class.Timeout = 0
	local localPlayer = LocalPlayer
	local character = localPlayer and localPlayer.Character
	local humanoid

	if character then
		humanoid = v10[localPlayer]

		if not humanoid or humanoid.Parent ~= character then
			v10[localPlayer] = nil
			humanoid = character:FindFirstChildOfClass("Humanoid")

			if humanoid then
				v10[localPlayer] = humanoid
			end
		end
	end

	class.Humanoid = humanoid
	class.OriginPoint = nil
	class.AgentCanFollowPath = false
	class.DirectPath = false
	class.DirectPathRiseFirst = false
	class.stopTraverseFunc = nil
	class.setPointFunc = nil
	class.pointList = nil
	local rootPart = class.Humanoid and class.Humanoid.RootPart

	if rootPart then
		class.OriginPoint = rootPart.CFrame.Position
		local agentRadius = 2
		local agentHeight = 5
		local agentCanJump = true
		local seatPart = class.Humanoid.SeatPart

		if seatPart and seatPart:IsA("VehicleSeat") then
			local model = seatPart:FindFirstAncestorOfClass("Model")

			if model then
				local primaryPart = model.PrimaryPart
				model.PrimaryPart = seatPart

				if directPath then
					local extentsSize = model:GetExtentsSize()
					agentRadius = v6 * 0.5 * math.sqrt(extentsSize.X * extentsSize.X + extentsSize.Z * extentsSize.Z)
					agentHeight = v6 * extentsSize.Y
					class.AgentCanFollowPath = true
					class.DirectPath = directPath
					agentCanJump = false
				end

				model.PrimaryPart = primaryPart
			end
		else
			local extentsSize = nil

			if v then
				local character2 = GetCharacter() -- inferred equivalent call

				if character2 ~= nil then
					extentsSize = getCollidableExtentsSize(character2)
				end
			end

			if extentsSize == nil then
				extentsSize = GetCharacter():GetExtentsSize() -- inferred equivalent call
			end

			assert(extentsSize, "")
			agentRadius = v6 * 0.5 * math.sqrt(extentsSize.X * extentsSize.X + extentsSize.Z * extentsSize.Z)
			agentHeight = v6 * extentsSize.Y
			agentCanJump = class.Humanoid.JumpPower > 0
			class.AgentCanFollowPath = true
			class.DirectPath = directPath2
			class.DirectPathRiseFirst = class.Humanoid.Sit
		end

		if v2 then
			class.pathResult = PathfindingService:CreatePath({
				AgentRadius = agentRadius,
				AgentHeight = agentHeight,
				AgentCanJump = agentCanJump,
				AgentCanClimb = true
			})
		else
			class.pathResult = PathfindingService:CreatePath({
				AgentRadius = agentRadius,
				AgentHeight = agentHeight,
				AgentCanJump = agentCanJump
			})
		end
	end

	function class:Cleanup()
		if class.stopTraverseFunc then
			class.stopTraverseFunc()
			class.stopTraverseFunc = nil
		end

		if class.BlockedConn then
			class.BlockedConn:Disconnect()
			class.BlockedConn = nil
		end

		if class.DiedConn then
			class.DiedConn:Disconnect()
			class.DiedConn = nil
		end

		if class.SeatedConn then
			class.SeatedConn:Disconnect()
			class.SeatedConn = nil
		end

		if class.TeleportedConn then
			class.TeleportedConn:Disconnect()
			class.TeleportedConn = nil
		end

		class.Started = false
	end

	function class:Cancel()
		class.Cancelled = true
		class:Cleanup()
	end

	function class:IsActive()
		return class.AgentCanFollowPath and class.Started and not class.Cancelled
	end

	function class:OnPathInterrupted()
		class.Cancelled = true
		class:OnPointReached(false)
	end

	function class:ComputePath()
		if class.OriginPoint then
			if class.PathComputed or class.PathComputing then
				return
			end

			class.PathComputing = true

			if class.AgentCanFollowPath then
				if class.DirectPath then
					class.pointList = {
						PathWaypoint.new(class.OriginPoint, Enum.PathWaypointAction.Walk),
						PathWaypoint.new(
							class.TargetPoint,
							class.DirectPathRiseFirst and Enum.PathWaypointAction.Jump or Enum.PathWaypointAction.Walk
						)
					}
					class.PathComputed = true
				else
					class.pathResult:ComputeAsync(class.OriginPoint, class.TargetPoint)
					class.pointList = class.pathResult:GetWaypoints()
					class.BlockedConn = class.pathResult.Blocked:Connect(function(p2)
						class:OnPathBlocked(p2)
					end)
					class.PathComputed = class.pathResult.Status == Enum.PathStatus.Success
				end
			end

			class.PathComputing = false
		end
	end

	function class:IsValidPath()
		class:ComputePath()
		return class.PathComputed and class.AgentCanFollowPath
	end

	class.Recomputing = false

	function class:OnPathBlocked(p2)
		if not (class.CurrentPoint <= p2) or class.Recomputing then
			return
		end

		class.Recomputing = true

		if class.stopTraverseFunc then
			class.stopTraverseFunc()
			class.stopTraverseFunc = nil
		end

		class.OriginPoint = class.Humanoid.RootPart.CFrame.p
		class.pathResult:ComputeAsync(class.OriginPoint, class.TargetPoint)
		class.pointList = class.pathResult:GetWaypoints()

		if #class.pointList > 0 then
			class.HumanoidOffsetFromPath = class.pointList[1].Position - class.OriginPoint
		end

		class.PathComputed = class.pathResult.Status == Enum.PathStatus.Success

		if v3 then
			local v12 = class
			local v13 = class
			local pathDisplay, setPointFunc = ClickToMoveDisplay.CreatePathDisplay(class.pointList)
			v12.stopTraverseFunc = pathDisplay
			v13.setPointFunc = setPointFunc
		end

		if class.PathComputed then
			class.CurrentPoint = 1
			class:OnPointReached(true)
		else
			class.PathFailed:Fire()
			class:Cleanup()
		end

		class.Recomputing = false
	end

	function class:OnRenderStepped(p2: number)
		if class.Started and not class.Cancelled then
			class.Timeout += p2
			local timeout = class.Timeout

			if v7 < timeout then
				class:OnPointReached(false)
				return
			end

			class.CurrentHumanoidPosition = class.Humanoid.RootPart.Position + class.HumanoidOffsetFromPath
			class.CurrentHumanoidVelocity = class.Humanoid.RootPart.Velocity

			while class.Started and class:IsCurrentWaypointReached() do
				class:OnPointReached(true)
			end

			if class.Started then
				class.NextActionMoveDirection = class.CurrentWaypointPosition - class.CurrentHumanoidPosition

				if class.NextActionMoveDirection.Magnitude > 1e-6 then
					class.NextActionMoveDirection = class.NextActionMoveDirection.Unit
				else
					class.NextActionMoveDirection = createVector(0, 0, 0)
				end

				if class.CurrentWaypointNeedsJump then
					class.NextActionJump = true
					class.CurrentWaypointNeedsJump = false
				else
					class.NextActionJump = false
				end
			end
		end
	end

	function class:IsCurrentWaypointReached()
		local v12 = class.CurrentWaypointPlaneNormal == createVector(0, 0, 0)
			or class.CurrentWaypointPlaneNormal:Dot(class.CurrentHumanoidPosition) - class.CurrentWaypointPlaneDistance < math.max(
				1,
				0.0625 * -class.CurrentWaypointPlaneNormal:Dot(class.CurrentHumanoidVelocity)
			)

		if v12 then
			class.CurrentWaypointPosition = nil
			class.CurrentWaypointPlaneNormal = createVector(0, 0, 0)
			class.CurrentWaypointPlaneDistance = 0
		end

		return v12
	end

	function class:OnPointReached(p2)
		if p2 and not class.Cancelled then
			if class.setPointFunc then
				class.setPointFunc(class.CurrentPoint)
			end

			local v12 = class.CurrentPoint + 1

			if #class.pointList < v12 then
				if class.stopTraverseFunc then
					class.stopTraverseFunc()
				end

				class.Finished:Fire()
				class:Cleanup()
			else
				local v13 = class.pointList[class.CurrentPoint]
				local v14 = class.pointList[v12]
				local state = class.Humanoid:GetState()

				if
					state == Enum.HumanoidStateType.FallingDown
					or state == Enum.HumanoidStateType.Freefall
					or state == Enum.HumanoidStateType.Jumping
				then
					local v15 = v14.Action == Enum.PathWaypointAction.Jump

					if not v15 and class.CurrentPoint > 1 then
						local v16 = class.pointList[class.CurrentPoint - 1]
						local v17 = v13.Position - v16.Position
						local v18 = v14.Position - v13.Position
						v15 = Vector2.new(v17.x, v17.z).Unit:Dot(Vector2.new(v18.x, v18.z).Unit) < 0.996
					end

					if v15 then
						class.Humanoid.FreeFalling:Wait()
						wait(0.1)
					end
				end

				class:MoveToNextWayPoint(v13, v14, v12)
			end
		else
			class.PathFailed:Fire()
			class:Cleanup()
		end
	end

	function class:MoveToNextWayPoint(p2, data, currentPoint: number)
		class.CurrentWaypointPlaneNormal = p2.Position - data.Position

		if not v2 or data.Label ~= "Climb" then
			class.CurrentWaypointPlaneNormal = Vector3.new(
				class.CurrentWaypointPlaneNormal.X,
				0,
				class.CurrentWaypointPlaneNormal.Z
			)
		end

		if class.CurrentWaypointPlaneNormal.Magnitude > 1e-6 then
			class.CurrentWaypointPlaneNormal = class.CurrentWaypointPlaneNormal.Unit
			class.CurrentWaypointPlaneDistance = class.CurrentWaypointPlaneNormal:Dot(data.Position)
		else
			class.CurrentWaypointPlaneNormal = createVector(0, 0, 0)
			class.CurrentWaypointPlaneDistance = 0
		end

		class.CurrentWaypointNeedsJump = data.Action == Enum.PathWaypointAction.Jump
		class.CurrentWaypointPosition = data.Position
		class.CurrentPoint = currentPoint
		class.Timeout = 0
	end

	function class:Start(p2)
		if not class.AgentCanFollowPath then
			class.PathFailed:Fire()
			return
		end

		if class.Started then
			return
		end

		class.Started = true
		ClickToMoveDisplay.CancelFailureAnimation()

		if v3 and (p2 == nil or p2) then
			local v12 = class
			local v13 = class
			local pathDisplay, setPointFunc = ClickToMoveDisplay.CreatePathDisplay(
				class.pointList,
				class.OriginalTargetPoint
			)
			v12.stopTraverseFunc = pathDisplay
			v13.setPointFunc = setPointFunc
		end

		if #class.pointList > 0 then
			class.HumanoidOffsetFromPath = Vector3.new(0, class.pointList[1].Position.Y - class.OriginPoint.Y, 0)
			class.CurrentHumanoidPosition = class.Humanoid.RootPart.Position + class.HumanoidOffsetFromPath
			class.CurrentHumanoidVelocity = class.Humanoid.RootPart.Velocity
			class.SeatedConn = class.Humanoid.Seated:Connect(function(_, _)
				class:OnPathInterrupted()
			end)
			class.DiedConn = class.Humanoid.Died:Connect(function()
				class:OnPathInterrupted()
			end)
			class.TeleportedConn = class.Humanoid.RootPart:GetPropertyChangedSignal("CFrame"):Connect(function()
				class:OnPathInterrupted()
			end)
			class.CurrentPoint = 1
			class:OnPointReached(true)
		else
			class.PathFailed:Fire()

			if class.stopTraverseFunc then
				class.stopTraverseFunc()
			end
		end
	end

	local v12 = class.TargetPoint + class.TargetSurfaceNormal * 1.5

	if userFlag then
		raycastParams.FilterDescendantsInstances = getIgnoreList() -- inferred equivalent call
		local raycastResult = Workspace:Raycast(v12, createVector(-0, -50, -0), raycastParams)

		if raycastResult then
			class.TargetPoint = raycastResult.Position
		end
	else
		local part, targetPoint = Workspace:FindPartOnRayWithIgnoreList(
			Ray.new(v12, createVector(0, -50, 0)),
			getIgnoreList() -- inferred equivalent call
		)

		if part then
			class.TargetPoint = targetPoint
		end
	end

	class:ComputePath()
	return class
end

local function CheckAlive() -- 1 equivalent call inferred from this helper
	local localPlayer = LocalPlayer
	local character = localPlayer and localPlayer.Character
	local humanoid

	if not character then
		return humanoid ~= nil and humanoid.Health > 0
	end

	humanoid = v10[localPlayer]

	if not humanoid or humanoid.Parent ~= character then
		v10[localPlayer] = nil
		humanoid = character:FindFirstChildOfClass("Humanoid")

		if humanoid then
			v10[localPlayer] = humanoid
		end
	end

	return humanoid ~= nil and humanoid.Health > 0
end

local function GetEquippedTool(instance)
	if instance ~= nil then
		for _, tool in pairs(instance:GetChildren()) do
			if tool:IsA("Tool") then
				return tool
			end
		end
	end
end

local v12 = nil
local eventConnection = nil
local eventConnection2 = nil

local function CleanupPath() -- 10 equivalent calls inferred from this helper
	if v12 then
		v12:Cancel()
		v12 = nil
	end

	if eventConnection then
		eventConnection:Disconnect()
		eventConnection = nil
	end

	if eventConnection2 then
		eventConnection2:Disconnect()
		eventConnection2 = nil
	end
end

local function HandleMoveTo(object, p, p2, character, p3)
	if v12 then
		CleanupPath() -- inferred equivalent call
	end

	v12 = object
	object:Start(p3)
	eventConnection = object.Finished.Event:Connect(function()
		CleanupPath() -- inferred equivalent call
		local v13 = p2 and GetEquippedTool(character)

		if v13 then
			v13:Activate()
		end
	end)
	eventConnection2 = object.PathFailed.Event:Connect(function()
		CleanupPath() -- inferred equivalent call

		if p3 == nil or p3 then
			local v13 = v4

			if v13 then
				v13 = not (v12 and v12:IsActive())
			end

			if v13 then
				ClickToMoveDisplay.PlayFailureAnimation()
			end

			ClickToMoveDisplay.DisplayFailureWaypoint(p)
		end
	end)
end

local function ShowPathFailedFeedback(p) -- 2 equivalent calls inferred from this helper
	if v12 and v12:IsActive() then
		v12:Cancel()
	end

	if v4 then
		ClickToMoveDisplay.PlayFailureAnimation()
	end

	ClickToMoveDisplay.DisplayFailureWaypoint(p)
end

function OnTap(list, vector: Vector3?, flag: boolean?)
	local currentCamera = Workspace.CurrentCamera
	local character = LocalPlayer.Character

	if not CheckAlive() then -- inferred equivalent call
		return
	end

	if #list == 1 or vector then
		if currentCamera then
			local screenPointToRay = currentCamera:ScreenPointToRay(list[1].X, list[1].Y)

			if userFlag then
				local humanoid = nil
				local v13 = nil
				local ignoreList = getIgnoreList() -- inferred equivalent call

				if not ignoreList then
					ignoreList = {}
				end

				local raycastResult

				repeat
					local flag2 = true
					raycastParams.FilterDescendantsInstances = ignoreList
					raycastResult = Workspace:Raycast(
						screenPointToRay.Origin,
						screenPointToRay.Direction * 1000,
						raycastParams
					)

					if raycastResult then
						local instance = raycastResult.Instance

						if not instance.CanCollide then
							local parent

							while true do
								humanoid = instance:FindFirstChildOfClass("Humanoid")
								parent = instance.Parent

								if humanoid or not parent then
									break
								end

								instance = parent
							end

							if humanoid or not parent then
								v13 = instance
							else
								table.insert(ignoreList, parent)
								flag2 = false
								v13 = nil
							end
						end
					end
				until flag2

				if
					flag
					and humanoid
					and StarterGui:GetCore("AvatarContextMenuEnabled")
					and Players:GetPlayerFromCharacter(humanoid.Parent)
				then
					CleanupPath() -- inferred equivalent call
				else
					if not (raycastResult and character) then
						return
					end

					local position = raycastResult.Position

					if vector then
						position = vector
						v13 = nil
					end

					CleanupPath() -- inferred equivalent call
					local pather = Pather(position, raycastResult.Normal)

					if pather:IsValidPath() then
						HandleMoveTo(pather, position, v13, character)
						return
					end

					pather:Cleanup()
					ShowPathFailedFeedback(position) -- inferred equivalent call
				end
			else
				local ray = Ray.new(screenPointToRay.Origin, screenPointToRay.Direction * 1000)
				local v13, v14, v15 = v9.Raycast(ray, true, getIgnoreList()) -- inferred equivalent call
				local characterAncestor, v16 = v9.FindCharacterAncestor(v13)

				if
					flag
					and v16
					and StarterGui:GetCore("AvatarContextMenuEnabled")
					and Players:GetPlayerFromCharacter(v16.Parent)
				then
					CleanupPath() -- inferred equivalent call
				else
					if vector then
						v14 = vector
						characterAncestor = nil
					end

					if v14 and character then
						CleanupPath() -- inferred equivalent call
						local pather = Pather(v14, v15)

						if pather:IsValidPath() then
							HandleMoveTo(pather, v14, characterAncestor, character)
							return
						end

						pather:Cleanup()
						ShowPathFailedFeedback(v14) -- inferred equivalent call
					end
				end
			end
		end
	else
		local v13 = #list >= 2 and currentCamera and GetEquippedTool(character)

		if v13 then
			v13:Activate()
		end
	end
end

local function DisconnectEvent(connection3) -- 12 equivalent calls inferred from this helper
	if connection3 then
		connection3:Disconnect()
	end
end

local Keyboard = require(script.Parent:WaitForChild("Keyboard"))
local object = setmetatable({}, Keyboard)
object.__index = object

function object.new(p)
	local self = setmetatable(Keyboard.new(p), object)
	self.fingerTouches = {}
	self.numUnsunkTouches = 0
	self.mouse2DownTime = tick()
	self.mouse2DownPos = Vector2.new()
	self.mouse2UpTime = tick()
	self.keyboardMoveVector = createVector(0, 0, 0)
	self.tapConn = nil
	self.inputBeganConn = nil
	self.inputChangedConn = nil
	self.inputEndedConn = nil
	self.humanoidDiedConn = nil
	self.characterChildAddedConn = nil
	self.onCharacterAddedConn = nil
	self.characterChildRemovedConn = nil
	self.renderSteppedConn = nil
	self.menuOpenedConnection = nil
	self.preferredInputChangedConnection = nil
	self.running = false
	self.wasdEnabled = false
	return self
end

function object:DisconnectEvents()
	DisconnectEvent(self.tapConn) -- inferred equivalent call
	DisconnectEvent(self.inputBeganConn) -- inferred equivalent call
	DisconnectEvent(self.inputChangedConn) -- inferred equivalent call
	DisconnectEvent(self.inputEndedConn) -- inferred equivalent call
	DisconnectEvent(self.humanoidDiedConn) -- inferred equivalent call
	DisconnectEvent(self.characterChildAddedConn) -- inferred equivalent call
	DisconnectEvent(self.onCharacterAddedConn) -- inferred equivalent call
	DisconnectEvent(self.renderSteppedConn) -- inferred equivalent call
	DisconnectEvent(self.characterChildRemovedConn) -- inferred equivalent call
	DisconnectEvent(self.menuOpenedConnection) -- inferred equivalent call
	DisconnectEvent(self.preferredInputChangedConnection) -- inferred equivalent call
end

function object:OnTouchBegan(p, p2)
	if self.fingerTouches[p] == nil and not p2 then
		self.numUnsunkTouches += 1
	end

	self.fingerTouches[p] = p2
end

function object:OnTouchChanged(p, p2)
	if self.fingerTouches[p] == nil then
		self.fingerTouches[p] = p2

		if not p2 then
			self.numUnsunkTouches += 1
		end
	end
end

function object:OnTouchEnded(p, _)
	if self.fingerTouches[p] ~= nil and self.fingerTouches[p] == false then
		self.numUnsunkTouches -= 1
	end

	self.fingerTouches[p] = nil
end

function object:OnPreferredInputChanged()
	local character = LocalPlayer.Character

	if character then
		local manualActivationOnly = UserInputService.PreferredInput == Enum.PreferredInput.Touch

		for _, tool in pairs(character:GetChildren()) do
			if tool:IsA("Tool") then
				tool.ManualActivationOnly = manualActivationOnly
			end
		end
	end
end

function object:OnCharacterAdded(instance)
	self:DisconnectEvents()
	self.inputBeganConn = UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.Touch then
			self:OnTouchBegan(input, gameProcessed)
		end

		if
			self.wasdEnabled
			and gameProcessed == false
			and input.UserInputType == Enum.UserInputType.Keyboard
			and v8[input.KeyCode]
		then
			CleanupPath() -- inferred equivalent call
			ClickToMoveDisplay.CancelFailureAnimation()
		end

		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			self.mouse2DownTime = tick()
			self.mouse2DownPos = input.Position
		end
	end)
	self.inputChangedConn = UserInputService.InputChanged:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.Touch then
			self:OnTouchChanged(input, gameProcessed)
		end
	end)
	self.inputEndedConn = UserInputService.InputEnded:Connect(function(input, gameProcessed)
		if input.UserInputType == Enum.UserInputType.Touch then
			self:OnTouchEnded(input, gameProcessed)
		end

		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			self.mouse2UpTime = tick()
			local position = input.Position
			local v13 = v12 or self.keyboardMoveVector.Magnitude <= 0

			if
				self.mouse2UpTime - self.mouse2DownTime < 0.25
				and (position - self.mouse2DownPos).magnitude < 5
				and v13
			then
				OnTap({ position })
			end
		end
	end)
	self.tapConn = UserInputService.TouchTap:Connect(function(p, p2)
		if not p2 then
			OnTap(p, nil, true)
		end
	end)
	self.menuOpenedConnection = GuiService.MenuOpened:Connect(function()
		if v12 then
			v12:Cancel()
			v12 = nil
		end

		if eventConnection then
			eventConnection:Disconnect()
			eventConnection = nil
		end

		if eventConnection2 then
			eventConnection2:Disconnect()
			eventConnection2 = nil
		end
	end)

	local function OnCharacterChildAdded(child)
		if UserInputService.PreferredInput == Enum.PreferredInput.Touch and child:IsA("Tool") then
			child.ManualActivationOnly = true
		end

		if child:IsA("Humanoid") then
			DisconnectEvent(self.humanoidDiedConn) -- inferred equivalent call
			self.humanoidDiedConn = child.Died:Connect(function() end)
		end
	end

	self.characterChildAddedConn = instance.ChildAdded:Connect(function(child)
		OnCharacterChildAdded(child)
	end)
	self.characterChildRemovedConn = instance.ChildRemoved:Connect(function(tool)
		if UserInputService.PreferredInput == Enum.PreferredInput.Touch and tool:IsA("Tool") then
			tool.ManualActivationOnly = false
		end
	end)

	for _, child in pairs(instance:GetChildren()) do
		OnCharacterChildAdded(child)
	end

	self.preferredInputChangedConnection = UserInputService:GetPropertyChangedSignal("PreferredInput"):Connect(function()
		self:OnPreferredInputChanged()
	end)
end

function object:Start()
	self:Enable(true)
end

function object:Stop()
	self:Enable(false)
end

function object.CleanupPath(_)
	CleanupPath() -- inferred equivalent call
end

function object:Enable(enabled: boolean, flag: boolean, touchJumpController)
	if enabled then
		if not self.running then
			if LocalPlayer.Character then
				self:OnCharacterAdded(LocalPlayer.Character)
			end

			self.onCharacterAddedConn = LocalPlayer.CharacterAdded:Connect(function(character)
				self:OnCharacterAdded(character)
			end)
			self.running = true
		end

		self.touchJumpController = touchJumpController

		if self.touchJumpController then
			self.touchJumpController:Enable(self.jumpEnabled)
		end
	else
		if self.running then
			self:DisconnectEvents()
			CleanupPath() -- inferred equivalent call

			if UserInputService.PreferredInput == Enum.PreferredInput.Touch then
				local character = LocalPlayer.Character

				if character then
					for _, tool in pairs(character:GetChildren()) do
						if tool:IsA("Tool") then
							tool.ManualActivationOnly = false
						end
					end
				end
			end

			self.running = false
		end

		if self.touchJumpController and not self.jumpEnabled then
			self.touchJumpController:Enable(true)
		end

		self.touchJumpController = nil
	end

	Keyboard.Enable(self, enabled)
	self.wasdEnabled = enabled and flag or false
	self.enabled = enabled
end

function object:OnRenderStepped(p)
	self.isJumping = false

	if v12 then
		v12:OnRenderStepped(p)

		if v12 then
			self.moveVector = v12.NextActionMoveDirection
			self.moveVectorIsCameraRelative = false

			if v12.NextActionJump then
				self.isJumping = true
			end
		else
			self.moveVector = self.keyboardMoveVector
			self.moveVectorIsCameraRelative = true
		end
	else
		self.moveVector = self.keyboardMoveVector
		self.moveVectorIsCameraRelative = true
	end

	if self.jumpRequested then
		self.isJumping = true
	end
end

function object:UpdateMovement(p)
	if p == Enum.UserInputState.Cancel then
		self.keyboardMoveVector = createVector(0, 0, 0)
	elseif self.wasdEnabled then
		self.keyboardMoveVector = Vector3.new(
			self.leftValue + self.rightValue,
			0,
			self.forwardValue + self.backwardValue
		)
	end
end

function object.UpdateJump(_) end

function object.SetShowPath(_, p)
	v3 = p
end

function object.GetShowPath(_)
	return v3
end

function object.SetWaypointTexture(_, p)
	ClickToMoveDisplay.SetWaypointTexture(p)
end

function object.GetWaypointTexture(_)
	return ClickToMoveDisplay.GetWaypointTexture()
end

function object.SetWaypointRadius(_, p)
	ClickToMoveDisplay.SetWaypointRadius(p)
end

function object.GetWaypointRadius(_)
	return ClickToMoveDisplay.GetWaypointRadius()
end

function object.SetEndWaypointTexture(_, p)
	ClickToMoveDisplay.SetEndWaypointTexture(p)
end

function object.GetEndWaypointTexture(_)
	return ClickToMoveDisplay.GetEndWaypointTexture()
end

function object.SetWaypointsAlwaysOnTop(_, p)
	ClickToMoveDisplay.SetWaypointsAlwaysOnTop(p)
end

function object.GetWaypointsAlwaysOnTop(_)
	return ClickToMoveDisplay.GetWaypointsAlwaysOnTop()
end

function object.SetFailureAnimationEnabled(_, p)
	v4 = p
end

function object.GetFailureAnimationEnabled(_)
	return v4
end

function object.SetIgnoredPartsTag(_, p)
	UpdateIgnoreTag(p)
end

function object.GetIgnoredPartsTag(_)
	return v11
end

function object.SetUseDirectPath(_, p)
	v5 = p
end

function object.GetUseDirectPath(_)
	return v5
end

function object.SetAgentSizeIncreaseFactor(_, p: number)
	v6 = p / 100 + 1
end

function object.GetAgentSizeIncreaseFactor(_)
	return (v6 - 1) * 100
end

function object.SetUnreachableWaypointTimeout(_, p)
	v7 = p
end

function object.GetUnreachableWaypointTimeout(_)
	return v7
end

function object:SetUserJumpEnabled(jumpEnabled)
	self.jumpEnabled = jumpEnabled

	if self.touchJumpController then
		self.touchJumpController:Enable(jumpEnabled)
	end
end

function object.GetUserJumpEnabled(p)
	return p.jumpEnabled
end

function object.MoveTo(_, p, p2, p3)
	local character = LocalPlayer.Character

	if character == nil then
		return false
	end

	local pather = Pather(p, createVector(0, 1, 0), p3)

	if pather and pather:IsValidPath() then
		HandleMoveTo(pather, p, nil, character, p2)
		return true
	else
		return false
	end
end

return object