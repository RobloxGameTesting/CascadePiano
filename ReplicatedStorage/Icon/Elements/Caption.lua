local color = Color3.fromRGB(39, 41, 48)
return function(object)
	local instance = object:getInstance("ClickRegion")
	local canvasGroup = Instance.new("CanvasGroup")
	canvasGroup.Name = "Caption"
	canvasGroup.AnchorPoint = Vector2.new(0.5, 0)
	canvasGroup.BackgroundTransparency = 1
	canvasGroup.BorderSizePixel = 0
	canvasGroup.GroupTransparency = 1
	canvasGroup.Position = UDim2.fromOffset(0, 0)
	canvasGroup.Visible = true
	canvasGroup.ZIndex = 30
	canvasGroup.Parent = instance
	local frame = Instance.new("Frame")
	frame.Name = "Box"
	frame.AutomaticSize = Enum.AutomaticSize.XY
	frame.BackgroundColor3 = color
	frame.Position = UDim2.fromOffset(4, 7)
	frame.ZIndex = 12
	frame.Parent = canvasGroup
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "Header"
	textLabel.FontFace = Font.new(
		"rbxasset://fonts/families/BuilderSans.json",
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	textLabel.Text = "Caption"
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.TextSize = 15
	textLabel.TextTruncate = Enum.TextTruncate.None
	textLabel.TextWrapped = false
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.AutomaticSize = Enum.AutomaticSize.X
	textLabel.BackgroundTransparency = 1
	textLabel.LayoutOrder = 1
	textLabel.Size = UDim2.fromOffset(0, 16)
	textLabel.ZIndex = 18
	textLabel.Parent = frame
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Name = "Layout"
	uiListLayout.Padding = UDim.new(0, 8)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Parent = frame
	local uiCorner = Instance.new("UICorner")
	uiCorner.Name = "CaptionCorner"
	uiCorner.Parent = frame
	local uiPadding = Instance.new("UIPadding")
	uiPadding.Name = "Padding"
	uiPadding.PaddingBottom = UDim.new(0, 12)
	uiPadding.PaddingLeft = UDim.new(0, 12)
	uiPadding.PaddingRight = UDim.new(0, 12)
	uiPadding.PaddingTop = UDim.new(0, 12)
	uiPadding.Parent = frame
	local frame2 = Instance.new("Frame")
	frame2.Name = "Hotkeys"
	frame2.AutomaticSize = Enum.AutomaticSize.Y
	frame2.BackgroundTransparency = 1
	frame2.LayoutOrder = 3
	frame2.Size = UDim2.fromScale(1, 0)
	frame2.Visible = false
	frame2.Parent = frame
	local uiListLayout2 = Instance.new("UIListLayout")
	uiListLayout2.Name = "Layout1"
	uiListLayout2.Padding = UDim.new(0, 6)
	uiListLayout2.FillDirection = Enum.FillDirection.Vertical
	uiListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
	uiListLayout2.HorizontalFlex = Enum.UIFlexAlignment.None
	uiListLayout2.ItemLineAlignment = Enum.ItemLineAlignment.Automatic
	uiListLayout2.VerticalFlex = Enum.UIFlexAlignment.None
	uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout2.Parent = frame2
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "Key1"
	imageLabel.Image = "rbxasset://textures/ui/Controls/key_single.png"
	imageLabel.ImageTransparency = 0.7
	imageLabel.ScaleType = Enum.ScaleType.Slice
	imageLabel.SliceCenter = Rect.new(5, 5, 23, 24)
	imageLabel.AutomaticSize = Enum.AutomaticSize.X
	imageLabel.BackgroundTransparency = 1
	imageLabel.LayoutOrder = 1
	imageLabel.Size = UDim2.fromOffset(0, 30)
	imageLabel.ZIndex = 15
	imageLabel.Parent = frame2
	local uiPadding2 = Instance.new("UIPadding")
	uiPadding2.Name = "Inset"
	uiPadding2.PaddingLeft = UDim.new(0, 8)
	uiPadding2.PaddingRight = UDim.new(0, 8)
	uiPadding2.Parent = imageLabel
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.AutoLocalize = false
	textLabel2.Name = "LabelContent"
	textLabel2.FontFace = Font.new(
		"rbxasset://fonts/families/GothamSSm.json",
		Enum.FontWeight.Medium,
		Enum.FontStyle.Normal
	)
	textLabel2.Text = ""
	textLabel2.TextColor3 = Color3.fromRGB(189, 190, 190)
	textLabel2.TextSize = 15
	textLabel2.AutomaticSize = Enum.AutomaticSize.X
	textLabel2.BackgroundTransparency = 1
	textLabel2.Position = UDim2.fromOffset(0, -1)
	textLabel2.Size = UDim2.fromScale(1, 1)
	textLabel2.ZIndex = 16
	textLabel2.Parent = imageLabel
	local imageLabel2 = Instance.new("ImageLabel")
	imageLabel2.Name = "Caret"
	imageLabel2.Image = "rbxassetid://101906294438076"
	imageLabel2.ImageColor3 = color
	imageLabel2.AnchorPoint = Vector2.new(0, 0.5)
	imageLabel2.BackgroundTransparency = 1
	imageLabel2.Position = UDim2.new(0, 0, 0, 4)
	imageLabel2.Size = UDim2.fromOffset(16, 8)
	imageLabel2.ZIndex = 12
	imageLabel2.Parent = canvasGroup
	local imageLabel3 = Instance.new("ImageLabel")
	imageLabel3.Visible = true
	imageLabel3.Name = "DropShadow"
	imageLabel3.Image = "rbxassetid://124920646932671"
	imageLabel3.ImageColor3 = Color3.fromRGB(0, 0, 0)
	imageLabel3.ImageTransparency = 0.45
	imageLabel3.ScaleType = Enum.ScaleType.Slice
	imageLabel3.SliceCenter = Rect.new(12, 12, 13, 13)
	imageLabel3.BackgroundTransparency = 1
	imageLabel3.Position = UDim2.fromOffset(0, 5)
	imageLabel3.Size = UDim2.new(1, 0, 0, 48)
	imageLabel3.Parent = canvasGroup
	frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		imageLabel3.Size = UDim2.new(1, 0, 0, frame.AbsoluteSize.Y + 8)
	end)
	local captionJanitor = object.captionJanitor
	local _, v = object:clipOutside(canvasGroup)
	v.AutomaticSize = Enum.AutomaticSize.None

	local function matchSize() -- 1 equivalent call inferred from this helper
		local absoluteSize = canvasGroup.AbsoluteSize
		v.Size = UDim2.fromOffset(absoluteSize.X, absoluteSize.Y)
	end

	captionJanitor:add(canvasGroup:GetPropertyChangedSignal("AbsoluteSize"):Connect(matchSize))
	matchSize() -- inferred equivalent call
	local v2 = false
	local header = canvasGroup.Box.Header
	local UserInputService = game:GetService("UserInputService")

	local function updateHotkey(fakeToggleKey) -- 2 equivalent calls inferred from this helper
		local keyboardEnabled = UserInputService.KeyboardEnabled
		local captionText = canvasGroup:GetAttribute("CaptionText") or ""
		local v3 = captionText == "_hotkey_"

		if not keyboardEnabled and v3 then
			object:setCaption()
			return
		end

		header.Text = captionText
		header.Visible = not v3

		if fakeToggleKey then
			textLabel2.Text = fakeToggleKey.Name
			frame2.Visible = true
		end

		if not keyboardEnabled then
			frame2.Visible = false
		end
	end

	canvasGroup:GetAttributeChangedSignal("CaptionText"):Connect(updateHotkey)
	local quad = Enum.EasingStyle.Quad
	local tweenInfo = TweenInfo.new(0.2, quad, Enum.EasingDirection.In)
	local tweenInfo2 = TweenInfo.new(0.2, quad, Enum.EasingDirection.Out)
	local TweenService = game:GetService("TweenService")
	local RunService = game:GetService("RunService")

	local function getCaptionPosition(p) -- 1 equivalent call inferred from this helper
		if p == nil then
			p = v2
		end

		return UDim2.new(0.5, 0, 1, p and 10 or 2)
	end

	local function updatePosition(p)
		if not v2 then
			return
		end

		if p == nil then
			p = v2
		end

		local captionPosition = getCaptionPosition(not p) -- inferred equivalent call
		local v3

		if p == nil then
			v3 = v2
		else
			v3 = p
		end

		local udim = UDim2.new(0.5, 0, 1, v3 and 10 or 2)

		if p then
			local offset = imageLabel2.Position.Y.Offset
			imageLabel2.Position = UDim2.fromOffset(0, offset)
			canvasGroup.AutomaticSize = Enum.AutomaticSize.XY
			canvasGroup.Size = UDim2.fromOffset(32, 53)
		else
			local absoluteSize = canvasGroup.AbsoluteSize
			canvasGroup.AutomaticSize = Enum.AutomaticSize.Y
			canvasGroup.Size = UDim2.fromOffset(absoluteSize.X, absoluteSize.Y)
		end

		local v4 = nil

		local function updateCaret()
			local v5 = instance.AbsolutePosition.X - canvasGroup.AbsolutePosition.X + instance.AbsoluteSize.X / 2 - imageLabel2.AbsoluteSize.X / 2
			local offset = imageLabel2.Position.Y.Offset
			local udim2 = UDim2.fromOffset(v5, offset)

			if v4 ~= v5 then
				v4 = v5
				imageLabel2.Position = UDim2.fromOffset(0, offset)
				task.wait()
			end

			imageLabel2.Position = udim2
		end

		v.Position = captionPosition
		updateCaret()
		local tween = TweenService:Create(v, p and tweenInfo or tweenInfo2, { Position = udim })
		local heartbeatConnection = RunService.Heartbeat:Connect(updateCaret)
		tween:Play()
		tween.Completed:Once(function()
			heartbeatConnection:Disconnect()
		end)
	end

	captionJanitor:add(instance:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		updatePosition()
	end))
	updatePosition(false)
	captionJanitor:add(object.toggleKeyAdded:Connect(updateHotkey))

	for k, _ in pairs(object.bindedToggleKeys) do
		local keyboardEnabled = UserInputService.KeyboardEnabled
		local captionText = canvasGroup:GetAttribute("CaptionText") or ""
		local v3 = captionText == "_hotkey_"

		if not keyboardEnabled and v3 then
			object:setCaption()
			break
		end

		header.Text = captionText
		header.Visible = not v3

		if k then
			textLabel2.Text = k.Name
			frame2.Visible = true
		end

		if keyboardEnabled then
			break
		end

		frame2.Visible = false
		break
	end

	captionJanitor:add(object.fakeToggleKeyChanged:Connect(updateHotkey))
	local fakeToggleKey = object.fakeToggleKey

	if fakeToggleKey then
		updateHotkey(fakeToggleKey) -- inferred equivalent call
	end

	local function setCaptionEnabled(flag)
		if v2 == flag then
			return
		end

		local joinedFrame = object.joinedFrame

		if joinedFrame and string.match(joinedFrame.Name, "Dropdown") then
			flag = false
		end

		v2 = flag
		TweenService:Create(canvasGroup, flag and tweenInfo or tweenInfo2, {
			GroupTransparency = flag and 0 or 1
		}):Play()

		if flag then
			v:SetAttribute("ForceUpdate", true)
		end

		updatePosition()
		updateHotkey() -- inferred equivalent call
	end

	local iconModule = require(object.iconModule)
	captionJanitor:add(object.stateChanged:Connect(function(p)
		if p == "Viewing" then
			local captionLastClosedClock = iconModule.captionLastClosedClock
			local v3 = (captionLastClosedClock and os.clock() - captionLastClosedClock or 999) < 0.3 and 0 or 0.5
			task.delay(v3, function()
				if object.activeState == "Viewing" then
					setCaptionEnabled(true)
				end
			end)
		else
			iconModule.captionLastClosedClock = os.clock()
			setCaptionEnabled(false)
		end
	end))
	return canvasGroup
end