local parent = script.Parent.Parent
local parent2 = script.Parent
local resizeWindow = parent:FindFirstChild("ResizeWindow")
local scrollingFrame = parent:FindFirstChild("ScrollingFrame")
local sheetBox = scrollingFrame:FindFirstChild("SheetBox")
local textSizePlus = parent:FindFirstChild("TextSizePlus")
local textSizeMinus = parent:FindFirstChild("TextSizeMinus")
local size = parent.Size
local size2 = scrollingFrame.Size
local position = scrollingFrame.Position
local anchorPoint = scrollingFrame.AnchorPoint
local position2 = resizeWindow.Position
local position3 = parent2.Position
local textSize = sheetBox.TextSize
local position4 = textSizePlus.Position
local position5 = textSizeMinus.Position
parent2.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		parent.Size = size
		scrollingFrame.Size = size2
		scrollingFrame.Position = position
		scrollingFrame.AnchorPoint = anchorPoint
		resizeWindow.Position = position2
		parent2.Position = position3
		sheetBox.TextSize = textSize
		textSizePlus.Position = position4
		textSizeMinus.Position = position5
	end
end)