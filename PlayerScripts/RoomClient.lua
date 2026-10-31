local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Room_CreateRoom = ReplicatedStorage:WaitForChild("Room_CreateRoom")
local Room_JoinRoom = ReplicatedStorage:WaitForChild("Room_JoinRoom")
local Room_LeaveRoom = ReplicatedStorage:WaitForChild("Room_LeaveRoom")
local Room_UpdateRoomList = ReplicatedStorage:WaitForChild("Room_UpdateRoomList")
local Room_PlayerJoined = ReplicatedStorage:WaitForChild("Room_PlayerJoined")
local Room_PlayerLeft = ReplicatedStorage:WaitForChild("Room_PlayerLeft")
local Room_NoteForwarded = ReplicatedStorage:WaitForChild("Room_NoteForwarded")
local Room_VisualNoteFwd = ReplicatedStorage:WaitForChild("Room_VisualNoteFwd")
local Room_TrailForwarded = ReplicatedStorage:WaitForChild("Room_TrailForwarded")
local Room_SustainForwarded = ReplicatedStorage:WaitForChild("Room_SustainForwarded")
local Room_FinishForwarded = ReplicatedStorage:WaitForChild("Room_FinishForwarded")
local Room_GetRooms = ReplicatedStorage:WaitForChild("Room_GetRooms")
local Room_KickPlayer = ReplicatedStorage:WaitForChild("Room_KickPlayer")
local Room_PlayerKicked = ReplicatedStorage:WaitForChild("Room_PlayerKicked")
local PianoLogic = require(workspace:WaitForChild("Piano_Dependencies"):WaitForChild("Modules"):WaitForChild("Logic"):WaitForChild("PianoLogic"))

local function isBlackKey(p) -- 1 equivalent call inferred from this helper
	local v = p % 12
	return v == 2 or v == 4 or v == 7 or v == 9 or v == 11
end

local function resetKeyColor(instance, p)
	local child = instance:FindFirstChild((tostring(p)))

	if not child then
		return
	end

	if isBlackKey(p) then -- inferred equivalent call
		child.ImageColor3 = Color3.fromRGB(0, 0, 0)
	else
		child.ImageColor3 = Color3.fromRGB(255, 255, 255)
	end
end

local function getKeyFrame()
	local UserInputService = game:GetService("UserInputService")
	local child = PlayerGui:FindFirstChild(UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and "FulllScreenPianoMobileUI" or "FulllScreenPianoUI")

	if not child then
		return nil
	end

	local pianoContainer = child:FindFirstChild("PianoContainer")

	if pianoContainer then
		return pianoContainer:FindFirstChild("KeyFrame")
	end

	return nil
end

local RoomSystemGUI = PlayerGui:WaitForChild("RoomSystemGUI")
local MainFrame = RoomSystemGUI:WaitForChild("MainFrame")
local CreateRoomFrame = RoomSystemGUI:WaitForChild("CreateRoomFrame")
local PasswordFrame = RoomSystemGUI:WaitForChild("PasswordFrame")
local RoomFrame = RoomSystemGUI:WaitForChild("RoomFrame")
MainFrame.ZIndex = 2
CreateRoomFrame.ZIndex = 2
PasswordFrame.ZIndex = 2
local RoomsScrollingFrame = MainFrame:WaitForChild("RoomsScrollingFrame")
local RoomListLayout = RoomsScrollingFrame:WaitForChild("RoomListLayout")
local CreateRoomButton = MainFrame:WaitForChild("CreateRoomButton")
local RoomNameTextBox = CreateRoomFrame:WaitForChild("RoomNameTextBox")
local MaxPlayersTextBox = CreateRoomFrame:WaitForChild("MaxPlayersTextBox")
local PasswordTextBox = CreateRoomFrame:WaitForChild("PasswordTextBox")
local CreateButton = CreateRoomFrame:WaitForChild("CreateButton")
local CancelButton = CreateRoomFrame:WaitForChild("CancelButton")

local function utf8sub(text, p) -- 2 equivalent calls inferred from this helper
	local v = utf8.offset(text, p + 1)

	if v then
		return (string.sub(text, 1, v - 1))
	end

	return text
end

RoomNameTextBox:GetPropertyChangedSignal("Text"):Connect(function()
	if (utf8.len(RoomNameTextBox.Text) or 0) > 20 then
		RoomNameTextBox.Text = utf8sub(RoomNameTextBox.Text, 20) -- inferred equivalent call
	end
end)
PasswordTextBox:GetPropertyChangedSignal("Text"):Connect(function()
	if (utf8.len(PasswordTextBox.Text) or 0) > 20 then
		PasswordTextBox.Text = utf8sub(PasswordTextBox.Text, 20) -- inferred equivalent call
	end
end)
MaxPlayersTextBox:GetPropertyChangedSignal("Text"):Connect(function()
	if MaxPlayersTextBox.Text ~= "" and not MaxPlayersTextBox.Text:match("^%d*$") then
		MaxPlayersTextBox.Text = MaxPlayersTextBox.Text:gsub("%D", "")
	end
end)
MaxPlayersTextBox.FocusLost:Connect(function()
	local v = math.clamp(tonumber(MaxPlayersTextBox.Text) or 2, 2, 20)
	MaxPlayersTextBox.Text = tostring(v)
end)
local PasswordInputTextBox = PasswordFrame:WaitForChild("PasswordInputTextBox")
local ConfirmButton = PasswordFrame:WaitForChild("ConfirmButton")
local cancelButton = PasswordFrame:WaitForChild("CancelButton")
local RoomTitleLabel = RoomFrame:WaitForChild("RoomTitleLabel")
local ParticipantsScrollingFrame = RoomFrame:WaitForChild("ParticipantsScrollingFrame")
local ParticipantsLayout = ParticipantsScrollingFrame:WaitForChild("ParticipantsLayout")
local LeaveRoomButton = RoomFrame:WaitForChild("LeaveRoomButton")
local CloseRoomButton = RoomFrame:WaitForChild("CloseRoomButton")
task.spawn(function()
	local UserInputService = game:GetService("UserInputService")

	if not UserInputService.TouchEnabled or UserInputService.KeyboardEnabled then
		return
	end

	MainFrame.Size = UDim2.new(0.82, 0, 0, 240)
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	local titleLabel = MainFrame:FindFirstChild("TitleLabel")

	if titleLabel then
		titleLabel.Size = UDim2.new(1, 0, 0, 44)
		titleLabel.TextSize = 18
	end

	local createRoomButton = MainFrame:FindFirstChild("CreateRoomButton")

	if createRoomButton then
		createRoomButton.Size = UDim2.new(1, -24, 0, 46)
		createRoomButton.Position = UDim2.new(0, 12, 0, 50)
		createRoomButton.TextSize = 16
	end

	local publicRoomsLabel = MainFrame:FindFirstChild("PublicRoomsLabel")

	if publicRoomsLabel then
		publicRoomsLabel.Size = UDim2.new(1, -24, 0, 22)
		publicRoomsLabel.Position = UDim2.new(0, 12, 0, 104)
		publicRoomsLabel.TextSize = 12
	end

	local roomsScrollingFrame = MainFrame:FindFirstChild("RoomsScrollingFrame")

	if roomsScrollingFrame then
		roomsScrollingFrame.Size = UDim2.new(1, -24, 1, -132)
		roomsScrollingFrame.Position = UDim2.new(0, 12, 0, 128)
		local uiListLayout = roomsScrollingFrame:FindFirstChildOfClass("UIListLayout")

		if uiListLayout then
			uiListLayout.Padding = UDim.new(0, 8)
		end
	end

	CreateRoomFrame.Size = UDim2.new(0.82, 0, 0, 320)
	CreateRoomFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	CreateRoomFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	local createTitle = CreateRoomFrame:FindFirstChild("CreateTitle")

	if createTitle then
		createTitle.Size = UDim2.new(1, 0, 0, 46)
		createTitle.TextSize = 18
	end

	local roomNameTextBox = CreateRoomFrame:FindFirstChild("RoomNameTextBox")

	if roomNameTextBox then
		roomNameTextBox.Size = UDim2.new(1, -24, 0, 48)
		roomNameTextBox.Position = UDim2.new(0, 12, 0, 52)
		roomNameTextBox.TextSize = 16
	end

	local maxPlayersTextBox = CreateRoomFrame:FindFirstChild("MaxPlayersTextBox")

	if maxPlayersTextBox then
		maxPlayersTextBox.Size = UDim2.new(1, -24, 0, 48)
		maxPlayersTextBox.Position = UDim2.new(0, 12, 0, 110)
		maxPlayersTextBox.TextSize = 16
	end

	local passwordTextBox = CreateRoomFrame:FindFirstChild("PasswordTextBox")

	if passwordTextBox then
		passwordTextBox.Size = UDim2.new(1, -24, 0, 48)
		passwordTextBox.Position = UDim2.new(0, 12, 0, 168)
		passwordTextBox.TextSize = 16
	end

	local publicCheckBoxFrame = CreateRoomFrame:FindFirstChild("PublicCheckBoxFrame")

	if publicCheckBoxFrame then
		publicCheckBoxFrame.Size = UDim2.new(1, -24, 0, 48)
		publicCheckBoxFrame.Position = UDim2.new(0, 12, 0, 226)
		local publicCheckBox = publicCheckBoxFrame:FindFirstChild("PublicCheckBox")

		if publicCheckBox then
			publicCheckBox.Size = UDim2.new(0, 38, 0, 38)
			publicCheckBox.Position = UDim2.new(0, 0, 0, 5)
		end

		local checkBoxLabel = publicCheckBoxFrame:FindFirstChild("CheckBoxLabel")

		if checkBoxLabel then
			checkBoxLabel.Size = UDim2.new(1, -50, 1, 0)
			checkBoxLabel.Position = UDim2.new(0, 50, 0, 0)
			checkBoxLabel.TextSize = 15
		end
	end

	local createButton = CreateRoomFrame:FindFirstChild("CreateButton")

	if createButton then
		createButton.Size = UDim2.new(0.47, 0, 0, 50)
		createButton.Position = UDim2.new(0.02, 0, 1, -60)
		createButton.TextSize = 16
	end

	local cancelButton2 = CreateRoomFrame:FindFirstChild("CancelButton")

	if cancelButton2 then
		cancelButton2.Size = UDim2.new(0.47, 0, 0, 50)
		cancelButton2.Position = UDim2.new(0.51, 0, 1, -60)
		cancelButton2.TextSize = 16
	end

	PasswordFrame.Size = UDim2.new(0.92, 0, 0, 270)
	PasswordFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	PasswordFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	local passwordTitle = PasswordFrame:FindFirstChild("PasswordTitle")

	if passwordTitle then
		passwordTitle.Size = UDim2.new(1, 0, 0, 52)
		passwordTitle.TextSize = 20
	end

	local passwordInputTextBox = PasswordFrame:FindFirstChild("PasswordInputTextBox")

	if passwordInputTextBox then
		passwordInputTextBox.Size = UDim2.new(1, -24, 0, 54)
		passwordInputTextBox.Position = UDim2.new(0, 12, 0, 62)
		passwordInputTextBox.TextSize = 18
	end

	local confirmButton = PasswordFrame:FindFirstChild("ConfirmButton")

	if confirmButton then
		confirmButton.Size = UDim2.new(0.47, 0, 0, 54)
		confirmButton.Position = UDim2.new(0.02, 0, 1, -66)
		confirmButton.TextSize = 17
	end

	local cancelButton3 = PasswordFrame:FindFirstChild("CancelButton")

	if cancelButton3 then
		cancelButton3.Size = UDim2.new(0.47, 0, 0, 54)
		cancelButton3.Position = UDim2.new(0.51, 0, 1, -66)
		cancelButton3.TextSize = 17
	end

	RoomFrame.Size = UDim2.new(0.55, 0, 0, 210)
	RoomFrame.Position = UDim2.new(0.5, 0, 0, 55)
	RoomFrame.AnchorPoint = Vector2.new(0.5, 0)
	RoomFrame.ClipsDescendants = false
	local roomTitleLabel = RoomFrame:FindFirstChild("RoomTitleLabel")

	if roomTitleLabel then
		roomTitleLabel.Size = UDim2.new(1, 0, 0, 32)
		roomTitleLabel.Position = UDim2.new(0, 0, 0, 0)
		roomTitleLabel.TextSize = 13
	end

	local participantsLabel = RoomFrame:FindFirstChild("ParticipantsLabel")

	if participantsLabel then
		participantsLabel.Visible = false
	end

	local participantsScrollingFrame = RoomFrame:FindFirstChild("ParticipantsScrollingFrame")

	if participantsScrollingFrame then
		participantsScrollingFrame.Size = UDim2.new(1, -16, 0, 60)
		participantsScrollingFrame.Position = UDim2.new(0, 8, 0, 34)
		participantsScrollingFrame.ScrollingEnabled = true
		participantsScrollingFrame.ScrollBarThickness = 4
		participantsScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	end

	local leaveRoomButton = RoomFrame:FindFirstChild("LeaveRoomButton")

	if leaveRoomButton then
		leaveRoomButton.Size = UDim2.new(1, -16, 0, 36)
		leaveRoomButton.Position = UDim2.new(0, 8, 0, 118)
		leaveRoomButton.TextSize = 13
	end

	local closeRoomButton = RoomFrame:FindFirstChild("CloseRoomButton")

	if closeRoomButton then
		closeRoomButton.Size = UDim2.new(1, -16, 0, 36)
		closeRoomButton.Position = UDim2.new(0, 8, 0, 118)
		closeRoomButton.TextSize = 13
	end
end)
local roomId = nil
local ownerId = nil
local id = nil
local isOwner = false
local v = {}
local v2 = {}
local v3 = {}
local v4 = {}
local v5 = {}
local v6 = {}
local v7 = {}
local v8 = {}

local function updateNpsLabel(p)
	local child = ParticipantsScrollingFrame:FindFirstChild("P_" .. p)

	if not child then
		return
	end

	local nps = child:FindFirstChild("NPS")
	local playingGlow = child:FindFirstChild("PlayingGlow")

	if not nps then
		return
	end

	local v9 = v4[p]

	if v9 and v9.nps and v9.nps > 0 then
		nps.Text = string.format("%.1f/s", v9.nps)

		if playingGlow then
			playingGlow.Visible = true
		end
	else
		nps.Text = ""

		if playingGlow then
			playingGlow.Visible = false
		end
	end
end

local function recordNote(p)
	local now = tick()

	if not v4[p] then
		v4[p] = { timestamps = {}, nps = 0 }
	end

	local v9 = v4[p]
	table.insert(v9.timestamps, now)
	local v10 = now - 1

	while #v9.timestamps > 0 and v9.timestamps[1] < v10 do
		table.remove(v9.timestamps, 1)
	end

	v9.nps = #v9.timestamps
	updateNpsLabel(p)

	if v5[p] then
		task.cancel(v5[p])
	end

	v5[p] = task.delay(3, function()
		if v4[p] then
			v4[p].nps = 0
			v4[p].timestamps = {}
		end

		updateNpsLabel(p)
		v5[p] = nil
	end)
end

_G.RoomRecordNote = recordNote

local function stopAllForPlayer(p)
	if v6[p] then
		local fsEndRemoteTrail = _G.FSEndRemoteTrail or _G.FSEndTrail

		if fsEndRemoteTrail then
			for k in pairs(v6[p]) do
				pcall(fsEndRemoteTrail, k)
			end
		end

		v6[p] = {}
	end

	local v9 = {}

	if v7[p] then
		for k in pairs(v7[p]) do
			v9[k] = true
		end

		v7[p] = {}
	end

	pcall(function()
		local keyFrame = getKeyFrame()

		if not keyFrame then
			return
		end

		local playerColor = playerColors[p]

		if playerColor then
			for _, guiObject in ipairs(keyFrame:GetChildren()) do
				if not (guiObject:IsA("ImageButton") or guiObject:IsA("ImageLabel")) then
					continue
				end

				local imageColor3 = guiObject.ImageColor3

				if not (math.abs(imageColor3.R - playerColor.R) < 0.02 and math.abs(imageColor3.G - playerColor.G) < 0.02) then
					continue
				end

				if not (math.abs(imageColor3.B - playerColor.B) < 0.02) then
					continue
				end

				local name = tonumber(guiObject.Name)

				if name then
					v9[name] = true
				end
			end
		end
	end)
	pcall(function()
		local keyFrame = getKeyFrame()

		if not keyFrame then
			return
		end

		for k in pairs(v9) do
			local child = keyFrame:FindFirstChild((tostring(k)))

			if child then
				resetKeyColor(keyFrame, k)
				local uiStroke = child:FindFirstChildOfClass("UIStroke")

				if uiStroke then
					uiStroke.Color = Color3.fromRGB(0, 0, 0)
				end
			end

			local v10 = k
			pcall(function()
				PianoLogic.ServerFinishNonSustainNote(v10, 0)
			end)
		end
	end)
end

local function stopAllTrailsForPlayer(p)
	stopAllForPlayer(p)
end

local v9 = {
	Color3.fromRGB(255, 80, 80),
	Color3.fromRGB(80, 160, 255),
	Color3.fromRGB(80, 220, 120),
	Color3.fromRGB(255, 200, 60),
	Color3.fromRGB(200, 80, 255),
	Color3.fromRGB(255, 150, 50),
	Color3.fromRGB(80, 220, 220),
	Color3.fromRGB(255, 100, 200)
}
local v10 = {}
local v11 = 0

local function getPlayerColor(p)
	if v10[p] then
		return v10[p]
	end

	v11 = v11 % #v9 + 1
	v10[p] = v9[v11]
	return v10[p]
end

local function clearPlayerColors() -- 3 equivalent calls inferred from this helper
	v10 = {}
	v11 = 0
end

local function applyPlayerVolume(p)
	local SoundService = game:GetService("SoundService")
	local child

	if _G.RoomFX_GetOrCreateGroup then
		child = _G.RoomFX_GetOrCreateGroup(p)
	else
		child = SoundService:FindFirstChild("Player_" .. p)
	end

	if not child then
		return
	end

	if v2[p] then
		child.Volume = 0
	else
		child.Volume = v3[p] or 1
	end
end

local Room_AutoplayStatus = ReplicatedStorage:WaitForChild("Room_AutoplayStatus")
local Room_AutoplayFwd = ReplicatedStorage:WaitForChild("Room_AutoplayFwd")

local function setAutoplayLabel(userId, p) -- 2 equivalent calls inferred from this helper
	v8[userId] = p or nil
	local child = ParticipantsScrollingFrame:FindFirstChild("P_" .. userId)

	if not child then
		return
	end

	local autoplayLabel = child:FindFirstChild("AutoplayLabel")

	if autoplayLabel then
		autoplayLabel.Text = p and "AUTOPLAYING" or ""
	end
end

Room_AutoplayFwd.OnClientEvent:Connect(function(p, p2)
	v8[p] = p2 or nil
	local child = ParticipantsScrollingFrame:FindFirstChild("P_" .. p)

	if not child then
		return
	end

	local autoplayLabel = child:FindFirstChild("AutoplayLabel")

	if autoplayLabel then
		autoplayLabel.Text = p2 and "AUTOPLAYING" or ""
	end
end)
local bindableEvent = Instance.new("BindableEvent")
_G.FSAutoPlayingChanged = bindableEvent
bindableEvent.Event:Connect(function(p)
	if not roomId then
		return
	end

	pcall(function()
		Room_AutoplayStatus:FireServer(p and not _G.HideAutotag)
	end)
	setAutoplayLabel(LocalPlayer.UserId, p and not _G.HideAutotag) -- inferred equivalent call
end)
local MenuEvents = ReplicatedStorage:WaitForChild("MenuEvents", 15)
local openRooms = MenuEvents and MenuEvents:WaitForChild("OpenRooms", 10)
local closeRooms = MenuEvents and MenuEvents:WaitForChild("CloseRooms", 10)

local function hideAll() -- 5 equivalent calls inferred from this helper
	MainFrame.Visible = false
	CreateRoomFrame.Visible = false
	PasswordFrame.Visible = false
	local pianoBlocker = PlayerGui:FindFirstChild("PianoBlocker")

	if pianoBlocker then
		pianoBlocker.Enabled = false
	end
end

local function setRoomFrameVisible(visible) -- 6 equivalent calls inferred from this helper
	RoomFrame.Visible = visible
end

local function showFrame(p)
	hideAll() -- inferred equivalent call
	p.Visible = true
	local v12 = p ~= RoomFrame

	if _G.FSSetInputBlocked then
		pcall(_G.FSSetInputBlocked, v12)
	end

	local parent = PlayerGui:FindFirstChild("PianoBlocker")

	if v12 then
		if not parent then
			parent = Instance.new("ScreenGui")
			parent.Name = "PianoBlocker"
			parent.DisplayOrder = 50
			parent.IgnoreGuiInset = true
			parent.ResetOnSpawn = false
			parent.Parent = PlayerGui
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1, 0, 1, 0)
			frame.BackgroundTransparency = 1
			frame.ZIndex = 1
			frame.Parent = parent
		end

		parent.Enabled = true
	elseif parent then
		parent.Enabled = false
	end
end

local function clearChildren(participantsScrollingFrame, p)
	for _, frame in ipairs(participantsScrollingFrame:GetChildren()) do
		if frame:IsA("Frame") and frame.Name ~= p then
			frame:Destroy()
		end
	end
end

local function makeParticipantRow(k, text, p)
	local v12 = k == LocalPlayer.UserId
	local frame = Instance.new("Frame")
	frame.Name = "P_" .. k
	local UserInputService = game:GetService("UserInputService")
	local v13 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	frame.Size = UDim2.new(1, 0, 0, v13 and 62 or 42)
	frame.BackgroundColor3 = Color3.fromRGB(35, 38, 55)
	frame.BackgroundTransparency = 0.15
	frame.BorderSizePixel = 0
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = frame
	local Players2 = game:GetService("Players")
	local playerByUserId = Players2:GetPlayerByUserId(k)
	local v14 = playerByUserId and playerByUserId:GetAttribute("HasVip") == true

	local function applyVipRowStyle(p2)
		local vipGradient = frame:FindFirstChild("VipGradient")

		if p2 and not vipGradient then
			frame.BackgroundColor3 = Color3.fromRGB(60, 45, 10)
			frame.BackgroundTransparency = 0.05
			local uiGradient = Instance.new("UIGradient")
			uiGradient.Name = "VipGradient"
			uiGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 220, 80)),
				ColorSequenceKeypoint.new(0.25, Color3.fromRGB(200, 140, 20)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 200, 60)),
				ColorSequenceKeypoint.new(0.75, Color3.fromRGB(220, 160, 30)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 220, 80))
			})
			uiGradient.Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 0.55),
				NumberSequenceKeypoint.new(0.5, 0.35),
				NumberSequenceKeypoint.new(1, 0.55)
			})
			uiGradient.Rotation = 30
			uiGradient.Parent = frame
			task.spawn(function()
				local total = 0

				while frame and frame.Parent and uiGradient and uiGradient.Parent do
					total += 0.02
					uiGradient.Rotation = math.sin(total * 1.2) * 15 + 30
					frame.BackgroundTransparency = math.abs((math.sin(total * 2))) * 0.08 + 0.05
					task.wait(0.05)
				end
			end)
		elseif not p2 and vipGradient then
			vipGradient:Destroy()
			frame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
			frame.BackgroundTransparency = 0
		end

		local vipTag = frame:FindFirstChild("VipTag")

		if p2 and not vipTag then
			local nameLabel = frame:FindFirstChild("NameLabel")
			local v15 = v13 and 82 or 60
			local v16 = v13 and 34 or 28
			local textLabel = Instance.new("TextLabel")
			textLabel.Name = "VipTag"
			textLabel.Size = UDim2.new(0, v16, 1, 0)
			textLabel.Position = UDim2.new(0, v15, 0, 0)
			textLabel.BackgroundTransparency = 1
			textLabel.Text = "[VIP]"
			textLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
			textLabel.Font = Enum.Font.GothamBold
			textLabel.TextSize = v13 and 13 or 11
			textLabel.TextScaled = false
			textLabel.TextXAlignment = Enum.TextXAlignment.Left
			textLabel.ZIndex = 3
			textLabel.Parent = frame

			if nameLabel then
				nameLabel.Position = UDim2.new(0, v15 + v16, 0, 0)
				nameLabel.Size = UDim2.new(0, (v13 and 100 or 120) - v16, 1, 0)
			end
		elseif not p2 and vipTag then
			local nameLabel = frame:FindFirstChild("NameLabel")

			if nameLabel then
				local v15 = v13 and 40 or 34
				nameLabel.Position = UDim2.new(0, nameLabel.Position.X.Offset - v15, 0, 0)
				nameLabel.Size = UDim2.new(0, nameLabel.Size.X.Offset + v15, 1, 0)
			end

			vipTag:Destroy()
		end
	end

	if playerByUserId then
		playerByUserId:GetAttributeChangedSignal("HasVip"):Connect(function()
			local hasVip = playerByUserId:GetAttribute("HasVip") == true
			applyVipRowStyle(hasVip)
		end)
	end

	local uiStroke = Instance.new("UIStroke")
	uiStroke.Name = "LeaderStroke"
	uiStroke.Thickness = p and 2 or 0
	uiStroke.Color = Color3.fromRGB(255, 210, 50)
	uiStroke.Transparency = p and 0 or 1
	uiStroke.Parent = frame
	local frame2 = Instance.new("Frame")
	frame2.Name = "PlayingGlow"
	frame2.Size = UDim2.new(1, 0, 1, 0)
	frame2.BackgroundColor3 = Color3.fromRGB(60, 220, 100)
	frame2.BackgroundTransparency = 0.72
	frame2.BorderSizePixel = 0
	frame2.ZIndex = 0
	frame2.Visible = false
	local uiCorner2 = Instance.new("UICorner")
	uiCorner2.CornerRadius = UDim.new(0, 8)
	uiCorner2.Parent = frame2
	frame2.Parent = frame
	local imageLabel = Instance.new("ImageLabel")
	imageLabel.Name = "Avatar"
	imageLabel.Size = UDim2.new(0, v13 and 44 or 30, 0, v13 and 44 or 30)
	imageLabel.Position = UDim2.new(0, v13 and 9 or 6, 0.5, v13 and -22 or -15)
	imageLabel.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
	imageLabel.BorderSizePixel = 0
	imageLabel.ZIndex = 2
	local uiCorner3 = Instance.new("UICorner")
	uiCorner3.CornerRadius = UDim.new(0.5, 0)
	uiCorner3.Parent = imageLabel
	local success, result = pcall(function()
		return Players:GetUserThumbnailAsync(k, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)
	imageLabel.Image = success and result or ""
	imageLabel.Parent = frame

	if p then
		local textLabel = Instance.new("TextLabel")
		textLabel.Name = "Crown"
		textLabel.Size = UDim2.new(0, 16, 0, 16)
		textLabel.Position = UDim2.new(0, -2, 0, -4)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = "👑"
		textLabel.TextSize = 13
		textLabel.ZIndex = 5
		textLabel.Font = Enum.Font.GothamBold
		textLabel.Parent = imageLabel
	end

	local textLabel = Instance.new("TextLabel")
	textLabel.Name = "PianoIcon"
	textLabel.Size = UDim2.new(0, v13 and 22 or 18, 0, v13 and 22 or 18)
	textLabel.Position = UDim2.new(0, v13 and 57 or 40, 0.5, v13 and -11 or -9)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "🎹"
	textLabel.TextSize = v13 and 18 or 14
	textLabel.ZIndex = 2
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = frame
	local textLabel2 = Instance.new("TextLabel")
	textLabel2.Name = "NameLabel"
	textLabel2.Size = UDim2.new(0, v13 and 100 or 120, 1, 0)
	textLabel2.Position = UDim2.new(0, v13 and 82 or 60, 0, 0)
	textLabel2.BackgroundTransparency = 1
	textLabel2.Text = text

	if not v10[k] then
		v11 = v11 % #v9 + 1
		v10[k] = v9[v11]
	end

	textLabel2.TextColor3 = v10[k]
	textLabel2.TextXAlignment = Enum.TextXAlignment.Left
	textLabel2.Font = Enum.Font.GothamMedium
	textLabel2.TextSize = v13 and 15 or 13
	textLabel2.TextTruncate = Enum.TextTruncate.AtEnd
	textLabel2.ZIndex = 2
	textLabel2.Parent = frame
	applyVipRowStyle(v14)
	local textLabel3 = Instance.new("TextLabel")
	textLabel3.Name = "NPS"
	textLabel3.Size = UDim2.new(0, v13 and 60 or 55, 1, 0)
	textLabel3.Position = UDim2.new(0, v13 and 184 or 182, 0, 0)
	textLabel3.BackgroundTransparency = 1
	textLabel3.Text = ""
	textLabel3.TextColor3 = Color3.fromRGB(100, 230, 130)
	textLabel3.TextXAlignment = Enum.TextXAlignment.Right
	textLabel3.Font = Enum.Font.GothamMedium
	textLabel3.TextSize = v13 and 13 or 12
	textLabel3.ZIndex = 2
	textLabel3.Parent = frame
	local textLabel4 = Instance.new("TextLabel")
	textLabel4.Name = "AutoplayLabel"
	textLabel4.Size = UDim2.new(0, v13 and 80 or 70, 0, v13 and 16 or 14)
	textLabel4.Position = UDim2.new(0, v13 and 82 or 60, 1, v13 and -20 or -16)
	textLabel4.BackgroundTransparency = 1
	textLabel4.Text = ""
	textLabel4.TextColor3 = Color3.fromRGB(0, 255, 127)
	textLabel4.TextXAlignment = Enum.TextXAlignment.Left
	textLabel4.Font = Enum.Font.GothamBold
	textLabel4.TextSize = v13 and 10 or 9
	textLabel4.ZIndex = 3
	textLabel4.Parent = frame

	if v8[k] then
		textLabel4.Text = "AUTOPLAYING"
	end

	if v12 then
		return frame
	end

	local v15 = v13 and 34 or 24
	local v16 = v13 and 34 or 22
	local v17 = v13 and 80 or 64
	local v18 = v13 and 14 or 10
	local v19 = v13 and -6 or -4

	if isOwner and k ~= ownerId then
		local imageButton = Instance.new("ImageButton")
		imageButton.Name = "KickBtn"
		imageButton.Size = UDim2.new(0, v15, 0, v16)
		imageButton.Position = UDim2.new(1, v19 - v15, 0.5, -v16 / 2)
		imageButton.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
		imageButton.Image = ""
		imageButton.BorderSizePixel = 0
		imageButton.ZIndex = 3
		local textLabel5 = Instance.new("TextLabel")
		textLabel5.Size = UDim2.new(1, 0, 1, 0)
		textLabel5.BackgroundTransparency = 1
		textLabel5.Text = "⛔"
		textLabel5.TextSize = v13 and 16 or 12
		textLabel5.Font = Enum.Font.GothamBold
		textLabel5.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel5.ZIndex = 4
		textLabel5.Parent = imageButton
		local uiCorner4 = Instance.new("UICorner")
		uiCorner4.CornerRadius = UDim.new(0, 5)
		uiCorner4.Parent = imageButton
		imageButton.MouseButton1Click:Connect(function()
			Room_KickPlayer:FireServer(k)
		end)
		imageButton.Parent = frame
	end

	local frame3 = Instance.new("Frame")
	frame3.Name = "VolumeSlider"
	frame3.Size = UDim2.new(0, v17, 0, v16)
	frame3.Position = UDim2.new(
		1,
		v19 - ((not isOwner or k == ownerId) and 0 or v15 + 4 or 0) - v17 - (v15 + 4),
		0.5,
		-v16 / 2
	)
	frame3.BackgroundTransparency = 1
	frame3.ZIndex = 3
	frame3.Parent = frame
	local frame4 = Instance.new("Frame")
	frame4.Name = "Track"
	frame4.Size = UDim2.new(1, 0, 0, v18)
	frame4.Position = UDim2.new(0, 0, 0.5, -v18 / 2)
	frame4.BackgroundColor3 = Color3.fromRGB(50, 55, 80)
	frame4.BorderSizePixel = 0
	frame4.ZIndex = 3
	local uiCorner4 = Instance.new("UICorner")
	uiCorner4.CornerRadius = UDim.new(0, 4)
	uiCorner4.Parent = frame4
	frame4.Parent = frame3
	local frame5 = Instance.new("Frame")
	frame5.Name = "Fill"
	frame5.Size = UDim2.new(v3[k] or 1, 0, 1, 0)
	frame5.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
	frame5.BorderSizePixel = 0
	frame5.ZIndex = 4
	local uiCorner5 = Instance.new("UICorner")
	uiCorner5.CornerRadius = UDim.new(0, 4)
	uiCorner5.Parent = frame5
	frame5.Parent = frame4
	local imageButton = Instance.new("ImageButton")
	imageButton.Name = "Handle"
	imageButton.Size = UDim2.new(0, v13 and 14 or 10, 0, v13 and 14 or 10)
	imageButton.AnchorPoint = Vector2.new(0.5, 0.5)
	imageButton.Position = UDim2.new(v3[k] or 1, 0, 0.5, 0)
	imageButton.BackgroundColor3 = Color3.fromRGB(200, 210, 255)
	imageButton.BorderSizePixel = 0
	imageButton.Image = ""
	imageButton.ZIndex = 5
	local uiCorner6 = Instance.new("UICorner")
	uiCorner6.CornerRadius = UDim.new(0.5, 0)
	uiCorner6.Parent = imageButton
	imageButton.Parent = frame4

	local function setVolume(value) -- 1 equivalent call inferred from this helper
		local v20 = math.clamp(value, 0, 1)
		v3[k] = v20
		frame5.Size = UDim2.new(v20, 0, 1, 0)
		imageButton.Position = UDim2.new(v20, 0, 0.5, 0)
		applyPlayerVolume(k)
	end

	local v20 = false
	local UserInputService2 = game:GetService("UserInputService")

	local function volFromAbsX(x) -- 4 equivalent calls inferred from this helper
		local x2 = frame4.AbsolutePosition.X
		local x3 = frame4.AbsoluteSize.X

		if x3 == 0 then
			return
		end

		setVolume((x - x2) / x3) -- inferred equivalent call
	end

	imageButton.InputBegan:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			v20 = true
		end
	end)
	frame3.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			volFromAbsX(UserInputService2:GetMouseLocation().X) -- inferred equivalent call
			v20 = true
		elseif input.UserInputType == Enum.UserInputType.Touch then
			volFromAbsX(input.Position.X) -- inferred equivalent call
			v20 = true
		end
	end)
	UserInputService2.InputChanged:Connect(function(input)
		if not v20 then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement then
			volFromAbsX(UserInputService2:GetMouseLocation().X) -- inferred equivalent call
		elseif input.UserInputType == Enum.UserInputType.Touch then
			volFromAbsX(input.Position.X) -- inferred equivalent call
		end
	end)
	UserInputService2.InputEnded:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			v20 = false
		end
	end)
	local imageButton2 = Instance.new("ImageButton")
	imageButton2.Name = "MuteBtn"
	imageButton2.Size = UDim2.new(0, v15, 0, v16)
	imageButton2.Position = UDim2.new(0, -(v15 + 4), 0.5, -v16 / 2)
	imageButton2.BackgroundTransparency = 1
	imageButton2.Image = v2[k] and "rbxassetid://70636863327316" or "rbxassetid://125717440802006"
	imageButton2.ScaleType = Enum.ScaleType.Fit
	imageButton2.BorderSizePixel = 0
	imageButton2.ZIndex = 3
	local uiCorner7 = Instance.new("UICorner")
	uiCorner7.CornerRadius = UDim.new(0, v13 and 8 or 5)
	uiCorner7.Parent = imageButton2
	imageButton2.Parent = frame3
	imageButton2.MouseButton1Click:Connect(function()
		if v2[k] then
			v2[k] = nil
		else
			v2[k] = true
		end

		imageButton2.Image = v2[k] and "rbxassetid://70636863327316" or "rbxassetid://125717440802006"
		applyPlayerVolume(k)

		if not v2[k] then
			pcall(function()
				local keyFrame = getKeyFrame()

				if not keyFrame then
					return
				end

				if v7[k] then
					local v21 = k

					if not v10[v21] then
						v11 = v11 % #v9 + 1
						v10[v21] = v9[v11]
					end

					local imageColor = v10[v21]

					for k2 in pairs(v7[k]) do
						local child = keyFrame:FindFirstChild((tostring(k2)))

						if child then
							child.ImageColor3 = imageColor
						end
					end
				end
			end)
			return
		end

		if v6[k] then
			local fsEndRemoteTrail = _G.FSEndRemoteTrail or _G.FSEndTrail

			if fsEndRemoteTrail then
				for k2 in pairs(v6[k]) do
					pcall(fsEndRemoteTrail, k2)
				end
			end

			v6[k] = {}
		end

		pcall(function()
			local keyFrame = getKeyFrame()

			if not keyFrame then
				return
			end

			if v7[k] then
				for k2 in pairs(v7[k]) do
					resetKeyColor(keyFrame, k2)
				end
			end
		end)

		if v4[k] then
			v4[k].nps = 0
			v4[k].timestamps = {}
		end

		if v5[k] then
			task.cancel(v5[k])
			v5[k] = nil
		end

		updateNpsLabel(k)
	end)
	return frame
end

local function refreshParticipants()
	clearChildren(ParticipantsScrollingFrame, "ParticipantsLayout")

	for k, v12 in pairs(v) do
		local participantRow = makeParticipantRow(k, v12, k == ownerId)
		participantRow.Parent = ParticipantsScrollingFrame
	end

	task.wait()
	ParticipantsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, ParticipantsLayout.AbsoluteContentSize.Y + 10)
end

local function showToast(text, value)
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0.7, 0, 0, 40)
	textLabel.Position = UDim2.new(0.5, 0, 0.5, -20)
	textLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	textLabel.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
	textLabel.BackgroundTransparency = 0.15
	textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	textLabel.Text = text
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 15
	textLabel.BorderSizePixel = 0
	textLabel.ZIndex = 20
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 10)
	uiCorner.Parent = textLabel
	textLabel.Parent = RoomSystemGUI
	task.delay(value or 3, function()
		if textLabel.Parent then
			textLabel:Destroy()
		end
	end)
end

local flag = false

local function refreshRoomList()
	if flag then
		return
	end

	flag = true

	for _, frame in ipairs(RoomsScrollingFrame:GetChildren()) do
		if not (frame:IsA("Frame") and frame.Name:sub(1, 8) == "RoomBtn_") then
			continue
		end

		frame:Destroy()
	end

	local success, result = pcall(function()
		return Room_GetRooms:InvokeServer()
	end)
	flag = false

	if not (success and result) then
		return
	end

	for _, v12 in ipairs(result) do
		local frame = Instance.new("Frame")
		frame.Name = "RoomBtn_" .. v12.id
		local UserInputService = game:GetService("UserInputService")
		local v13 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
		frame.Size = UDim2.new(1, 0, 0, v13 and 70 or 54)
		frame.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
		frame.BackgroundTransparency = 0.1
		frame.BorderSizePixel = 0
		local uiCorner = Instance.new("UICorner")
		uiCorner.CornerRadius = UDim.new(0, 8)
		uiCorner.Parent = frame
		local uiStroke = Instance.new("UIStroke")
		uiStroke.Color = Color3.fromRGB(100, 100, 180)
		uiStroke.Thickness = 1
		uiStroke.Parent = frame
		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(v13 and 1 or 0.65, v13 and -104 or 0, v13 and 0 or 0.5, v13 and 34 or 0)
		textLabel.Position = UDim2.new(0, v13 and 12 or 10, 0, v13 and 8 or 4)
		textLabel.BackgroundTransparency = 1
		textLabel.Text = (v12.hasPassword and "🔒 " or "🌐 ") .. v12.name
		textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.Font = Enum.Font.GothamBold
		textLabel.TextSize = v13 and 16 or 14
		textLabel.TextTruncate = Enum.TextTruncate.AtEnd
		textLabel.Parent = frame
		local textLabel2 = Instance.new("TextLabel")
		textLabel2.Size = UDim2.new(v13 and 1 or 0.35, v13 and -104 or -10, 0, v13 and 24 or 18)
		textLabel2.Position = UDim2.new(v13 and 0 or 0.65, v13 and 12 or 0, 0, v13 and 40 or 4)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Text = "👥 " .. v12.memberCount .. " / " .. v12.maxPlayers
		textLabel2.TextColor3 = Color3.fromRGB(180, 200, 255)
		textLabel2.TextXAlignment = v13 and Enum.TextXAlignment.Left or Enum.TextXAlignment.Right
		textLabel2.Font = Enum.Font.Gotham
		textLabel2.TextSize = 13
		textLabel2.Parent = frame
		local v14

		if roomId == nil then
			v14 = false
		else
			v14 = roomId == v12.id
		end

		local textButton = Instance.new("TextButton")
		textButton.Size = UDim2.new(0, v13 and 88 or 0, 0, v13 and 46 or 0)

		if not v13 then
			textButton.Size = UDim2.new(0.35, -10, 0.45, 0)
		end

		textButton.Position = v13 and UDim2.new(1, -100, 0.5, -23) or UDim2.new(0.65, 0, 0.5, 2)
		textButton.BackgroundColor3 = v14 and Color3.fromRGB(40, 160, 80) or Color3.fromRGB(70, 130, 255)
		textButton.Text = v14 and "In Room" or "Join"
		textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		textButton.Font = Enum.Font.GothamBold
		textButton.TextSize = v13 and 16 or 13
		textButton.BorderSizePixel = 0
		textButton.Active = not v14
		local uiCorner2 = Instance.new("UICorner")
		uiCorner2.CornerRadius = UDim.new(0, v13 and 10 or 6)
		uiCorner2.Parent = textButton
		textButton.Parent = frame
		local v15 = v12
		textButton.MouseButton1Click:Connect(function()
			if v14 then
				return
			end

			if roomId then
				showToast("⚠️ You are already in a room. Please leave it before joining another.", 4)
				return
			end

			if not v15.hasPassword then
				Room_JoinRoom:FireServer(v15.id, "")
				return
			end

			id = v15.id
			PasswordInputTextBox.Text = ""
			showFrame(PasswordFrame)
		end)
		frame.Parent = RoomsScrollingFrame
	end

	task.wait()
	RoomsScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, RoomListLayout.AbsoluteContentSize.Y + 10)
end

Room_UpdateRoomList.OnClientEvent:Connect(function()
	if MainFrame.Visible then
		refreshRoomList()
	end
end)
local flag2 = false
CreateRoomButton.MouseButton1Click:Connect(function()
	if flag2 then
		return
	end

	if roomId then
		showToast("⚠️ You are already in a room.\nPlease leave your current room before creating a new one.", 4)
		return
	end

	RoomNameTextBox.Text = ""
	MaxPlayersTextBox.Text = "10"
	PasswordTextBox.Text = ""
	showFrame(CreateRoomFrame)
end)
CreateButton.MouseButton1Click:Connect(function()
	if flag2 then
		return
	end

	local text = RoomNameTextBox.Text
	local text2 = MaxPlayersTextBox.Text
	local text3 = PasswordTextBox.Text

	if text == "" or text == RoomNameTextBox.PlaceholderText then
		RoomNameTextBox.BorderColor3 = Color3.fromRGB(255, 80, 80)
		return
	end

	flag2 = true
	CreateButton.Active = false
	Room_CreateRoom:FireServer(text, text3, text2)
	hideAll() -- inferred equivalent call
	task.delay(10, function()
		if flag2 then
			flag2 = false
			CreateButton.Active = true
		end
	end)
end)
CancelButton.MouseButton1Click:Connect(function()
	showFrame(MainFrame)
	refreshRoomList()
end)
ConfirmButton.MouseButton1Click:Connect(function()
	if id then
		Room_JoinRoom:FireServer(id, PasswordInputTextBox.Text)
		PasswordFrame.Visible = false
	end
end)
cancelButton.MouseButton1Click:Connect(function()
	id = nil
	showFrame(MainFrame)
end)

local function doLeaveRoom()
	if _G.FSStopAllNotes then
		pcall(_G.FSStopAllNotes)
	end

	local keyFrame = getKeyFrame()
	local count = 0

	for _, v12 in pairs(v7) do
		for _ in pairs(v12) do
			count += 1
		end
	end

	for _, v12 in pairs(v7) do
		for k in pairs(v12) do
			if keyFrame then
				resetKeyColor(keyFrame, k)
			end
		end
	end

	v7 = {}
	local count2 = 0

	for _, v12 in pairs(v6) do
		for _ in pairs(v12) do
			count2 += 1
		end
	end

	for _, v12 in pairs(v6) do
		local fsEndRemoteTrail = _G.FSEndRemoteTrail or _G.FSEndTrail

		if not fsEndRemoteTrail then
			continue
		end

		for k in pairs(v12) do
			pcall(fsEndRemoteTrail, k)
		end
	end

	v6 = {}

	if not keyFrame and _G.FSForceResetAllKeyColors then
		pcall(_G.FSForceResetAllKeyColors)
	end

	Room_LeaveRoom:FireServer()
	roomId = nil
	ownerId = nil
	isOwner = false
	v = {}
	v2 = {}
	v3 = {}
	v8 = {}
	v4 = {}

	for _, v12 in pairs(v5) do
		pcall(task.cancel, v12)
	end

	v5 = {}
	clearPlayerColors() -- inferred equivalent call
	hideAll() -- inferred equivalent call
	setRoomFrameVisible(false) -- inferred equivalent call
	pcall(function() end)
end

LeaveRoomButton.MouseButton1Click:Connect(doLeaveRoom)
CloseRoomButton.MouseButton1Click:Connect(doLeaveRoom)

if openRooms then
	openRooms.Event:Connect(function()
		showFrame(MainFrame)
		refreshRoomList()
		setRoomFrameVisible(roomId ~= nil) -- inferred equivalent call
	end)
end

if closeRooms then
	closeRooms.Event:Connect(function()
		hideAll() -- inferred equivalent call
		setRoomFrameVisible(roomId ~= nil) -- inferred equivalent call
	end)
end

Room_PlayerJoined.OnClientEvent:Connect(function(data)
	if data.error then
		if data.error == "wrong_password" then
			PasswordInputTextBox.Text = ""
			PasswordInputTextBox.PlaceholderText = "❌ Wrong password!"
			task.delay(2, function()
				PasswordInputTextBox.PlaceholderText = "Enter password..."
			end)
		elseif data.error == "bad_password" then
			PasswordTextBox.Text = ""
			PasswordTextBox.PlaceholderText = "❌ Password not allowed, try another!"
			task.delay(3, function()
				PasswordTextBox.PlaceholderText = "Password (optional)"
			end)
			showFrame(CreateRoomFrame)
			flag2 = false
			CreateButton.Active = true
		elseif data.error == "kicked" then
			showFrame(MainFrame)
			refreshRoomList()
		elseif data.error == "room_full" then
			showFrame(MainFrame)
		end
	elseif data.newMember then
		v[data.newMember.userId] = data.newMember.name
		refreshParticipants()

		if _G.FSAutoPlaying and not _G.HideAutotag then
			pcall(function()
				Room_AutoplayStatus:FireServer(true)
			end)
		end
	else
		flag2 = false
		CreateButton.Active = true
		roomId = data.roomId
		ownerId = data.ownerId
		isOwner = data.isOwner
		v = {}

		if data.members then
			for _, member in ipairs(data.members) do
				v[member.userId] = member.name
			end
		end

		RoomTitleLabel.Text = "🎹 " .. (data.roomName or "Room")
		CloseRoomButton.Visible = isOwner
		LeaveRoomButton.Visible = not isOwner
		refreshParticipants()
		hideAll() -- inferred equivalent call
		setRoomFrameVisible(true) -- inferred equivalent call

		if closeRooms then
			closeRooms:Fire()
		end

		if _G.FSAutoPlaying and not _G.HideAutotag then
			pcall(function()
				Room_AutoplayStatus:FireServer(true)
			end)
			setAutoplayLabel(LocalPlayer.UserId, true) -- inferred equivalent call
		end
	end
end)
Room_PlayerLeft.OnClientEvent:Connect(function(p)
	if p.roomClosed then
		local keyFrame = getKeyFrame()

		if keyFrame then
			for k in pairs(v) do
				if not v7[k] then
					continue
				end

				for k2 in pairs(v7[k]) do
					resetKeyColor(keyFrame, k2)
				end
			end
		end

		roomId = nil
		ownerId = nil
		isOwner = false
		v = {}
		v2 = {}
		v3 = {}
		v8 = {}
		v4 = {}

		for _, v12 in pairs(v5) do
			pcall(task.cancel, v12)
		end

		v5 = {}
		v7 = {}
		v6 = {}
		clearPlayerColors() -- inferred equivalent call
		setRoomFrameVisible(false) -- inferred equivalent call
		showFrame(MainFrame)
		refreshRoomList()
	else
		pcall(function()
			local keyFrame = getKeyFrame()

			if keyFrame and v7[p.userId] then
				for k in pairs(v7[p.userId]) do
					resetKeyColor(keyFrame, k)
				end
			end
		end)

		if v6[p.userId] then
			local fsEndRemoteTrail = _G.FSEndRemoteTrail or _G.FSEndTrail

			if fsEndRemoteTrail then
				for k in pairs(v6[p.userId]) do
					pcall(fsEndRemoteTrail, k)
				end
			end

			v6[p.userId] = nil
		end

		v7[p.userId] = nil
		v[p.userId] = nil
		v2[p.userId] = nil
		v3[p.userId] = nil
		pcall(function()
			local SoundService = game:GetService("SoundService")
			local child = SoundService:FindFirstChild("Player_" .. p.userId)

			if child then
				child.Volume = 1
			end
		end)
		v8[p.userId] = nil
		v4[p.userId] = nil

		if v5[p.userId] then
			pcall(task.cancel, v5[p.userId])
			v5[p.userId] = nil
		end

		refreshParticipants()
	end
end)
Room_PlayerKicked.OnClientEvent:Connect(function()
	local keyFrame = getKeyFrame()

	if keyFrame then
		for k in pairs(v) do
			if not v7[k] then
				continue
			end

			for k2 in pairs(v7[k]) do
				resetKeyColor(keyFrame, k2)
			end
		end
	end

	roomId = nil
	ownerId = nil
	isOwner = false
	v = {}
	v2 = {}
	v3 = {}
	v8 = {}
	v4 = {}

	for _, v12 in pairs(v5) do
		pcall(task.cancel, v12)
	end

	v5 = {}
	v7 = {}
	v6 = {}
	clearPlayerColors() -- inferred equivalent call
	setRoomFrameVisible(false) -- inferred equivalent call
	showFrame(MainFrame)
	refreshRoomList()
	showToast("❌ You were kicked from the room", 4)
end)
Room_VisualNoteFwd.OnClientEvent:Connect(function(p, p2, p3, _, _)
	if not roomId then
		return
	end

	if p2 then
		if not v7[p3] then
			v7[p3] = {}
		end

		v7[p3][p] = true
		recordNote(p3)
	elseif v7[p3] then
		v7[p3][p] = nil
	end

	if v2[p3] then
		return
	end

	pcall(function()
		local keyFrame = getKeyFrame()

		if not keyFrame then
			return
		end

		local child = keyFrame:FindFirstChild((tostring(p)))

		if not child then
			return
		end

		if p2 then
			if not (_G.PracticeHighlightedSet and _G.PracticeHighlightedSet[p]) then
				local v12 = p3

				if not v10[v12] then
					v11 = v11 % #v9 + 1
					v10[v12] = v9[v11]
				end

				child.ImageColor3 = v10[v12]
			end
		elseif _G.PracticeHighlightedSet and _G.PracticeHighlightedSet[p] then
			child.ImageColor3 = Color3.fromRGB(0, 220, 80)
		else
			resetKeyColor(keyFrame, p)
		end
	end)
end)
Room_TrailForwarded.OnClientEvent:Connect(function(p, p2, p3, p4, p5, p6, p7)
	if not roomId then
		return
	end

	if p == "start" then
		if not v6[p3] then
			v6[p3] = {}
		end

		v6[p3][p2] = true
	elseif p == "stop" and v6[p3] then
		v6[p3][p2] = nil
	end

	if v2[p3] then
		return
	end

	if p == "start" then
		local fsStartRemoteTrail = _G.FSStartRemoteTrail or _G.FSStartTrail

		if fsStartRemoteTrail then
			pcall(fsStartRemoteTrail, p2, p4, p5, p6, p7)
		end
	else
		local fsEndRemoteTrail = p == "stop" and (_G.FSEndRemoteTrail or _G.FSEndTrail)

		if fsEndRemoteTrail then
			pcall(fsEndRemoteTrail, p2)
		end
	end
end)
Room_FinishForwarded.OnClientEvent:Connect(function(p, value)
	local pianoLogicInstance = _G.PianoLogicInstance

	if pianoLogicInstance then
		pianoLogicInstance.ServerFinishNonSustainNote(p, value or 0.5)
	end
end)
Room_NoteForwarded.OnClientEvent:Connect(function(p, _, p2, p3, p4, p5, p6, p7, p8, p9, p10)
	if v2[p] then
		return
	end

	pcall(function()
		if _G.FSPlayServerNote then
			_G.FSPlayServerNote(p2, p3, p4, p5, p6, p7, p8, p9, p10, p)
		end
	end)
end)
Room_SustainForwarded.OnClientEvent:Connect(function(p, p2)
	local pianoLogicInstance = _G.PianoLogicInstance

	if not pianoLogicInstance then
		return
	end

	if not p then
		pianoLogicInstance.ServerFadeoutAllSustainedNotes(0.5, p2)
	end
end)
task.spawn(function()
	while true do
		task.wait(0.1)
		local v12 = (next(v) or next(v7)) and getKeyFrame()

		if not v12 then
			continue
		end

		for k in pairs(v7) do
			local v13 = v2[k]

			if not ((not v[k] or v13) and v7[k]) then
				continue
			end

			for k2 in pairs(v7[k]) do
				resetKeyColor(v12, k2)
			end

			if not v[k] then
				v7[k] = nil
			end
		end
	end
end)
print("[RoomClient] v5 Loaded!")