local parent = script.Parent.Parent
local parent2 = script.Parent
local resizeWindow = parent:FindFirstChild("ResizeWindow")
local scrollingFrame = parent:FindFirstChild("ScrollingFrame")
local sheetBox = scrollingFrame:FindFirstChild("SheetBox")
local textSizePlus = parent:FindFirstChild("TextSizePlus")
local textSizeMinus = parent:FindFirstChild("TextSizeMinus")
local isResizing = parent:FindFirstChild("IsResizing")
local size = parent.Size
local size2 = scrollingFrame.Size
local position = scrollingFrame.Position
local anchorPoint = scrollingFrame.AnchorPoint
local position2 = resizeWindow.Position
local position3 = parent2.Position
local textSize = sheetBox.TextSize
local position4 = textSizePlus.Position
local position5 = textSizeMinus.Position
local clearTextOnFocus = sheetBox.ClearTextOnFocus
parent2.InputBegan:Connect(function(input)
	if
		(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
		and not isResizing.Value
	then
		parent.Size = size
		scrollingFrame.Size = size2
		scrollingFrame.Position = position
		scrollingFrame.AnchorPoint = anchorPoint
		resizeWindow.Position = position2
		parent2.Position = position3
		sheetBox.TextSize = textSize
		textSizePlus.Position = position4
		textSizeMinus.Position = position5
		sheetBox.ClearTextOnFocus = clearTextOnFocus
	end
end)