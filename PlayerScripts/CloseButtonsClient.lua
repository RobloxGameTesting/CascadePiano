local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local MenuEvents = ReplicatedStorage:WaitForChild("MenuEvents", 15)

local function getEvent(childName) -- 4 equivalent calls inferred from this helper
	return MenuEvents and MenuEvents:WaitForChild(childName, 10)
end

local event = getEvent("CloseRooms") -- inferred equivalent call
local event2 = getEvent("CloseDailyReward") -- inferred equivalent call
local event3 = getEvent("CloseDailyQuests") -- inferred equivalent call
local event4 = getEvent("CloseLeaderboard") -- inferred equivalent call

local function addCloseButton(parent, onMouseButton1Click)
	if not parent or parent:FindFirstChild("__CloseBtn") then
		return
	end

	local textButton = Instance.new("TextButton")
	textButton.Name = "__CloseBtn"
	textButton.Text = "X"
	textButton.Size = UDim2.new(0, 26, 0, 26)
	textButton.AnchorPoint = Vector2.new(1, 0)
	textButton.Position = UDim2.new(1, -10, 0, 10)
	textButton.BackgroundColor3 = Color3.fromRGB(38, 20, 20)
	textButton.TextColor3 = Color3.fromRGB(190, 75, 75)
	textButton.Font = Enum.Font.GothamBold
	textButton.TextSize = 12
	textButton.ZIndex = 20
	textButton.BorderSizePixel = 0
	textButton.AutoButtonColor = false
	local uiCorner = Instance.new("UICorner", textButton)
	uiCorner.CornerRadius = UDim.new(0, 7)
	textButton.Parent = parent
	textButton.MouseButton1Click:Connect(onMouseButton1Click)
	return textButton
end

task.spawn(function()
	local roomSystemGUI = PlayerGui:WaitForChild("RoomSystemGUI", 30)

	if not roomSystemGUI then
		return
	end

	for _, childName in ipairs({ "MainFrame", "CreateRoomFrame", "PasswordFrame" }) do
		local child = roomSystemGUI:FindFirstChild(childName)

		if child then
			addCloseButton(child, function()
				if event then
					event:Fire()
				end
			end)
		end
	end
end)
task.spawn(function()
	local v = tick() + 30
	local v2 = nil

	while tick() < v do
		for _, frame in ipairs(PlayerGui:GetDescendants()) do
			if not (frame.Name == "Window" and frame:IsA("Frame") and frame.Parent and frame.Parent:IsA("ScreenGui")) then
				continue
			end

			if not frame:FindFirstChild("CloseBtn") then
				continue
			end

			v2 = frame
			break
		end

		if v2 then
			break
		else
			task.wait(0.5)
		end
	end

	if not v2 then
		return
	end

	addCloseButton(v2, function()
		if event2 then
			event2:Fire()
		end
	end)
end)
task.spawn(function()
	local v = tick() + 30
	local v2 = nil

	while tick() < v do
		for _, screenGui in ipairs(PlayerGui:GetChildren()) do
			if not (screenGui:IsA("ScreenGui") and screenGui.Name:lower():find("quest")) then
				continue
			end

			v2 = screenGui
			break
		end

		if not v2 then
			for _, screenGui in ipairs(PlayerGui:GetChildren()) do
				if screenGui:IsA("ScreenGui") then
					for _, descendant in ipairs(screenGui:GetDescendants()) do
						if not (descendant.Name == "QuestCard" or descendant.Name == "QuestsFrame") then
							continue
						end

						v2 = screenGui
						break
					end
				end

				if v2 then
					break
				end
			end
		end

		if v2 then
			break
		else
			task.wait(0.5)
		end
	end

	if not v2 then
		return
	end

	local frame = v2:FindFirstChildOfClass("Frame")

	if frame then
		addCloseButton(frame, function()
			if event3 then
				event3:Fire()
			end
		end)
	end
end)
task.spawn(function()
	local leaderboardGUI = PlayerGui:WaitForChild("LeaderboardGUI", 30)

	if not leaderboardGUI then
		return
	end

	local leaderboardFrame = leaderboardGUI:FindFirstChild("LeaderboardFrame")

	if leaderboardFrame then
		addCloseButton(leaderboardFrame, function()
			if event4 then
				event4:Fire()
			end
		end)
	end
end)
print("[CloseButtonsClient] Loaded!")