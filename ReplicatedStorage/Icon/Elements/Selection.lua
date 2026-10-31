return function(_)
	local frame = Instance.new("Frame")
	frame.Name = "SelectionContainer"
	frame.Visible = false
	local frame2 = Instance.new("Frame")
	frame2.Name = "Selection"
	frame2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	frame2.BackgroundTransparency = 1
	frame2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	frame2.BorderSizePixel = 0
	frame2.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Name = "UIStroke"
	uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Thickness = 3
	uiStroke.Parent = frame2
	local uiGradient = Instance.new("UIGradient")
	uiGradient.Name = "SelectionGradient"
	uiGradient.Parent = uiStroke
	local uiCorner = Instance.new("UICorner")
	uiCorner:SetAttribute("Collective", "IconCorners")
	uiCorner.Name = "UICorner"
	uiCorner.CornerRadius = UDim.new(1, 0)
	uiCorner.Parent = frame2
	local RunService = game:GetService("RunService")
	local GuiService = game:GetService("GuiService")
	local rotationSpeed = 1
	frame2:GetAttributeChangedSignal("RotationSpeed"):Connect(function()
		rotationSpeed = frame2:GetAttribute("RotationSpeed")
	end)
	RunService.Heartbeat:Connect(function()
		if not GuiService.SelectedObject then
			return
		end

		uiGradient.Rotation = os.clock() * rotationSpeed * 100 % 360
	end)
	return frame
end