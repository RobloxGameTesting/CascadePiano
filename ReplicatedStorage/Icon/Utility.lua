local Utility = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

function Utility.createStagger(p, callback, p2)
	local flag = false
	local flag2 = false
	local v = (not p or p == 0) and 0.01 or p
	local function staggeredCallback(...)
		if flag then
			flag2 = true
			return
		end

		local v2 = table.pack(...)
		flag = true
		flag2 = false
		task.spawn(function()
			if p2 then
				task.wait(v)
			end

			callback(table.unpack(v2))
		end)
		task.delay(v, function()
			flag = false

			if flag2 then
				staggeredCallback(table.unpack(v2))
			end
		end)
	end

	return staggeredCallback
end

function Utility.round(p)
	return (math.floor(p + 0.5))
end

function Utility:reverseTable()
	for i = 1, math.floor(#self / 2) do
		local v = #self - i + 1
		local v2 = self[v]
		local v3 = self[i]
		self[i] = v2
		self[v] = v3
	end
end

function Utility.copyTable(list)
	assert(type(list) == "table", "First argument must be a table")
	local result = table.create(#list)

	for k, v in pairs(list) do
		if type(v) == "table" then
			result[k] = Utility.copyTable(v)
		else
			result[k] = v
		end
	end

	return result
end

local v = {
	"a",
	"b",
	"c",
	"d",
	"e",
	"f",
	"g",
	"h",
	"i",
	"j",
	"k",
	"l",
	"m",
	"n",
	"o",
	"p",
	"q",
	"r",
	"s",
	"t",
	"u",
	"v",
	"w",
	"x",
	"y",
	"z",
	"A",
	"B",
	"C",
	"D",
	"E",
	"F",
	"G",
	"H",
	"I",
	"J",
	"K",
	"L",
	"M",
	"N",
	"O",
	"P",
	"Q",
	"R",
	"S",
	"T",
	"U",
	"V",
	"W",
	"X",
	"Y",
	"Z",
	"1",
	"2",
	"3",
	"4",
	"5",
	"6",
	"7",
	"8",
	"9",
	"0",
	"<",
	">",
	"?",
	"@",
	"{",
	"}",
	"[",
	"]",
	"!",
	"(",
	")",
	"=",
	"+",
	"~",
	"#"
}

function Utility.generateUID(value)
	local v2 = v
	local v3 = #v2
	local v4 = ""

	for _ = 1, value or 8 do
		v4 ..= v2[math.random(1, v3)]
	end

	return v4
end

local v2 = {}

function Utility:setVisible(visible, p)
	local v3 = v2[self]

	if not v3 then
		v3 = {}
		v2[self] = v3
		self.Destroying:Once(function()
			v2[self] = nil
		end)
	end

	if visible then
		v3[p] = nil
	else
		v3[p] = true
	end

	if visible then
		for _, _ in pairs(v3) do
			visible = false
			break
		end
	end

	self.Visible = visible
end

function Utility.formatStateName(value)
	return string.upper((string.sub(value, 1, 1))) .. string.lower((string.sub(value, 2)))
end

function Utility.localPlayerRespawned(onCharacterRemoving)
	LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)
end

function Utility.getClippedContainer(parent)
	local v3 = parent:FindFirstChild("ClippedContainer")

	if not v3 then
		v3 = Instance.new("Folder")
		v3.Name = "ClippedContainer"
		v3.Parent = parent
	end

	return v3
end

local Janitor = require(script.Parent.Packages.Janitor)
local GuiService = game:GetService("GuiService")

function Utility.clipOutside(data, udims)
	local v3 = data.janitor:add(Janitor.new())
	udims.Destroying:Once(function()
		v3:Destroy()
	end)
	data.janitor:add(udims)
	local parent = udims.Parent
	local parent2 = v3:add(Instance.new("Frame"))
	parent2:SetAttribute("IsAClippedClone", true)
	parent2.Name = udims.Name
	parent2.AnchorPoint = udims.AnchorPoint
	parent2.Size = udims.Size
	parent2.Position = udims.Position
	parent2.BackgroundTransparency = 1
	parent2.LayoutOrder = udims.LayoutOrder
	parent2.Parent = parent
	local objectValue = Instance.new("ObjectValue")
	objectValue.Name = "OriginalInstance"
	objectValue.Value = udims
	objectValue.Parent = parent2
	local clone = objectValue:Clone()
	udims:SetAttribute("HasAClippedClone", true)
	clone.Name = "ClippedClone"
	clone.Value = parent2
	clone.Parent = udims
	local v4 = nil
	local iconModule = require(data.iconModule)
	local container = iconModule.container

	local function updateScreenGui()
		local screenGui = parent:FindFirstAncestorWhichIsA("ScreenGui")

		if not string.match(screenGui.Name, "Clipped") then
			screenGui = container[screenGui.Name .. "Clipped"]
		end

		v4 = screenGui
		udims.AnchorPoint = Vector2.new(0, 0)
		udims.Parent = Utility.getClippedContainer(v4)
	end

	v3:add(data.alignmentChanged:Connect(updateScreenGui))
	updateScreenGui()

	for _, uiAspectRatioConstraint in pairs(udims:GetChildren()) do
		if not uiAspectRatioConstraint:IsA("UIAspectRatioConstraint") then
			continue
		end

		local clone_2 = uiAspectRatioConstraint:Clone()
		clone_2.Parent = parent2
	end

	local widget = data.widget
	local v5 = false
	local ignoreVisibilityUpdater = udims:GetAttribute("IgnoreVisibilityUpdater")

	local function updateVisibility() -- 7 equivalent calls inferred from this helper
		if ignoreVisibilityUpdater then
			return
		end

		local visible = widget.Visible

		if v5 then
			visible = false
		end

		Utility.setVisible(udims, visible, "ClipHandler")
	end

	v3:add(widget:GetPropertyChangedSignal("Visible"):Connect(updateVisibility))
	local v6 = nil
	local function checkIfOutsideParentXBounds()
		task.defer(function()
			local scrollingFrame = nil
			local uid = data.UID

			if udims:GetAttribute("ClipToJoinedParent") then
				local parentIconUID = uid

				for _ = 1, 10 do
					local iconByUID = iconModule.getIconByUID(parentIconUID)

					if not iconByUID then
						break
					end

					local joinedFrame = iconByUID.joinedFrame
					parentIconUID = iconByUID.parentIconUID

					if not joinedFrame then
						break
					end

					if joinedFrame and joinedFrame.Name == "DropdownScroller" then
						scrollingFrame = joinedFrame
						break
					else
						scrollingFrame = joinedFrame
					end
				end
			end

			if scrollingFrame then
				local absolutePosition = udims.AbsolutePosition
				local halfAbsoluteSize = udims.AbsoluteSize / 2
				local absolutePosition2 = scrollingFrame.AbsolutePosition
				local absoluteSize = scrollingFrame.AbsoluteSize
				local v7 = absolutePosition + halfAbsoluteSize
				local v8 = v7.X < absolutePosition2.X
				local v9 = v7.X > absolutePosition2.X + absoluteSize.X
				local v10 = v7.Y < absolutePosition2.Y
				local v11 = v7.Y > absolutePosition2.Y + absoluteSize.Y
				local v12 = v8 or v9 or v10 or v11

				if v12 ~= v5 then
					v5 = v12
					updateVisibility() -- inferred equivalent call
				end

				if scrollingFrame:IsA("ScrollingFrame") and v6 ~= scrollingFrame then
					v6 = scrollingFrame
					v3:add(scrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
						checkIfOutsideParentXBounds()
					end), "Disconnect", "TrackUtilityScroller-" .. uid)
				end
			else
				v5 = false
				updateVisibility() -- inferred equivalent call
			end
		end)
	end

	local currentCamera = workspace.CurrentCamera
	local additionalOffsetX = udims:GetAttribute("AdditionalOffsetX") or 0

	local function trackProperty(p)
		local v7 = "Absolute" .. p

		local function updateProperty()
			local v8 = parent2[v7]
			local udim = UDim2.fromOffset(v8.X, v8.Y)

			if p == "Position" then
				local v9 = currentCamera.ViewportSize.X - udims.AbsoluteSize.X - 4
				local offset = udim.X.Offset

				if offset < 4 then
					offset = 4
				elseif v9 < offset then
					offset = v9
				end

				local udim2 = UDim2.fromOffset(offset, udim.Y.Offset)
				local topbarInset = GuiService.TopbarInset
				local x = workspace.CurrentCamera.ViewportSize.X
				local x2 = v4.AbsoluteSize.X
				local x3 = v4.AbsolutePosition.X

				if not iconModule.isOldTopbar then
					x3 = x - x2 - 0
				end

				local v10 = x3 - additionalOffsetX
				udim = udim2 + UDim2.fromOffset(-v10, topbarInset.Height)
				task.defer(function()
					local scrollingFrame = nil
					local uid = data.UID

					if udims:GetAttribute("ClipToJoinedParent") then
						local parentIconUID = uid

						for _ = 1, 10 do
							local iconByUID = iconModule.getIconByUID(parentIconUID)

							if not iconByUID then
								break
							end

							local joinedFrame = iconByUID.joinedFrame
							parentIconUID = iconByUID.parentIconUID

							if not joinedFrame then
								break
							end

							if joinedFrame and joinedFrame.Name == "DropdownScroller" then
								scrollingFrame = joinedFrame
								break
							else
								scrollingFrame = joinedFrame
							end
						end
					end

					if scrollingFrame then
						local absolutePosition = udims.AbsolutePosition
						local halfAbsoluteSize = udims.AbsoluteSize / 2
						local absolutePosition2 = scrollingFrame.AbsolutePosition
						local absoluteSize = scrollingFrame.AbsoluteSize
						local v11 = absolutePosition + halfAbsoluteSize
						local v12 = v11.X < absolutePosition2.X
						local v13 = v11.X > absolutePosition2.X + absoluteSize.X
						local v14 = v11.Y < absolutePosition2.Y
						local v15 = v11.Y > absolutePosition2.Y + absoluteSize.Y
						local v16 = v12 or v13 or v14 or v15

						if v16 ~= v5 then
							v5 = v16
							updateVisibility() -- inferred equivalent call
						end

						if scrollingFrame:IsA("ScrollingFrame") and v6 ~= scrollingFrame then
							v6 = scrollingFrame
							v3:add(scrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
								checkIfOutsideParentXBounds()
							end), "Disconnect", "TrackUtilityScroller-" .. uid)
						end
					else
						v5 = false
						updateVisibility() -- inferred equivalent call
					end
				end)
			end

			udims[p] = udim
		end

		local stagger = Utility.createStagger(0.01, updateProperty)
		v3:add(parent2:GetPropertyChangedSignal(v7):Connect(stagger))
		v3:add(parent2:GetAttributeChangedSignal("ForceUpdate"):Connect(function()
			stagger()
		end))
		local stagger2 = Utility.createStagger(0.5, updateProperty, true)
		v3:add(parent2:GetPropertyChangedSignal(v7):Connect(stagger2))

		if p == "Position" then
			v3:add(v4:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				stagger()
			end))
		end
	end

	task.delay(0.1, checkIfOutsideParentXBounds)
	task.defer(function()
		local scrollingFrame = nil
		local uid = data.UID

		if udims:GetAttribute("ClipToJoinedParent") then
			local parentIconUID = uid

			for _ = 1, 10 do
				local iconByUID = iconModule.getIconByUID(parentIconUID)

				if not iconByUID then
					break
				end

				local joinedFrame = iconByUID.joinedFrame
				parentIconUID = iconByUID.parentIconUID

				if not joinedFrame then
					break
				end

				if joinedFrame and joinedFrame.Name == "DropdownScroller" then
					scrollingFrame = joinedFrame
					break
				else
					scrollingFrame = joinedFrame
				end
			end
		end

		if scrollingFrame then
			local absolutePosition = udims.AbsolutePosition
			local halfAbsoluteSize = udims.AbsoluteSize / 2
			local absolutePosition2 = scrollingFrame.AbsolutePosition
			local absoluteSize = scrollingFrame.AbsoluteSize
			local v7 = absolutePosition + halfAbsoluteSize
			local v8 = v7.X < absolutePosition2.X
			local v9 = v7.X > absolutePosition2.X + absoluteSize.X
			local v10 = v7.Y < absolutePosition2.Y
			local v11 = v7.Y > absolutePosition2.Y + absoluteSize.Y
			local v12 = v8 or v9 or v10 or v11

			if v12 ~= v5 then
				v5 = v12
				updateVisibility() -- inferred equivalent call
			end

			if scrollingFrame:IsA("ScrollingFrame") and v6 ~= scrollingFrame then
				v6 = scrollingFrame
				v3:add(scrollingFrame:GetPropertyChangedSignal("AbsoluteWindowSize"):Connect(function()
					checkIfOutsideParentXBounds()
				end), "Disconnect", "TrackUtilityScroller-" .. uid)
			end
		else
			v5 = false
			updateVisibility() -- inferred equivalent call
		end
	end)
	updateVisibility() -- inferred equivalent call
	trackProperty("Position")
	v3:add(udims:GetPropertyChangedSignal("Visible"):Connect(function() end))

	if udims:GetAttribute("TrackCloneSize") then
		trackProperty("Size")
	else
		v3:add(udims:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
			local absoluteSize = udims.AbsoluteSize
			parent2.Size = UDim2.fromOffset(absoluteSize.X, absoluteSize.Y)
		end))
	end

	return parent2
end

function Utility:joinFeature(object, uids, joinedFrame)
	local joinJanitor = self.joinJanitor
	joinJanitor:clean()

	if not joinedFrame then
		self:leave()
		return
	end

	self.parentIconUID = object.UID
	self.joinedFrame = joinedFrame

	local function updateAlignent() -- 2 equivalent calls inferred from this helper
		local alignment = object.alignment
		self:setAlignment(alignment == "Center" and "Left" or alignment, true)
	end

	joinJanitor:add(object.alignmentChanged:Connect(updateAlignent))
	updateAlignent() -- inferred equivalent call
	self:modifyTheme({ "IconButton", "BackgroundTransparency", 1 }, "JoinModification")
	self:modifyTheme({ "ClickRegion", "Active", false }, "JoinModification")

	if object.childModifications then
		task.defer(function()
			self:modifyTheme(object.childModifications, object.childModificationsUID)
		end)
	end

	local instance = self:getInstance("ClickRegion")

	local function makeSelectable()
		instance.Selectable = object.isSelected
	end

	joinJanitor:add(object.toggled:Connect(makeSelectable))
	task.defer(makeSelectable)
	joinJanitor:add(function()
		instance.Selectable = true
	end)
	local uid = self.UID
	table.insert(uids, uid)
	object:autoDeselect(false)
	object.childIconsDict[uid] = true

	if not object.isEnabled then
		object:setEnabled(true)
	end

	self.joinedParent:Fire(object)
	joinJanitor:add(function()
		if not self.joinedFrame then
			return
		end

		for k, v3 in pairs(uids) do
			if v3 ~= uid then
				continue
			end

			table.remove(uids, k)
			break
		end

		local iconModule = require(self.iconModule)
		local iconByUID = iconModule.getIconByUID(self.parentIconUID)

		if not iconByUID then
			return
		end

		self:setAlignment(self.originalAlignment)
		self.parentIconUID = false
		self.joinedFrame = false
		self:removeModification("JoinModification")
		local v3 = true
		local childIconsDict = iconByUID.childIconsDict
		childIconsDict[uid] = nil

		for _, _ in pairs(childIconsDict) do
			v3 = false
			break
		end

		if v3 and not iconByUID.isAnOverflow then
			iconByUID:setEnabled(false)
		end

		updateAlignent() -- inferred equivalent call
	end)
end

return Utility