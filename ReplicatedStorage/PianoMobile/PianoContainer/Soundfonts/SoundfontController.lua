local Players2 = game:GetService("Players")
Players = Players2
Piano_Dependencies = workspace.Piano_Dependencies
Buttons = {}
Folder_Modules = Piano_Dependencies.Modules
Folder_Remotes = Piano_Dependencies.Remotes
Folder_Logic = Folder_Modules.Logic
Folder_Dependencies = Folder_Modules.Dependencies
local Soundfonts = require(Folder_Dependencies.Soundfonts)
Dependence_Soundfonts = Soundfonts
local PlayerVariables = require(Folder_Dependencies.PlayerVariables)
Dependence_PlayerVariables = PlayerVariables
local PianoLogic = require(Folder_Logic.PianoLogic)
Logic_Piano = PianoLogic
local UILogic = require(Folder_Logic.UILogic)
Logic_UI = UILogic
Frame_Soundfonts = script.Parent
ScrollingFrame_Soundfonts = Frame_Soundfonts.ScrollingFrame
SearchBox = Frame_Soundfonts:FindFirstChild("TextBox")
local Sample = ScrollingFrame_Soundfonts:FindFirstChild("Sample")
local color = Color3.fromRGB(61, 123, 198)
local color2 = Color3.fromRGB(255, 255, 255)
local color3 = Color3.fromRGB(255, 200, 50)
local color4 = Color3.fromRGB(255, 160, 0)
ScrollingFrame_Soundfonts.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame_Soundfonts.AutomaticCanvasSize = Enum.AutomaticSize.Y
local v = {}
local v2 = { "Grand Pianos", "Guitars", "Organs", "Synth", "Funny" }
local flag = false

local function UpdateButtonsVisuals()
	local current_SoundfontID = Dependence_PlayerVariables.Current_SoundfontID

	for _, v3 in pairs(Buttons) do
		local name = tonumber(v3.Name)
		local uiStroke = v3:FindFirstChild("UIStroke")

		if name == current_SoundfontID then
			v3.TextColor3 = color

			if uiStroke then
				uiStroke.Color = color
			end
		else
			v3.TextColor3 = color2

			if uiStroke then
				uiStroke.Color = color2
			end
		end
	end
end

local function ApplySearch(value)
	local v3 = value:lower():gsub("%s+", "")

	if v3 == "" then
		flag = false

		for _, v4 in ipairs(v2) do
			local v5 = v[v4]

			if not v5 then
				continue
			end

			v5.headerBtn.Visible = true

			for _, soundfontBtn in ipairs(v5.soundfontBtns) do
				soundfontBtn.Visible = v5.isOpen
			end
		end
	else
		flag = true

		for _, v4 in ipairs(v2) do
			local v5 = v[v4]

			if not v5 then
				continue
			end

			local visible = false

			for _, soundfontBtn in ipairs(v5.soundfontBtns) do
				local visible2 = soundfontBtn.Text:lower():gsub("%s+", ""):find(v3, 1, true) ~= nil
				soundfontBtn.Visible = visible2

				if visible2 then
					visible = true
				end
			end

			v5.headerBtn.Visible = visible
		end
	end
end

local function CreateCategoryButton(p) -- 1 equivalent call inferred from this helper
	local clone = Sample:Clone()
	clone.Visible = true
	clone.Name = "CAT_" .. p
	clone.Text = "▶  " .. p
	clone.TextColor3 = color3

	if clone:FindFirstChild("UIStroke") then
		clone.UIStroke.Color = color3
	end

	clone.Parent = ScrollingFrame_Soundfonts
	return clone
end

local function ToggleCategory(p)
	if flag then
		return
	end

	local v3 = v[p]

	if not v3 then
		return
	end

	v3.isOpen = not v3.isOpen
	local isOpen = v3.isOpen
	v3.headerBtn.Text = (isOpen and "▼  " or "▶  ") .. p
	v3.headerBtn.TextColor3 = isOpen and color4 or color3

	if v3.headerBtn:FindFirstChild("UIStroke") then
		v3.headerBtn.UIStroke.Color = isOpen and color4 or color3
	end

	for _, soundfontBtn in ipairs(v3.soundfontBtns) do
		soundfontBtn.Visible = isOpen
	end
end

local v3 = {}

for k, v4 in pairs(Dependence_Soundfonts) do
	local category = v4.Category or "Other"

	if not v3[category] then
		v3[category] = {}
	end

	table.insert(v3[category], { id = k, data = v4 })
end

if v3.Other then
	local v4 = false

	for _, v5 in ipairs(v2) do
		if v5 ~= "Other" then
			continue
		end

		v4 = true
		break
	end

	if not v4 then
		table.insert(v2, "Other")
	end
end

local count = 0

for _, v4 in ipairs(v2) do
	local v5 = v3[v4]

	if not v5 then
		continue
	end

	table.sort(v5, function(a, b)
		return a.id < b.id
	end)
	local headerBtn = CreateCategoryButton(v4) -- inferred equivalent call
	count += 1
	headerBtn.LayoutOrder = count
	v[v4] = { isOpen = false, headerBtn = headerBtn, soundfontBtns = {} }

	for _, v6 in ipairs(v5) do
		local id = v6.id
		local data = v6.data
		local clone = Sample:Clone()
		clone.Visible = false
		clone.Text = data.Name
		clone.Name = tostring(id)
		clone.TextColor3 = color2
		count += 1
		clone.LayoutOrder = count

		if clone:FindFirstChild("UIStroke") then
			clone.UIStroke.Color = color2
		end

		table.insert(Buttons, clone)
		table.insert(v[v4].soundfontBtns, clone)
		clone.MouseButton1Click:Connect(function()
			Dependence_PlayerVariables.Current_SoundfontID = tonumber(clone.Name)
			Players.LocalPlayer:SetAttribute("CurrentSoundfontID", (tonumber(clone.Name)))
			UpdateButtonsVisuals()
			task.spawn(function()
				Logic_Piano.PreloadSoundfont(data.AssetIds, data.PacketType, data.Name)
			end)
			local soundfontChanged = game.ReplicatedStorage:FindFirstChild("PlayerInspectRemotes")
				and game.ReplicatedStorage.PlayerInspectRemotes:FindFirstChild("SoundfontChanged")

			if soundfontChanged then
				soundfontChanged:FireServer(data.Name)
			end
		end)
		clone.Parent = ScrollingFrame_Soundfonts
	end

	local v6 = v4
	headerBtn.MouseButton1Click:Connect(function()
		ToggleCategory(v6)
	end)
end

Sample.Visible = false

if SearchBox then
	SearchBox.FocusLost:Connect(function(p)
		if p then
			ApplySearch(SearchBox.Text)
		end
	end)
	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		if SearchBox.Text == "" then
			ApplySearch("")
		end
	end)
else
	warn("[SoundfontController] TextBox not found in Frame_Soundfonts!")
end

local function OpenCategoryOfCurrentSoundfont()
	local current_SoundfontID = Dependence_PlayerVariables.Current_SoundfontID

	for _, v4 in ipairs(v2) do
		local v5 = v[v4]

		if not v5 then
			continue
		end

		for _, soundfontBtn in ipairs(v5.soundfontBtns) do
			if tonumber(soundfontBtn.Name) ~= current_SoundfontID then
				continue
			end

			v5.isOpen = true
			v5.headerBtn.Text = "▼  " .. v4
			v5.headerBtn.TextColor3 = color4

			if v5.headerBtn:FindFirstChild("UIStroke") then
				v5.headerBtn.UIStroke.Color = color4
			end

			for _, soundfontBtn2 in ipairs(v5.soundfontBtns) do
				soundfontBtn2.Visible = true
			end

			return
		end
	end
end

Sample.Visible = false
UpdateButtonsVisuals()
print("[SoundfontController] Started correctly.")