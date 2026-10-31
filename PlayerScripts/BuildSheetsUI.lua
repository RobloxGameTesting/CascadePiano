local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer.PlayerGui
local TrelloSheetsUI = PlayerGui:WaitForChild("TrelloSheetsUI")

if TrelloSheetsUI:FindFirstChild("MainFrame") then
	return
end

local UserInputService = game:GetService("UserInputService")
local TouchEnabled = UserInputService.TouchEnabled

if TouchEnabled then
	local UserInputService2 = game:GetService("UserInputService")
	TouchEnabled = not UserInputService2.KeyboardEnabled
end

local x = workspace.CurrentCamera.ViewportSize.X
local y = workspace.CurrentCamera.ViewportSize.Y
local v, v2, v3, v4, v5

if TouchEnabled then
	v = math.floor(y * 0.76)
	v2 = math.floor(x * 0.94)
	v3 = 160
	v4 = 48
	v5 = 130
else
	v3 = 270
	v4 = 44
	v5 = 220
	v = 560
	v2 = 900
end

local v6 = (TouchEnabled and v3 + 8 or v3 + 24) + v4
local _ = v6 - v4
local v7 = {
	bg = Color3.fromRGB(10, 10, 18),
	bgPanel = Color3.fromRGB(16, 16, 28),
	bgCard = Color3.fromRGB(22, 22, 38),
	bgCardHov = Color3.fromRGB(32, 32, 52),
	bgSel = Color3.fromRGB(35, 55, 110),
	accent = Color3.fromRGB(90, 130, 255),
	accentDim = Color3.fromRGB(50, 70, 160),
	text = Color3.fromRGB(220, 220, 235),
	textDim = Color3.fromRGB(120, 120, 145),
	border = Color3.fromRGB(38, 38, 62),
	btnGreen = Color3.fromRGB(45, 155, 85),
	btnBlue = Color3.fromRGB(45, 105, 195),
	btnPurple = Color3.fromRGB(105, 55, 195),
	btnOrange = Color3.fromRGB(195, 115, 35),
	btnGray = Color3.fromRGB(38, 38, 55)
}

local function make(className, items, parent) -- 53 equivalent calls inferred from this helper
	local instance = Instance.new(className)

	for k, item in pairs(items) do
		instance[k] = item
	end

	if parent then
		instance.Parent = parent
	end

	return instance
end

local function corner(p, parent) -- 15 equivalent calls inferred from this helper
	make("UICorner", { CornerRadius = UDim.new(0, p) }, parent) -- inferred equivalent call
end

local function stroke(thickness, p, parent) -- 5 equivalent calls inferred from this helper
	make("UIStroke", { -- inferred equivalent call
		Thickness = thickness,
		Color = p or v7.border,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	}, parent)
end

local function padding(p, p2, p3, p4, parent)
	make( -- inferred equivalent call
		"UIPadding",
		{
			PaddingTop = UDim.new(0, p),
			PaddingBottom = UDim.new(0, p2),
			PaddingLeft = UDim.new(0, p3),
			PaddingRight = UDim.new(0, p4)
		},
		parent
	)
end

local parent2 = make("Frame", { -- inferred equivalent call
	Name = "MainFrame",
	Size = TouchEnabled and UDim2.new(0.94, 0, 0, v6) or UDim2.new(0, v2, 0, v6),
	Position = TouchEnabled and UDim2.new(0.03, 0, 0.12, 0) or UDim2.new(0.5, 0, 0.45, 0),
	AnchorPoint = TouchEnabled and Vector2.new(0, 0) or Vector2.new(0.5, 0.5),
	BackgroundColor3 = v7.bg,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Visible = false
}, TrelloSheetsUI)
corner(14, parent2) -- inferred equivalent call
stroke(1.5, v7.border, parent2) -- inferred equivalent call
local parent3 = make("Frame", { -- inferred equivalent call
	Name = "Header",
	Size = UDim2.new(1, 0, 0, v4),
	BackgroundColor3 = v7.bgPanel,
	BorderSizePixel = 0,
	ClipsDescendants = false
}, parent2)
corner(14, parent3) -- inferred equivalent call
make( -- inferred equivalent call
	"Frame",
	{
		Size = UDim2.new(1, 0, 0, 2),
		Position = UDim2.new(0, 0, 1, -2),
		BackgroundColor3 = v7.accent,
		BorderSizePixel = 0
	},
	parent3
)
corner(8, make("TextButton", { -- inferred equivalent call
	Name = "BackButton",
	Size = UDim2.new(0, 36, 0, 36),
	Position = UDim2.new(0, 6, 0.5, 0),
	AnchorPoint = Vector2.new(0, 0.5),
	BackgroundColor3 = v7.bgCard,
	Text = "‹",
	TextColor3 = v7.text,
	TextSize = 22,
	Font = Enum.Font.GothamBold,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Visible = false
}, parent3))
make("ImageButton", { -- inferred equivalent call
	Name = "RefreshButton",
	Size = TouchEnabled and UDim2.new(0, 44, 0, 44) or UDim2.new(0, 28, 0, 28),
	Position = TouchEnabled and UDim2.new(1, -92, 0.5, 0) or UDim2.new(1, -68, 0.5, 0),
	AnchorPoint = Vector2.new(0, 0.5),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Image = "rbxassetid://11570018242",
	ImageColor3 = v7.textDim
}, parent3)
make("TextButton", { -- inferred equivalent call
	Name = "CloseButton",
	Size = TouchEnabled and UDim2.new(0, 44, 0, 44) or UDim2.new(0, 28, 0, 28),
	Position = TouchEnabled and UDim2.new(1, -46, 0.5, 0) or UDim2.new(1, -34, 0.5, 0),
	AnchorPoint = Vector2.new(0, 0.5),
	BackgroundTransparency = 1,
	Text = "X",
	TextColor3 = v7.textDim,
	TextSize = TouchEnabled and 20 or 18,
	Font = Enum.Font.GothamBold,
	BorderSizePixel = 0,
	AutoButtonColor = false
}, parent3)
make("TextLabel", { -- inferred equivalent call
	Name = "Title",
	Size = UDim2.new(1, -160, 1, 0),
	Position = UDim2.new(0, 10, 0, 0),
	BackgroundTransparency = 1,
	Text = "🎹 Cascade Piano Sheets",
	TextColor3 = v7.text,
	TextSize = TouchEnabled and 14 or 16,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd
}, parent3)
local parent4 = make("TextBox", { -- inferred equivalent call
	Name = "SearchBox",
	Size = UDim2.new(0, TouchEnabled and 200 or 300, 0, 28),
	Position = UDim2.new(0.5, 0, 0.5, 0),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = v7.bgCard,
	Text = "",
	PlaceholderText = "🔍 Search...",
	PlaceholderColor3 = v7.textDim,
	TextColor3 = v7.text,
	TextSize = TouchEnabled and 11 or 12,
	Font = Enum.Font.Gotham,
	BorderSizePixel = 0,
	ClearTextOnFocus = false,
	Visible = false
}, parent3)
corner(8, parent4) -- inferred equivalent call
padding(0, 0, 8, 8, parent4)
local parent5 = make("Frame", { -- inferred equivalent call
	Name = "Body",
	Size = UDim2.new(1, 0, 1, -v4),
	Position = UDim2.new(0, 0, 0, v4),
	BackgroundTransparency = 1,
	BorderSizePixel = 0
}, parent2)
local parent6 = make( -- inferred equivalent call
	"Frame",
	{
		Name = "CategoriesPage",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Visible = false
	},
	parent5
)
local parent7 = make("ScrollingFrame", { -- inferred equivalent call
	Name = "CatsScroll",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = v7.accent,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.X,
	ScrollingDirection = Enum.ScrollingDirection.X
}, parent6)
padding(8, 8, 10, 10, parent7)
make( -- inferred equivalent call
	"UIListLayout",
	{
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Top
	},
	parent7
)
local parent8 = make("ImageButton", { -- inferred equivalent call
	Name = "CategoryCard",
	Size = UDim2.new(0, v5, 0, v3),
	BackgroundColor3 = v7.bgCard,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Visible = false
}, parent7)
corner(10, parent8) -- inferred equivalent call
stroke(1, v7.border, parent8) -- inferred equivalent call
local parent9 = make("ImageLabel", { -- inferred equivalent call
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScaleType = Enum.ScaleType.Crop,
	Image = ""
}, parent8)
corner(10, parent9) -- inferred equivalent call
make("UIGradient", { -- inferred equivalent call
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.3),
		NumberSequenceKeypoint.new(1, 0)
	}),
	Rotation = 90
}, parent9)
local parent10 = make("Frame", { -- inferred equivalent call
	Size = UDim2.new(1, 0, 0, 52),
	Position = UDim2.new(0, 0, 1, -52),
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 0,
	ZIndex = 3
}, parent8)
make("UIGradient", { -- inferred equivalent call
	Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1) }),
	Rotation = 270
}, parent10)
corner(10, parent10) -- inferred equivalent call
padding(6, 6, 8, 6, parent10)
make( -- inferred equivalent call
	"UIListLayout",
	{
		Padding = UDim.new(0, 2),
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	},
	parent10
)
make("TextLabel", { -- inferred equivalent call
	Name = "CategoryName",
	Size = UDim2.new(1, 0, 0, TouchEnabled and 14 or 16),
	BackgroundTransparency = 1,
	Text = "Category",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = TouchEnabled and 11 or 13,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd,
	TextWrapped = false,
	ZIndex = 3
}, parent10)
make("TextLabel", { -- inferred equivalent call
	Name = "SongCount",
	Size = UDim2.new(1, 0, 0, TouchEnabled and 13 or 14),
	BackgroundTransparency = 1,
	Text = "0 Sheets",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = TouchEnabled and 10 or 11,
	Font = Enum.Font.Gotham,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 3
}, parent10)
local parent11 = make( -- inferred equivalent call
	"Frame",
	{
		Name = "GamesPage",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Visible = false
	},
	parent5
)
local parent12 = make("ScrollingFrame", { -- inferred equivalent call
	Name = "GamesScroll",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = v7.accent,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.X,
	ScrollingDirection = Enum.ScrollingDirection.X
}, parent11)
padding(8, 8, 10, 10, parent12)
make( -- inferred equivalent call
	"UIListLayout",
	{
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Top
	},
	parent12
)
local parent13 = make("ImageButton", { -- inferred equivalent call
	Name = "GameCard",
	Size = UDim2.new(0, v5, 0, v3),
	BackgroundColor3 = v7.bgCard,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Visible = false
}, parent12)
corner(10, parent13) -- inferred equivalent call
stroke(1, v7.border, parent13) -- inferred equivalent call
local parent14 = make("ImageLabel", { -- inferred equivalent call
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScaleType = Enum.ScaleType.Crop,
	Image = ""
}, parent13)
corner(10, parent14) -- inferred equivalent call
make("UIGradient", { -- inferred equivalent call
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.3),
		NumberSequenceKeypoint.new(1, 0)
	}),
	Rotation = 90
}, parent14)
local parent15 = make("Frame", { -- inferred equivalent call
	Size = UDim2.new(1, 0, 0, 52),
	Position = UDim2.new(0, 0, 1, -52),
	BackgroundColor3 = Color3.new(0, 0, 0),
	BackgroundTransparency = 0,
	ZIndex = 3
}, parent13)
make("UIGradient", { -- inferred equivalent call
	Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1) }),
	Rotation = 270
}, parent15)
corner(10, parent15) -- inferred equivalent call
padding(6, 6, 8, 6, parent15)
make( -- inferred equivalent call
	"UIListLayout",
	{
		Padding = UDim.new(0, 2),
		FillDirection = Enum.FillDirection.Vertical,
		SortOrder = Enum.SortOrder.LayoutOrder
	},
	parent15
)
make("TextLabel", { -- inferred equivalent call
	Name = "GameName",
	Size = UDim2.new(1, 0, 0, TouchEnabled and 14 or 16),
	BackgroundTransparency = 1,
	Text = "Game",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = TouchEnabled and 11 or 13,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd,
	ZIndex = 3
}, parent15)
make("TextLabel", { -- inferred equivalent call
	Name = "SongCount",
	Size = UDim2.new(1, 0, 0, TouchEnabled and 13 or 14),
	BackgroundTransparency = 1,
	Text = "0 Sheets",
	TextColor3 = Color3.fromRGB(180, 180, 180),
	TextSize = TouchEnabled and 10 or 11,
	Font = Enum.Font.Gotham,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 3
}, parent15)
local parent16 = make( -- inferred equivalent call
	"Frame",
	{
		Name = "SongsPage",
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Visible = false
	},
	parent5
)
local parent17 = make("ScrollingFrame", { -- inferred equivalent call
	Name = "SongsScroll",
	Size = UDim2.new(1, 0, 1, 0),
	ClipsDescendants = true,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = v7.accent,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y
}, parent16)
padding(4, 4, 6, 6, parent17)
make( -- inferred equivalent call
	"UIListLayout",
	{
		Padding = UDim.new(0, 3),
		SortOrder = Enum.SortOrder.LayoutOrder,
		FillDirection = Enum.FillDirection.Vertical
	},
	parent17
)
local parent18 = make("TextButton", { -- inferred equivalent call
	Name = "SongRow",
	Size = UDim2.new(1, 0, 0, TouchEnabled and 34 or 30),
	BackgroundColor3 = v7.bgCard,
	BorderSizePixel = 0,
	Text = "",
	AutoButtonColor = false,
	Visible = false
}, parent17)
corner(6, parent18) -- inferred equivalent call
padding(0, 0, 10, 10, parent18)
make("TextLabel", { -- inferred equivalent call
	Name = "SongName",
	Size = UDim2.new(0.65, 0, 1, 0),
	BackgroundTransparency = 1,
	Text = "Song Name",
	TextColor3 = v7.text,
	TextSize = TouchEnabled and 12 or 13,
	Font = Enum.Font.Gotham,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextTruncate = Enum.TextTruncate.AtEnd
}, parent18)
make("TextLabel", { -- inferred equivalent call
	Name = "Difficulty",
	Size = UDim2.new(0.27, 0, 1, 0),
	Position = UDim2.new(0.65, 0, 0, 0),
	BackgroundTransparency = 1,
	Text = "",
	TextColor3 = v7.textDim,
	TextSize = TouchEnabled and 10 or 11,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Center
}, parent18)
corner(4, make("TextLabel", { -- inferred equivalent call
	Name = "MultiIcon",
	Size = UDim2.new(0, 60, 0, 18),
	Position = UDim2.new(1, -64, 0.5, 0),
	AnchorPoint = Vector2.new(0, 0.5),
	BackgroundColor3 = v7.accentDim,
	BackgroundTransparency = 0,
	Text = "MT",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = 10,
	Font = Enum.Font.GothamBold,
	TextXAlignment = Enum.TextXAlignment.Center,
	Visible = false,
	BorderSizePixel = 0
}, parent18))
local parent19 = make("Frame", { -- inferred equivalent call
	Name = "NotesPage",
	Size = UDim2.new(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Visible = false,
	ClipsDescendants = false
}, parent5)
local parent20 = make("ScrollingFrame", { -- inferred equivalent call
	Name = "VersionsBar",
	Size = UDim2.new(1, 0, 0, 30),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 0,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.X,
	ScrollingDirection = Enum.ScrollingDirection.X,
	Visible = false
}, parent19)
padding(3, 3, 6, 6, parent20)
make( -- inferred equivalent call
	"UIListLayout",
	{
		Padding = UDim.new(0, 4),
		FillDirection = Enum.FillDirection.Horizontal,
		SortOrder = Enum.SortOrder.LayoutOrder
	},
	parent20
)
local parent21 = make("TextButton", { -- inferred equivalent call
	Name = "VersionButton",
	Size = UDim2.new(0, 120, 1, -6),
	BackgroundColor3 = v7.bgCard,
	Text = "Version",
	TextColor3 = v7.text,
	TextSize = TouchEnabled and 10 or 11,
	Font = Enum.Font.GothamBold,
	BorderSizePixel = 0,
	AutoButtonColor = false,
	Visible = false
}, parent20)
corner(6, parent21) -- inferred equivalent call
stroke(1, v7.accent, parent21) -- inferred equivalent call
local v8 = v - v4 - 30 - (TouchEnabled and 100 or 90) - 8
local parent22 = make("ScrollingFrame", { -- inferred equivalent call
	Name = "NotesScroll",
	Size = UDim2.new(1, 0, 0, v8 + 30),
	Position = UDim2.new(0, 0, 0, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 3,
	ScrollBarImageColor3 = v7.accent,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y
}, parent19)
padding(4, 4, 6, 6, parent22)
local parent23 = make("TextBox", { -- inferred equivalent call
	Name = "NotesBox",
	Size = UDim2.new(1, 0, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundColor3 = v7.bgPanel,
	Text = "",
	PlaceholderText = "← Select a song",
	PlaceholderColor3 = v7.textDim,
	TextColor3 = v7.text,
	TextSize = TouchEnabled and 13 or 12,
	Font = Enum.Font.Code,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Top,
	MultiLine = true,
	ClearTextOnFocus = false,
	BorderSizePixel = 0,
	TextEditable = false
}, parent22)
corner(6, parent23) -- inferred equivalent call
padding(6, 6, 6, 6, parent23)
local v9 = TouchEnabled and 100 or 90
local parent24 = make("Frame", { -- inferred equivalent call
	Name = "ActionsBar",
	Size = UDim2.new(1, 0, 0, v9),
	Position = UDim2.new(0, 0, 1, -v9),
	BackgroundColor3 = v7.bgPanel,
	BorderSizePixel = 0
}, parent19)
stroke(1, v7.border, parent24) -- inferred equivalent call
padding(6, 6, 6, 6, parent24)

local function makeBtn(name, text, backgroundColor, parent, p)
	local parent25 = make("TextButton", { -- inferred equivalent call
		Name = name,
		BackgroundColor3 = backgroundColor,
		Text = text,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		BorderSizePixel = 0,
		AutoButtonColor = false,
		Size = p and UDim2.new(0.5, -3, 0, TouchEnabled and 36 or 34) or UDim2.new(0.333, -3, 0, TouchEnabled and 36 or 34)
	}, parent)
	corner(8, parent25) -- inferred equivalent call
	return parent25
end

local parent = make("Frame", { -- inferred equivalent call
	Name = "Row1",
	Size = UDim2.new(1, 0, 0, TouchEnabled and 36 or 34),
	BackgroundTransparency = 1,
	BorderSizePixel = 0
}, parent24)
make( -- inferred equivalent call
	"UIListLayout",
	{
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder
	},
	parent
)
makeBtn("CopyNotes", "📋  Copy", v7.btnBlue, parent, false)
makeBtn("ToSheets", "📄  → Sheets", v7.btnGreen, parent, false)
makeBtn("ToAutoPlayer", "▶  → AutoPlayer", v7.btnPurple, parent, false)
local parent25 = make("Frame", { -- inferred equivalent call
	Name = "Row2",
	Size = UDim2.new(1, 0, 0, TouchEnabled and 36 or 34),
	Position = UDim2.new(0, 0, 0, (TouchEnabled and 36 or 34) + 6),
	BackgroundTransparency = 1,
	BorderSizePixel = 0
}, parent24)
make( -- inferred equivalent call
	"UIListLayout",
	{
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 5),
		SortOrder = Enum.SortOrder.LayoutOrder
	},
	parent25
)
makeBtn("ToPractice", "🎯  → Practice", v7.btnOrange, parent25, true)
makeBtn("CopyTranspose", "⚙  → MultiTransposer", v7.accentDim, parent25, true)
local trelloSheetsUI = PlayerGui:WaitForChild("TrelloSheetsUI")
trelloSheetsUI.DisplayOrder = 600
print("[Sheets] isMobile=" .. tostring(TouchEnabled) .. " screenX=" .. x .. " screenY=" .. y .. " W=" .. v2 .. " H=" .. v6 .. " SONGS_H=" .. v)
print("[BuildSheetsUI] UI built successfully")