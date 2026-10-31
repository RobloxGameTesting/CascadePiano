local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local DailyQuestsRemotes = ReplicatedStorage:WaitForChild("DailyQuestsRemotes")
local DQ_RequestData = DailyQuestsRemotes:WaitForChild("DQ_RequestData")
local DQ_Data = DailyQuestsRemotes:WaitForChild("DQ_Data")
local DQ_TrackEvent = DailyQuestsRemotes:WaitForChild("DQ_TrackEvent")
local Room_NoteForwarded = ReplicatedStorage:WaitForChild("Room_NoteForwarded")
require(ReplicatedStorage:WaitForChild("Icon"))
local v = {}
Room_NoteForwarded.OnClientEvent:Connect(function(p)
	if v[p] then
		return
	end

	v[p] = true
	DQ_TrackEvent:FireServer("listen_players", p)
end)
ReplicatedStorage:WaitForChild("Room_PlayerLeft").OnClientEvent:Connect(function(p)
	if p and p.roomClosed then
		v = {}
	end
end)
local v2 = {
	play_notes = function(p)
		return string.format("Play %d notes", p)
	end,
	play_time = function(p)
		return string.format("Play for %d minutes", p)
	end,
	listen_players = function(p)
		return string.format("Listen to %d players", p)
	end,
	join_rooms = function(p)
		return string.format("Visit %d rooms", p)
	end
}
local v3 = {
	play_notes = "rbxassetid://170813352",
	play_time = "rbxassetid://6846329320",
	listen_players = "rbxassetid://126358805627316",
	join_rooms = "rbxassetid://11974681757"
}
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DailyQuestsGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 15
screenGui.Enabled = false
screenGui.Parent = PlayerGui
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 340, 0, 310)
frame.Position = UDim2.new(0.5, 0, 0.35, 0)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(22, 24, 38)
frame.BorderSizePixel = 0
frame.Parent = screenGui
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 14)
uiCorner.Parent = frame
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(90, 100, 200)
uiStroke.Thickness = 2
uiStroke.Parent = frame
local textLabel = Instance.new("TextLabel")
textLabel.Name = "Title"
textLabel.Size = UDim2.new(1, 0, 0, 44)
textLabel.Position = UDim2.new(0, 0, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.Text = "Daily Quests"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.Font = Enum.Font.GothamBold
textLabel.TextSize = 22
textLabel.Parent = frame
local textLabel2 = Instance.new("TextLabel")
textLabel2.Name = "Timer"
textLabel2.Size = UDim2.new(1, -20, 0, 20)
textLabel2.Position = UDim2.new(0, 10, 0, 44)
textLabel2.BackgroundTransparency = 1
textLabel2.Text = "Resets in: --:--:--"
textLabel2.TextColor3 = Color3.fromRGB(160, 170, 220)
textLabel2.Font = Enum.Font.Gotham
textLabel2.TextSize = 13
textLabel2.TextXAlignment = Enum.TextXAlignment.Center
textLabel2.Parent = frame
local frame2 = Instance.new("Frame")
frame2.Name = "QuestsContainer"
frame2.Size = UDim2.new(1, -20, 0, 228)
frame2.Position = UDim2.new(0, 10, 0, 72)
frame2.BackgroundTransparency = 1
frame2.Parent = frame
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 8)
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Parent = frame2
local v4 = {}

local function makeQuestCard(layoutOrder)
	local frame3 = Instance.new("Frame")
	frame3.Name = "Quest_" .. layoutOrder
	frame3.Size = UDim2.new(1, 0, 0, 68)
	frame3.BackgroundColor3 = Color3.fromRGB(32, 36, 58)
	frame3.BorderSizePixel = 0
	frame3.LayoutOrder = layoutOrder
	frame3.Parent = frame2
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 10)
	uiCorner2.Parent = frame3
	local uiStroke2 = Instance.new("UIStroke")
	uiStroke2.Color = Color3.fromRGB(60, 70, 130)
	uiStroke2.Thickness = 1
	uiStroke2.Name = "CardStroke"
	uiStroke2.Parent = frame3
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "QuestIcon"
	imageLabel.Size = UDim2.new(0, 22, 0, 22)
	imageLabel.Position = UDim2.new(0, 10, 0, 7)
	imageLabel.BackgroundTransparency = 1
	imageLabel.Image = ""
	imageLabel.Parent = frame3
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.Name = "QuestName"
	textLabel3.Size = UDim2.new(1, -120, 0, 22)
	textLabel3.Position = UDim2.new(0, 38, 0, 8)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Text = "..."
	textLabel3.TextColor3 = Color3.fromRGB(230, 235, 255)
	textLabel3.Font = Enum.Font.GothamMedium
	textLabel3.TextSize = 13
	textLabel3.TextXAlignment = Enum.TextXAlignment.Left
	textLabel3.TextTruncate = Enum.TextTruncate.AtEnd
	textLabel3.Parent = frame3
	local textLabel4 = Instance.new("TextLabel")
	textLabel4.Name = "Reward"
	textLabel4.Size = UDim2.new(0, 100, 0, 22)
	textLabel4.Position = UDim2.new(1, -108, 0, 8)
	textLabel4.BackgroundTransparency = 1
	textLabel4.Text = "+0 🎵"
	textLabel4.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel4.Font = Enum.Font.GothamBold
	textLabel4.TextSize = 13
	textLabel4.TextXAlignment = Enum.TextXAlignment.Right
	textLabel4.Parent = frame3
	local textLabel5 = Instance.new("TextLabel")
	textLabel5.Name = "ProgressText"
	textLabel5.Size = UDim2.new(1, -24, 0, 16)
	textLabel5.Position = UDim2.new(0, 12, 0, 32)
	textLabel5.BackgroundTransparency = 1
	textLabel5.Text = "0 / 0"
	textLabel5.TextColor3 = Color3.fromRGB(140, 150, 200)
	textLabel5.Font = Enum.Font.Gotham
	textLabel5.TextSize = 11
	textLabel5.TextXAlignment = Enum.TextXAlignment.Left
	textLabel5.Parent = frame3
	local frame4 = Instance.new("Frame")
	frame4.Name = "BarBg"
	frame4.Size = UDim2.new(1, -24, 0, 10)
	frame4.Position = UDim2.new(0, 12, 0, 50)
	frame4.BackgroundColor3 = Color3.fromRGB(50, 55, 85)
	frame4.BorderSizePixel = 0
	frame4.Parent = frame3
	local uiCorner3 = Instance.new("UICorner")
	uiCorner3.CornerRadius = UDim.new(0, 5)
	uiCorner3.Parent = frame4
	local frame5 = Instance.new("Frame")
	frame5.Name = "BarFill"
	frame5.Size = UDim2.new(0, 0, 1, 0)
	frame5.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
	frame5.BorderSizePixel = 0
	frame5.Parent = frame4
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 5)
	uiCorner4.Parent = frame5
	v4[layoutOrder] = {
		card = frame3,
		questIcon = imageLabel,
		questName = textLabel3,
		rewardLabel = textLabel4,
		progressText = textLabel5,
		barFill = frame5,
		cardStroke = uiStroke2
	}
end

makeQuestCard(1)
makeQuestCard(2)
makeQuestCard(3)
local timeLeft = 0

local function updateCard(i, quest)
	local v5 = v4[i]

	if not v5 then
		return
	end

	local v6 = v2[quest.type]
	v5.questName.Text = v6 and v6(quest.target) or quest.type
	v5.questIcon.Image = v3[quest.type] or ""
	v5.rewardLabel.Text = "+" .. quest.reward .. " ♬"
	local v7 = math.clamp(quest.progress / quest.target, 0, 1)

	if quest.type == "play_time" then
		v5.progressText.Text = string.format("%d / %d min", quest.progress, quest.target)
	else
		v5.progressText.Text = string.format("%d / %d", quest.progress, quest.target)
	end

	TweenService:Create(v5.barFill, TweenInfo.new(0.35, Enum.EasingStyle.Quad), {
		Size = UDim2.new(v7, 0, 1, 0)
	}):Play()

	if quest.completed then
		v5.barFill.BackgroundColor3 = Color3.fromRGB(60, 210, 100)
		v5.cardStroke.Color = Color3.fromRGB(60, 200, 100)
		v5.questName.TextColor3 = Color3.fromRGB(150, 255, 150)
		v5.rewardLabel.Text = "✅ Claimed"
	else
		v5.barFill.BackgroundColor3 = Color3.fromRGB(80, 140, 255)
		v5.cardStroke.Color = Color3.fromRGB(60, 70, 130)
		v5.questName.TextColor3 = Color3.fromRGB(230, 235, 255)
	end
end

local function formatTime(timeLeft2) -- 1 equivalent call inferred from this helper
	local v5 = math.max(0, (math.floor(timeLeft2)))
	local v6 = math.floor(v5 / 3600)
	local v7 = math.floor(v5 % 3600 / 60)
	local v8 = v5 % 60
	return string.format("%02d:%02d:%02d", v6, v7, v8)
end

DQ_Data.OnClientEvent:Connect(function(p)
	timeLeft = p.timeLeft or 0

	if p.quests then
		for i, quest in ipairs(p.quests) do
			updateCard(i, quest)
		end
	end
end)
task.spawn(function()
	while true do
		task.wait(1)
		timeLeft = math.max(0, timeLeft - 1)
		textLabel2.Text = "Resets in: " .. formatTime(timeLeft) -- inferred equivalent call
	end
end)
task.wait(4)
local MenuEvents = ReplicatedStorage:WaitForChild("MenuEvents", 15)
local openDailyQuests = MenuEvents and MenuEvents:WaitForChild("OpenDailyQuests", 10)
local closeDailyQuests = MenuEvents and MenuEvents:WaitForChild("CloseDailyQuests", 10)

if openDailyQuests then
	openDailyQuests.Event:Connect(function()
		screenGui.Enabled = true
		DQ_RequestData:FireServer()
	end)
end

if closeDailyQuests then
	closeDailyQuests.Event:Connect(function()
		screenGui.Enabled = false
	end)
end

task.wait(3)
DQ_RequestData:FireServer()
print("[DailyQuestsClient] Loaded!")