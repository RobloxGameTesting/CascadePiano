local UserInputService = game:GetService("UserInputService")
local parent = script.Parent.Parent
local parent2 = script.Parent
local resetWindow = parent:FindFirstChild("ResetWindow")
local scrollingFrame = parent:FindFirstChild("ScrollingFrame")
local sheetBox = scrollingFrame:FindFirstChild("SheetBox")
local textSizePlus = parent:FindFirstChild("TextSizePlus")
local textSizeMinus = parent:FindFirstChild("TextSizeMinus")
local isResizing = parent:FindFirstChild("IsResizing")
parent:FindFirstChild("IsDragging")
local v = false
local position = nil
local size = nil
local v2 = nil
local v3 = nil
local v4 = nil
local v5 = nil
local v6 = textSizePlus.AbsolutePosition.Y - parent.AbsolutePosition.Y
local v7 = textSizeMinus.AbsolutePosition.Y - parent.AbsolutePosition.Y
local v8 = parent.AbsoluteSize.Y - (resetWindow.AbsolutePosition.Y - parent.AbsolutePosition.Y)
local v9 = parent.AbsoluteSize.Y - (parent2.AbsolutePosition.Y - parent.AbsolutePosition.Y)
local vector = Vector2.new(200, v7 + textSizeMinus.AbsoluteSize.Y + v8 + 20)
parent2.Active = true
game:GetService("RunService")
parent2.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		isResizing.Value = true
		task.wait(0.05)
		v = true
		position = input.Position
		size = parent.Size
		scrollingFrame.ScrollingEnabled = false
		sheetBox.TextEditable = false
		sheetBox.ClearTextOnFocus = false
		sheetBox:ReleaseFocus()
		local absoluteSize = parent.AbsoluteSize
		local absoluteSize2 = scrollingFrame.AbsoluteSize
		local absolutePosition = scrollingFrame.AbsolutePosition
		local absolutePosition2 = parent.AbsolutePosition
		v2 = absolutePosition.X - absolutePosition2.X
		v4 = absolutePosition.Y - absolutePosition2.Y
		v3 = absoluteSize.X - (absolutePosition.X - absolutePosition2.X + absoluteSize2.X)
		v5 = absoluteSize.Y - (absolutePosition.Y - absolutePosition2.Y + absoluteSize2.Y)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if
		v
		and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch)
	then
		local v10 = input.Position - position
		local v11 = math.max(vector.X, size.X.Offset + v10.X)
		local v12 = math.max(vector.Y, size.Y.Offset + v10.Y)
		parent.Size = UDim2.new(0, v11, 0, v12)
		local v13 = v11 - v2 - v3
		local v14 = v12 - v4 - v5
		scrollingFrame.Size = UDim2.new(0, v13, 0, v14)
		scrollingFrame.Position = UDim2.new(0, v2 + v13 / 2, 0, v4 + v14 / 2)
		scrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		textSizePlus.Position = UDim2.new(textSizePlus.Position.X.Scale, 0, 0, v6)
		textSizeMinus.Position = UDim2.new(textSizeMinus.Position.X.Scale, 0, 0, v7)
		local v15 = v7 + textSizeMinus.AbsoluteSize.Y + 10
		local v16 = math.max(v15, v12 - v8)
		local v17 = math.max(v15 + (v9 - v8), v12 - v9)
		resetWindow.Position = UDim2.new(resetWindow.Position.X.Scale, 0, 0, v16)
		parent2.Position = UDim2.new(parent2.Position.X.Scale, 0, 0, v17)
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if
		(input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
		and v
	then
		v = false
		isResizing.Value = false
		sheetBox.Position = UDim2.new(1, -14, 0.5, 0)
		sheetBox.AnchorPoint = Vector2.new(1, 0.5)
		scrollingFrame.ScrollingEnabled = true
	end
end)