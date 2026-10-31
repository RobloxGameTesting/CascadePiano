local SheetBox = script.Parent.Parent.ScrollingFrame:FindFirstChild("SheetBox")
script.Parent.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		SheetBox.TextSize += 1
	end
end)