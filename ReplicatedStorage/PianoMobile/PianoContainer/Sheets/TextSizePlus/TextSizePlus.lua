local parent = script.Parent.Parent
local sheetBox = parent.ScrollingFrame:FindFirstChild("SheetBox")
local isResizing = parent:FindFirstChild("IsResizing")
script.Parent.InputBegan:Connect(function(input)
	if
		(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
		and not isResizing.Value
	then
		sheetBox.TextSize += 1
	end
end)