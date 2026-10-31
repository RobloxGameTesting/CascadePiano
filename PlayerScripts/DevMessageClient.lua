local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local DevMessageEvent = ReplicatedStorage:WaitForChild("DevMessageEvent")
local v = { Server = Color3.fromRGB(59, 130, 246), Global = Color3.fromRGB(34, 197, 94) }
local color = Color3.fromRGB(15, 23, 42)
local color2 = Color3.fromRGB(241, 245, 249)
local v2 = { Server = Color3.fromRGB(96, 165, 250), Global = Color3.fromRGB(74, 222, 128) }
local color3 = Color3.fromRGB(226, 232, 240)
local color4 = Color3.fromRGB(148, 163, 184)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DevMessageGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.DisplayOrder = 9999
screenGui.Parent = PlayerGui
local v3 = nil
local thread = nil

local function showBanner(value, p, p2)
	if thread then
		task.cancel(thread)
	end

	if v3 then
		v3:Destroy()
	end

	local v4 = v[value] or v.Server
	local v5 = v2[value] or v2.Server
	local v6 = "[" .. (value or "Server") .. "]"
	local frame = Instance.new("Frame")
	frame.Name = "DevBanner"
	frame.AnchorPoint = Vector2.new(0.5, 0)
	frame.Position = UDim2.new(0.5, 0, 0, 0)
	frame.Size = UDim2.new(0, 600, 0, 0)
	frame.AutomaticSize = Enum.AutomaticSize.Y
	frame.BackgroundColor3 = color
	frame.BackgroundTransparency = 0.12
	frame.BorderSizePixel = 0
	frame.ZIndex = 10
	frame.Position = UDim2.new(0.5, 0, 0.13, 0)
	frame.Parent = screenGui
	local uiSizeConstraint = Instance.new("UISizeConstraint")
	uiSizeConstraint.MaxSize = Vector2.new(700, 1e999)
	uiSizeConstraint.MinSize = Vector2.new(280, 0)
	uiSizeConstraint.Parent = frame
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = frame
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingLeft = UDim.new(0, 20)
	uiPadding.PaddingRight = UDim.new(0, 20)
	uiPadding.PaddingTop = UDim.new(0, 14)
	uiPadding.PaddingBottom = UDim.new(0, 14)
	uiPadding.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = v4
	uiStroke.Thickness = 1
	uiStroke.Transparency = 0.25
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Parent = frame
	local frame2 = Instance.new("Frame")
	frame2.Name = "BottomGlow"
	frame2.AnchorPoint = Vector2.new(0.5, 0)
	frame2.Position = UDim2.new(0.5, 0, 1, -1)
	frame2.Size = UDim2.new(0.85, 0, 0, 3)
	frame2.BackgroundColor3 = v4
	frame2.BackgroundTransparency = 0
	frame2.BorderSizePixel = 0
	frame2.ZIndex = 9
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(1, 0)
	uiCorner2.Parent = frame2
	frame2.Parent = screenGui

	local function colorToHex(data) -- 3 equivalent calls inferred from this helper
		return string.format(
			"#%02X%02X%02X",
			math.floor(data.R * 255),
			math.floor(data.G * 255),
			(math.floor(data.B * 255))
		)
	end

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "MainLabel"
	textLabel.BackgroundTransparency = 1
	textLabel.Size = UDim2.new(1, 0, 0, 0)
	textLabel.AutomaticSize = Enum.AutomaticSize.Y
	textLabel.TextXAlignment = Enum.TextXAlignment.Left
	textLabel.TextYAlignment = Enum.TextYAlignment.Center
	textLabel.Font = Enum.Font.Gotham
	textLabel.TextSize = 22
	textLabel.TextWrapped = true
	textLabel.RichText = true
	textLabel.TextColor3 = color2
	textLabel.ZIndex = 12
	textLabel.Text = string.format(
		"<font color='%s'>%s</font><font color='%s'><b>%s</b></font><font color='%s'>: </font>%s",
		colorToHex(v5), -- inferred equivalent call
		v6,
		colorToHex(color3), -- inferred equivalent call
		p,
		colorToHex(color4), -- inferred equivalent call
		p2
	)
	textLabel.Parent = frame
	frame.BackgroundTransparency = 1
	uiStroke.Transparency = 1
	frame2.BackgroundTransparency = 1
	textLabel.TextTransparency = 1
	v3 = frame
	local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local v7 = {
		TweenService:Create(frame, tweenInfo, { BackgroundTransparency = 0.12 }),
		TweenService:Create(uiStroke, tweenInfo, { Transparency = 0.25 }),
		TweenService:Create(frame2, tweenInfo, { BackgroundTransparency = 0.3 }),
		TweenService:Create(textLabel, tweenInfo, { TextTransparency = 0 })
	}

	for _, v8 in ipairs(v7) do
		v8:Play()
	end

	thread = task.delay(10, function()
		if v3 ~= frame then
			return
		end

		local tweenInfo2 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local v8 = {
			TweenService:Create(frame2, tweenInfo2, { BackgroundTransparency = 1 }),
			TweenService:Create(frame, tweenInfo2, { BackgroundTransparency = 1 }),
			TweenService:Create(uiStroke, tweenInfo2, { Transparency = 1 }),
			TweenService:Create(textLabel, tweenInfo2, { TextTransparency = 1 })
		}

		for _, v9 in ipairs(v8) do
			v9:Play()
		end

		task.wait(0.3)

		if v3 == frame then
			frame:Destroy()
			v3 = nil
		end
	end)
end

DevMessageEvent.OnClientEvent:Connect(function(p, p2, p3)
	showBanner(p, p2, p3)
end)