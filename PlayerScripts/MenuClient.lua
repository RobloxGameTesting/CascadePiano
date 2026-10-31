local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local Icon = require(ReplicatedStorage:WaitForChild("Icon"))

local function waitForGui(childName, value)
	local lastTime = tick()
	local v = value or 15

	while tick() - lastTime < v do
		local child = PlayerGui:FindFirstChild(childName)

		if child then
			return child
		else
			task.wait(0.2)
		end
	end

	return nil
end

local parent2 = ReplicatedStorage:FindFirstChild("MenuEvents")

if not parent2 then
	parent2 = Instance.new("Folder")
	parent2.Name = "MenuEvents"
	parent2.Parent = ReplicatedStorage
end

local function getOrCreate(parent, className, name)
	local child = parent:FindFirstChild(name)

	if child then
		return child
	end

	local instance = Instance.new(className)
	instance.Name = name
	instance.Parent = parent
	return instance
end

local openEvent = parent2:FindFirstChild("OpenRooms")

if not openEvent then
	openEvent = Instance.new("BindableEvent")
	openEvent.Name = "OpenRooms"
	openEvent.Parent = parent2
end

local closeEvent = parent2:FindFirstChild("CloseRooms")

if not closeEvent then
	closeEvent = Instance.new("BindableEvent")
	closeEvent.Name = "CloseRooms"
	closeEvent.Parent = parent2
end

local openEvent2 = parent2:FindFirstChild("OpenDailyReward")

if not openEvent2 then
	openEvent2 = Instance.new("BindableEvent")
	openEvent2.Name = "OpenDailyReward"
	openEvent2.Parent = parent2
end

local closeEvent2 = parent2:FindFirstChild("CloseDailyReward")

if not closeEvent2 then
	closeEvent2 = Instance.new("BindableEvent")
	closeEvent2.Name = "CloseDailyReward"
	closeEvent2.Parent = parent2
end

local openEvent3 = parent2:FindFirstChild("OpenDailyQuests")

if not openEvent3 then
	openEvent3 = Instance.new("BindableEvent")
	openEvent3.Name = "OpenDailyQuests"
	openEvent3.Parent = parent2
end

local closeEvent3 = parent2:FindFirstChild("CloseDailyQuests")

if not closeEvent3 then
	closeEvent3 = Instance.new("BindableEvent")
	closeEvent3.Name = "CloseDailyQuests"
	closeEvent3.Parent = parent2
end

local openEvent4 = parent2:FindFirstChild("OpenLeaderboard")

if not openEvent4 then
	openEvent4 = Instance.new("BindableEvent")
	openEvent4.Name = "OpenLeaderboard"
	openEvent4.Parent = parent2
end

local closeEvent4 = parent2:FindFirstChild("CloseLeaderboard")

if not closeEvent4 then
	closeEvent4 = Instance.new("BindableEvent")
	closeEvent4.Name = "CloseLeaderboard"
	closeEvent4.Parent = parent2
end

local openEvent5 = parent2:FindFirstChild("OpenPractice")

if not openEvent5 then
	openEvent5 = Instance.new("BindableEvent")
	openEvent5.Name = "OpenPractice"
	openEvent5.Parent = parent2
end

local closeEvent5 = parent2:FindFirstChild("ClosePractice")

if not closeEvent5 then
	closeEvent5 = Instance.new("BindableEvent")
	closeEvent5.Name = "ClosePractice"
	closeEvent5.Parent = parent2
end

local openEvent6 = parent2:FindFirstChild("OpenSheets")

if not openEvent6 then
	openEvent6 = Instance.new("BindableEvent")
	openEvent6.Name = "OpenSheets"
	openEvent6.Parent = parent2
end

local closeEvent6 = parent2:FindFirstChild("CloseSheets")

if not closeEvent6 then
	closeEvent6 = Instance.new("BindableEvent")
	closeEvent6.Name = "CloseSheets"
	closeEvent6.Parent = parent2
end

local v = Icon.new()
v:setImage("rbxassetid://14895352864")
v:setLabel("Menu")
v:setOrder(1)
Icon.setDisplayOrder(600)
local v2 = {
	{
		label = "Rooms",
		image = "rbxassetid://12122755689",
		openEvent = openEvent,
		closeEvent = closeEvent
	},
	{
		label = "Daily Rewards",
		image = "rbxassetid://111576444061359",
		openEvent = openEvent2,
		closeEvent = closeEvent2
	},
	{
		label = "Daily Quests",
		image = "rbxassetid://14135445185",
		openEvent = openEvent3,
		closeEvent = closeEvent3
	},
	{
		label = "Leaderboard",
		image = "rbxassetid://117492667198151",
		openEvent = openEvent4,
		closeEvent = closeEvent4
	},
	{
		label = "Practice",
		image = "rbxassetid://133754377546128",
		openEvent = openEvent5,
		closeEvent = closeEvent5
	},
	{
		label = "Sheets",
		image = "rbxassetid://89352212342464",
		openEvent = openEvent6,
		closeEvent = closeEvent6
	}
}
game:GetService("UserInputService")
local v3 = {}

for i, v4 in ipairs(v2) do
	local v5 = Icon.new()
	v5:setImage(v4.image)
	v5:setLabel(v4.label)
	v5:setOrder(i)
	v5.Parent = script
	local v6 = v4
	v5.selected:Connect(function()
		v6.openEvent:Fire()
		v:deselect()
	end)
	local v7 = v4
	v5.deselected:Connect(function()
		v7.closeEvent:Fire()
	end)
	table.insert(v3, v5)
end

v:setDropdown(v3)

local function deselByLabel(p)
	for i, v4 in ipairs(v2) do
		if v4.label ~= p then
			continue
		end

		v3[i]:deselect()
		break
	end
end

closeEvent.Event:Connect(function()
	deselByLabel("Rooms")
end)
closeEvent2.Event:Connect(function()
	deselByLabel("Daily Rewards")
end)
closeEvent3.Event:Connect(function()
	deselByLabel("Daily Quests")
end)
closeEvent4.Event:Connect(function()
	deselByLabel("Leaderboard")
end)
closeEvent5.Event:Connect(function()
	deselByLabel("Practice")
end)
closeEvent6.Event:Connect(function()
	deselByLabel("Sheets")
end)
print("[MenuClient] Menu icon initialized with", #v3, "items")