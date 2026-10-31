local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local child = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild(
	UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and "FulllScreenPianoMobileUI" or "FulllScreenPianoUI",
	30
)

if not child then
	warn("[GradAnim] PianoGui not found")
	return
end

local textLabel = child:WaitForChild("PianoContainer", 10):WaitForChild("KeyFrame", 10):FindFirstChildOfClass("TextLabel")

if not textLabel then
	warn("[GradAnim] StripeLabel not found")
	return
end

local uiGradient = textLabel:FindFirstChildOfClass("UIGradient")

if not uiGradient then
	warn("[GradAnim] UIGradient not found")
	return
end

local cascadePiano = child:FindFirstChild("CascadePiano")
local v = {
	Color3.fromRGB(255, 0, 0),
	Color3.fromRGB(255, 140, 0),
	Color3.fromRGB(255, 220, 0),
	Color3.fromRGB(0, 210, 0),
	Color3.fromRGB(0, 120, 255),
	Color3.fromRGB(160, 0, 255)
}
local v2 = {
	default_trail = { w = Color3.fromRGB(0, 170, 255), b = Color3.fromRGB(29, 203, 17) },
	trail_cyan = { w = Color3.fromRGB(0, 255, 255), b = Color3.fromRGB(0, 180, 180) },
	trail_deep_blue = { w = Color3.fromRGB(30, 60, 200), b = Color3.fromRGB(10, 30, 120) },
	trail_fire = { w = Color3.fromRGB(255, 80, 0), b = Color3.fromRGB(200, 30, 0) },
	trail_red = { w = Color3.fromRGB(255, 0, 0), b = Color3.fromRGB(180, 0, 0) },
	trail_crimson = { w = Color3.fromRGB(220, 20, 60), b = Color3.fromRGB(140, 0, 40) },
	trail_lava = { w = Color3.fromRGB(255, 100, 0), b = Color3.fromRGB(255, 40, 0) },
	trail_green = { w = Color3.fromRGB(0, 220, 80), b = Color3.fromRGB(0, 140, 40) },
	trail_lime = { w = Color3.fromRGB(180, 255, 0), b = Color3.fromRGB(100, 180, 0) },
	trail_emerald = { w = Color3.fromRGB(80, 200, 80), b = Color3.fromRGB(30, 120, 30) },
	trail_neon_green = { w = Color3.fromRGB(0, 255, 100), b = Color3.fromRGB(0, 180, 50) },
	trail_pink = { w = Color3.fromRGB(255, 100, 180), b = Color3.fromRGB(200, 0, 120) },
	trail_hot_pink = { w = Color3.fromRGB(255, 80, 140), b = Color3.fromRGB(200, 0, 100) },
	trail_purple = { w = Color3.fromRGB(160, 80, 255), b = Color3.fromRGB(80, 0, 160) },
	trail_violet = { w = Color3.fromRGB(180, 100, 255), b = Color3.fromRGB(100, 30, 180) },
	trail_magenta = { w = Color3.fromRGB(255, 0, 255), b = Color3.fromRGB(180, 0, 180) },
	trail_gold = { w = Color3.fromRGB(255, 210, 0), b = Color3.fromRGB(200, 140, 0) },
	trail_yellow = { w = Color3.fromRGB(255, 255, 0), b = Color3.fromRGB(180, 180, 0) },
	trail_amber = { w = Color3.fromRGB(255, 200, 50), b = Color3.fromRGB(200, 120, 0) },
	trail_prism = { w = Color3.fromRGB(255, 255, 255), b = Color3.fromRGB(100, 100, 255) },
	trail_ice = { w = Color3.fromRGB(150, 220, 255), b = Color3.fromRGB(80, 140, 200) },
	trail_silver = { w = Color3.fromRGB(200, 200, 220), b = Color3.fromRGB(120, 120, 140) },
	trail_platinum = { w = Color3.fromRGB(230, 230, 250), b = Color3.fromRGB(150, 150, 170) },
	trail_aurora = { w = Color3.fromRGB(0, 255, 150), b = Color3.fromRGB(0, 100, 200) },
	trail_galaxy = { w = Color3.fromRGB(150, 50, 200), b = Color3.fromRGB(80, 20, 120) },
	trail_neon_blue = { w = Color3.fromRGB(0, 100, 255), b = Color3.fromRGB(0, 0, 200) },
	trail_neon_pink = { w = Color3.fromRGB(255, 0, 150), b = Color3.fromRGB(200, 0, 100) },
	trail_turquoise = { w = Color3.fromRGB(50, 200, 180), b = Color3.fromRGB(0, 140, 120) },
	trail_teal = { w = Color3.fromRGB(0, 150, 150), b = Color3.fromRGB(0, 80, 80) },
	trail_rose = { w = Color3.fromRGB(255, 150, 180), b = Color3.fromRGB(200, 80, 100) },
	trail_mint = { w = Color3.fromRGB(120, 255, 150), b = Color3.fromRGB(50, 180, 80) },
	trail_lavender = { w = Color3.fromRGB(180, 150, 255), b = Color3.fromRGB(100, 70, 180) },
	trail_crystal = { w = Color3.fromRGB(180, 220, 255), b = Color3.fromRGB(100, 150, 200) },
	trail_angelic = { w = Color3.fromRGB(255, 255, 200), b = Color3.fromRGB(200, 200, 100) },
	trail_glow_blue = { w = Color3.fromRGB(0, 100, 255), b = Color3.fromRGB(0, 0, 200) },
	trail_glow_pink = { w = Color3.fromRGB(255, 50, 150), b = Color3.fromRGB(200, 0, 100) },
	trail_glow_green = { w = Color3.fromRGB(0, 255, 100), b = Color3.fromRGB(0, 180, 50) },
	trail_glow_purple = { w = Color3.fromRGB(150, 50, 255), b = Color3.fromRGB(80, 0, 180) },
	trail_glow_gold = { w = Color3.fromRGB(255, 200, 0), b = Color3.fromRGB(200, 120, 0) },
	trail_supernova = { w = Color3.fromRGB(255, 200, 100), b = Color3.fromRGB(255, 100, 0) },
	trail_stardust = { w = Color3.fromRGB(255, 220, 180), b = Color3.fromRGB(150, 100, 80) },
	trail_celestial = { w = Color3.fromRGB(255, 220, 150), b = Color3.fromRGB(150, 100, 50) },
	trail_fairy_dust = { w = Color3.fromRGB(255, 200, 255), b = Color3.fromRGB(200, 100, 200) },
	trail_christmas = { w = Color3.fromRGB(255, 0, 0), b = Color3.fromRGB(0, 200, 0) },
	trail_halloween = { w = Color3.fromRGB(255, 100, 0), b = Color3.fromRGB(0, 0, 0) },
	trail_valentine = { w = Color3.fromRGB(255, 100, 150), b = Color3.fromRGB(200, 50, 100) },
	trail_new_year = { w = Color3.fromRGB(255, 200, 0), b = Color3.fromRGB(200, 200, 200) },
	trail_gradient_fire = { w = Color3.fromRGB(255, 100, 0), b = Color3.fromRGB(255, 0, 0) },
	trail_gradient_ice = { w = Color3.fromRGB(100, 200, 255), b = Color3.fromRGB(0, 100, 200) },
	trail_gradient_nebula = { w = Color3.fromRGB(200, 100, 255), b = Color3.fromRGB(100, 0, 150) },
	trail_gradient_sunset = { w = Color3.fromRGB(255, 150, 50), b = Color3.fromRGB(255, 50, 100) },
	trail_gradient_ocean = { w = Color3.fromRGB(0, 150, 200), b = Color3.fromRGB(0, 50, 100) },
	trail_gradient_aurora = { w = Color3.fromRGB(0, 255, 150), b = Color3.fromRGB(0, 100, 200) },
	trail_gradient_lava = { w = Color3.fromRGB(255, 80, 0), b = Color3.fromRGB(200, 30, 0) },
	trail_wormhole = { w = Color3.fromRGB(100, 0, 200), b = Color3.fromRGB(0, 0, 100) },
	trail_comet = { w = Color3.fromRGB(100, 200, 255), b = Color3.fromRGB(50, 100, 150) },
	trail_coral = { w = Color3.fromRGB(255, 100, 80), b = Color3.fromRGB(200, 50, 30) },
	trail_courage = { w = Color3.fromRGB(255, 150, 0), b = Color3.fromRGB(200, 100, 0) },
	trail_dark_matter = { w = Color3.fromRGB(80, 0, 120), b = Color3.fromRGB(20, 0, 40) },
	trail_demonic = { w = Color3.fromRGB(150, 0, 0), b = Color3.fromRGB(80, 0, 0) },
	trail_dragon = { w = Color3.fromRGB(255, 50, 0), b = Color3.fromRGB(150, 20, 0) },
	trail_electric = { w = Color3.fromRGB(0, 255, 200), b = Color3.fromRGB(0, 100, 150) },
	trail_glitch = { w = Color3.fromRGB(0, 255, 100), b = Color3.fromRGB(255, 0, 255) },
	trail_indigo = { w = Color3.fromRGB(100, 0, 200), b = Color3.fromRGB(50, 0, 120) },
	trail_lightning = { w = Color3.fromRGB(100, 200, 255), b = Color3.fromRGB(0, 100, 200) },
	trail_nebula = { w = Color3.fromRGB(200, 100, 200), b = Color3.fromRGB(100, 30, 100) },
	trail_neon_orange = { w = Color3.fromRGB(255, 100, 0), b = Color3.fromRGB(200, 50, 0) },
	trail_nightmare = { w = Color3.fromRGB(100, 0, 50), b = Color3.fromRGB(30, 0, 20) },
	trail_phoenix = { w = Color3.fromRGB(255, 100, 50), b = Color3.fromRGB(200, 50, 20) },
	trail_plasma = { w = Color3.fromRGB(255, 100, 200), b = Color3.fromRGB(200, 0, 100) },
	trail_shadow = { w = Color3.fromRGB(60, 60, 80), b = Color3.fromRGB(20, 20, 30) },
	trail_void = { w = Color3.fromRGB(40, 0, 60), b = Color3.fromRGB(0, 0, 0) },
	trail_water = { w = Color3.fromRGB(0, 150, 255), b = Color3.fromRGB(0, 80, 180) }
}
local colorSequence = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 159)),
	ColorSequenceKeypoint.new(0.01, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.19, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(0.57, Color3.fromRGB(0, 85, 255)),
	ColorSequenceKeypoint.new(0.8, Color3.fromRGB(204, 204, 235)),
	ColorSequenceKeypoint.new(0.9, Color3.fromRGB(0, 85, 255)),
	ColorSequenceKeypoint.new(0.96, Color3.fromRGB(244, 244, 251)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 85, 255))
})
local color = Color3.fromRGB(0, 0, 195)
local total = 0

local function isRainbow(p)
	return p == "trail_rainbow_gamepass"
end

local function getRainbowColor(p) -- 3 equivalent calls inferred from this helper
	local v3 = math.floor(p) % 6 + 1
	local v4 = v3 % 6 + 1
	return v[v3]:Lerp(v[v4], p % 1)
end

local function makeStripeFromColor(w, b)
	local lerped = w:Lerp(b, 0.5)
	local lerped2 = w:Lerp(Color3.fromRGB(255, 255, 255), 0.4)
	return ColorSequence.new({
		ColorSequenceKeypoint.new(0, b),
		ColorSequenceKeypoint.new(0.01, lerped2),
		ColorSequenceKeypoint.new(0.19, lerped2),
		ColorSequenceKeypoint.new(0.57, w),
		ColorSequenceKeypoint.new(0.8, lerped),
		ColorSequenceKeypoint.new(0.9, w),
		ColorSequenceKeypoint.new(0.96, lerped2),
		ColorSequenceKeypoint.new(1, w)
	})
end

local v3 = ""
RunService.Heartbeat:Connect(function(dt)
	if not child.Enabled then
		return
	end

	total += dt * 0.4
	local equippedTrail = LocalPlayer:GetAttribute("EquippedTrail") or "default_trail"

	if equippedTrail ~= v3 then
		v3 = equippedTrail

		if equippedTrail == "trail_vip" then
			uiGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 120)),
				ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(0.35, Color3.fromRGB(220, 160, 20)),
				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 10)),
				ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 200, 40)),
				ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 255, 255)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 240, 120))
			})

			if cascadePiano then
				cascadePiano.TextColor3 = Color3.fromRGB(255, 200, 0)
			end
		elseif equippedTrail == "default_trail" then
			uiGradient.Color = colorSequence

			if cascadePiano then
				cascadePiano.TextColor3 = color
			end
		else
			local v4 = equippedTrail ~= "trail_rainbow_gamepass" and v2[equippedTrail]

			if v4 then
				uiGradient.Color = makeStripeFromColor(v4.w, v4.b)

				if cascadePiano then
					local v5 = v4.w.R * 0.299 + v4.w.G * 0.587 + v4.w.B * 0.114
					local v6 = v4.b.R * 0.299 + v4.b.G * 0.587 + v4.b.B * 0.114
					cascadePiano.TextColor3 = math.min(v5, v6) < 0.15 and (v6 <= v5 and v4.w or v4.b)
						or v6 < v5 and v4.b
						or v4.w
				end
			end
		end
	end

	local v4 = math.sin(total) * 0.5
	uiGradient.Offset = Vector2.new(v4, 0)

	if equippedTrail == "trail_vip" then
		local v5 = total * 0.8
		local color2 = Color3.fromRGB(255, 240, 120)
		local color3 = Color3.fromRGB(255, 255, 255)
		local color4 = Color3.fromRGB(15, 15, 15)
		local color5 = Color3.fromRGB(200, 130, 10)
		local midpoint = (math.sin(v5) + 1) / 2
		uiGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, color2),
			ColorSequenceKeypoint.new(0.18, color3:Lerp(color2, midpoint)),
			ColorSequenceKeypoint.new(0.36, color5),
			ColorSequenceKeypoint.new(0.5, color4:Lerp(color5, midpoint)),
			ColorSequenceKeypoint.new(0.64, color5),
			ColorSequenceKeypoint.new(0.82, color3:Lerp(color2, 1 - midpoint)),
			ColorSequenceKeypoint.new(1, color2)
		})

		if cascadePiano then
			local v6 = math.abs((math.sin(v5 * 1.5))) * 0.15 + 0.85
			cascadePiano.TextColor3 = Color3.fromRGB(math.floor(v6 * 55 + 200), math.floor(v6 * 50 + 150), 0)
		end
	end

	if equippedTrail == "trail_rainbow_gamepass" then
		local fsRainbowIdx = _G.FSRainbowIdx or total
		local rainbowColor = getRainbowColor(fsRainbowIdx) -- inferred equivalent call
		local rainbowColor2 = getRainbowColor(fsRainbowIdx + 2) -- inferred equivalent call
		local rainbowColor3 = getRainbowColor(fsRainbowIdx + 4) -- inferred equivalent call
		uiGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, rainbowColor),
			ColorSequenceKeypoint.new(0.25, rainbowColor2),
			ColorSequenceKeypoint.new(0.5, rainbowColor3),
			ColorSequenceKeypoint.new(0.75, rainbowColor2),
			ColorSequenceKeypoint.new(1, rainbowColor)
		})

		if cascadePiano then
			cascadePiano.TextColor3 = rainbowColor
		end
	end
end)
print("[GradAnim] загружен!")