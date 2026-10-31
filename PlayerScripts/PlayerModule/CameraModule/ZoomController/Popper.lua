local Players = game:GetService("Players")
local CommonUtils = script.Parent.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local CameraWrapper = require(CommonUtils:WaitForChild("CameraWrapper"))
local ConnectionUtil = require(CommonUtils:WaitForChild("ConnectionUtil"))
local userFlag = FlagUtil.getUserFlag("UserRaycastUpdateAPI2")
local userFlag2 = FlagUtil.getUserFlag("UserCurrentCameraUpdate2")
local userFlag3 = FlagUtil.getUserFlag("UserPlayerConnectionMemoryLeak")
local v

if userFlag2 then
	v = CameraWrapper.new()
else
	v = nil
end

local currentCamera

if userFlag2 then
	currentCamera = nil
else
	currentCamera = game.Workspace.CurrentCamera
end

if userFlag2 then
	v:Enable()
end

local min = math.min
local tan = math.tan
local rad = math.rad
local new = Ray.new
local raycastParams = RaycastParams.new()
raycastParams.IgnoreWater = true
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
raycastParams.RespectCanCollide = true
local raycastParams2 = RaycastParams.new()
raycastParams2.IgnoreWater = true
raycastParams2.FilterType = Enum.RaycastFilterType.Include
local v2

if userFlag3 then
	v2 = ConnectionUtil.new()
else
	v2 = nil
end

local function getTotalTransparency(trussPart) -- 1 equivalent call inferred from this helper
	return 1 - (1 - trussPart.Transparency) * (1 - trussPart.LocalTransparencyModifier)
end

local function eraseFromEnd(list, p) -- 3 equivalent calls inferred from this helper
	for i = #list, p + 1, -1 do
		list[i] = nil
	end
end

local v3 = nil
local v4 = nil
local nearPlaneZ

if userFlag2 then
	local function updateProjection()
		local camera = v:getCamera()
		local v5 = rad(camera.FieldOfView)
		local viewportSize = camera.ViewportSize
		local v6 = viewportSize.X / viewportSize.Y
		v4 = tan(v5 / 2) * 2
		v3 = v6 * v4
	end

	v:Connect("FieldOfView", updateProjection)
	v:Connect("ViewportSize", updateProjection)
	local camera = v:getCamera()
	local fieldOfView = rad(camera.FieldOfView)
	local viewportSize = camera.ViewportSize
	local v5 = viewportSize.X / viewportSize.Y
	v4 = tan(fieldOfView / 2) * 2
	v3 = v5 * v4
	nearPlaneZ = v:getCamera().NearPlaneZ
	v:Connect("NearPlaneZ", function()
		nearPlaneZ = v:getCamera().NearPlaneZ
	end)
else
	local function updateProjection()
		local v5 = rad(currentCamera.FieldOfView)
		local viewportSize = currentCamera.ViewportSize
		local v6 = viewportSize.X / viewportSize.Y
		v4 = tan(v5 / 2) * 2
		v3 = v6 * v4
	end

	currentCamera:GetPropertyChangedSignal("FieldOfView"):Connect(updateProjection)
	currentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateProjection)
	local fieldOfView = rad(currentCamera.FieldOfView)
	local viewportSize = currentCamera.ViewportSize
	local v5 = viewportSize.X / viewportSize.Y
	v4 = tan(fieldOfView / 2) * 2
	v3 = v5 * v4
	nearPlaneZ = currentCamera.NearPlaneZ
	currentCamera:GetPropertyChangedSignal("NearPlaneZ"):Connect(function()
		nearPlaneZ = currentCamera.NearPlaneZ
	end)
end

local filterDescendantsInstances = {}
local v5 = {}

local function refreshIgnoreList() -- 3 equivalent calls inferred from this helper
	local v6 = 1
	filterDescendantsInstances = {}

	for _, v7 in pairs(v5) do
		filterDescendantsInstances[v6] = v7
		v6 += 1
	end
end

local function playerAdded(player)
	local function characterAdded(character) -- 2 equivalent calls inferred from this helper
		v5[player] = character
		refreshIgnoreList() -- inferred equivalent call
	end

	local function characterRemoving()
		characterAdded(nil) -- inferred equivalent call
	end

	if userFlag3 then
		v2:trackConnection(`{player.UserId}CharacterAdded`, player.CharacterAdded:Connect(characterAdded))
		v2:trackConnection(`{player.UserId}CharacterRemoving`, player.CharacterRemoving:Connect(characterRemoving))
	else
		player.CharacterAdded:Connect(characterAdded)
		player.CharacterRemoving:Connect(characterRemoving)
	end

	if player.Character then
		characterAdded(player.Character) -- inferred equivalent call
	end
end

local function playerRemoving(p)
	v5[p] = nil
	refreshIgnoreList() -- inferred equivalent call

	if userFlag3 then
		v2:disconnect(`{p.UserId}CharacterAdded`)
		v2:disconnect(`{p.UserId}CharacterRemoving`)
	end
end

Players.PlayerAdded:Connect(playerAdded)
Players.PlayerRemoving:Connect(playerRemoving)

for _, v6 in ipairs(Players:GetPlayers()) do
	playerAdded(v6)
end

refreshIgnoreList() -- inferred equivalent call
local rootPart = nil
local rootPart2 = nil

if userFlag2 then
	v:Connect("CameraSubject", function()
		local cameraSubject = v:getCamera().CameraSubject

		if cameraSubject and cameraSubject:IsA("Humanoid") then
			rootPart2 = cameraSubject.RootPart
		elseif cameraSubject and cameraSubject:IsA("BasePart") then
			rootPart2 = cameraSubject
		else
			rootPart2 = nil
		end
	end)
else
	currentCamera:GetPropertyChangedSignal("CameraSubject"):Connect(function()
		local cameraSubject = currentCamera.CameraSubject

		if cameraSubject:IsA("Humanoid") then
			rootPart2 = cameraSubject.RootPart
		elseif cameraSubject:IsA("BasePart") then
			rootPart2 = cameraSubject
		else
			rootPart2 = nil
		end
	end)
end

local function canOcclude(trussPart) -- 2 equivalent calls inferred from this helper
	local v6

	if getTotalTransparency(trussPart) < 0.25 then -- inferred equivalent call
		v6 = userFlag or trussPart.CanCollide

		if v6 then
			if rootPart == (trussPart:GetRootPart() or trussPart) then
				return false
			else
				return not trussPart:IsA("TrussPart")
			end
		end
	else
		return false
	end

	return v6
end

local v6 = {
	Vector2.new(0.4, 0),
	Vector2.new(-0.4, 0),
	Vector2.new(0, -0.4),
	Vector2.new(0, 0.4),
	Vector2.new(0, 0.2)
}

local function getCollisionPoint(p, p2)
	if userFlag then
		raycastParams.FilterDescendantsInstances = filterDescendantsInstances
		local raycastResult = workspace:Raycast(p, p2, raycastParams)

		if raycastResult then
			return raycastResult.Position, true
		end
	else
		local count = #filterDescendantsInstances

		repeat
			local part, v7 = workspace:FindPartOnRayWithIgnoreList(new(p, p2), filterDescendantsInstances, false, true)

			if part then
				if part.CanCollide then
					eraseFromEnd(filterDescendantsInstances, count) -- inferred equivalent call
					return v7, true
				else
					filterDescendantsInstances[#filterDescendantsInstances + 1] = part
				end
			end
		until not part

		eraseFromEnd(filterDescendantsInstances, count) -- inferred equivalent call
	end

	return p + p2, false
end

local function queryPoint(p, p2, p3, p4)
	debug.profilebegin("queryPoint")
	local v7 = #filterDescendantsInstances
	local v8 = p3 + nearPlaneZ
	local v9 = p + p2 * v8
	local v10 = 1e999
	local v11 = 1e999
	local count = 0

	if userFlag then
		raycastParams.FilterDescendantsInstances = filterDescendantsInstances
		local v12 = p

		while true do
			local raycastResult = workspace:Raycast(v12, v9 - v12, raycastParams)

			if not raycastResult then
				break
			end

			count += 1
			local instance = raycastResult.Instance
			local position = raycastResult.Position
			local magnitude = (position - p).Magnitude

			if count >= 64 then
				v11 = magnitude
			elseif canOcclude(instance) then -- inferred equivalent call
				raycastParams2.FilterDescendantsInstances = { instance }

				if workspace:Raycast(v9, position - v9, raycastParams2) then
					local v13

					if p4 then
						v13 = workspace:Raycast(p4, v9 - p4, raycastParams2)
							or workspace:Raycast(v9, p4 - v9, raycastParams2)
					else
						v13 = false
					end

					if v13 then
						v11 = magnitude
					elseif v8 < v10 then
						v10 = magnitude
					end
				else
					v11 = magnitude
				end
			end

			raycastParams:AddToFilter(instance)
			v12 = position - p2 * 0.001

			if v11 < 1e999 or not instance then
				break
			end
		end
	else
		local v12 = p

		repeat
			local part, v13 = workspace:FindPartOnRayWithIgnoreList(
				new(v12, v9 - v12),
				filterDescendantsInstances,
				false,
				true
			)
			count += 1

			if part then
				local v14 = count >= 64

				if canOcclude(part) or v14 then -- inferred equivalent call
					local v15 = { part }
					local part2 = workspace:FindPartOnRayWithWhitelist(new(v9, v13 - v9), v15, true)
					local magnitude = (v13 - p).Magnitude

					if part2 and not v14 then
						local v16

						if p4 then
							v16 = workspace:FindPartOnRayWithWhitelist(new(p4, v9 - p4), v15, true)
								or workspace:FindPartOnRayWithWhitelist(new(v9, p4 - v9), v15, true)
						else
							v16 = false
						end

						if v16 then
							v11 = magnitude
						elseif v8 < v10 then
							v10 = magnitude
						end
					else
						v11 = magnitude
					end
				end

				filterDescendantsInstances[#filterDescendantsInstances + 1] = part
				v12 = v13 - p2 * 0.001
			end
		until v11 < 1e999 or not part

		eraseFromEnd(filterDescendantsInstances, v7) -- inferred equivalent call
	end

	debug.profileend()
	return v10 - nearPlaneZ, v11 - nearPlaneZ
end

local function queryViewport(data, p)
	debug.profilebegin("queryViewport")
	local p2 = data.p
	local rightVector = data.rightVector
	local upVector = data.upVector
	local v7 = -data.lookVector
	local v8

	if userFlag2 then
		v8 = v:getCamera()
	else
		v8 = currentCamera
	end

	currentCamera = v8
	local viewportSize = currentCamera.ViewportSize
	local v9 = 1e999
	local v10 = 1e999

	for i = 0, 1 do
		local v11 = rightVector * ((i - 0.5) * v3)

		for j = 0, 1 do
			local v12 = upVector * ((j - 0.5) * v4)
			local v13, v14 = queryPoint(
				p2 + nearPlaneZ * (v11 + v12),
				v7,
				p,
				currentCamera:ViewportPointToRay(viewportSize.x * i, viewportSize.y * j).Origin
			)

			if v14 < v9 then
				v9 = v14
			end

			if v13 < v10 then
				v10 = v13
			end
		end
	end

	debug.profileend()
	return v10, v9
end

local function testPromotion(data, p, data2)
	debug.profilebegin("testPromotion")
	local p2 = data.p
	local rightVector = data.rightVector
	local upVector = data.upVector
	local v7 = -data.lookVector
	debug.profilebegin("extrapolate")
	local magnitude = (getCollisionPoint(p2, data2.posVelocity * 1.25) - p2).Magnitude
	local magnitude2 = data2.posVelocity.magnitude

	for i = 0, min(1.25, data2.rotVelocity.magnitude + magnitude / magnitude2), 0.0625 do
		local extrapolate = data2.extrapolate(i)

		if p <= queryPoint(extrapolate.p, -extrapolate.lookVector, p) then
			return false
		end
	end

	debug.profileend()
	debug.profilebegin("testOffsets")

	for _, v8 in ipairs(v6) do
		local collisionPoint = getCollisionPoint(p2, rightVector * v8.x + upVector * v8.y)

		if queryPoint(collisionPoint, (p2 + v7 * p - collisionPoint).Unit, p) == 1e999 then
			return false
		end
	end

	debug.profileend()
	debug.profileend()
	return true
end

local function Popper(p, p2, p3)
	debug.profilebegin("popper")
	rootPart = rootPart2 and rootPart2:GetRootPart() or rootPart2
	local v7, v8 = queryViewport(p, p2)

	if not (v8 < p2) then
		v8 = p2
	end

	if v7 < v8 and testPromotion(p, p2, p3) then
		v8 = v7
	end

	rootPart = nil
	debug.profileend()
	return v8
end

return Popper