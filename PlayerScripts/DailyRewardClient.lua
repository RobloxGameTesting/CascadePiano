local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local PlayerInspectRemotes = ReplicatedStorage:WaitForChild("PlayerInspectRemotes", 20)
PlayerInspectRemotes:WaitForChild("DailyRewardOpen", 20)
local DailyRewardClaim = PlayerInspectRemotes:WaitForChild("DailyRewardClaim", 20)
local DailyRewardData = PlayerInspectRemotes:WaitForChild("DailyRewardData", 20)
PlayerInspectRemotes:WaitForChild("DailyRewardUnlock", 20)
local v = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local v2 = v and 310 or 500
local v3 = {
	Color3.fromRGB(80, 210, 230),
	Color3.fromRGB(65, 105, 215),
	Color3.fromRGB(55, 185, 130),
	Color3.fromRGB(145, 85, 205),
	Color3.fromRGB(190, 150, 55),
	Color3.fromRGB(205, 85, 85),
	Color3.fromRGB(215, 125, 45)
}
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DailyRewardGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 1
screenGui.Parent = PlayerGui
local frame = Instance.new("Frame")
frame.Size = UDim2.new(1, 0, 1, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.ZIndex = 10
frame.Visible = false
frame.Parent = screenGui
local frame2 = Instance.new("Frame")
frame2.Name = "Window"
frame2.Size = UDim2.new(0, v2, 0, v and 260 or 340)
frame2.AnchorPoint = Vector2.new(0.5, 0.5)
frame2.Position = UDim2.new(0.5, 0, 0.5, 0)
frame2.BackgroundColor3 = Color3.fromRGB(13, 14, 20)
frame2.BackgroundTransparency = 1
frame2.BorderSizePixel = 0
frame2.ZIndex = 11
frame2.Visible = false
frame2.Parent = screenGui
local uiCorner = Instance.new("UICorner", frame2)
uiCorner.CornerRadius = UDim.new(0, 18)
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(35, 38, 55)
uiStroke.Thickness = 1
uiStroke.Parent = frame2
local textButton = Instance.new("TextButton")
textButton.Size = v and UDim2.new(0, 36, 0, 36) or UDim2.new(0, 26, 0, 26)
textButton.AnchorPoint = Vector2.new(1, 0)
textButton.Position = v and UDim2.new(1, -8, 0, 8) or UDim2.new(1, -10, 0, 10)
textButton.BackgroundColor3 = Color3.fromRGB(38, 20, 20)
textButton.TextColor3 = Color3.fromRGB(190, 75, 75)
textButton.Text = "X"
textButton.TextSize = v and 16 or 12
textButton.Font = Enum.Font.GothamBold
textButton.BorderSizePixel = 0
textButton.AutoButtonColor = false
textButton.ZIndex = 15
textButton.Parent = frame2
local uiCorner_2 = Instance.new("UICorner", textButton)
uiCorner_2.CornerRadius = UDim.new(0, 7)
local textLabel = Instance.new("TextLabel")
textLabel.Size = v and UDim2.new(1, -50, 0, 36) or UDim2.new(1, -60, 0, 36)
textLabel.Position = v and UDim2.new(0, 0, 0, 10) or UDim2.new(0, 30, 0, 14)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Daily Rewards"
textLabel.TextSize = v and 17 or 24
textLabel.Font = Enum.Font.GothamBold
textLabel.TextColor3 = Color3.fromRGB(240, 242, 255)
textLabel.TextXAlignment = Enum.TextXAlignment.Center
textLabel.ZIndex = 12
textLabel.Parent = frame2
local textLabel2 = Instance.new("TextLabel")
textLabel2.Size = UDim2.new(1, -60, 0, 20)
textLabel2.Position = v and UDim2.new(0, 20, 0, 38) or UDim2.new(0, 30, 0, 50)
textLabel2.BackgroundTransparency = 1
textLabel2.Text = "Welcome back, " .. LocalPlayer.DisplayName .. "!"
textLabel2.TextSize = v and 10 or 14
textLabel2.Font = Enum.Font.GothamBold
textLabel2.TextColor3 = Color3.fromRGB(225, 228, 255)
textLabel2.TextXAlignment = Enum.TextXAlignment.Center
textLabel2.ZIndex = 12
textLabel2.Parent = frame2
local textLabel3 = Instance.new("TextLabel")
textLabel3.Size = UDim2.new(1, -60, 0, 14)
textLabel3.Position = v and UDim2.new(0, 20, 0, 54) or UDim2.new(0, 30, 0, 70)
textLabel3.BackgroundTransparency = 1
textLabel3.Text = "Come back every day to claim bigger rewards."
textLabel3.TextSize = 10
textLabel3.Font = Enum.Font.Gotham
textLabel3.TextColor3 = Color3.fromRGB(80, 84, 118)
textLabel3.TextXAlignment = Enum.TextXAlignment.Center
textLabel3.ZIndex = 12
textLabel3.Parent = frame2
local v4 = v and 70 or 100
local v5 = v and 100 or 140
local v6 = v and 7 or 10
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, v and -20 or -40, 0, v5 + 4)
scrollingFrame.Position = v and UDim2.new(0, 10, 0, 68) or UDim2.new(0, 20, 0, 90)
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.BorderSizePixel = 0
scrollingFrame.ScrollBarThickness = 0
scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.X
scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollingFrame.ElasticBehavior = Enum.ElasticBehavior.Never
scrollingFrame.ZIndex = 12
scrollingFrame.Parent = frame2
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.FillDirection = Enum.FillDirection.Horizontal
uiListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
uiListLayout.Padding = UDim.new(0, v6)
uiListLayout.Parent = scrollingFrame
local uiPadding = Instance.new("UIPadding")
uiPadding.PaddingLeft = UDim.new(0, 2)
uiPadding.PaddingRight = UDim.new(0, 2)
uiPadding.Parent = scrollingFrame
local v7 = v and 190 or 256
local v8 = v and 34 or 38
local v9 = v and 14 or 20
local frame3 = Instance.new("Frame")
frame3.Size = UDim2.new(1, -40, 0, 1)
frame3.Position = v and UDim2.new(0, 14, 0, 178) or UDim2.new(0, 20, 0, 238)
frame3.BackgroundColor3 = Color3.fromRGB(30, 33, 50)
frame3.BorderSizePixel = 0
frame3.ZIndex = 12
frame3.Parent = frame2
local v10 = (v2 - v9 * 2 - 32) / 2
local textButton2 = Instance.new("TextButton")
textButton2.Size = UDim2.new(0, v10, 0, v8)
textButton2.Position = UDim2.new(0, v9, 0, v7)
textButton2.BackgroundColor3 = Color3.fromRGB(55, 138, 78)
textButton2.TextColor3 = Color3.fromRGB(230, 255, 235)
textButton2.Text = "CLAIM REWARD"
textButton2.TextSize = v and 10 or 13
textButton2.Font = Enum.Font.GothamBold
textButton2.BorderSizePixel = 0
textButton2.AutoButtonColor = false
textButton2.ZIndex = 13
textButton2.Parent = frame2
local uiCorner_3 = Instance.new("UICorner", textButton2)
uiCorner_3.CornerRadius = UDim.new(0, 10)
local textLabel4 = Instance.new("TextLabel")
textLabel4.Size = UDim2.new(0, 32, 0, v8)
textLabel4.Position = UDim2.new(0, v9 + v10, 0, v7)
textLabel4.BackgroundTransparency = 1
textLabel4.Text = "or"
textLabel4.TextSize = 11
textLabel4.Font = Enum.Font.Gotham
textLabel4.TextColor3 = Color3.fromRGB(70, 74, 108)
textLabel4.TextXAlignment = Enum.TextXAlignment.Center
textLabel4.TextYAlignment = Enum.TextYAlignment.Center
textLabel4.ZIndex = 13
textLabel4.Parent = frame2
local textButton3 = Instance.new("TextButton")
textButton3.Size = UDim2.new(0, v10, 0, v8)
textButton3.Position = UDim2.new(0, v9 + v10 + 32, 0, v7)
textButton3.BackgroundColor3 = Color3.fromRGB(155, 55, 65)
textButton3.TextColor3 = Color3.fromRGB(255, 210, 215)
textButton3.Text = "UNLOCK FOR 19 "
textButton3.TextSize = v and 9 or 12
textButton3.Font = Enum.Font.GothamBold
textButton3.BorderSizePixel = 0
textButton3.AutoButtonColor = false
textButton3.ZIndex = 13
textButton3.Parent = frame2
local uiCorner_4 = Instance.new("UICorner", textButton3)
uiCorner_4.CornerRadius = UDim.new(0, 10)
local textLabel5 = Instance.new("TextLabel")
textLabel5.Size = UDim2.new(1, -40, 0, 14)
textLabel5.Position = UDim2.new(0, 20, 0, v7 + v8 + 6)
textLabel5.BackgroundTransparency = 1
textLabel5.Text = ""
textLabel5.TextSize = 10
textLabel5.Font = Enum.Font.GothamBold
textLabel5.TextColor3 = Color3.fromRGB(100, 160, 240)
textLabel5.TextXAlignment = Enum.TextXAlignment.Center
textLabel5.ZIndex = 12
textLabel5.Parent = frame2
frame2.Size = UDim2.new(0, v2, 0, v7 + v8 + 6 + 14 + 20)
local frame4 = Instance.new("Frame")
frame4.Size = UDim2.new(0, 240, 0, 46)
frame4.AnchorPoint = Vector2.new(0.5, 0)
frame4.Position = UDim2.new(0.5, 0, 0, -70)
frame4.BackgroundColor3 = Color3.fromRGB(38, 122, 62)
frame4.BorderSizePixel = 0
frame4.ZIndex = 30
frame4.Parent = screenGui
local uiCorner_5 = Instance.new("UICorner", frame4)
uiCorner_5.CornerRadius = UDim.new(0, 12)
local textLabel6 = Instance.new("TextLabel")
textLabel6.Size = UDim2.new(1, 0, 1, 0)
textLabel6.BackgroundTransparency = 1
textLabel6.Text = ""
textLabel6.TextSize = 16
textLabel6.Font = Enum.Font.GothamBold
textLabel6.TextColor3 = Color3.fromRGB(200, 255, 215)
textLabel6.TextXAlignment = Enum.TextXAlignment.Center
textLabel6.ZIndex = 31
textLabel6.Parent = frame4

local function createSound(p, value, value2)
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxassetid://" .. p
	sound.Volume = value or 0.6
	sound.PlaybackSpeed = value2 or 1
	sound.RollOffMaxDistance = 0
	sound.Parent = SoundService
	return sound
end

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://" .. 4590662766
sound.Volume = 0.7
sound.PlaybackSpeed = 1
sound.RollOffMaxDistance = 0
sound.Parent = SoundService
local sound2 = Instance.new("Sound")
sound2.SoundId = "rbxassetid://" .. 6042053626
sound2.Volume = 0.4
sound2.PlaybackSpeed = 1.1
sound2.RollOffMaxDistance = 0
sound2.Parent = SoundService
local sound3 = Instance.new("Sound")
sound3.SoundId = "rbxassetid://" .. 6042053626
sound3.Volume = 0.3
sound3.PlaybackSpeed = 0.85
sound3.RollOffMaxDistance = 0
sound3.Parent = SoundService
local v11 = {}

local function buildCards(days)
	for _, v12 in ipairs(v11) do
		v12.root:Destroy()
	end

	v11 = {}
	local count = #days
	local v12 = count * v4 + (count - 1) * v6 + 4
	scrollingFrame.CanvasSize = UDim2.new(0, v12, 0, 0)

	for i = 1, count do
		local v13 = v3[(i - 1) % #v3 + 1]
		local frame5 = Instance.new("Frame")
		frame5.Size = UDim2.new(0, v4, 0, v5)
		frame5.BackgroundColor3 = v13
		frame5.BackgroundTransparency = 0.85
		frame5.BorderSizePixel = 0
		frame5.ZIndex = 13
		frame5.Parent = scrollingFrame
		local uiCorner = Instance.new("UICorner", frame5)
		uiCorner.CornerRadius = UDim.new(0, 14)
		local frame6 = Instance.new("Frame")
		frame6.Size = UDim2.new(1, 0, 1, 0)
		frame6.BackgroundColor3 = Color3.fromRGB(16, 18, 28)
		frame6.BorderSizePixel = 0
		frame6.ZIndex = 14
		frame6.Parent = frame5
		local uiCorner_2 = Instance.new("UICorner", frame6)
		uiCorner_2.CornerRadius = UDim.new(0, 14)
		local uiStroke2 = Instance.new("UIStroke")
		uiStroke2.Color = v13
		uiStroke2.Thickness = 1.5
		uiStroke2.Transparency = 0.65
		uiStroke2.Parent = frame6
		local textLabel7 = Instance.new("TextLabel")
		textLabel7.Size = UDim2.new(1, 0, 0, v and 42 or 72)
		textLabel7.Position = UDim2.new(0, 0, 0, v and 4 or 10)
		textLabel7.BackgroundTransparency = 1
		textLabel7.Text = "♫"
		textLabel7.TextSize = v and 28 or 48
		textLabel7.Font = Enum.Font.GothamBold
		textLabel7.TextColor3 = v13
		textLabel7.TextTransparency = 0.45
		textLabel7.TextXAlignment = Enum.TextXAlignment.Center
		textLabel7.ZIndex = 15
		textLabel7.Parent = frame6
		local textLabel8 = Instance.new("TextLabel")
		textLabel8.Size = UDim2.new(1, -4, 0, v and 14 or 18)
		textLabel8.Position = UDim2.new(0, 2, 0, v and 50 or 86)
		textLabel8.BackgroundTransparency = 1
		local v14

		if days[i] then
			v14 = days[i].dayNum or i
		else
			v14 = i
		end

		textLabel8.Text = "Day " .. v14
		textLabel8.TextSize = v and 9 or 12
		textLabel8.Font = Enum.Font.GothamBold
		textLabel8.TextColor3 = Color3.fromRGB(210, 215, 250)
		textLabel8.TextTransparency = 0.15
		textLabel8.TextXAlignment = Enum.TextXAlignment.Center
		textLabel8.ZIndex = 15
		textLabel8.Parent = frame6
		local textLabel9 = Instance.new("TextLabel")
		textLabel9.Size = UDim2.new(1, -4, 0, 14)
		textLabel9.Position = UDim2.new(0, 2, 0, v and 65 or 106)
		textLabel9.BackgroundTransparency = 1
		textLabel9.Text = (not days[i] and 75 or days[i].notes or 75) .. " Notes"
		textLabel9.TextSize = v and 8 or 10
		textLabel9.Font = Enum.Font.Gotham
		textLabel9.TextColor3 = Color3.fromRGB(130, 135, 175)
		textLabel9.TextTransparency = 0.15
		textLabel9.TextXAlignment = Enum.TextXAlignment.Center
		textLabel9.ZIndex = 15
		textLabel9.Parent = frame6
		local textLabel10 = Instance.new("TextLabel")
		textLabel10.Size = UDim2.new(1, 0, 0, v and 42 or 72)
		textLabel10.Position = UDim2.new(0, 0, 0, v and 4 or 10)
		textLabel10.BackgroundTransparency = 1
		textLabel10.Text = "✓"
		textLabel10.TextSize = 38
		textLabel10.Font = Enum.Font.GothamBold
		textLabel10.TextColor3 = Color3.fromRGB(75, 205, 115)
		textLabel10.TextXAlignment = Enum.TextXAlignment.Center
		textLabel10.TextYAlignment = Enum.TextYAlignment.Center
		textLabel10.TextTransparency = 1
		textLabel10.ZIndex = 16
		textLabel10.Parent = frame6
		v11[i] = {
			root = frame5,
			inner = frame6,
			stroke = uiStroke2,
			icon = textLabel7,
			dayLbl = textLabel8,
			notesLbl = textLabel9,
			checkLbl = textLabel10,
			color = v13
		}
	end
end

local function updateCards(p)
	for i, v12 in ipairs(v11) do
		local color = v12.color

		if i < p then
			v12.inner.BackgroundColor3 = Color3.fromRGB(12, 20, 13)
			v12.root.BackgroundColor3 = Color3.fromRGB(25, 80, 30)
			v12.root.BackgroundTransparency = 0.88
			v12.stroke.Color = Color3.fromRGB(35, 100, 42)
			v12.stroke.Transparency = 0.35
			v12.icon.TextColor3 = Color3.fromRGB(35, 95, 42)
			v12.icon.TextTransparency = 0.2
			v12.dayLbl.TextColor3 = Color3.fromRGB(50, 120, 58)
			v12.notesLbl.TextColor3 = Color3.fromRGB(38, 88, 44)
			v12.checkLbl.TextTransparency = 0
		elseif i == p then
			v12.inner.BackgroundColor3 = Color3.fromRGB(13, 17, 28)
			v12.root.BackgroundColor3 = color
			v12.root.BackgroundTransparency = 0.78
			v12.stroke.Color = color
			v12.stroke.Thickness = 2
			v12.stroke.Transparency = 0
			v12.icon.TextColor3 = color
			v12.icon.TextTransparency = 0
			v12.dayLbl.TextColor3 = Color3.fromRGB(230, 235, 255)
			v12.notesLbl.TextColor3 = Color3.fromRGB(160, 165, 210)
			v12.checkLbl.TextTransparency = 1
			local v13 = v12
			task.spawn(function()
				for _ = 1, 5 do
					TweenService:Create(
						v13.root,
						TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, true),
						{ BackgroundTransparency = 0.62 }
					):Play()
					task.wait(1.6)
				end
			end)
		else
			v12.inner.BackgroundColor3 = Color3.fromRGB(13, 14, 20)
			v12.root.BackgroundColor3 = Color3.fromRGB(22, 24, 36)
			v12.root.BackgroundTransparency = 0.92
			v12.stroke.Color = Color3.fromRGB(28, 30, 46)
			v12.stroke.Transparency = 0.55
			v12.icon.TextColor3 = Color3.fromRGB(38, 40, 62)
			v12.dayLbl.TextColor3 = Color3.fromRGB(52, 55, 82)
			v12.notesLbl.TextColor3 = Color3.fromRGB(38, 40, 62)
			v12.checkLbl.TextTransparency = 1
		end
	end

	task.defer(function()
		local v12 = (p - 1) * (v4 + v6)
		local x = scrollingFrame.AbsoluteSize.X
		local v13 = math.clamp(v12 - x / 2 + v4 / 2, 0, (math.max(0, scrollingFrame.CanvasSize.X.Offset - x)))
		TweenService:Create(scrollingFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
			CanvasPosition = Vector2.new(v13, 0)
		}):Play()
	end)
end

local v12 = 0
local thread = nil
local v13 = false

local function setClaimable(p) -- 3 equivalent calls inferred from this helper
	if p then
		textButton2.Text = "CLAIM REWARD"
		textButton2.BackgroundColor3 = Color3.fromRGB(55, 138, 78)
		textButton2.TextColor3 = Color3.fromRGB(230, 255, 235)
		textButton2.Active = true
		textButton3.BackgroundColor3 = Color3.fromRGB(62, 34, 38)
		textButton3.TextColor3 = Color3.fromRGB(120, 85, 90)
		textButton3.Active = false
	else
		textButton2.Text = "CLAIMED"
		textButton2.BackgroundColor3 = Color3.fromRGB(25, 45, 28)
		textButton2.TextColor3 = Color3.fromRGB(60, 110, 65)
		textButton2.Active = false
		textButton3.BackgroundColor3 = Color3.fromRGB(155, 55, 65)
		textButton3.TextColor3 = Color3.fromRGB(255, 210, 215)
		textButton3.Active = true
	end
end

local function fmtTimer(p) -- 1 equivalent call inferred from this helper
	local v14 = math.max(0, (math.floor(p)))
	return string.format("%02d:%02d:%02d", math.floor(v14 / 3600), math.floor(v14 % 3600 / 60), v14 % 60)
end

local function startTimer(timeLeft)
	if thread then
		task.cancel(thread)
	end

	v12 = math.floor(timeLeft)

	if v12 <= 0 then
		textLabel5.Text = ""
		setClaimable(true) -- inferred equivalent call
	else
		setClaimable(false) -- inferred equivalent call
		thread = task.spawn(function()
			while v12 > 0 do
				textLabel5.Text = "Next reward in " .. fmtTimer(v12) -- inferred equivalent call
				task.wait(1)
				v12 -= 1
			end

			textLabel5.Text = ""
			setClaimable(true) -- inferred equivalent call
		end)
	end
end

local flag = false

local function openWindow()
	if flag then
		return
	end

	flag = true
	sound2:Play()
	frame.Visible = true
	frame2.Visible = true
	frame2.BackgroundTransparency = 1
	TweenService:Create(frame, TweenInfo.new(0.2), { BackgroundTransparency = 0.55 }):Play()
	TweenService:Create(frame2, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		BackgroundTransparency = 0
	}):Play()
end

local function closeWindow(p)
	if not flag then
		return
	end

	flag = false
	sound3:Play()
	frame.Visible = false
	frame.Active = false
	frame2.Visible = false

	if not p then
		local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
		local menuEvents = ReplicatedStorage2:FindFirstChild("MenuEvents")
		local closeDailyReward = menuEvents and menuEvents:FindFirstChild("CloseDailyReward")

		if closeDailyReward then
			closeDailyReward:Fire()
		end
	end
end

textButton.MouseButton1Click:Connect(closeWindow)
frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		closeWindow()
	end
end)

local function showToast(text)
	textLabel6.Text = text
	frame4.Position = UDim2.new(0.5, 0, 0, -70)
	TweenService:Create(frame4, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Position = UDim2.new(0.5, 0, 0, 60)
	}):Play()
	task.delay(2.6, function()
		TweenService:Create(frame4, TweenInfo.new(0.22), { Position = UDim2.new(0.5, 0, 0, -70) }):Play()
	end)
end

textButton2.MouseButton1Click:Connect(function()
	if not textButton2.Active or v13 then
		return
	end

	v13 = true
	textButton2.Active = false
	DailyRewardClaim:FireServer()
end)

local function addHover(textButton4, color, color2)
	textButton4.MouseEnter:Connect(function()
		if textButton4.Active then
			TweenService:Create(textButton4, TweenInfo.new(0.1), { BackgroundColor3 = color }):Play()
		end
	end)
	textButton4.MouseLeave:Connect(function()
		if textButton4.Active then
			TweenService:Create(textButton4, TweenInfo.new(0.1), { BackgroundColor3 = color2 }):Play()
		end
	end)
end

addHover(textButton2, Color3.fromRGB(68, 158, 90), Color3.fromRGB(55, 138, 78))
addHover(textButton3, Color3.fromRGB(175, 68, 78), Color3.fromRGB(155, 55, 65))
addHover(textButton, Color3.fromRGB(50, 24, 24), Color3.fromRGB(38, 20, 20))
textButton3.MouseButton1Click:Connect(function()
	if not textButton3.Active then
		return
	end

	MarketplaceService:PromptProductPurchase(LocalPlayer, 3582033368)
end)
local v14 = false
DailyRewardData.OnClientEvent:Connect(function(data)
	if not data then
		return
	end

	v13 = false

	if data.days then
		buildCards(data.days)
		updateCards(1)
	end

	if data.claimed or data.unlocked then
		task.spawn(function()
			sound:Play()
		end)
	end

	startTimer(data.timeLeft or 0)

	if not v14 then
		v14 = true

		if not flag then
			openWindow()
		end
	end
end)
task.wait(2)
local MenuEvents = ReplicatedStorage:WaitForChild("MenuEvents", 15)
local openDailyReward = MenuEvents and MenuEvents:WaitForChild("OpenDailyReward", 10)
local closeDailyReward = MenuEvents and MenuEvents:WaitForChild("CloseDailyReward", 10)

if openDailyReward then
	openDailyReward.Event:Connect(function()
		openWindow()
	end)
end

if closeDailyReward then
	closeDailyReward.Event:Connect(function()
		if not flag then
			return
		end

		flag = false
		sound3:Play()
		frame.Visible = false
		frame.Active = false
		frame2.Visible = false
	end)
end

print("[DailyReward] Client loaded.")