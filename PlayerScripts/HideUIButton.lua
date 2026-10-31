local Players = game:GetService("Players")
game:GetService("RunService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local child = PlayerGui:WaitForChild(
	UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and "FulllScreenPianoMobileUI" or "FulllScreenPianoUI",
	30
)

if not child then
	warn("[HideUI] PianoGui not found")
	return
end

local pianoContainer = child:WaitForChild("PianoContainer", 10)

if not pianoContainer then
	warn("[HideUI] PianoContainer not found")
	return
end

local keyFrame = pianoContainer:WaitForChild("KeyFrame", 10)
local Icon = require(game.ReplicatedStorage:WaitForChild("Icon"))
local backgroundTransparency = pianoContainer.BackgroundTransparency
local v = false
local NotesGui = PlayerGui:WaitForChild("NotesGui", 30)

local function applyHideState(p)
	v = p

	for _, guiObject in ipairs(pianoContainer:GetChildren()) do
		if not (guiObject ~= keyFrame and guiObject.Name ~= "_TrailCanvas" and guiObject.Name ~= "BubblesBG" and guiObject:IsA("GuiObject")) then
			continue
		end

		guiObject.Visible = not p
	end

	if NotesGui then
		NotesGui.Enabled = not p
	end
end

local v2 = Icon.new()
v2:setImage("rbxassetid://102976018150012")
v2:setLabel("Hide UI")
v2:setOrder(10)
v2:setRight()
v2:bindEvent("selected", function()
	applyHideState(true)
end)
v2:bindEvent("deselected", function()
	applyHideState(false)
end)

local function syncIconEnabled() -- 1 equivalent call inferred from this helper
	v2:setEnabled(child.Enabled)

	if not child.Enabled and v then
		applyHideState(false)
		v2:deselect()
	end
end

child:GetPropertyChangedSignal("Enabled"):Connect(syncIconEnabled)
syncIconEnabled() -- inferred equivalent call
print("[HideUI] Icon топбар кнопка создана!")