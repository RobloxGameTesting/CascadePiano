local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local PracticeModeGUI = PlayerGui:WaitForChild("PracticeModeGUI", 30)

if not PracticeModeGUI then
	warn("[PracticeClient] PracticeModeGUI not found!")
	return
end

local MainFrame = PracticeModeGUI:WaitForChild("MainFrame")
local CloseButton = MainFrame:WaitForChild("CloseButton")
local InputScrollFrame = MainFrame:WaitForChild("InputScrollFrame")
local InputBox = InputScrollFrame:WaitForChild("InputBox")
local ButtonsFrame = MainFrame:WaitForChild("ButtonsFrame")
local StartButton = ButtonsFrame:WaitForChild("StartButton")
local ClearButton = ButtonsFrame:WaitForChild("ClearButton")
local HintText = MainFrame:WaitForChild("HintText")
local StatsFrame = MainFrame:WaitForChild("StatsFrame")
local MissLabel = StatsFrame:WaitForChild("MissLabel")
local PerfectLabel = StatsFrame:WaitForChild("PerfectLabel")
local progressFill = MainFrame:WaitForChild("ProgressBackground"):WaitForChild("ProgressFill")
local ProgressText = MainFrame:WaitForChild("ProgressText")

local function applyLayout()
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		MainFrame.AnchorPoint = Vector2.new(0.5, 0)
		MainFrame.Position = UDim2.new(0.5, 0, 0, 5)
		MainFrame.Size = UDim2.new(0.95, 0, 0, 245)
		local v = MainFrame:FindFirstChildOfClass("UISizeConstraint")

		if not v then
			v = Instance.new("UISizeConstraint")
			v.Parent = mf
		end

		v.MaxSize = Vector2.new(700, 245)
		v.MinSize = Vector2.new(260, 245)
		local header = MainFrame:FindFirstChild("Header")
		local hintText = MainFrame:FindFirstChild("HintText")
		local inputScrollFrame = MainFrame:FindFirstChild("InputScrollFrame")
		local statsFrame = MainFrame:FindFirstChild("StatsFrame")
		local progressBackground = MainFrame:FindFirstChild("ProgressBackground")
		local progressText = MainFrame:FindFirstChild("ProgressText")
		local buttonsFrame = MainFrame:FindFirstChild("ButtonsFrame")
		local closeButton = MainFrame:FindFirstChild("CloseButton")

		if header then
			header.Size = UDim2.new(1, 0, 0, 28)
			header.Position = UDim2.new(0, 0, 0, 2)
		end

		if closeButton then
			closeButton.Size = UDim2.new(0, 24, 0, 24)
			closeButton.Position = UDim2.new(1, -28, 0, 3)
		end

		if hintText then
			hintText.Size = UDim2.new(1, -20, 0, 14)
			hintText.Position = UDim2.new(0, 10, 0, 30)
			hintText.TextSize = 10
		end

		if inputScrollFrame then
			inputScrollFrame.Size = UDim2.new(1, -20, 0, 110)
			inputScrollFrame.Position = UDim2.new(0, 10, 0, 46)
		end

		if statsFrame then
			statsFrame.Size = UDim2.new(1, -20, 0, 22)
			statsFrame.Position = UDim2.new(0, 10, 0, 160)

			for _, label in ipairs(statsFrame:GetChildren()) do
				if label:IsA("TextLabel") then
					label.TextSize = 12
				end
			end
		end

		if progressBackground then
			progressBackground.Size = UDim2.new(1, -20, 0, 6)
			progressBackground.Position = UDim2.new(0, 10, 0, 186)
		end

		if progressText then
			progressText.Size = UDim2.new(1, 0, 0, 11)
			progressText.Position = UDim2.new(0, 0, 0, 194)
			progressText.TextSize = 10
		end

		if buttonsFrame then
			buttonsFrame.Size = UDim2.new(1, -20, 0, 36)
			buttonsFrame.Position = UDim2.new(0, 10, 0, 206)

			for _, button in ipairs(buttonsFrame:GetChildren()) do
				if button:IsA("TextButton") then
					button.TextSize = 15
				end
			end
		end
	end
end

applyLayout()
ProgressText.Text = "Progress: 0 / 0"
progressFill.Size = UDim2.new(0, 0, 1, 0)
MissLabel.Text = "Misses: 0"
PerfectLabel.Text = "Perfect: 0"
local v = {
	0,
	-1,
	-2,
	-3,
	-4,
	-5,
	-6,
	-7,
	-8,
	-9,
	-10,
	-11,
	-12,
	-13,
	-14,
	62,
	63,
	64,
	65,
	66,
	67,
	68,
	69,
	70,
	71,
	72,
	73,
	74
}
local v2 = {
	"transpose by",
	"transpose",
	"trans",
	"tempo",
	"bpm",
	"chorus",
	"intro",
	"verse",
	"author",
	"arranger",
	"pitch",
	"speed",
	"song",
	"title",
	"artist",
	"creator",
	"played by",
	"changed to",
	"slower",
	"faster"
}

local function parseNotes(value)
	local lower = value:lower()
	local v3 = 1
	local v4 = {}
	local v5 = false
	local result = {}

	while v3 <= #value do
		local v6 = value:find("\n", v3, true)
		local v7

		if v6 then
			v7 = v6 - 1
		else
			v7 = #value
		end

		local v8 = lower:sub(v3, v7)

		for _, v9 in ipairs(v2) do
			if not v8:find(v9, 1, true) then
				continue
			end

			for i = v3, v7 do
				v4[i] = true
			end

			break
		end

		v3 = v7 + 2
	end

	local v6 = 1

	while v6 <= #value do
		if v4[v6] then
			if value:sub(v6, v6):match("%s") then
				v5 = false
			end

			v6 += 1
		else
			local token = value:sub(v6, v6)

			if token:match("%s") or token == "|" or token == "-" then
				v6 += 1
				v5 = false
			elseif token == ":" then
				v5 = not value:sub(v6 + 1, v6 + 1):match("%s") or v5
				v6 += 1
			elseif token == "'" then
				v6 += 1
				v5 = false
			elseif token == "[" or token == "{" then
				local endIdx = value:find(token == "{" and "}" or "]", v6, true)

				if endIdx then
					local token2 = value:sub(v6 + 1, endIdx - 1)
					local flag = false

					for i = 1, #token2 do
						local v7 = token2:sub(i, i)

						if not (("1!2@34$5%6^78*9(0qQwWeErtTyYuiIoOpPasSdDfgGhHjJklLzZxcCvVbBnm"):find(v7, 1, true) or ("trewq0987654321yuiopasdfghj"):find(v7, 1, true)) then
							continue
						end

						flag = true
						break
					end

					if flag then
						table.insert(result, {
							isChord = true,
							token = token2,
							startIdx = v6,
							endIdx = endIdx,
							startCtrl = v5
						})
					end

					v6 = endIdx + 1
				else
					v6 += 1
				end
			else
				if
					token:match("%S")
					and (("1!2@34$5%6^78*9(0qQwWeErtTyYuiIoOpPasSdDfgGhHjJklLzZxcCvVbBnm"):find(token, 1, true) or ("trewq0987654321yuiopasdfghj"):find(token, 1, true))
				then
					table.insert(result, {
						isChord = false,
						token = token,
						startIdx = v6,
						endIdx = v6,
						isCtrl = v5
					})
				end

				v6 += 1
			end
		end
	end

	return result
end

local function tokenToNums(data, value)
	local v3 = value or 0
	local v4 = {}
	local v5 = {}

	local function add(p, p2)
		local v6 = nil

		if p2 then
			local v7 = ("trewq0987654321yuiopasdfghj"):find(p, 1, true)

			if v7 then
				v6 = (v[v7] or 0) + v3
			end
		end

		if not v6 then
			local v7 = ("1!2@34$5%6^78*9(0qQwWeErtTyYuiIoOpPasSdDfgGhHjJklLzZxcCvVbBnm"):find(p, 1, true)

			if v7 then
				v6 = v7 + v3
			end
		end

		if v6 and not v5[v6] then
			v5[v6] = true
			table.insert(v4, v6)
		end
	end

	if data.isChord then
		local startCtrl = data.startCtrl

		for i = 1, #data.token do
			local v6 = data.token:sub(i, i)

			if v6 == ":" then
				startCtrl = true
			elseif v6 == "'" then
				startCtrl = false
			else
				add(v6, startCtrl)
			end
		end
	else
		add(data.token, data.isCtrl)
	end

	return v4
end

local keyFrame = nil

local function getKeyFrame() -- 1 equivalent call inferred from this helper
	if keyFrame and keyFrame.Parent then
		return keyFrame
	end

	local child = PlayerGui:FindFirstChild(UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and "FulllScreenPianoMobileUI" or "FulllScreenPianoUI")

	if not child then
		return nil
	end

	local pianoContainer = child:FindFirstChild("PianoContainer")

	if not pianoContainer then
		return nil
	end

	keyFrame = pianoContainer:FindFirstChild("KeyFrame")
	return keyFrame
end

local function isBlack(p) -- 1 equivalent call inferred from this helper
	local v3 = p % 12
	return v3 == 2 or v3 == 4 or v3 == 7 or v3 == 9 or v3 == 11
end

local color = Color3.fromRGB(0, 220, 80)
local v3 = {}
local practiceHighlightedSet = {}

local function setKey(p, p2)
	local keyFrame2 = getKeyFrame() -- inferred equivalent call

	if not keyFrame2 then
		return
	end

	local child = keyFrame2:FindFirstChild((tostring(p)))

	if not child then
		return
	end

	local color2 = p2 and color

	if not color2 then
		color2 = isBlack(p) and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255) -- inferred equivalent call
	end

	child.ImageColor3 = color2
	practiceHighlightedSet[p] = p2 or nil
end

_G.PracticeHighlightedSet = practiceHighlightedSet

local function clearKeys()
	for _, v4 in ipairs(v3) do
		setKey(v4, false)
	end

	v3 = {}
end

local flag = false
local v4 = {}
local v5 = 1
local count = 0
local count2 = 0
local v6 = 1
local inputBeganConnection = nil
local inputBeganConnections = {}
local scrollingFrame = nil
local v7 = {}
local v8 = {}
local text3 = ""

local function esc(value) -- 11 equivalent calls inferred from this helper
	return (value:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"))
end

local function buildDisplay(text)
	if scrollingFrame then
		scrollingFrame:Destroy()
		scrollingFrame = nil
	end

	v7 = {}
	scrollingFrame = Instance.new("ScrollingFrame")
	scrollingFrame.Name = "PracticeDisplay"
	scrollingFrame.Size = InputScrollFrame.Size
	scrollingFrame.Position = InputScrollFrame.Position
	scrollingFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
	scrollingFrame.BackgroundTransparency = 0.2
	scrollingFrame.BorderSizePixel = 0
	scrollingFrame.ScrollBarThickness = 4
	scrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 160)
	scrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame.ClipsDescendants = true
	scrollingFrame.ZIndex = 5
	scrollingFrame.Parent = MainFrame
	local uiCorner = Instance.new("UICorner", scrollingFrame)
	uiCorner.CornerRadius = UDim.new(0, 6)
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 2)
	uiListLayout.Parent = scrollingFrame
	local uiPadding = Instance.new("UIPadding")
	uiPadding.PaddingTop = UDim.new(0, 3)
	uiPadding.PaddingLeft = UDim.new(0, 3)
	uiPadding.PaddingRight = UDim.new(0, 3)
	uiPadding.Parent = scrollingFrame
	local startPos2 = 1
	local v9 = {}

	while startPos2 <= #text do
		local v10 = text:find("\n", startPos2, true)
		local v11 = v10 and v10 - 1 or #text
		local v12 = text:sub(startPos2, v11)
		local v13 = 1
		local v14 = {}

		while true do
			local v15 = v13 <= #v12 and v12:find("%S", v13)

			if not v15 then
				break
			end

			v13 = v12:find("%s", v15) or #v12 + 1
			table.insert(v14, {
				text = v12:sub(v15, v13 - 1),
				startPos = startPos2 + v15 - 1
			})
		end

		if #v14 == 0 then
			table.insert(v9, { raw = "", startPos = startPos2 })
		else
			local startPos = v14[1].startPos
			local text2 = ""

			for _, v15 in ipairs(v14) do
				local v16 = text2 .. (text2 == "" and "" or " ") .. v15.text

				if #v16 * 11 <= 450 then
					text2 = v16
				else
					if text2 ~= "" then
						table.insert(v9, { raw = text2, startPos = startPos })
					end

					text2 = v15.text
					startPos = v15.startPos
				end
			end

			if text2 ~= "" then
				table.insert(v9, { raw = text2, startPos = startPos })
			end
		end

		startPos2 = v11 + 2
	end

	local v10 = #v9 == 0 and {
		{ raw = text, startPos = 1 }
	} or v9
	local v11 = parseNotes(text)
	local v12 = 1
	local si = 1

	for i, v13 in ipairs(v10) do
		local raw = v13.raw
		local startPos = v13.startPos
		local v14 = startPos + #raw - 1
		local toks = {}

		while v12 <= #v11 do
			local v15 = v11[v12]

			if v14 < v15.startIdx then
				break
			end

			if startPos <= v15.startIdx then
				local v16 = {}

				for k, v17 in pairs(v15) do
					v16[k] = v17
				end

				table.insert(toks, v16)
			end

			v12 += 1
		end

		local ei = si + #toks - 1
		local v15 = ei + 1
		local frame = Instance.new("Frame")
		frame.Name = "Row" .. i
		frame.Size = UDim2.new(1, 0, 0, 24)
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.LayoutOrder = i
		frame.ZIndex = 5
		frame.Parent = scrollingFrame
		local textLabel = Instance.new("TextLabel")
		textLabel.Name = "Lbl"
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 1
		textLabel.Font = Enum.Font.Code
		textLabel.TextSize = 20
		textLabel.TextColor3 = Color3.fromRGB(180, 180, 210)
		textLabel.TextXAlignment = Enum.TextXAlignment.Left
		textLabel.TextYAlignment = Enum.TextYAlignment.Center
		textLabel.RichText = true
		textLabel.Text = esc(raw) -- inferred equivalent call
		textLabel.ZIndex = 5
		textLabel.Parent = frame
		table.insert(v7, {
			row = frame,
			lbl = textLabel,
			toks = toks,
			raw = raw,
			lineStart = startPos,
			si = si,
			ei = ei
		})
		si = v15
	end

	task.defer(function()
		if not scrollingFrame then
			return
		end

		local count3 = #v7
		scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, count3 * 24 + math.max(0, count3 - 1) * 2 + 10)
		scrollingFrame.CanvasPosition = Vector2.new(0, 0)
	end)
	InputScrollFrame.Visible = false
	HintText.Visible = false
end

local function scrollToLine(_)
	if not scrollingFrame then
		return
	end

	local v9 = scrollingFrame.CanvasPosition.Y + 24 + 2
	local v10 = scrollingFrame.CanvasSize.Y.Offset - scrollingFrame.AbsoluteSize.Y
	local v11 = v10 < 0 and 0 or v10
	TweenService:Create(scrollingFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
		CanvasPosition = Vector2.new(0, (math.min(v9, v11)))
	}):Play()
end

local function renderLine(data, p) -- 1 equivalent call inferred from this helper
	if not data then
		return
	end

	if p then
		local tok = data.toks[p]

		if not tok then
			data.lbl.Text = esc(data.raw) -- inferred equivalent call
			return
		end

		local v9 = data.lineStart - 1
		local v10 = math.max(1, tok.startIdx - v9)
		local v11 = math.min(#data.raw, tok.endIdx - v9)
		data.lbl.Text = "<font color=\"#FFFFFF\">" .. esc(data.raw:sub(1, v10 - 1)) .. "</font>" .. "<font color=\"#00FF55\"><b>" .. esc(data.raw:sub(v10, v11)) .. "</b></font>" .. "<font color=\"#AAAAAA\">" .. esc(data.raw:sub(v11 + 1)) .. "</font>" -- inferred equivalent call
	else
		data.lbl.TextColor3 = Color3.fromRGB(180, 180, 210)
		data.lbl.Text = esc(data.raw) -- inferred equivalent call
	end
end

local function lineForIdx(p)
	for i, v9 in ipairs(v7) do
		if #v9.toks > 0 and v9.si <= p and p <= v9.ei then
			return i
		end
	end

	for i, v9 in ipairs(v7) do
		if p <= v9.ei then
			return i
		end
	end

	return #v7
end

local count3 = 0

local function doHighlight()
	count3 += 1
	local v9 = count3
	clearKeys()

	for _, v10 in ipairs(v7) do
		renderLine(v10) -- inferred equivalent call
	end

	if v5 > #v4 then
		return
	end

	local v10 = lineForIdx(v5)
	local v11 = v7[v10]

	if not v11 then
		return
	end

	if v10 ~= v6 then
		v6 = v10
		scrollToLine(v11)
	end

	renderLine(v11, v5 - v11.si + 1)
	local v12 = #v8 > 0 and v8 or tokenToNums(v4[v5], 0)
	local v13 = {}

	for _, v14 in ipairs(v12) do
		table.insert(v13, v14)
	end

	local function applyHL()
		if not flag or count3 ~= v9 then
			return
		end

		v3 = {}

		for _, v14 in ipairs(v13) do
			setKey(v14, true)
			table.insert(v3, v14)
		end
	end

	task.delay(0.05, applyHL)
	task.delay(0.2, applyHL)
	task.delay(0.4, applyHL)
end

local function updProgress()
	local count4 = #v4
	local v9 = math.max(0, v5 - 1)
	ProgressText.Text = "Progress: " .. v9 .. " / " .. count4
	TweenService:Create(progressFill, TweenInfo.new(0.1), {
		Size = count4 > 0 and UDim2.new(v9 / count4, 0, 1, 0) or UDim2.new(0, 0, 1, 0)
	}):Play()
end

local function updStats() -- 7 equivalent calls inferred from this helper
	MissLabel.Text = "Misses: " .. count2
	PerfectLabel.Text = "Perfect: " .. count
end

local function stopCapture()
	if inputBeganConnection then
		inputBeganConnection:Disconnect()
		inputBeganConnection = nil
	end

	for _, connection in ipairs(inputBeganConnections) do
		connection:Disconnect()
	end

	inputBeganConnections = {}
end

local function restoreInput() -- 2 equivalent calls inferred from this helper
	if scrollingFrame then
		scrollingFrame:Destroy()
		scrollingFrame = nil
	end

	InputScrollFrame.Visible = true
	HintText.Visible = true
	InputBox.Text = text3
	InputBox.TextEditable = true
end

local function resetAll()
	flag = false
	clearKeys()
	stopCapture()
	v5 = 1
	v6 = 1
	count = 0
	count2 = 0
	v4 = {}
	v7 = {}
	v8 = {}
	restoreInput() -- inferred equivalent call
	updStats() -- inferred equivalent call
	ProgressText.Text = "Progress: 0 / 0"
	progressFill.Size = UDim2.new(0, 0, 1, 0)
	StartButton.Text = "Start"
	StartButton.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
end

local function finishPractice()
	flag = false
	clearKeys()
	stopCapture()
	local text = "Complete! " .. count .. " / " .. #v4
	v5 = 1
	v6 = 1
	v4 = {}
	v7 = {}
	v8 = {}
	restoreInput() -- inferred equivalent call
	StartButton.Text = "Start"
	StartButton.BackgroundColor3 = Color3.fromRGB(0, 170, 80)
	ProgressText.Text = text
	task.delay(5, function()
		ProgressText.Text = "Progress: 0 / 0"
		progressFill.Size = UDim2.new(0, 0, 1, 0)
		count = 0
		count2 = 0
		updStats() -- inferred equivalent call
	end)
end

local function onNotePressed(p)
	if not flag or v5 > #v4 then
		return
	end

	local v9 = v4[v5]

	if v9.isChord then
		if #v8 == 0 then
			local v10 = tokenToNums(v9, 0)

			for _, v11 in ipairs(v10) do
				table.insert(v8, v11)
			end
		end

		local flag2 = false

		for i, v10 in ipairs(v8) do
			if v10 ~= p then
				continue
			end

			table.remove(v8, i)
			flag2 = true
			break
		end

		if flag2 then
			for i, v10 in ipairs(v3) do
				if v10 ~= p then
					continue
				end

				setKey(v10, false)
				table.remove(v3, i)
				break
			end

			if #v8 == 0 then
				count += 1
				v5 += 1
				updStats() -- inferred equivalent call
				updProgress()

				if v5 > #v4 then
					finishPractice()
				else
					task.defer(doHighlight)
				end
			else
				local v10 = lineForIdx(v5)
				local v11 = v7[v10]
				local v12 = v11 and v11.toks[v5 - v11.si + 1]

				if v12 then
					local v13 = v11.lineStart - 1
					local v14 = math.max(1, v12.startIdx - v13)
					local v15 = math.min(#v11.raw, v12.endIdx - v13)
					local v16 = v11.raw:sub(v14, v15)
					local v17 = {}

					for _, v18 in ipairs(v8) do
						v17[v18] = true
					end

					local v18 = ""

					for i = 1, #v16 do
						local v19 = v16:sub(i, i)
						local v20 = ("1!2@34$5%6^78*9(0qQwWeErtTyYuiIoOpPasSdDfgGhHjJklLzZxcCvVbBnm"):find(v19, 1, true)

						if v20 and v17[v20] then
							v18 ..= "<font color=\"#00FF55\"><b>" .. esc(v19) .. "</b></font>" -- inferred equivalent call
						elseif v19 == "[" or v19 == "]" then
							v18 ..= "<font color=\"#888888\">" .. esc(v19) .. "</font>" -- inferred equivalent call
						else
							v18 ..= "<font color=\"#555555\">" .. esc(v19) .. "</font>" -- inferred equivalent call
						end
					end

					v11.lbl.Text = "<font color=\"#FFFFFF\">" .. esc(v11.raw:sub(1, v14 - 1)) .. "</font>" .. v18 .. "<font color=\"#AAAAAA\">" .. esc(v11.raw:sub(v15 + 1)) .. "</font>" -- inferred equivalent call
				end
			end
		else
			count2 += 1
			updStats() -- inferred equivalent call
		end
	else
		local v10 = tokenToNums(v9, 0)
		local flag2 = false

		for _, v11 in ipairs(v10) do
			if v11 ~= p then
				continue
			end

			flag2 = true
			break
		end

		if flag2 then
			count += 1
			v5 += 1
			updStats() -- inferred equivalent call
			updProgress()

			if v5 > #v4 then
				finishPractice()
			else
				task.defer(doHighlight)
			end
		else
			count2 += 1
			updStats() -- inferred equivalent call
		end
	end
end

local function bindMouseKeys()
	for _, connection in ipairs(inputBeganConnections) do
		connection:Disconnect()
	end

	inputBeganConnections = {}
	local v9 = {
		PlayerGui:FindFirstChild("FulllScreenPianoUI"),
		(PlayerGui:FindFirstChild("FulllScreenPianoMobileUI"))
	}
	local keyFrames = {}

	for _, v10 in ipairs(v9) do
		if not v10 then
			continue
		end

		local pianoContainer = v10:FindFirstChild("PianoContainer")
		local keyFrame2 = pianoContainer and pianoContainer:FindFirstChild("KeyFrame")

		if keyFrame2 then
			table.insert(keyFrames, keyFrame2)
		end
	end

	for _, v10 in ipairs(keyFrames) do
		for _, button in ipairs(v10:GetChildren()) do
			local name = tonumber(button.Name)

			if not (name and button:IsA("ImageButton")) then
				continue
			end

			local inputBeganConnection2 = button.InputBegan:Connect(function(input)
				if not flag then
					return
				end

				if
					input.UserInputType == Enum.UserInputType.MouseButton1
					or input.UserInputType == Enum.UserInputType.Touch
				then
					onNotePressed(name)
				end
			end)
			table.insert(inputBeganConnections, inputBeganConnection2)
		end
	end
end

local function startCapture() -- 1 equivalent call inferred from this helper
	if inputBeganConnection then
		inputBeganConnection:Disconnect()
	end

	inputBeganConnection = UserInputService.InputBegan:Connect(function(input, _)
		if not (flag and input.UserInputType == Enum.UserInputType.Keyboard) then
			return
		end

		local value = input.KeyCode.Value

		if value < 32 or value > 126 then
			return
		end

		local v9 = string.char(value)
		local v10 = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
			or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
		local v11 = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
			or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
		local v12

		if v10 then
			local v13 = ("trewq0987654321yuiopasdfghj"):find(v9, 1, true)

			if not v13 then
				return
			end

			v12 = v[v13] or 0
		else
			local v13 = ("1!2@34$5%6^78*9(0qQwWeErtTyYuiIoOpPasSdDfgGhHjJklLzZxcCvVbBnm"):find(v9, 1, true)

			if not v13 then
				return
			end

			v12 = v13 + (v11 and 1 or 0)
		end

		onNotePressed(v12)
	end)
	task.delay(0.5, bindMouseKeys)
end

StartButton.MouseButton1Click:Connect(function()
	if flag then
		resetAll()
		return
	end

	local text = InputBox.Text

	if not text or text:match("^%s*$") then
		return
	end

	local v9 = parseNotes(text)

	if #v9 == 0 then
		return
	end

	text3 = text
	keyFrame = nil
	v4 = v9
	v5 = 1
	v6 = 1
	count = 0
	count2 = 0
	v8 = {}
	buildDisplay(text)
	updStats() -- inferred equivalent call
	updProgress()
	flag = true
	StartButton.Text = "Stop"
	StartButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
	InputBox:ReleaseFocus()
	task.defer(function()
		v6 = lineForIdx(1)
		doHighlight()
	end)
	startCapture() -- inferred equivalent call
end)
ClearButton.MouseButton1Click:Connect(function()
	resetAll()
	text3 = ""
	InputBox.Text = ""
end)
CloseButton.MouseButton1Click:Connect(function()
	resetAll()
	PracticeModeGUI.Enabled = false
	local menuEvents = ReplicatedStorage:FindFirstChild("MenuEvents")
	local closePractice = menuEvents and menuEvents:FindFirstChild("ClosePractice")

	if closePractice then
		closePractice:Fire()
	end
end)
task.spawn(function()
	local menuEvents = ReplicatedStorage:WaitForChild("MenuEvents", 15)

	if not menuEvents then
		return
	end

	local openPractice = menuEvents:WaitForChild("OpenPractice", 10)
	local closePractice = menuEvents:WaitForChild("ClosePractice", 10)

	if openPractice then
		openPractice.Event:Connect(function()
			PracticeModeGUI.DisplayOrder = 601
			PracticeModeGUI.Enabled = true
		end)
	end

	if closePractice then
		closePractice.Event:Connect(function()
			resetAll()
			PracticeModeGUI.Enabled = false
		end)
	end
end)
PracticeModeGUI.Enabled = false
print("[PracticeClient] v10 Ready.")