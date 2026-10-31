local parent = script.Parent
local TweenService = game:GetService("TweenService")
local color = Color3.fromRGB(0, 127, 255)
local color2 = Color3.fromRGB(255, 255, 255)
local color3 = Color3.fromRGB(180, 230, 255)
local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local tweenInfo2 = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function applyEffect(button)
	if button:IsA("ImageButton") or button:IsA("TextButton") then
		local size = button.Size
		local udim = UDim2.new(size.X.Scale * 0.9, size.X.Offset, size.Y.Scale * 0.9, size.Y.Offset)
		button.MouseEnter:Connect(function()
			TweenService:Create(button, tweenInfo, { ImageColor3 = color }):Play()
		end)
		button.MouseLeave:Connect(function()
			TweenService:Create(button, tweenInfo, {
				ImageColor3 = color2,
				Size = size,
				ImageTransparency = 0
			}):Play()
		end)
		button.MouseButton1Down:Connect(function()
			TweenService:Create(button, tweenInfo, {
				Size = udim,
				ImageColor3 = color3,
				ImageTransparency = 0.3
			}):Play()
		end)
		button.MouseButton1Up:Connect(function()
			TweenService:Create(button, tweenInfo2, {
				Size = size,
				ImageColor3 = color,
				ImageTransparency = 0
			}):Play()
		end)
	end
end

for _, child in ipairs(parent:GetChildren()) do
	applyEffect(child)
end