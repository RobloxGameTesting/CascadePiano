local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local SoundfontLoadStatus = ReplicatedStorage:WaitForChild("SoundfontLoadStatus", 10)

if not SoundfontLoadStatus then
	warn("[SoundfontNotifier] SoundfontLoadStatus not found!")
	return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SoundfontNotifierGui"
screenGui.ResetOnSpawn = false
screenGui.DisplayOrder = 100
screenGui.IgnoreGuiInset = true
screenGui.Parent = PlayerGui
local frame = Instance.new("Frame")
frame.Name = "NotifFrame"
frame.Size = UDim2.new(0, 280, 0, 48)
frame.AnchorPoint = Vector2.new(0.5, 0)
frame.Position = UDim2.new(0.5, 0, 0, -60)
frame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = screenGui
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = frame
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(60, 60, 100)
uiStroke.Thickness = 1
uiStroke.Parent = frame
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -16, 1, 0)
textLabel.Position = UDim2.new(0, 8, 0, 0)
textLabel.BackgroundTransparency = 1
textLabel.TextColor3 = Color3.fromRGB(220, 220, 255)
textLabel.TextSize = 14
textLabel.Font = Enum.Font.GothamBold
textLabel.TextXAlignment = Enum.TextXAlignment.Left
textLabel.TextTruncate = Enum.TextTruncate.AtEnd
textLabel.Text = ""
textLabel.Parent = frame
local thread = nil
local v = false

local function showNotif(text, color)
	if thread then
		task.cancel(thread)
		thread = nil
	end

	textLabel.Text = text
	uiStroke.Color = color
	frame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)

	if not v then
		v = true
		TweenService:Create(frame, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, 0, 0, 12)
		}):Play()
	end
end

local function hideNotif(duration) -- 1 equivalent call inferred from this helper
	thread = task.delay(duration, function()
		TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, 0, 0, -60)
		}):Play()
		task.wait(0.35)
		v = false
		thread = nil
	end)
end

SoundfontLoadStatus.Event:Connect(function(p, p2)
	if p == "loading" then
		showNotif("⏳  " .. p2 .. " is loading...", Color3.fromRGB(80, 80, 160))
	elseif p == "done" then
		showNotif("✅  " .. p2 .. " loaded!", Color3.fromRGB(40, 160, 80))
		uiStroke.Color = Color3.fromRGB(40, 160, 80)
		hideNotif(2.5) -- inferred equivalent call
	end
end)