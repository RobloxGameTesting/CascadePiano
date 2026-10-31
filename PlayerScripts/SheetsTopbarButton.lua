local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local mainFrame = Players.LocalPlayer.PlayerGui:WaitForChild("TrelloSheetsUI"):WaitForChild("MainFrame")
local MenuEvents = ReplicatedStorage:WaitForChild("MenuEvents", 15)
local OpenSheets = MenuEvents:WaitForChild("OpenSheets", 10)
local CloseSheets = MenuEvents:WaitForChild("CloseSheets", 10)
local blurEffect = nil

local function openSheets()
	mainFrame.Visible = true

	if not blurEffect then
		blurEffect = Instance.new("BlurEffect")
		blurEffect.Size = 12
		blurEffect.Parent = Lighting
	end

	blurEffect.Enabled = true
end

local function closeSheets()
	mainFrame.Visible = false

	if blurEffect then
		blurEffect.Enabled = false
	end
end

OpenSheets.Event:Connect(openSheets)
CloseSheets.Event:Connect(closeSheets)
local bindableEvent = Instance.new("BindableEvent")
bindableEvent.Name = "CloseSheetsIcon"
bindableEvent.Parent = ReplicatedStorage
bindableEvent.Event:Connect(function()
	CloseSheets:Fire()
end)
print("[SheetsTopbarButton] Sheets integrated into Menu dropdown")