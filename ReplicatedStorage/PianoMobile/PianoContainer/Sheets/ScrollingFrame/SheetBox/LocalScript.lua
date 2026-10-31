local parent = script.Parent
local isResizing = parent.Parent.Parent:FindFirstChild("IsResizing")
parent.InputBegan:Connect(function(input)
	if
		(input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1)
		and not isResizing.Value
	then
		parent:CaptureFocus()
	end
end)
parent.Focused:Connect(function()
	if isResizing.Value then
		parent:ReleaseFocus()
	else
		parent.TextEditable = true
	end
end)