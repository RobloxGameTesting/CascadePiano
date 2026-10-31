local Players2 = game:GetService("Players")
Players = Players2
local ContextActionService2 = game:GetService("ContextActionService")
ContextActionService = ContextActionService2
local UserInputService2 = game:GetService("UserInputService")
UserInputService = UserInputService2
local RunService2 = game:GetService("RunService")
RunService = RunService2
local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
ReplicatedStorage = ReplicatedStorage2
local ContentProvider2 = game:GetService("ContentProvider")
ContentProvider = ContentProvider2
Piano_Dependencies = workspace:FindFirstChild("Piano_Dependencies")

if not Piano_Dependencies then
	warn("[PianoMain] Piano_Dependencies not found!")
	return
end

Folder_Modules = Piano_Dependencies:FindFirstChild("Modules")
Folder_Remotes = Piano_Dependencies:FindFirstChild("Remotes")

if not (Folder_Modules and Folder_Remotes) then
	warn("[PianoMain] Required folders not found!")
	return
end

Folder_Logic = Folder_Modules:FindFirstChild("Logic")
Folder_Dependencies = Folder_Modules:FindFirstChild("Dependencies")

if not (Folder_Logic and Folder_Dependencies) then
	warn("[PianoMain] Logic or Dependencies not found!")
	return
end

local DraggableObject = require(Folder_Dependencies:FindFirstChild("DraggableObject"))
local Soundfonts = require(Folder_Dependencies:FindFirstChild("Soundfonts"))
local PlayerVariables = require(Folder_Dependencies:FindFirstChild("PlayerVariables"))
local PianoLogic = require(Folder_Logic:FindFirstChild("PianoLogic"))
_G.PianoLogicInstance = PianoLogic
local CharacterLogic = require(Folder_Logic:FindFirstChild("CharacterLogic"))
local KeymapLogic = require(Folder_Logic:FindFirstChild("KeymapLogic"))
local UILogic = require(Folder_Logic:FindFirstChild("UILogic"))
LocalPlayer = Players.LocalPlayer
Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
Humanoid = Character:WaitForChild("Humanoid")
local v = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local KeyboardEnabled = UserInputService.KeyboardEnabled
print("[PianoMain] Device type:", v and "Mobile" or "PC")
local v2 = KeyboardEnabled and "PianoUI" or "PianoMobile"
local child = ReplicatedStorage:FindFirstChild(v2)

if not child then
	warn("[PianoMain] GUI not found:", v2)
	return
end

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local clone = child:Clone()
clone.Parent = PlayerGui
clone.Enabled = false
local pianoContainer = clone:FindFirstChild("PianoContainer")

if not pianoContainer then
	warn("[PianoMain] PianoContainer not found")
	return
end

local keyFrame = pianoContainer:FindFirstChild("KeyFrame")
local optionFrame = pianoContainer:FindFirstChild("OptionFrame")
local screen = pianoContainer:FindFirstChild("Screen")
local velocityBar = pianoContainer:FindFirstChild("VelocityBar")

if not (keyFrame and optionFrame) then
	warn("[PianoMain] Required frames not found")
	return
end

local flag = false
local flag2 = false
local pianoSustainPacket = true
_G.PianoSustainPacket = true
Transposition = 0
Velocity = 50
LocalVolume = 100
KEY_OFFSET = 15
local v3 = {}
local v4 = {}
local soundfonts = pianoContainer:FindFirstChild("Soundfonts")
local sheets = pianoContainer:FindFirstChild("Sheets")

if soundfonts then
	table.insert(v4, soundfonts)
end

if sheets then
	table.insert(v4, sheets)
end

local function ShowLoadingStatus(text) -- 2 equivalent calls inferred from this helper
	if screen and screen:FindFirstChild("Instructions") then
		screen.Instructions.Visible = true
		screen.Instructions.Text = text
	end
end

local function HideLoadingStatus() -- 1 equivalent call inferred from this helper
	if screen and screen:FindFirstChild("Instructions") then
		screen.Instructions.Visible = false
		screen.Instructions.Text = ""
	end
end

local function PreloadCurrentSoundfont()
	local soundfont = Soundfonts[PlayerVariables.Current_SoundfontID]

	if not soundfont then
		return
	end

	local assetIds = soundfont.AssetIds
	local name = soundfont.Name or "Unknown"
	local v5 = {}

	for _, assetId in ipairs(assetIds) do
		local sound = Instance.new("Sound")
		sound.SoundId = "rbxassetid://" .. assetId
		sound.Parent = game:GetService("SoundService")
		table.insert(v5, sound)
	end

	print("[Piano] Preloading:", name, "| Assets:", #v5)
	ShowLoadingStatus("⏳ " .. name .. "...") -- inferred equivalent call
	ContentProvider:PreloadAsync(v5)

	for _, v6 in ipairs(v5) do
		v6:Destroy()
	end

	print("[Piano] Preload done:", name)
	ShowLoadingStatus("✅ " .. name .. " готов!") -- inferred equivalent call
	task.wait(1.5)
	HideLoadingStatus() -- inferred equivalent call
end

local v5 = {}
local v6 = {}
local v7 = {}
local v8 = {}

local function GetKeyBounds(p) -- 1 equivalent call inferred from this helper
	return {
		min = p.AbsolutePosition,
		max = p.AbsolutePosition + p.AbsoluteSize
	}
end

local function IsTouchInsideKey(p, button)
	if not (button and button.Parent) then
		return false
	end

	local keyBounds = GetKeyBounds(button) -- inferred equivalent call
	return p.X >= keyBounds.min.X and p.X <= keyBounds.max.X and p.Y >= keyBounds.min.Y and p.Y <= keyBounds.max.Y
end

local function FindKeyAtPosition(vector)
	for _, button in pairs(keyFrame:GetChildren()) do
		if button:IsA("ImageButton") and tonumber(button.Name) and IsTouchInsideKey(vector, button) then
			return button
		end
	end

	return nil
end

local function GetPianoModule()
	local seatPart = Humanoid.SeatPart

	if not seatPart then
		return nil
	end

	local parent = seatPart.Parent

	if not parent then
		return nil
	end

	local scripts = parent:FindFirstChild("Scripts")

	if not scripts then
		return nil
	end

	local pianoModule = scripts:FindFirstChild("PianoModule")

	if pianoModule and pianoModule:IsA("ModuleScript") then
		return pianoModule
	end

	return nil
end

local function ReleaseKey(p)
	if not (p and p.Parent and v5[p]) then
		return
	end

	local v9 = v6[p]
	local v10 = v7[p]
	pcall(function()
		UILogic.FinishNote(keyFrame, v9)
	end)
	local seatPart = Humanoid.SeatPart
	local pianoModule

	if seatPart then
		local parent = seatPart.Parent

		if parent then
			local scripts = parent:FindFirstChild("Scripts")

			if scripts then
				pianoModule = scripts:FindFirstChild("PianoModule")

				if not (pianoModule and pianoModule:IsA("ModuleScript")) then
					pianoModule = nil
				end
			else
				pianoModule = nil
			end
		else
			pianoModule = nil
		end
	else
		pianoModule = nil
	end

	if pianoModule and v10 then
		pcall(function()
			local module = require(pianoModule)
			module.PianoAnimation(v10 + KEY_OFFSET, false)
			Folder_Remotes.AnimationRemote:FireServer(v10 + KEY_OFFSET, false)
		end)
	end

	local soundfont = Soundfonts[PlayerVariables.Current_SoundfontID]
	PianoLogic.FinishNonSustainNote(Enum.KeyCode.Unknown, soundfont.Fadeout)
	Folder_Remotes.SustainRemote:FireServer(Enum.KeyCode.Unknown, soundfont.Fadeout)
	v5[p] = nil
	v6[p] = nil
	v7[p] = nil
end

local function PressKey(instance, p)
	if not (instance and instance.Parent and v8[p] ~= instance) then
		return
	end

	local v9 = v8[p]

	if v9 then
		ReleaseKey(v9)
	end

	if v5[instance] then
		return
	end

	v8[p] = instance
	v5[instance] = true
	local soundfont = Soundfonts[PlayerVariables.Current_SoundfontID]
	local name = tonumber(instance.Name)

	if not name then
		return
	end

	local v10 = name + Transposition
	pcall(function()
		PianoLogic[soundfont.PacketType](
			v10,
			soundfont.AssetIds,
			soundfont.Offset,
			soundfont.MaxLifetime,
			soundfont.Fadeout,
			Transposition,
			soundfont.PacketType,
			pianoSustainPacket,
			false,
			Velocity,
			LocalVolume,
			soundfont.VolumeModifier,
			Enum.KeyCode.Unknown
		)
	end)
	v6[instance] = name
	v7[instance] = v10
	pcall(function()
		UILogic.PlayNote(keyFrame, name)
	end)
	local seatPart = Humanoid.SeatPart
	local pianoModule

	if seatPart then
		local parent = seatPart.Parent

		if parent then
			local scripts = parent:FindFirstChild("Scripts")

			if scripts then
				pianoModule = scripts:FindFirstChild("PianoModule")

				if not (pianoModule and pianoModule:IsA("ModuleScript")) then
					pianoModule = nil
				end
			else
				pianoModule = nil
			end
		else
			pianoModule = nil
		end
	else
		pianoModule = nil
	end

	if pianoModule then
		pcall(function()
			local module = require(pianoModule)
			module.PianoAnimation(v10 + KEY_OFFSET, true)
			Folder_Remotes.AnimationRemote:FireServer(v10 + KEY_OFFSET, true)
		end)
	end
end

UserInputService.TouchMoved:Connect(function(p, _)
	if not clone.Enabled then
		return
	end

	local keyCode = p.KeyCode
	local position = p.Position
	local keyAtPosition = FindKeyAtPosition(Vector2.new(position.X, position.Y))
	local v9 = v8[keyCode]

	if keyAtPosition ~= v9 then
		if v9 then
			ReleaseKey(v9)
			v8[keyCode] = nil
		end

		if keyAtPosition then
			PressKey(keyAtPosition, keyCode)
		end
	end
end)
UserInputService.TouchEnded:Connect(function(otherPart, _)
	if not clone.Enabled then
		return
	end

	local keyCode = otherPart.KeyCode
	local v9 = v8[keyCode]

	if v9 then
		ReleaseKey(v9)
		v8[keyCode] = nil
	end
end)
local v9 = false
local v10 = nil

local function PressKeyMouse(p)
	if not (p and p.Parent and v10 ~= p) then
		return
	end

	if v10 then
		ReleaseKey(v10)
		v8.mouse = nil
		v10 = nil
	end

	PressKey(p, "mouse")
	v10 = p
end

local function ReleaseMouseKey() -- 3 equivalent calls inferred from this helper
	if v10 then
		ReleaseKey(v10)
		v8.mouse = nil
		v10 = nil
	end

	v9 = false
end

UserInputService.WindowFocusReleased:Connect(function()
	for k in pairs(v5) do
		ReleaseKey(k)
	end

	table.clear(v8)
	table.clear(v5)
	table.clear(v6)
	table.clear(v7)
	ReleaseMouseKey() -- inferred equivalent call

	if KeyboardEnabled then
		local soundfont = Soundfonts[PlayerVariables.Current_SoundfontID]

		for k, v11 in pairs(v3) do
			local v12 = k
			local v13 = v11
			pcall(function()
				PianoLogic.FinishNonSustainNote(v12, soundfont.Fadeout)
				Folder_Remotes.SustainRemote:FireServer(v12, soundfont.Fadeout)
				UILogic.FinishNote(keyFrame, v13)
				local seatPart = Humanoid.SeatPart
				local pianoModule

				if seatPart then
					local parent = seatPart.Parent

					if parent then
						local scripts = parent:FindFirstChild("Scripts")

						if scripts then
							pianoModule = scripts:FindFirstChild("PianoModule")

							if not (pianoModule and pianoModule:IsA("ModuleScript")) then
								pianoModule = nil
							end
						end
					end
				end

				if pianoModule then
					local module = require(pianoModule)
					module.PianoAnimation(v13 + KEY_OFFSET, false)
					Folder_Remotes.AnimationRemote:FireServer(v13 + KEY_OFFSET, false)
				end
			end)
		end

		table.clear(v3)
		flag2 = false
		flag = false
	end
end)

for _, button in pairs(keyFrame:GetChildren()) do
	if not (button:IsA("ImageButton") and tonumber(button.Name)) then
		continue
	end

	local v11 = button
	button.InputBegan:Connect(function(input)
		if not clone.Enabled then
			return
		end

		if input.UserInputType == Enum.UserInputType.Touch then
			PressKey(v11, input.KeyCode)
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			v9 = true
			local v12 = v11

			if v12 then
				if not (v12.Parent and v10 ~= v12) then
					return
				end

				if v10 then
					ReleaseKey(v10)
					v8.mouse = nil
					v10 = nil
				end

				PressKey(v12, "mouse")
				v10 = v12
			end
		end
	end)
	button.InputEnded:Connect(function(input)
		if not clone.Enabled then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if v10 then
				ReleaseKey(v10)
				v8.mouse = nil
				v10 = nil
			end

			v9 = false
		end
	end)
	local v12 = button
	button.MouseEnter:Connect(function()
		if not clone.Enabled then
			return
		end

		local v13 = v9 and v12

		if v13 then
			if not (v13.Parent and v10 ~= v13) then
				return
			end

			if v10 then
				ReleaseKey(v10)
				v8.mouse = nil
				v10 = nil
			end

			PressKey(v13, "mouse")
			v10 = v13
		end
	end)
end

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		ReleaseMouseKey() -- inferred equivalent call
	end
end)
task.spawn(function()
	while true do
		task.wait(0.1)

		if clone.Enabled then
			local success, result = pcall(function()
				return UserInputService:GetTouches()
			end)
			local v11 = {}

			for _, v12 in ipairs(success and result or {}) do
				v11[v12.KeyCode] = true
			end

			for k, v12 in pairs(v8) do
				if k == "mouse" or v11[k] then
					continue
				end

				ReleaseKey(v12)
				v8[k] = nil
			end

			if KeyboardEnabled then
				local soundfont = Soundfonts[PlayerVariables.Current_SoundfontID]

				for k, v12 in pairs(v3) do
					if UserInputService:IsKeyDown(k) then
						continue
					end

					local v13 = k
					local v14 = v12
					pcall(function()
						PianoLogic.FinishNonSustainNote(v13, soundfont.Fadeout)
						Folder_Remotes.SustainRemote:FireServer(v13, soundfont.Fadeout)
						UILogic.FinishNote(keyFrame, v14)
						local seatPart = Humanoid.SeatPart
						local pianoModule

						if seatPart then
							local parent = seatPart.Parent

							if parent then
								local scripts = parent:FindFirstChild("Scripts")

								if scripts then
									pianoModule = scripts:FindFirstChild("PianoModule")

									if not (pianoModule and pianoModule:IsA("ModuleScript")) then
										pianoModule = nil
									end
								end
							end
						end

						if pianoModule then
							local module = require(pianoModule)
							module.PianoAnimation(v14 + KEY_OFFSET, false)
							Folder_Remotes.AnimationRemote:FireServer(v14 + KEY_OFFSET, false)
						end
					end)
					v3[k] = nil
				end
			end
		else
			for k in pairs(v5) do
				ReleaseKey(k)
			end

			table.clear(v8)
			table.clear(v5)
			table.clear(v6)
			table.clear(v7)
			v9 = false
			v10 = nil
		end
	end
end)
local GuiService = game:GetService("GuiService")
GuiService.MenuOpened:Connect(function()
	if not clone.Enabled then
		return
	end

	local soundfont = Soundfonts[PlayerVariables.Current_SoundfontID]

	for k, v11 in pairs(v3) do
		local v12 = k
		local v13 = v11
		pcall(function()
			PianoLogic.FinishNonSustainNote(v12, soundfont.Fadeout)
			Folder_Remotes.SustainRemote:FireServer(v12, soundfont.Fadeout)
			UILogic.FinishNote(keyFrame, v13)
			local seatPart = Humanoid.SeatPart
			local pianoModule

			if seatPart then
				local parent = seatPart.Parent

				if parent then
					local scripts = parent:FindFirstChild("Scripts")

					if scripts then
						pianoModule = scripts:FindFirstChild("PianoModule")

						if not (pianoModule and pianoModule:IsA("ModuleScript")) then
							pianoModule = nil
						end
					end
				end
			end

			if pianoModule then
				local module = require(pianoModule)
				module.PianoAnimation(v13 + KEY_OFFSET, false)
				Folder_Remotes.AnimationRemote:FireServer(v13 + KEY_OFFSET, false)
			end
		end)
	end

	table.clear(v3)

	for k in pairs(v5) do
		ReleaseKey(k)
	end

	table.clear(v8)
	table.clear(v5)
	table.clear(v6)
	table.clear(v7)
	ReleaseMouseKey() -- inferred equivalent call
	flag2 = false
	flag = false
end)

local function ProcessPianoAction(_, p, p2)
	if not KeyboardEnabled then
		return
	end

	local value = p2.KeyCode.Value
	local v11 = ("1!2@34$5%6^78*9(0qQwWeErtTyYuiIoOpPasSdDfgGhHjJklLzZxcCvVbBnm"):find(string.char(value), 1, true)

	if not v11 then
		return
	end

	local v12 = v11 + Transposition
	local soundfont = Soundfonts[PlayerVariables.Current_SoundfontID]
	local seatPart = Humanoid.SeatPart
	local pianoModule

	if seatPart then
		local parent = seatPart.Parent

		if parent then
			local scripts = parent:FindFirstChild("Scripts")

			if scripts then
				pianoModule = scripts:FindFirstChild("PianoModule")

				if not (pianoModule and pianoModule:IsA("ModuleScript")) then
					pianoModule = nil
				end
			end
		end
	end

	if p == Enum.UserInputState.Begin then
		if flag2 then
			Velocity = tonumber(KeymapLogic:VelocityKeyCodes()[("1234567890qwertyuiopasdfghjklzxc"):find(
				string.char(value),
				1,
				true
			)])

			if velocityBar then
				UILogic.ForceShowFrame(velocityBar)

				if velocityBar:FindFirstChild("Bar") then
					velocityBar.Bar.Size = UDim2.fromOffset(Velocity, 5)
				end
			end
		elseif flag then
			local v13 = ("trewq0987654321yuiopasdfghj"):find(string.char(value), 1, true)
			local v14 = KeymapLogic.Piano88KeyCodes[v13] + Transposition
			PianoLogic[soundfont.PacketType](
				v14,
				soundfont.AssetIds,
				soundfont.Offset,
				soundfont.MaxLifetime,
				soundfont.Fadeout,
				Transposition,
				soundfont.PacketType,
				pianoSustainPacket,
				flag,
				Velocity,
				LocalVolume,
				soundfont.VolumeModifier,
				p2.KeyCode
			)
			v3[p2.KeyCode] = v14
			UILogic.PlayNote(keyFrame, v14)

			if pianoModule then
				local module = require(pianoModule)
				module.PianoAnimation(v14 + KEY_OFFSET, true)
				Folder_Remotes.AnimationRemote:FireServer(v14 + KEY_OFFSET, true)
			end
		else
			PianoLogic[soundfont.PacketType](
				v12,
				soundfont.AssetIds,
				soundfont.Offset,
				soundfont.MaxLifetime,
				soundfont.Fadeout,
				Transposition,
				soundfont.PacketType,
				pianoSustainPacket,
				flag,
				Velocity,
				LocalVolume,
				soundfont.VolumeModifier,
				p2.KeyCode
			)
			v3[p2.KeyCode] = v12
			UILogic.PlayNote(keyFrame, v12)

			if pianoModule then
				local module = require(pianoModule)
				module.PianoAnimation(v12 + KEY_OFFSET, true)
				Folder_Remotes.AnimationRemote:FireServer(v12 + KEY_OFFSET, true)
			end
		end
	elseif p == Enum.UserInputState.End then
		PianoLogic.FinishNonSustainNote(p2.KeyCode, soundfont.Fadeout)
		Folder_Remotes.SustainRemote:FireServer(p2.KeyCode, soundfont.Fadeout)

		if not pianoSustainPacket then
			PianoLogic.FadeoutAllSustainedNotes(soundfont.Fadeout)
			Folder_Remotes.FinishNonSustainedNotesRemote:FireServer(soundfont.Fadeout)
		end

		UILogic.FinishNote(keyFrame, v3[p2.KeyCode])

		if pianoModule then
			local module = require(pianoModule)
			local v13 = v3[p2.KeyCode]

			if v13 then
				module.PianoAnimation(v13 + KEY_OFFSET, false)
				Folder_Remotes.AnimationRemote:FireServer(v13 + KEY_OFFSET, false)
			end
		end
	end
end

local function SustainAction(_, p, _)
	local soundfont = Soundfonts[PlayerVariables.Current_SoundfontID]

	if p == Enum.UserInputState.Begin then
		pianoSustainPacket = not pianoSustainPacket
		_G.PianoSustainPacket = pianoSustainPacket

		if not pianoSustainPacket then
			PianoLogic.FadeoutAllSustainedNotes(soundfont.Fadeout)
			Folder_Remotes.FinishNonSustainedNotesRemote:FireServer(soundfont.Fadeout)
		end

		if optionFrame and optionFrame.Sustain and optionFrame.Sustain:FindFirstChild("LED") then
			UILogic.GlowCheck(optionFrame.Sustain.LED, pianoSustainPacket)
		end
	elseif p == Enum.UserInputState.End then
		pianoSustainPacket = not pianoSustainPacket
		_G.PianoSustainPacket = pianoSustainPacket

		if not pianoSustainPacket then
			PianoLogic.FadeoutAllSustainedNotes(soundfont.Fadeout)
			Folder_Remotes.FinishNonSustainedNotesRemote:FireServer(soundfont.Fadeout)
		end

		if optionFrame and optionFrame.Sustain and optionFrame.Sustain:FindFirstChild("LED") then
			UILogic.GlowCheck(optionFrame.Sustain.LED, pianoSustainPacket)
		end
	end
end

local function VelocityAction(_, p, _)
	if p == Enum.UserInputState.Begin then
		flag2 = true
	elseif p == Enum.UserInputState.End then
		flag2 = false
	end
end

local function Above88KeyAction(_, p, _)
	if p == Enum.UserInputState.Begin then
		flag = true
	elseif p == Enum.UserInputState.End then
		flag = false
	end
end

local function ShiftAction(_, p, _)
	if p == Enum.UserInputState.Begin then
		Transposition = PianoLogic.Transpose(1, Transposition)

		if screen and screen.Transposition and screen.Transposition:FindFirstChild("Value") then
			UILogic.UpdateTextLabel(screen.Transposition.Value, Transposition)
		end
	elseif p == Enum.UserInputState.End then
		Transposition = PianoLogic.Transpose(-1, Transposition)

		if screen and screen.Transposition and screen.Transposition:FindFirstChild("Value") then
			UILogic.UpdateTextLabel(screen.Transposition.Value, Transposition)
		end
	end
end

local function TranspositionAction(_, p, p2)
	if p ~= Enum.UserInputState.Begin then
		return
	end

	local keyCode = p2.KeyCode

	if keyCode == Enum.KeyCode.Up then
		Transposition = PianoLogic.Transpose(1, Transposition)
	elseif keyCode == Enum.KeyCode.Down then
		Transposition = PianoLogic.Transpose(-1, Transposition)
	end

	if screen and screen.Transposition and screen.Transposition:FindFirstChild("Value") then
		UILogic.UpdateTextLabel(screen.Transposition.Value, Transposition)
	end
end

local function VolumeAction(_, p, p2)
	if p ~= Enum.UserInputState.Begin then
		return
	end

	local keyCode = p2.KeyCode

	if keyCode == Enum.KeyCode.Left then
		LocalVolume = PianoLogic.Volume(-10, LocalVolume)
	elseif keyCode == Enum.KeyCode.Right then
		LocalVolume = PianoLogic.Volume(10, LocalVolume)
	end

	if screen and screen.Volume and screen.Volume:FindFirstChild("Value") then
		UILogic.UpdateTextLabel(screen.Volume.Value, LocalVolume)
	end
end

function BindKeyboardActions()
	if not KeyboardEnabled then
		return
	end

	print("[PianoMain] Binding keyboard actions.")
	ContextActionService:BindAction("ShiftCheck", ShiftAction, false, Enum.KeyCode.RightShift, Enum.KeyCode.LeftShift)
	ContextActionService:BindAction("AltCheck", VelocityAction, false, Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt)
	ContextActionService:BindAction(
		"ControlCheck",
		Above88KeyAction,
		false,
		Enum.KeyCode.LeftControl,
		Enum.KeyCode.RightControl
	)
	ContextActionService:BindAction(
		"TranspositionCheck",
		TranspositionAction,
		false,
		Enum.KeyCode.Up,
		Enum.KeyCode.Down
	)
	ContextActionService:BindAction("SustainCheck", SustainAction, false, Enum.KeyCode.Space)
	ContextActionService:BindAction("ExitCheck", UnbindPiano, false, Enum.KeyCode.Backspace)
	ContextActionService:BindAction("CameraSwitch", function(_, p, _)
		if p == Enum.UserInputState.Begin then
			CharacterLogic.SwitchCamera()
		end
	end, false, Enum.KeyCode.BackSlash)
	ContextActionService:BindAction("VolumeCheck", VolumeAction, false, Enum.KeyCode.Left, Enum.KeyCode.Right)
	ContextActionService:BindAction("PianoAction", ProcessPianoAction, false, KeymapLogic.PianoKeyCodes())
	ContextActionService:BindAction("EscapeCheck", function(_, p, _)
		if p ~= Enum.UserInputState.Begin then
			return
		end

		local soundfont = Soundfonts[PlayerVariables.Current_SoundfontID]

		for k, v11 in pairs(v3) do
			local v12 = k
			local v13 = v11
			pcall(function()
				PianoLogic.FinishNonSustainNote(v12, soundfont.Fadeout)
				Folder_Remotes.SustainRemote:FireServer(v12, soundfont.Fadeout)
				UILogic.FinishNote(keyFrame, v13)
				local seatPart = Humanoid.SeatPart
				local pianoModule

				if seatPart then
					local parent = seatPart.Parent

					if parent then
						local scripts = parent:FindFirstChild("Scripts")

						if scripts then
							pianoModule = scripts:FindFirstChild("PianoModule")

							if not (pianoModule and pianoModule:IsA("ModuleScript")) then
								pianoModule = nil
							end
						end
					end
				end

				if pianoModule then
					local module = require(pianoModule)
					module.PianoAnimation(v13 + KEY_OFFSET, false)
					Folder_Remotes.AnimationRemote:FireServer(v13 + KEY_OFFSET, false)
				end
			end)
		end

		table.clear(v3)
		flag2 = false
		flag = false
	end, false, Enum.KeyCode.Escape)
end

function UnbindKeyboardActions()
	if not KeyboardEnabled then
		return
	end

	ContextActionService:UnbindAction("PianoAction")
	ContextActionService:UnbindAction("ShiftCheck")
	ContextActionService:UnbindAction("AltCheck")
	ContextActionService:UnbindAction("ControlCheck")
	ContextActionService:UnbindAction("TranspositionCheck")
	ContextActionService:UnbindAction("SustainCheck")
	ContextActionService:UnbindAction("ExitCheck")
	ContextActionService:UnbindAction("CameraSwitch")
	ContextActionService:UnbindAction("EscapeCheck")
	ContextActionService:UnbindAction("VolumeCheck")
end

function BindPiano(_)
	print("[PianoMain] Binding piano. Device:", v and "Mobile" or "PC", "GUI:", v2)
	clone.Enabled = true
	CharacterLogic.AddCamera(Humanoid)
	task.spawn(function()
		LocalPlayer:SetAttribute("CurrentSoundfontID", PlayerVariables.Current_SoundfontID)
		local soundfont = Soundfonts[PlayerVariables.Current_SoundfontID]

		if not soundfont then
			BindKeyboardActions()
			return
		end

		PianoLogic.PreloadSoundfont(soundfont.AssetIds, soundfont.PacketType, soundfont.Name)
		BindKeyboardActions()
	end)
	task.spawn(function()
		local character = LocalPlayer.Character

		if not character then
			return
		end

		local nametag = character:WaitForChild("Nametag", 5)

		if nametag then
			nametag.Enabled = false
		end
	end)

	if v and screen and screen:FindFirstChild("Instructions") then
		screen.Instructions.Visible = true
		screen.Instructions.Text = "Нажимайте на клавиши пальцами"
		task.wait(3)
		screen.Instructions.Visible = false
	end
end

function UnbindPiano()
	print("[PianoMain] Un-binding piano.")

	for k, _ in pairs(v5) do
		ReleaseKey(k)
	end

	table.clear(v8)
	table.clear(v5)
	table.clear(v6)
	table.clear(v7)
	v9 = false
	v10 = nil
	clone.Enabled = false
	UnbindKeyboardActions()
	Humanoid.Sit = false
	CharacterLogic.RevokeCamera()
	PianoLogic.ClearSoundfont()
	PianoLogic.ClearAllViewerSoundfonts()
	task.spawn(function()
		local character = LocalPlayer.Character

		if not character then
			return
		end

		local nametag = character:FindFirstChild("Nametag")

		if nametag then
			nametag.Enabled = true
		end
	end)
end

Humanoid.Seated:Connect(function(p, p2)
	if p then
		if p2 and p2.Parent and p2.Parent.Parent and p2.Parent.Parent.Name == "Pianos" then
			BindPiano(p2)
		end
	else
		UnbindPiano()
	end
end)

if velocityBar then
	velocityBar.MouseButton1Click:Connect(function()
		Velocity = 50
		velocityBar.Visible = false
	end)
end

Humanoid.Died:Connect(function()
	UnbindPiano()
end)

if optionFrame then
	if optionFrame:FindFirstChild("Power") then
		optionFrame.Power.MouseButton1Click:Connect(function()
			UnbindPiano()
		end)
	end

	if optionFrame:FindFirstChild("Sustain") then
		optionFrame.Sustain.MouseButton1Click:Connect(function()
			pianoSustainPacket = not pianoSustainPacket
			_G.PianoSustainPacket = pianoSustainPacket

			if optionFrame.Sustain:FindFirstChild("LED") then
				UILogic.GlowCheck(optionFrame.Sustain.LED, pianoSustainPacket)
			end
		end)
	end

	if optionFrame:FindFirstChild("TransposeUp") then
		optionFrame.TransposeUp.MouseButton1Click:Connect(function()
			Transposition = PianoLogic.Transpose(1, Transposition)

			if screen and screen.Transposition and screen.Transposition:FindFirstChild("Value") then
				UILogic.UpdateTextLabel(screen.Transposition.Value, Transposition)
			end
		end)
	end

	if optionFrame:FindFirstChild("TransposeDown") then
		optionFrame.TransposeDown.MouseButton1Click:Connect(function()
			Transposition = PianoLogic.Transpose(-1, Transposition)

			if screen and screen.Transposition and screen.Transposition:FindFirstChild("Value") then
				UILogic.UpdateTextLabel(screen.Transposition.Value, Transposition)
			end
		end)
	end

	if optionFrame:FindFirstChild("VolumeUp") then
		optionFrame.VolumeUp.MouseButton1Click:Connect(function()
			LocalVolume = PianoLogic.Volume(10, LocalVolume)

			if screen and screen.Volume and screen.Volume:FindFirstChild("Value") then
				UILogic.UpdateTextLabel(screen.Volume.Value, LocalVolume)
			end
		end)
	end

	if optionFrame:FindFirstChild("VolumeDown") then
		optionFrame.VolumeDown.MouseButton1Click:Connect(function()
			LocalVolume = PianoLogic.Volume(-10, LocalVolume)

			if screen and screen.Volume and screen.Volume:FindFirstChild("Value") then
				UILogic.UpdateTextLabel(screen.Volume.Value, LocalVolume)
			end
		end)
	end

	if optionFrame:FindFirstChild("Soundfonts") then
		optionFrame.Soundfonts.MouseButton1Click:Connect(function()
			local soundfonts2 = pianoContainer.Parent:FindFirstChild("Soundfonts")
				or pianoContainer:FindFirstChild("Soundfonts")

			if soundfonts2 then
				UILogic.ShowHideFrame(soundfonts2)
			end
		end)
	end

	if optionFrame:FindFirstChild("Sheets") then
		optionFrame.Sheets.MouseButton1Click:Connect(function()
			local sheets2 = pianoContainer.Parent:FindFirstChild("Sheets") or pianoContainer:FindFirstChild("Sheets")

			if sheets2 then
				UILogic.ShowHideFrame(sheets2)
			end
		end)
	end

	if optionFrame:FindFirstChild("CameraSwitch") then
		optionFrame.CameraSwitch.MouseButton1Click:Connect(function()
			CharacterLogic.SwitchCamera()
		end)
	end
end

for _, v11 in pairs(v4) do
	if not v11 then
		continue
	end

	local v12 = v11
	pcall(function()
		local v13 = DraggableObject.new(v12)

		if v12 == sheets then
			local scrollingFrame = sheets:FindFirstChild("ScrollingFrame")
			local sheetBox = scrollingFrame and scrollingFrame:FindFirstChild("SheetBox")
			local isDragging = sheets:FindFirstChild("IsDragging")

			function v13.DragStarted()
				if isDragging then
					isDragging.Value = true
				end

				if sheetBox then
					sheetBox.TextEditable = false
					sheetBox:ReleaseFocus()
				end
			end

			function v13.DragEnded()
				if isDragging then
					isDragging.Value = false
				end

				if sheetBox then
					sheetBox.TextEditable = true
				end
			end
		end

		v13:Enable()
	end)
end

Folder_Remotes.NoteRemote.OnClientEvent:Connect(function(p, p2, p3, p4, p5, p6, p7, p8, p9, p10)
	if p10 then
		local pianoVolPrefs = _G.PianoVolPrefs
		local v11 = pianoVolPrefs and pianoVolPrefs[p10]

		if v11 then
			p3 *= v11
		end
	end

	PianoLogic.PlayServerNote(p, p2, p3, p4, p5, p6, p7, p8, p9)
end)
Folder_Remotes.SustainRemote.OnClientEvent:Connect(function(p, p2)
	PianoLogic.ServerFinishNonSustainNote(p, p2)
end)
Folder_Remotes.FinishNonSustainedNotesRemote.OnClientEvent:Connect(function(p)
	PianoLogic.ServerFadeoutAllSustainedNotes(p)
end)
Folder_Remotes.AnimationRemote.OnClientEvent:Connect(function(instance, p, p2)
	local scripts = typeof(instance) == "Instance" and instance:FindFirstChild("Scripts")

	if scripts then
		local pianoModule = scripts:FindFirstChild("PianoModule")

		if pianoModule and pianoModule:IsA("ModuleScript") then
			pcall(function()
				local module = require(pianoModule)
				module.PianoAnimation(p, p2)
			end)
		end
	end
end)
local intValue = Instance.new("IntValue")
intValue.Name = "PianoTranspositionSync"
intValue.Parent = LocalPlayer
RunService.Heartbeat:Connect(function()
	intValue.Value = Transposition
end)
clone.Enabled = false
task.spawn(function()
	task.wait(1)
	local soundfont = Soundfonts[PlayerVariables.Current_SoundfontID]

	if soundfont then
		PianoLogic.PreloadSoundfont(soundfont.AssetIds, soundfont.PacketType, soundfont.Name)
	end
end)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PreloadViewerSF = ReplicatedStorage:WaitForChild("PreloadViewerSF", 10)

if PreloadViewerSF then
	PreloadViewerSF.OnClientEvent:Connect(function(p)
		local soundfont = Soundfonts[p]

		if not (soundfont and p ~= PlayerVariables.Current_SoundfontID) then
			return
		end

		task.spawn(function()
			for _, assetId in ipairs(soundfont.AssetIds) do
				local sound = Instance.new("Sound", SoundService)
				sound.SoundId = "rbxassetid://" .. tostring(assetId)
				sound.Volume = 0
				sound.Parent = SoundService
				local v11 = false
				local loadedConnection = sound.Loaded:Connect(function()
					v11 = true
				end)
				local total = 0

				while not v11 and total < 8 do
					task.wait(0.1)
					total += 0.1
				end

				loadedConnection:Disconnect()
				sound:Play()
				task.wait(0.05)
				sound:Stop()
				sound:Destroy()
			end

			print("[Piano] Viewer warmup done:", soundfont.Name)
		end)
	end)
	PreloadViewerSF.OnClientEvent:Connect(function(p, p2)
		local soundfont = Soundfonts[p]

		if not (soundfont and p ~= PlayerVariables.Current_SoundfontID) then
			return
		end

		task.spawn(function()
			PianoLogic.PreloadViewerSoundfont(soundfont.AssetIds, p2 or p)
			print("[Piano] Viewer preloaded SF:", soundfont.Name)
		end)
	end)
end

print("[PianoMain] UI initialized successfully for", v and "Mobile" or "PC", "GUI:", v2)