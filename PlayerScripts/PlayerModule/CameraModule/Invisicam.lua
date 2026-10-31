local createVector = vector.create
local Players = game:GetService("Players")
local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))
local userFlag = FlagUtil.getUserFlag("UserRaycastUpdateAPI2")
local v = {
	LIMBS = 2,
	MOVEMENT = 3,
	CORNERS = 4,
	CIRCLE1 = 5,
	CIRCLE2 = 6,
	LIMBMOVE = 7,
	SMART_CIRCLE = 8,
	CHAR_OUTLINE = 9
}
local v2 = {
	Head = true,
	["Left Arm"] = true,
	["Right Arm"] = true,
	["Left Leg"] = true,
	["Right Leg"] = true,
	LeftLowerArm = true,
	RightLowerArm = true,
	LeftUpperLeg = true,
	RightUpperLeg = true
}
local v3 = {
	createVector(1, 1, -1),
	createVector(1, -1, -1),
	createVector(-1, -1, -1),
	createVector(-1, 1, -1)
}
local raycastParams = RaycastParams.new()
raycastParams.FilterType = Enum.RaycastFilterType.Exclude
local raycastParams2 = RaycastParams.new()
raycastParams2.FilterType = Enum.RaycastFilterType.Include

local function AssertTypes(mode, ...)
	local v4 = {}
	local v5 = ""

	for _, v6 in pairs({ ... }) do
		v4[v6] = true
		v5 ..= (v5 == "" and "" or " or ") .. v6
	end

	local typeName = type(mode)
	assert(v4[typeName], v5 .. " type expected, got: " .. typeName)
end

local function Det3x3(p: number, p2: number, x: number, p3: number, p4: number, y: number, p5: number, p6: number, z: number) -- 3 equivalent calls inferred from this helper
	return p * (p4 * z - y * p6) - p2 * (p3 * z - y * p5) + x * (p3 * p6 - p4 * p5)
end

local function RayIntersection(vector: Vector3, unit: Vector3, vector2: Vector3, vector3: Vector3)
	local cross = unit:Cross(vector3)
	local v4 = vector2.X - vector.X
	local v5 = vector2.Y - vector.Y
	local v6 = vector2.Z - vector.Z
	local det3x3 = Det3x3(unit.X, -vector3.X, cross.X, unit.Y, -vector3.Y, cross.Y, unit.Z, -vector3.Z, cross.Z) -- inferred equivalent call

	if det3x3 == 0 then
		return createVector(0, 0, 0)
	end

	local v7 = Det3x3(v4, -vector3.X, cross.X, v5, -vector3.Y, cross.Y, v6, -vector3.Z, cross.Z) / det3x3 -- inferred equivalent call
	local v8 = Det3x3(unit.X, v4, cross.X, unit.Y, v5, cross.Y, unit.Z, v6, cross.Z) / det3x3 -- inferred equivalent call
	local v9 = vector + v7 * unit
	local v10 = vector2 + v8 * vector3
	local v11 = v9 + (v10 - v9) * 0.5

	if (v10 - v9).Magnitude < 0.25 then
		return v11
	end

	return createVector(0, 0, 0)
end

local BaseOcclusion = require(script.Parent:WaitForChild("BaseOcclusion"))
local object = setmetatable({}, BaseOcclusion)
object.__index = object

function object.new()
	local self = setmetatable(BaseOcclusion.new(), object)
	self.char = nil
	self.humanoidRootPart = nil
	self.torsoPart = nil
	self.headPart = nil
	self.childAddedConn = nil
	self.childRemovedConn = nil
	self.behaviors = {}
	self.behaviors[v.LIMBS] = self.LimbBehavior
	self.behaviors[v.MOVEMENT] = self.MoveBehavior
	self.behaviors[v.CORNERS] = self.CornerBehavior
	self.behaviors[v.CIRCLE1] = self.CircleBehavior
	self.behaviors[v.CIRCLE2] = self.CircleBehavior
	self.behaviors[v.LIMBMOVE] = self.LimbMoveBehavior
	self.behaviors[v.SMART_CIRCLE] = self.SmartCircleBehavior
	self.behaviors[v.CHAR_OUTLINE] = self.CharacterOutlineBehavior
	self.mode = v.SMART_CIRCLE
	self.behaviorFunction = self.SmartCircleBehavior
	self.savedHits = {}
	self.trackedLimbs = {}
	self.camera = game.Workspace.CurrentCamera
	self.enabled = false
	return self
end

function object:Enable(enabled)
	self.enabled = enabled

	if not enabled then
		self:Cleanup()
	end
end

function object.GetOcclusionMode(_)
	return Enum.DevCameraOcclusionMode.Invisicam
end

function object:LimbBehavior(positions)
	for k, _ in pairs(self.trackedLimbs) do
		positions[#positions + 1] = k.Position
	end
end

function object:MoveBehavior(list)
	for i = 1, 3 do
		local position = self.humanoidRootPart.Position
		local velocity = self.humanoidRootPart.Velocity
		local halfMagnitude = Vector3.new(velocity.X, 0, velocity.Z).Magnitude / 2
		local v4 = (i - 1) * self.humanoidRootPart.CFrame.lookVector * halfMagnitude
		list[#list + 1] = position + v4
	end
end

function object.CornerBehavior(p, list)
	local cframe = p.humanoidRootPart.CFrame
	local position = cframe.Position
	local v4 = cframe - position
	local v5 = p.char:GetExtentsSize() / 2
	list[#list + 1] = position

	for i = 1, #v3 do
		list[#list + 1] = position + v4 * (v5 * v3[i])
	end
end

function object.CircleBehavior(data, list)
	local cframe

	if data.mode == v.CIRCLE1 then
		cframe = data.humanoidRootPart.CFrame
	else
		local coordinateFrame = data.camera.CoordinateFrame
		cframe = coordinateFrame - coordinateFrame.Position + data.humanoidRootPart.Position
	end

	list[#list + 1] = cframe.Position

	for i = 0, 9 do
		local v4 = 0.6283185307179586 * i
		local v5 = Vector3.new(math.cos(v4), math.sin(v4), 0) * 3
		list[#list + 1] = cframe * v5
	end
end

function object:LimbMoveBehavior(p)
	self:LimbBehavior(p)
	self:MoveBehavior(p)
end

function object.CharacterOutlineBehavior(data, list)
	local unit = data.torsoPart.CFrame.upVector.unit
	local unit2 = data.torsoPart.CFrame.rightVector.unit
	list[#list + 1] = data.torsoPart.CFrame.p
	list[#list + 1] = data.torsoPart.CFrame.p + unit
	list[#list + 1] = data.torsoPart.CFrame.p - unit
	list[#list + 1] = data.torsoPart.CFrame.p + unit2
	list[#list + 1] = data.torsoPart.CFrame.p - unit2

	if data.headPart then
		list[#list + 1] = data.headPart.CFrame.p
	end

	local cframe = CFrame.new(
		createVector(0, 0, 0),
		(Vector3.new(data.camera.CoordinateFrame.lookVector.X, 0, data.camera.CoordinateFrame.lookVector.Z))
	)
	local position = data.torsoPart and data.torsoPart.Position or data.humanoidRootPart.Position
	local headParts = { data.torsoPart }

	if data.headPart then
		headParts[#headParts + 1] = data.headPart
	end

	for i = 1, 24 do
		local v4 = 6.283185307179586 * i / 24
		local v5 = cframe * (Vector3.new(math.cos(v4), math.sin(v4), 0) * 3)
		local vector = Vector3.new(v5.X, math.max(v5.Y, -2.25), v5.Z)

		if userFlag then
			raycastParams2.FilterDescendantsInstances = headParts
			local raycastResult = game.Workspace:Raycast(position + vector, -3 * vector, raycastParams2)

			if raycastResult then
				local position2 = raycastResult.Position
				list[#list + 1] = position2 + 0.2 * (position - position2).unit
			end
		else
			local ray = Ray.new(position + vector, -3 * vector)
			local part, v6 = game.Workspace:FindPartOnRayWithWhitelist(ray, headParts, false)

			if part then
				list[#list + 1] = v6 + 0.2 * (position - v6).unit
			end
		end
	end
end

function object.SmartCircleBehavior(data, list)
	local unit = data.torsoPart.CFrame.upVector.unit
	local unit2 = data.torsoPart.CFrame.rightVector.unit
	list[#list + 1] = data.torsoPart.CFrame.p
	list[#list + 1] = data.torsoPart.CFrame.p + unit
	list[#list + 1] = data.torsoPart.CFrame.p - unit
	list[#list + 1] = data.torsoPart.CFrame.p + unit2
	list[#list + 1] = data.torsoPart.CFrame.p - unit2

	if data.headPart then
		list[#list + 1] = data.headPart.CFrame.p
	end

	local v4 = data.camera.CFrame - data.camera.CFrame.p
	local v5 = createVector(0, 0.5, 0) + (data.torsoPart and data.torsoPart.Position or data.humanoidRootPart.Position)

	for i = 1, 24 do
		local v6 = 0.2617993877991494 * i - 1.5707963267948966
		local v7 = v5 + v4 * (Vector3.new(math.cos(v6), math.sin(v6), 0) * 2.5)
		local v8 = v7 - data.camera.CFrame.p

		if userFlag then
			raycastParams.FilterDescendantsInstances = { data.char }
			local raycastResult = game.Workspace:Raycast(v5, v7 - v5, raycastParams)

			if raycastResult then
				local position = raycastResult.Position
				local normal = raycastResult.Normal
				local v9 = position + 0.1 * normal.unit
				local vector = v9 - v5
				local unit3 = vector:Cross(v8).unit:Cross(normal).unit
				local unit4 = (v9 - data.camera.CFrame.p).unit

				if vector.unit:Dot(-unit3) < vector.unit:Dot(unit4) then
					v7 = RayIntersection(v9, unit3, v7, v8)

					if v7.Magnitude > 0 then
						local raycastResult2 = game.Workspace:Raycast(v9, v7 - v9, raycastParams)

						if raycastResult2 then
							v7 = raycastResult2.Position + 0.1 * raycastResult2.Normal.Unit
						end
					else
						v7 = v9
					end
				else
					v7 = v9
				end

				local raycastResult2 = game.Workspace:Raycast(v5, v7 - v5, raycastParams)

				if raycastResult2 then
					v7 = raycastResult2.Position - 0.1 * (v7 - v5).unit
				end
			end

			list[#list + 1] = v7
		else
			local ray = Ray.new(v5, v7 - v5)
			local part, v9, v10 = game.Workspace:FindPartOnRayWithIgnoreList(ray, { data.char }, false, false)

			if part then
				local v11 = v9 + 0.1 * v10.unit
				local vector = v11 - v5
				local unit3 = vector:Cross(v8).unit:Cross(v10).unit
				local unit4 = (v11 - data.camera.CFrame.p).unit

				if vector.unit:Dot(-unit3) < vector.unit:Dot(unit4) then
					v7 = RayIntersection(v11, unit3, v7, v8)

					if v7.Magnitude > 0 then
						local ray2 = Ray.new(v11, v7 - v11)
						local part2, v12, v13 = game.Workspace:FindPartOnRayWithIgnoreList(
							ray2,
							{ data.char },
							false,
							false
						)

						if part2 then
							v7 = v12 + 0.1 * v13.unit
						end
					else
						v7 = v11
					end
				else
					v7 = v11
				end

				local ray2 = Ray.new(v5, v7 - v5)
				local part2, v12, _ = game.Workspace:FindPartOnRayWithIgnoreList(ray2, { data.char }, false, false)

				if part2 then
					v7 = v12 - 0.1 * (v7 - v5).unit
				end
			end

			list[#list + 1] = v7
		end
	end
end

function object:CheckTorsoReference()
	if self.char then
		self.torsoPart = self.char:FindFirstChild("Torso")

		if not self.torsoPart then
			self.torsoPart = self.char:FindFirstChild("UpperTorso")

			if not self.torsoPart then
				self.torsoPart = self.char:FindFirstChild("HumanoidRootPart")
			end
		end

		self.headPart = self.char:FindFirstChild("Head")
	end
end

function object:CharacterAdded(char, p)
	if p ~= Players.LocalPlayer then
		return
	end

	if self.childAddedConn then
		self.childAddedConn:Disconnect()
		self.childAddedConn = nil
	end

	if self.childRemovedConn then
		self.childRemovedConn:Disconnect()
		self.childRemovedConn = nil
	end

	self.char = char
	self.trackedLimbs = {}

	local function childAdded(part) -- 1 equivalent call inferred from this helper
		if part:IsA("BasePart") then
			if v2[part.Name] then
				self.trackedLimbs[part] = true
			end

			if part.Name == "Torso" or part.Name == "UpperTorso" then
				self.torsoPart = part
			end

			if part.Name == "Head" then
				self.headPart = part
			end
		end
	end

	local function childRemoved(p2)
		self.trackedLimbs[p2] = nil
		self:CheckTorsoReference()
	end

	self.childAddedConn = char.ChildAdded:Connect(childAdded)
	self.childRemovedConn = char.ChildRemoved:Connect(childRemoved)

	for _, child in pairs(self.char:GetChildren()) do
		childAdded(child) -- inferred equivalent call
	end
end

function object:SetMode(mode: number)
	AssertTypes(mode, "number")

	for _, v4 in pairs(v) do
		if v4 ~= mode then
			continue
		end

		self.mode = mode
		self.behaviorFunction = self.behaviors[self.mode]
		return
	end

	error("Invalid mode number")
end

function object.GetObscuredParts(p)
	return p.savedHits
end

function object:Cleanup()
	for k, savedHit in pairs(self.savedHits) do
		k.LocalTransparencyModifier = savedHit
	end
end

function object:Update(_: number, cframe: CFrame, cframe2: CFrame)
	if not (self.enabled and self.char) then
		return cframe, cframe2
	end

	self.camera = game.Workspace.CurrentCamera

	if not self.humanoidRootPart then
		local humanoid = self.char:FindFirstChildOfClass("Humanoid")

		if humanoid and humanoid.RootPart then
			self.humanoidRootPart = humanoid.RootPart
		else
			self.humanoidRootPart = self.char:FindFirstChild("HumanoidRootPart")

			if not self.humanoidRootPart then
				return cframe, cframe2
			end
		end

		local ancestryChangedConnection = nil
		ancestryChangedConnection = self.humanoidRootPart.AncestryChanged:Connect(function(p, parent)
			if p == self.humanoidRootPart and not parent then
				self.humanoidRootPart = nil

				if ancestryChangedConnection and ancestryChangedConnection.Connected then
					ancestryChangedConnection:Disconnect()
					ancestryChangedConnection = nil
				end
			end
		end)
	end

	if not self.torsoPart then
		self:CheckTorsoReference()

		if not self.torsoPart then
			return cframe, cframe2
		end
	end

	local v4 = {}
	self.behaviorFunction(self, v4)
	local v5 = {}
	local v6 = { self.char }

	local function add(p) -- 2 equivalent calls inferred from this helper
		v5[p] = true

		if not self.savedHits[p] then
			self.savedHits[p] = p.LocalTransparencyModifier
		end
	end

	local p = self.headPart and self.headPart.CFrame.p or v4[1]
	local p2 = self.torsoPart and self.torsoPart.CFrame.p or v4[2]
	local partsObscuringTarget = self.camera:GetPartsObscuringTarget({ p, p2 }, v6)
	local count = 0
	local v7 = {}
	local v8 = 0.75
	local v9 = 0.75

	for i = 1, #partsObscuringTarget do
		local v10 = partsObscuringTarget[i]
		count += 1
		v7[v10] = true

		for _, child in pairs(v10:GetChildren()) do
			if not (child:IsA("Decal") or child:IsA("Texture")) then
				continue
			end

			count += 1
			break
		end
	end

	if count > 0 then
		v8 = math.pow(0.375 / count + 0.375, 1 / count)
		v9 = math.pow(0.25 / count + 0.25, 1 / count)
	end

	local partsObscuringTarget2 = self.camera:GetPartsObscuringTarget(v4, v6)
	local v10 = {}

	for i = 1, #partsObscuringTarget2 do
		local v11 = partsObscuringTarget2[i]
		v10[v11] = v7[v11] and v8 or v9

		if v11.Transparency < v10[v11] then
			add(v11) -- inferred equivalent call
		end

		for _, child in pairs(v11:GetChildren()) do
			if not ((child:IsA("Decal") or child:IsA("Texture")) and child.Transparency < v10[v11]) then
				continue
			end

			v10[child] = v10[v11]
			add(child) -- inferred equivalent call
		end
	end

	for k, savedHit in pairs(self.savedHits) do
		if v5[k] then
			k.LocalTransparencyModifier = not (k.Transparency < 1) and 0
				or (v10[k] - k.Transparency) / (1 - k.Transparency)
				or 0
		else
			k.LocalTransparencyModifier = savedHit
			self.savedHits[k] = nil
		end
	end

	return cframe, cframe2
end

return object