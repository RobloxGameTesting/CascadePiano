return function(object, p)
	local frame = Instance.new("Frame")
	frame.Name = "Notice"
	frame.ZIndex = 25
	frame.AutomaticSize = Enum.AutomaticSize.X
	frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	frame.BorderSizePixel = 0
	frame.BackgroundTransparency = 0.1
	frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame.Visible = false
	frame.Parent = object.widget
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(1, 0)
	uiCorner.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Parent = frame
	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "NoticeLabel"
	textLabel.ZIndex = 26
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.AutomaticSize = Enum.AutomaticSize.X
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Position = UDim2.new(0.5, 0, 0.515, 0)
	textLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.FontSize = Enum.FontSize.Size14
	textLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
	textLabel.Text = "1"
	textLabel.TextWrapped = true
	textLabel.TextWrap = true
	textLabel.Font = Enum.Font.Arial
	textLabel.Parent = frame
	local parent = script.Parent.Parent
	local packages = parent.Packages
	local Janitor = require(packages.Janitor)
	local GoodSignal = require(packages.GoodSignal)
	local Utility = require(parent.Utility)
	object.noticeChanged:Connect(function(p2)
		if not p2 then
			return
		end

		local v = p2 > 99
		textLabel.Text = v and "99+" or p2

		if v then
			textLabel.TextSize = 11
		end

		local v2 = not (p2 < 1)
		local iconByUID = p.getIconByUID(object.parentIconUID)
		local v3 = #object.dropdownIcons > 0 or #object.menuIcons > 0

		if object.isSelected and v3 then
			v2 = false
		elseif iconByUID and not iconByUID.isSelected then
			v2 = false
		end

		Utility.setVisible(frame, v2, "NoticeHandler")
	end)
	object.noticeStarted:Connect(function(p2, p3)
		local clearNoticeEvent = p2 or object.deselected
		local iconByUID = p.getIconByUID(object.parentIconUID)

		if iconByUID then
			iconByUID:notify(clearNoticeEvent)
		end

		local v = object.janitor:add(Janitor.new())
		local completeSignal = v:add(GoodSignal.new())
		v:add(object.endNotices:Connect(function()
			completeSignal:Fire()
		end))
		v:add(clearNoticeEvent:Connect(function()
			completeSignal:Fire()
		end))
		local v2 = p3 or Utility.generateUID()
		object.notices[v2] = {
			completeSignal = completeSignal,
			clearNoticeEvent = clearNoticeEvent
		}

		local function updateNotice() -- 2 equivalent calls inferred from this helper
			object.noticeChanged:Fire(object.totalNotices)
		end

		object.notified:Fire(v2)
		object.totalNotices += 1
		updateNotice() -- inferred equivalent call
		completeSignal:Once(function()
			v:destroy()
			object.totalNotices -= 1
			object.notices[v2] = nil
			updateNotice() -- inferred equivalent call
		end)
	end)
	frame:SetAttribute("ClipToJoinedParent", true)
	object:clipOutside(frame)
	return frame
end