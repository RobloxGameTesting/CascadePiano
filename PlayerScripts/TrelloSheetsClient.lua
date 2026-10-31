local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("UserInputService")
local PlayerGui = Players.LocalPlayer.PlayerGui
ReplicatedStorage:WaitForChild("GetSheetsCategories", 30)
local RequestSheetsList = ReplicatedStorage:WaitForChild("RequestSheetsList", 30)
local ReceiveSheetsList = ReplicatedStorage:WaitForChild("ReceiveSheetsList", 30)
local RefreshSheets = ReplicatedStorage:WaitForChild("RefreshSheets", 30)
local GetSheetsIndex = ReplicatedStorage:WaitForChild("GetSheetsIndex", 30)

if not (RequestSheetsList and ReceiveSheetsList and GetSheetsIndex) then
	warn("[TrelloSheetsClient] Remotes not found")
	return
end

local TrelloSheetsUI = PlayerGui:WaitForChild("TrelloSheetsUI", 30)

if not TrelloSheetsUI then
	return
end

local v = {}
local v2 = nil
task.spawn(function()
	v2 = GetSheetsIndex:InvokeServer()
end)
local MainFrame = TrelloSheetsUI:WaitForChild("MainFrame")
local Header = MainFrame:WaitForChild("Header")
local BackButton = Header:WaitForChild("BackButton")
local Title = Header:WaitForChild("Title")
local SearchBox = Header:WaitForChild("SearchBox")
local Body = MainFrame:WaitForChild("Body")
local CategoriesPage = Body:WaitForChild("CategoriesPage")
local GamesPage = Body:WaitForChild("GamesPage")
local SongsPage = Body:WaitForChild("SongsPage")
local NotesPage = Body:WaitForChild("NotesPage")
local CatsScroll = CategoriesPage:WaitForChild("CatsScroll")
local GamesScroll = GamesPage:WaitForChild("GamesScroll")
local SongsScroll = SongsPage:WaitForChild("SongsScroll")
local VersionsBar = NotesPage:WaitForChild("VersionsBar")
local NotesScroll = NotesPage:WaitForChild("NotesScroll")
local NotesBox = NotesScroll:WaitForChild("NotesBox")
local Offset = NotesScroll.Size.Y.Offset
local v3 = Offset - 30
local ActionsBar = NotesPage:WaitForChild("ActionsBar")
local CategoryCard = CatsScroll:WaitForChild("CategoryCard")
local GameCard = GamesScroll:WaitForChild("GameCard")
local SongRow = SongsScroll:WaitForChild("SongRow")
local VersionButton = VersionsBar:WaitForChild("VersionButton")
local Row1 = ActionsBar:WaitForChild("Row1")
local Row2 = ActionsBar:WaitForChild("Row2")
local CopyNotes = Row1:WaitForChild("CopyNotes")
local ToSheets = Row1:WaitForChild("ToSheets")
local ToAutoPlayer = Row1:WaitForChild("ToAutoPlayer")
local ToPractice = Row2:WaitForChild("ToPractice")
local CopyTranspose = Row2:WaitForChild("CopyTranspose")
local UserInputService = game:GetService("UserInputService")
local TouchEnabled = UserInputService.TouchEnabled

if TouchEnabled then
	local UserInputService2 = game:GetService("UserInputService")
	TouchEnabled = not UserInputService2.KeyboardEnabled
end

if TouchEnabled then
	NotesBox.Focused:Connect(function()
		NotesBox:ReleaseFocus()
	end)
end

local function screenY() -- 3 equivalent calls inferred from this helper
	return workspace.CurrentCamera.ViewportSize.Y
end

local v4 = TouchEnabled and 160 or 270
local v5 = TouchEnabled and 48 or 44
local fn
local SheetsImages = ReplicatedStorage:FindFirstChild("SheetsImages")

local function getImage(childName, name)
	if not SheetsImages then
		return nil
	end

	local child = SheetsImages:FindFirstChild(childName)

	if not child then
		return nil
	end

	local child2 = child:FindFirstChild(name)

	if child2 and child2.Value ~= "" then
		return child2.Value
	end

	for _, child3 in ipairs(child:GetChildren()) do
		if
			(name:lower():find(child3.Name:lower(), 1, true) or child3.Name:lower():find(name:lower(), 1, true))
			and child3.Value ~= ""
		then
			return child3.Value
		end
	end

	return nil
end

local function getSheetBox() -- 1 equivalent call inferred from this helper
	local child = PlayerGui:FindFirstChild(TouchEnabled and "FulllScreenPianoMobileUI" or "FulllScreenPianoUI")
	return child
		and child:FindFirstChild("Sheets")
		and child.Sheets:FindFirstChild("ScrollingFrame")
		and child.Sheets.ScrollingFrame:FindFirstChild("SheetBox")
end

local function getMultiTransposeBox() -- 1 equivalent call inferred from this helper
	local multiTransposer = PlayerGui:FindFirstChild("MultiTransposer")

	if not multiTransposer then
		return nil
	end

	local mainFrame = multiTransposer:FindFirstChild("MainFrame")

	if mainFrame then
		return mainFrame:FindFirstChild("TranspositionsInput")
	end

	return nil
end

local function getAutoPlayerBox()
	local autoPlayer = PlayerGui:FindFirstChild("AutoPlayer")
	return autoPlayer
		and autoPlayer:FindFirstChild("Frame")
		and autoPlayer.Frame:FindFirstChild("NoteFrame")
		and autoPlayer.Frame.NoteFrame:FindFirstChild("ScrollingFrame")
		and autoPlayer.Frame.NoteFrame.ScrollingFrame:FindFirstChild("Notes")
end

local function getPracticeBox() -- 1 equivalent call inferred from this helper
	local practiceModeGUI = PlayerGui:FindFirstChild("PracticeModeGUI")
	return practiceModeGUI
		and practiceModeGUI:FindFirstChild("MainFrame")
		and practiceModeGUI.MainFrame:FindFirstChild("InputScrollFrame")
		and practiceModeGUI.MainFrame.InputScrollFrame:FindFirstChild("InputBox")
end

local function flash(p, text) -- 9 equivalent calls inferred from this helper
	local text2 = p.Text
	p.Text = text
	task.delay(1.5, function()
		p.Text = text2
	end)
end

local notes = nil
local transposeList = nil
local v6 = {}
local v7 = {}
local text2 = ""
local flag = false
local v8 = false
local v9 = {
	["Super Easy"] = Color3.fromRGB(100, 220, 100),
	Easy = Color3.fromRGB(150, 220, 80),
	Beginner = Color3.fromRGB(80, 180, 220),
	Intermediate = Color3.fromRGB(220, 180, 60),
	Hard = Color3.fromRGB(220, 80, 80)
}

local function showPage(p, value, p2, p3)
	CategoriesPage.Visible = false
	GamesPage.Visible = false
	SongsPage.Visible = false
	NotesPage.Visible = false
	p.Visible = true
	Title.Text = value or "🎹 Cascade Piano Sheets"
	BackButton.Visible = p2 or false
	Title.Position = p2 and UDim2.new(0, 52, 0, 0) or UDim2.new(0, 10, 0, 0)
	SearchBox.Visible = p3 or false

	if v6[#v6] ~= p then
		table.insert(v6, p)
	end

	if TouchEnabled then
		local v10 = v4 + v5 + 16
		local v11 = math.floor(screenY() * 0.76) -- inferred equivalent call
		local v12 = (p == CategoriesPage or p == GamesPage) and v10 or v11
		MainFrame.Size = UDim2.new(0.94, 0, 0, v12)
	else
		local offset = MainFrame.Size.X.Offset

		if p == CategoriesPage or p == GamesPage then
			MainFrame.Size = UDim2.new(0, offset, 0, offset > 600 and 314 or 224)
		else
			MainFrame.Size = UDim2.new(0, offset, 0, 560)
		end
	end
end

local function goBack()
	if #v6 <= 1 then
		return
	end

	table.remove(v6)
	local v10 = v6[#v6]
	CategoriesPage.Visible = false
	GamesPage.Visible = false
	SongsPage.Visible = false
	NotesPage.Visible = false
	v10.Visible = true

	if v10 == CategoriesPage then
		Title.Text = "🎹 Cascade Piano Sheets"
		BackButton.Visible = false
		Title.Position = UDim2.new(0, 10, 0, 0)
		SearchBox.Visible = true
		flag = true
		SearchBox.Text = ""
		flag = false
		MainFrame.Size = TouchEnabled and UDim2.new(0.94, 0, 0, v4 + v5 + 16)
			or UDim2.new(0, MainFrame.Size.X.Offset, 0, MainFrame.Size.X.Offset > 600 and 314 or 224)
	elseif v10 == GamesPage then
		Title.Text = "🎮 Games"
		BackButton.Visible = true
		SearchBox.Visible = false
		MainFrame.Size = TouchEnabled and UDim2.new(0.94, 0, 0, v4 + v5 + 16)
			or UDim2.new(0, MainFrame.Size.X.Offset, 0, MainFrame.Size.X.Offset > 600 and 314 or 224)
	elseif v10 == SongsPage then
		Title.Text = text2
		BackButton.Visible = true
		SearchBox.Visible = true
		MainFrame.Size = TouchEnabled and UDim2.new(0.94, 0, 0, (math.floor(screenY() * 0.76))) -- inferred equivalent call
			or UDim2.new(0, MainFrame.Size.X.Offset, 0, 560)
	elseif v10 == NotesPage then
		BackButton.Visible = true
		SearchBox.Visible = false
		MainFrame.Size = TouchEnabled and UDim2.new(0.94, 0, 0, (math.floor(screenY() * 0.76))) -- inferred equivalent call
			or UDim2.new(0, MainFrame.Size.X.Offset, 0, 560)
	end
end

BackButton.Activated:Connect(goBack)
Header:WaitForChild("CloseButton").Activated:Connect(function()
	local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
	local closeSheetsIcon = ReplicatedStorage2:FindFirstChild("CloseSheetsIcon")

	if closeSheetsIcon then
		closeSheetsIcon:Fire()
	else
		MainFrame.Visible = false
	end
end)
MainFrame:GetPropertyChangedSignal("Visible"):Connect(function()
	_G.FSPianoScrollBlocked = MainFrame.Visible
end)
local RefreshButton = Header:WaitForChild("RefreshButton")
RefreshButton.Activated:Connect(function()
	v = {}
	local v10 = v2
	v2 = nil

	for _, guiObject in ipairs(CatsScroll:GetChildren()) do
		if guiObject:IsA("GuiObject") and guiObject ~= CategoryCard then
			guiObject:Destroy()
		end
	end

	flag = true
	SearchBox.Text = ""
	flag = false
	v8 = false
	v6 = {}
	showPage(CategoriesPage, "🎹 Cascade Piano Sheets", false, true)
	RefreshButton.ImageColor3 = Color3.fromRGB(90, 130, 255)
	RefreshButton.ImageTransparency = 0.3
	task.spawn(function()
		v2 = GetSheetsIndex:InvokeServer() or v10
	end)
	RefreshSheets:FireServer()
end)
local function showNotes(p, value)
	local v10 = value or 1
	local version = p.versions[v10]
	notes = version.notes
	transposeList = version.transposeList

	for _, child in ipairs(VersionsBar:GetChildren()) do
		if child.Name == "VersionButton" then
			child:Destroy()
		end
	end

	if #p.versions > 1 then
		VersionsBar.Visible = true
		NotesScroll.Position = UDim2.new(0, 0, 0, 30)
		NotesScroll.Size = UDim2.new(1, 0, 0, v3)
	else
		VersionsBar.Visible = false
		NotesScroll.Position = UDim2.new(0, 0, 0, 0)
		NotesScroll.Size = UDim2.new(1, 0, 0, Offset)
	end

	for i, version2 in ipairs(p.versions) do
		local clone = VersionButton:Clone()
		clone.Text = version2.label
		clone.Visible = true
		clone.BackgroundColor3 = i == v10 and Color3.fromRGB(60, 100, 190) or Color3.fromRGB(28, 28, 45)
		clone.Parent = VersionsBar
		local v11 = i
		clone.Activated:Connect(function()
			showNotes(p, v11)
		end)
	end

	NotesBox.Text = version.notes
	CopyTranspose.Visible = version.isMultiTransposed == true and version.transposeList ~= nil
	showPage(NotesPage, p.name, true, false)
end

local count = 0
local v10 = false

local function buildSongs(p, list, p2, p3)
	v10 = p3 or false
	v7 = list

	if not p2 then
		text2 = p
	end

	for _, child in ipairs(SongsScroll:GetChildren()) do
		if child.Name:sub(1, 8) == "SongRow_" then
			child:Destroy()
		end
	end

	if p2 then
		CategoriesPage.Visible = false
		GamesPage.Visible = false
		SongsPage.Visible = true
		NotesPage.Visible = false
		BackButton.Visible = true
		SearchBox.Visible = true
	else
		showPage(SongsPage, p, true, true)
	end

	local text = SearchBox.Text:lower()
	local v11 = {}

	for _, v12 in ipairs(list) do
		if not (text == "" or v12.name:lower():find(text, 1, true)) then
			continue
		end

		table.insert(v11, v12)
	end

	count += 1
	local v12 = count
	local total = 1
	task.spawn(function()
		while total <= #v11 do
			if count ~= v12 then
				break
			end

			for i = total, math.min(total + 20 - 1, #v11) do
				local v13 = v11[i]
				local clone = SongRow:Clone()
				clone.Name = "SongRow_" .. v13.name .. "_" .. i
				clone.Visible = true
				local songName = clone:FindFirstChild("SongName")

				if songName then
					songName.Text = v13.name
				end

				local difficulty = clone:FindFirstChild("Difficulty")

				if difficulty then
					local text3 = ""

					for _, label in ipairs(v13.labels) do
						if not (label ~= "Simplified" and label ~= "MultiTransposed") then
							continue
						end

						text3 = label
						break
					end

					if text3 == "" then
						text3 = v13.labels[1] or ""
					end

					difficulty.Text = text3
					difficulty.TextColor3 = v9[text3] or Color3.fromRGB(180, 140, 255)
				end

				local multiIcon = clone:FindFirstChild("MultiIcon")

				if multiIcon then
					local flag2 = false
					local v14 = false

					for _, v15 in ipairs(v13.versions or {}) do
						v14 = v15.label == "Simplified" or v15.label == "Unsimplified" or v14

						if v15.isMultiTransposed then
							flag2 = true
						end
					end

					if flag2 and v14 then
						multiIcon.Text = "MT+S"
						multiIcon.Visible = true
					elseif flag2 then
						multiIcon.Text = "MT"
						multiIcon.Visible = true
					elseif v14 then
						multiIcon.Text = "S"
						multiIcon.Visible = true
					elseif v13.versions and #v13.versions > 1 then
						multiIcon.Text = "⊕"
						multiIcon.Visible = true
					else
						multiIcon.Visible = false
					end
				end

				clone.Parent = SongsScroll
				local flag2 = false
				clone.Activated:Connect(function()
					if flag2 then
						return
					end

					flag2 = true

					if p3 and v13.versions == nil then
						print("[SEARCH] Loading listId=" .. tostring(v13.listId) .. " name=" .. tostring(v13.name) .. " isGames=" .. tostring(v13.isGames))
						fn(v13.listId, v13.isGames, function(p4)
							print("[SEARCH] data=", p4, "songs=", not p4 and "nil" or #(p4.songs or {}) or "nil")
							local songs = p4.songs

							if v13.isGames and p4.subcategories then
								songs = {}

								for _, subcategory in ipairs(p4.subcategories) do
									for _, song in ipairs(subcategory.songs) do
										table.insert(songs, song)
									end
								end
							end

							for _, v14 in ipairs(songs or {}) do
								if v14.name ~= v13.name then
									continue
								end

								showNotes(v14, 1)
								flag2 = false
								return
							end

							flag2 = false
						end)
					else
						if v13.versions ~= nil then
							showNotes(v13, 1)
						end

						flag2 = false
					end
				end)
			end

			total += 20
			task.wait()
		end
	end)
end

local function onSearchChanged()
	if flag then
		return
	end

	local text = SearchBox.Text

	if CategoriesPage.Visible then
		if text == "" then
			return
		end

		local lower = text:lower()

		if v2 then
			local v11 = {}

			for _, v12 in ipairs(v2) do
				if v12.name:lower():find(lower, 1, true) then
					table.insert(v11, v12)
				end
			end

			if #v11 == 0 then
				v6 = { CategoriesPage }
				buildSongs("Search results", {}, nil, true)
			else
				local v12 = {}

				for _, v13 in ipairs(v11) do
					table.insert(v12, {
						name = v13.name,
						labels = v13.labels,
						listId = v13.listId,
						isGames = v13.isGames,
						versions = nil
					})
				end

				v6 = { CategoriesPage }
				buildSongs("Search results", v12, nil, true)
			end
		else
			Title.Text = "🎹 Cascade Piano Sheets  ⏳"
			task.spawn(function()
				while not v2 do
					task.wait(0.2)
				end

				Title.Text = "🎹 Cascade Piano Sheets"

				if SearchBox.Text == text then
					onSearchChanged()
				end
			end)
		end
	elseif SongsPage.Visible then
		buildSongs(text2, v7, true, v10)
	end
end

SearchBox:GetPropertyChangedSignal("Text"):Connect(onSearchChanged)
local UserInputService2 = game:GetService("UserInputService")
UserInputService2.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Keyboard and SearchBox:IsFocused() then
		task.defer(onSearchChanged)
	end
end)
SearchBox.FocusLost:Connect(function()
	task.defer(onSearchChanged)
end)
local v11 = {}
ReceiveSheetsList.OnClientEvent:Connect(function(p, p2)
	if p2 then
		v[p] = p2
	end

	local v12 = v11[p]

	if v12 then
		v11[p] = nil

		for _, callback in ipairs(v12) do
			task.spawn(callback, p2)
		end
	end
end)

fn = function(p, p2, fn2)
	if v[p] then
		task.spawn(fn2, v[p])
		return
	end

	if not v11[p] then
		v11[p] = {}
		RequestSheetsList:FireServer(p, p2)
	end

	table.insert(v11[p], fn2)
end

local function buildGames(p)
	fn(p, true, function(p2)
		for _, child in ipairs(GamesScroll:GetChildren()) do
			if child.Name:sub(1, 9) == "GameCard_" then
				child:Destroy()
			end
		end

		for _, subcategory in ipairs(p2.subcategories) do
			local clone = GameCard:Clone()
			clone.Name = "GameCard_" .. subcategory.name
			clone.Visible = true
			local imageLabel = clone:FindFirstChildWhichIsA("ImageLabel")

			if imageLabel then
				imageLabel.Image = getImage("Games", subcategory.name) or ""
			end

			local gameName = clone:FindFirstChild("GameName", true)

			if gameName then
				gameName.Text = subcategory.name
			end

			local songCount = clone:FindFirstChild("SongCount", true)

			if songCount then
				songCount.Text = #subcategory.songs .. " Sheets"
			end

			clone.Parent = GamesScroll
			local v12 = subcategory
			clone.Activated:Connect(function()
				showPage(SongsPage, "⏳ Loading...", true, false)
				buildSongs(v12.name, v12.songs, false, false)
			end)
		end

		Title.Text = "🎮 Games"
	end)
end

local function buildCategories(list)
	for _, guiObject in ipairs(CatsScroll:GetChildren()) do
		if guiObject.Name ~= "CategoryCard" and guiObject:IsA("GuiObject") then
			guiObject:Destroy()
		end
	end

	for i, v12 in ipairs(list) do
		local clone = CategoryCard:Clone()
		clone.Name = "CategoryCard_" .. i
		clone.Visible = true
		local imageLabel = clone:FindFirstChildWhichIsA("ImageLabel")

		if imageLabel then
			imageLabel.Image = getImage("Categories", v12.name) or ""
		end

		local categoryName = clone:FindFirstChild("CategoryName", true)

		if categoryName then
			categoryName.Text = v12.name
		end

		local songCount = clone:FindFirstChild("SongCount", true)
		clone.Parent = CatsScroll

		if songCount then
			if v2 then
				local count2 = 0

				for _, v13 in ipairs(v2) do
					if v13.listId == v12.id then
						count2 += 1
					end
				end

				songCount.Text = count2 .. " Sheets"
			else
				songCount.Text = "..."
				local v13 = v12
				task.spawn(function()
					while not v2 do
						task.wait(0.2)
					end

					if not (songCount and songCount.Parent) then
						return
					end

					local count2 = 0

					for _, v14 in ipairs(v2) do
						if v14.listId == v13.id then
							count2 += 1
						end
					end

					songCount.Text = count2 .. " Sheets"
				end)
			end
		end

		local v13 = v12
		clone.Activated:Connect(function()
			if v13.isGames then
				showPage(GamesPage, "⏳ Loading...", true, false)
				local id = v13.id
				fn(id, true, function(p)
					for _, child in ipairs(GamesScroll:GetChildren()) do
						if child.Name:sub(1, 9) == "GameCard_" then
							child:Destroy()
						end
					end

					for _, subcategory in ipairs(p.subcategories) do
						local clone2 = GameCard:Clone()
						clone2.Name = "GameCard_" .. subcategory.name
						clone2.Visible = true
						local imageLabel2 = clone2:FindFirstChildWhichIsA("ImageLabel")

						if imageLabel2 then
							imageLabel2.Image = getImage("Games", subcategory.name) or ""
						end

						local gameName = clone2:FindFirstChild("GameName", true)

						if gameName then
							gameName.Text = subcategory.name
						end

						local songCount2 = clone2:FindFirstChild("SongCount", true)

						if songCount2 then
							songCount2.Text = #subcategory.songs .. " Sheets"
						end

						clone2.Parent = GamesScroll
						local v14 = subcategory
						clone2.Activated:Connect(function()
							showPage(SongsPage, "⏳ Loading...", true, false)
							buildSongs(v14.name, v14.songs, false, false)
						end)
					end

					Title.Text = "🎮 Games"
				end)
			else
				showPage(SongsPage, "⏳ Loading " .. v13.name .. "...", true, false)

				for _, child in ipairs(SongsScroll:GetChildren()) do
					if child.Name:sub(1, 8) == "SongRow_" then
						child:Destroy()
					end
				end

				fn(v13.id, false, function(p)
					buildSongs(v13.name, p.songs, false, false)
				end)
			end
		end)
	end

	v6 = {}
	showPage(CategoriesPage, "🎹 Cascade Piano Sheets", false, true)
	print("[BUILD] Done, total children: " .. #CatsScroll:GetChildren())
end

CopyNotes.Activated:Connect(function()
	if not notes then
		return
	end

	NotesBox:CaptureFocus()
	NotesBox.SelectionStart = 1
	NotesBox.CursorPosition = #NotesBox.Text + 1
	flash(CopyNotes, "✓ Copied!") -- inferred equivalent call
end)
ToSheets.Activated:Connect(function()
	local sheetBox = getSheetBox() -- inferred equivalent call

	if sheetBox and notes then
		sheetBox.Text = notes
		flash(ToSheets, "✓ Done!") -- inferred equivalent call
	else
		flash(ToSheets, "✗ Closed") -- inferred equivalent call
	end
end)
ToAutoPlayer.Activated:Connect(function()
	local autoPlayerBox = getAutoPlayerBox()

	if autoPlayerBox and notes then
		autoPlayerBox.Text = notes
		flash(ToAutoPlayer, "✓ Done!") -- inferred equivalent call
	else
		flash(ToAutoPlayer, "✗ Closed") -- inferred equivalent call
	end
end)
ToPractice.Activated:Connect(function()
	local practiceBox = getPracticeBox() -- inferred equivalent call

	if practiceBox and notes then
		practiceBox.Text = notes
		flash(ToPractice, "✓ Done!") -- inferred equivalent call
	else
		flash(ToPractice, "✗ Closed") -- inferred equivalent call
	end
end)
CopyTranspose.Activated:Connect(function()
	if not transposeList then
		return
	end

	local multiTransposeBox = getMultiTransposeBox() -- inferred equivalent call

	if multiTransposeBox then
		multiTransposeBox.Text = transposeList
		flash(CopyTranspose, "✓ → MultiTransposer!") -- inferred equivalent call
	else
		NotesBox.Text = transposeList
		NotesBox:CaptureFocus()
		NotesBox.SelectionStart = 1
		NotesBox.CursorPosition = #NotesBox.Text + 1
		flash(CopyTranspose, "✗ Open MultiTransposer!") -- inferred equivalent call
	end
end)
local v12 = false
ReplicatedStorage:WaitForChild("CategoriesReady", 30).OnClientEvent:Connect(function(p)
	if not p then
		return
	end

	task.spawn(function()
		local total = 0

		while not v2 and total < 5 do
			task.wait(0.1)
			total += 0.1
		end

		for _, guiObject in ipairs(CatsScroll:GetChildren()) do
			if guiObject:IsA("GuiObject") and guiObject ~= CategoryCard then
				guiObject:Destroy()
			end
		end

		v6 = {}
		showPage(CategoriesPage, "🎹 Cascade Piano Sheets", false, true)
		v12 = true
		buildCategories(p)
		CatsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
		RefreshButton.ImageColor3 = Color3.fromRGB(130, 130, 155)
		RefreshButton.ImageTransparency = 0
	end)
end)