local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local v = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local v2 = v and "FulllScreenPianoMobileUI" or "FulllScreenPianoUI"
local child = PlayerGui:WaitForChild(v2, 20)

if not child then
	warn("[FSPiano] " .. v2 .. " ne nayden!")
	return
end

print("[FSPiano] Используем GUI:", v2, "| Mobile:", v)
local pianoContainer = child:WaitForChild("PianoContainer")
local keysScrollFrame = pianoContainer:FindFirstChild("KeysScrollFrame")
local keyFrame = keysScrollFrame and keysScrollFrame:FindFirstChild("KeyFrame")
	or pianoContainer:WaitForChild("KeyFrame")

local function findBtn(childName)
	local leftPanel = pianoContainer:FindFirstChild("LeftPanel")
	local rightPanel = pianoContainer:FindFirstChild("RightPanel")
	local buttonRow = leftPanel and leftPanel:FindFirstChild("ButtonRow")
	local optionFrame = pianoContainer:FindFirstChild("OptionFrame")
	return pianoContainer:FindFirstChild(childName)
		or optionFrame and optionFrame:FindFirstChild(childName)
		or leftPanel and leftPanel:FindFirstChild(childName)
		or buttonRow and buttonRow:FindFirstChild(childName)
		or rightPanel and rightPanel:FindFirstChild(childName)
end

local optionFrame = pianoContainer:FindFirstChild("OptionFrame")
local screen = pianoContainer:FindFirstChild("Screen")
local soundfonts = child:FindFirstChild("Soundfonts")
local sheets = child:FindFirstChild("Sheets")
local settFrame = child:FindFirstChild("SettFrame")
local Piano_Dependencies = workspace:WaitForChild("Piano_Dependencies", 15)

if not Piano_Dependencies then
	warn("[FSPiano] Piano_Dependencies ne nayden!")
	return
end

local logic = Piano_Dependencies:WaitForChild("Modules"):WaitForChild("Logic")
local dependencies = Piano_Dependencies:WaitForChild("Modules"):WaitForChild("Dependencies")
local Remotes = Piano_Dependencies:WaitForChild("Remotes")
local PianoLogic = require(logic:WaitForChild("PianoLogic"))
local UILogic = require(logic:WaitForChild("UILogic"))
_G.FSUILogic = UILogic
local Soundfonts = require(dependencies:WaitForChild("Soundfonts"))
local PlayerVariables = require(dependencies:WaitForChild("PlayerVariables"))
local SustainRemote = Remotes:WaitForChild("SustainRemote")
local FinishNonSustainedNotesRemote = Remotes:WaitForChild("FinishNonSustainedNotesRemote")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Room_TrailForwarded = ReplicatedStorage:FindFirstChild("Room_TrailForwarded")
local ReplicatedStorage2 = game:GetService("ReplicatedStorage")
local Room_VisualNote = ReplicatedStorage2:FindFirstChild("Room_VisualNote")
local v3 = false
local fsTransposition = 0
local fsLocalVolume = 100
local v4 = true
local flag = false
local flag2 = false
local fsVelocity = 50
local v5 = nil
local v6 = false
_G.FSIsMouseDown = false
local v7 = {}
local walkSpeed = 16
local jumpHeight = 7.2
local eventConnection = nil
local eventConnection2 = nil

local function getCurrentSF()
	local current_SoundfontID = PlayerVariables.Current_SoundfontID or 25
	local soundfont = Soundfonts[current_SoundfontID]

	if not soundfont then
		for _, soundfont2 in pairs(Soundfonts) do
			return soundfont2
		end
	end

	return soundfont
end

local v8 = {
	trail_vip = { w = Color3.fromRGB(255, 200, 0), b = Color3.fromRGB(255, 100, 0) },
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
	trail_dark_matter = { w = Color3.fromRGB(80, 0, 120), b = Color3.fromRGB(20, 0, 40) },
	trail_void = { w = Color3.fromRGB(40, 0, 60), b = Color3.fromRGB(0, 0, 0) },
	trail_shadow = { w = Color3.fromRGB(60, 60, 80), b = Color3.fromRGB(20, 20, 30) },
	trail_nightmare = { w = Color3.fromRGB(100, 0, 50), b = Color3.fromRGB(30, 0, 20) },
	trail_lightning = { w = Color3.fromRGB(100, 200, 255), b = Color3.fromRGB(0, 100, 200) },
	trail_electric = { w = Color3.fromRGB(0, 255, 200), b = Color3.fromRGB(0, 100, 150) },
	trail_plasma = { w = Color3.fromRGB(255, 100, 200), b = Color3.fromRGB(200, 0, 100) },
	trail_water = { w = Color3.fromRGB(0, 150, 255), b = Color3.fromRGB(0, 80, 180) },
	trail_earth = { w = Color3.fromRGB(100, 80, 40), b = Color3.fromRGB(60, 40, 20) },
	trail_wind = { w = Color3.fromRGB(180, 220, 255), b = Color3.fromRGB(100, 140, 180) },
	trail_starlight = { w = Color3.fromRGB(255, 240, 180), b = Color3.fromRGB(100, 80, 40) },
	trail_moonlight = { w = Color3.fromRGB(200, 200, 220), b = Color3.fromRGB(100, 100, 120) },
	trail_sunlight = { w = Color3.fromRGB(255, 200, 100), b = Color3.fromRGB(200, 100, 0) },
	trail_aurora = { w = Color3.fromRGB(0, 255, 150), b = Color3.fromRGB(0, 100, 200) },
	trail_galaxy = { w = Color3.fromRGB(150, 50, 200), b = Color3.fromRGB(80, 20, 120) },
	trail_nebula = { w = Color3.fromRGB(200, 100, 200), b = Color3.fromRGB(100, 30, 100) },
	trail_neon_blue = { w = Color3.fromRGB(0, 100, 255), b = Color3.fromRGB(0, 0, 200) },
	trail_neon_pink = { w = Color3.fromRGB(255, 0, 150), b = Color3.fromRGB(200, 0, 100) },
	trail_neon_orange = { w = Color3.fromRGB(255, 100, 0), b = Color3.fromRGB(200, 50, 0) },
	trail_dragon = { w = Color3.fromRGB(255, 50, 0), b = Color3.fromRGB(150, 20, 0) },
	trail_phoenix = { w = Color3.fromRGB(255, 100, 50), b = Color3.fromRGB(200, 50, 20) },
	trail_angelic = { w = Color3.fromRGB(255, 255, 200), b = Color3.fromRGB(200, 200, 100) },
	trail_demonic = { w = Color3.fromRGB(150, 0, 0), b = Color3.fromRGB(80, 0, 0) },
	trail_crystal = { w = Color3.fromRGB(180, 220, 255), b = Color3.fromRGB(100, 150, 200) },
	trail_void_king = { w = Color3.fromRGB(100, 0, 100), b = Color3.fromRGB(0, 0, 0) },
	trail_coral = { w = Color3.fromRGB(255, 100, 80), b = Color3.fromRGB(200, 50, 30) },
	trail_turquoise = { w = Color3.fromRGB(50, 200, 180), b = Color3.fromRGB(0, 140, 120) },
	trail_teal = { w = Color3.fromRGB(0, 150, 150), b = Color3.fromRGB(0, 80, 80) },
	trail_indigo = { w = Color3.fromRGB(100, 0, 200), b = Color3.fromRGB(50, 0, 120) },
	trail_rose = { w = Color3.fromRGB(255, 150, 180), b = Color3.fromRGB(200, 80, 100) },
	trail_peach = { w = Color3.fromRGB(255, 180, 120), b = Color3.fromRGB(200, 100, 50) },
	trail_mint = { w = Color3.fromRGB(120, 255, 150), b = Color3.fromRGB(50, 180, 80) },
	trail_lavender = { w = Color3.fromRGB(180, 150, 255), b = Color3.fromRGB(100, 70, 180) },
	trail_fireworks = { w = Color3.fromRGB(255, 100, 0), b = Color3.fromRGB(255, 0, 100) },
	trail_confetti = { w = Color3.fromRGB(255, 200, 0), b = Color3.fromRGB(200, 100, 0) },
	trail_glitter = { w = Color3.fromRGB(255, 220, 150), b = Color3.fromRGB(200, 150, 80) },
	trail_flower = { w = Color3.fromRGB(255, 150, 200), b = Color3.fromRGB(150, 80, 100) },
	trail_leaf = { w = Color3.fromRGB(80, 180, 40), b = Color3.fromRGB(40, 100, 20) },
	trail_gradient_fire = { w = Color3.fromRGB(255, 100, 0), b = Color3.fromRGB(255, 0, 0) },
	trail_gradient_ice = { w = Color3.fromRGB(100, 200, 255), b = Color3.fromRGB(0, 100, 200) },
	trail_gradient_nebula = { w = Color3.fromRGB(200, 100, 255), b = Color3.fromRGB(100, 0, 150) },
	trail_gradient_sunset = { w = Color3.fromRGB(255, 150, 50), b = Color3.fromRGB(255, 50, 100) },
	trail_gradient_ocean = { w = Color3.fromRGB(0, 150, 200), b = Color3.fromRGB(0, 50, 100) },
	trail_gradient_forest = { w = Color3.fromRGB(50, 180, 50), b = Color3.fromRGB(20, 100, 20) },
	trail_gradient_cotton = { w = Color3.fromRGB(255, 150, 200), b = Color3.fromRGB(200, 100, 150) },
	trail_gradient_galaxy = { w = Color3.fromRGB(150, 50, 200), b = Color3.fromRGB(50, 0, 100) },
	trail_gradient_aurora = { w = Color3.fromRGB(0, 255, 150), b = Color3.fromRGB(0, 100, 200) },
	trail_gradient_lava = { w = Color3.fromRGB(255, 80, 0), b = Color3.fromRGB(200, 30, 0) },
	trail_glow_blue = { w = Color3.fromRGB(0, 100, 255), b = Color3.fromRGB(0, 0, 200) },
	trail_glow_pink = { w = Color3.fromRGB(255, 50, 150), b = Color3.fromRGB(200, 0, 100) },
	trail_glow_green = { w = Color3.fromRGB(0, 255, 100), b = Color3.fromRGB(0, 180, 50) },
	trail_glow_purple = { w = Color3.fromRGB(150, 50, 255), b = Color3.fromRGB(80, 0, 180) },
	trail_glow_red = { w = Color3.fromRGB(255, 0, 0), b = Color3.fromRGB(180, 0, 0) },
	trail_glow_gold = { w = Color3.fromRGB(255, 200, 0), b = Color3.fromRGB(200, 120, 0) },
	trail_glow_cyan = { w = Color3.fromRGB(0, 255, 255), b = Color3.fromRGB(0, 180, 180) },
	trail_glow_white = { w = Color3.fromRGB(255, 255, 255), b = Color3.fromRGB(200, 200, 200) },
	trail_ultraviolet = { w = Color3.fromRGB(120, 0, 255), b = Color3.fromRGB(60, 0, 150) },
	trail_neon_teal = { w = Color3.fromRGB(0, 200, 180), b = Color3.fromRGB(0, 120, 100) },
	trail_neon_lime = { w = Color3.fromRGB(180, 255, 0), b = Color3.fromRGB(100, 180, 0) },
	trail_neon_amber = { w = Color3.fromRGB(255, 150, 0), b = Color3.fromRGB(200, 80, 0) },
	trail_glitch = { w = Color3.fromRGB(0, 255, 100), b = Color3.fromRGB(255, 0, 255) },
	trail_pixel = { w = Color3.fromRGB(0, 255, 0), b = Color3.fromRGB(255, 0, 0) },
	trail_waves = { w = Color3.fromRGB(0, 150, 255), b = Color3.fromRGB(0, 80, 200) },
	trail_sparks = { w = Color3.fromRGB(255, 150, 0), b = Color3.fromRGB(255, 50, 0) },
	trail_smoke = { w = Color3.fromRGB(150, 150, 150), b = Color3.fromRGB(50, 50, 50) },
	trail_fog = { w = Color3.fromRGB(200, 200, 210), b = Color3.fromRGB(100, 100, 110) },
	trail_hex = { w = Color3.fromRGB(0, 200, 255), b = Color3.fromRGB(0, 100, 150) },
	trail_circuit = { w = Color3.fromRGB(0, 255, 150), b = Color3.fromRGB(0, 100, 80) },
	trail_binary = { w = Color3.fromRGB(0, 255, 0), b = Color3.fromRGB(0, 100, 0) },
	trail_chrome = { w = Color3.fromRGB(220, 230, 255), b = Color3.fromRGB(100, 110, 130) },
	trail_rose_gold = { w = Color3.fromRGB(255, 180, 150), b = Color3.fromRGB(200, 100, 80) },
	trail_black_ice = { w = Color3.fromRGB(80, 100, 120), b = Color3.fromRGB(20, 30, 40) },
	trail_titanium = { w = Color3.fromRGB(180, 190, 200), b = Color3.fromRGB(80, 90, 100) },
	trail_copper = { w = Color3.fromRGB(200, 120, 50), b = Color3.fromRGB(150, 70, 20) },
	trail_brass = { w = Color3.fromRGB(200, 150, 50), b = Color3.fromRGB(150, 100, 20) },
	trail_steel = { w = Color3.fromRGB(150, 160, 170), b = Color3.fromRGB(70, 80, 90) },
	trail_christmas = { w = Color3.fromRGB(255, 0, 0), b = Color3.fromRGB(0, 200, 0) },
	trail_halloween = { w = Color3.fromRGB(255, 100, 0), b = Color3.fromRGB(0, 0, 0) },
	trail_easter = { w = Color3.fromRGB(255, 200, 200), b = Color3.fromRGB(200, 255, 200) },
	trail_valentine = { w = Color3.fromRGB(255, 100, 150), b = Color3.fromRGB(200, 50, 100) },
	trail_new_year = { w = Color3.fromRGB(255, 200, 0), b = Color3.fromRGB(200, 200, 200) },
	trail_birthday = { w = Color3.fromRGB(255, 100, 255), b = Color3.fromRGB(0, 255, 255) },
	trail_sand = { w = Color3.fromRGB(220, 180, 100), b = Color3.fromRGB(150, 100, 50) },
	trail_dust = { w = Color3.fromRGB(180, 160, 120), b = Color3.fromRGB(100, 80, 60) },
	trail_steam = { w = Color3.fromRGB(200, 210, 220), b = Color3.fromRGB(100, 110, 120) },
	trail_mist = { w = Color3.fromRGB(180, 200, 210), b = Color3.fromRGB(80, 100, 110) },
	trail_thunder = { w = Color3.fromRGB(200, 200, 255), b = Color3.fromRGB(50, 50, 100) },
	trail_blizzard = { w = Color3.fromRGB(220, 240, 255), b = Color3.fromRGB(100, 120, 140) },
	trail_meteor = { w = Color3.fromRGB(255, 100, 0), b = Color3.fromRGB(150, 30, 0) },
	trail_earthquake = { w = Color3.fromRGB(100, 70, 40), b = Color3.fromRGB(50, 30, 20) },
	trail_fairy_dust = { w = Color3.fromRGB(255, 200, 255), b = Color3.fromRGB(200, 100, 200) },
	trail_runic = { w = Color3.fromRGB(100, 200, 100), b = Color3.fromRGB(50, 100, 50) },
	trail_ancient_magic = { w = Color3.fromRGB(150, 100, 255), b = Color3.fromRGB(80, 40, 150) },
	trail_soul_flame = { w = Color3.fromRGB(100, 200, 255), b = Color3.fromRGB(0, 100, 150) },
	trail_spirit = { w = Color3.fromRGB(180, 200, 255), b = Color3.fromRGB(80, 100, 150) },
	trail_eldritch = { w = Color3.fromRGB(100, 0, 150), b = Color3.fromRGB(50, 0, 80) },
	trail_celestial = { w = Color3.fromRGB(255, 220, 150), b = Color3.fromRGB(150, 100, 50) },
	trail_dreamweaver = { w = Color3.fromRGB(200, 150, 255), b = Color3.fromRGB(100, 50, 150) },
	trail_black_hole = { w = Color3.fromRGB(80, 0, 100), b = Color3.fromRGB(0, 0, 0) },
	trail_supernova = { w = Color3.fromRGB(255, 200, 100), b = Color3.fromRGB(255, 100, 0) },
	trail_comet = { w = Color3.fromRGB(100, 200, 255), b = Color3.fromRGB(50, 100, 150) },
	trail_asteroid = { w = Color3.fromRGB(150, 100, 50), b = Color3.fromRGB(80, 50, 20) },
	trail_stardust = { w = Color3.fromRGB(255, 220, 180), b = Color3.fromRGB(150, 100, 80) },
	trail_pulsar = { w = Color3.fromRGB(0, 200, 255), b = Color3.fromRGB(0, 100, 150) },
	trail_quasar = { w = Color3.fromRGB(255, 100, 200), b = Color3.fromRGB(150, 0, 100) },
	trail_wormhole = { w = Color3.fromRGB(100, 0, 200), b = Color3.fromRGB(0, 0, 100) },
	trail_anger = { w = Color3.fromRGB(255, 0, 0), b = Color3.fromRGB(150, 0, 0) },
	trail_joy = { w = Color3.fromRGB(255, 255, 100), b = Color3.fromRGB(200, 200, 0) },
	trail_sorrow = { w = Color3.fromRGB(100, 100, 150), b = Color3.fromRGB(50, 50, 80) },
	trail_calm = { w = Color3.fromRGB(100, 180, 200), b = Color3.fromRGB(50, 100, 120) },
	trail_fear = { w = Color3.fromRGB(80, 80, 100), b = Color3.fromRGB(30, 30, 50) },
	trail_courage = { w = Color3.fromRGB(255, 150, 0), b = Color3.fromRGB(200, 100, 0) },
	trail_text_fire = { w = Color3.fromRGB(255, 80, 0), b = Color3.fromRGB(200, 30, 0) },
	trail_text_ice = { w = Color3.fromRGB(100, 200, 255), b = Color3.fromRGB(50, 100, 150) },
	trail_text_star = { w = Color3.fromRGB(255, 240, 150), b = Color3.fromRGB(200, 150, 50) },
	trail_text_heart = { w = Color3.fromRGB(255, 100, 150), b = Color3.fromRGB(200, 50, 100) },
	trail_text_skull = { w = Color3.fromRGB(100, 100, 100), b = Color3.fromRGB(50, 0, 0) },
	trail_text_neon = { w = Color3.fromRGB(0, 255, 200), b = Color3.fromRGB(0, 150, 100) },
	trail_text_crystal = { w = Color3.fromRGB(200, 220, 255), b = Color3.fromRGB(100, 120, 180) }
}

local function isBlackKey(p) -- 5 equivalent calls inferred from this helper
	return p % 12 == 2 or p % 12 == 4 or p % 12 == 7 or p % 12 == 9 or p % 12 == 11
end

local v9 = {
	Color3.fromRGB(255, 0, 0),
	Color3.fromRGB(255, 140, 0),
	Color3.fromRGB(255, 220, 0),
	Color3.fromRGB(0, 210, 0),
	Color3.fromRGB(0, 120, 255),
	Color3.fromRGB(160, 0, 255)
}
local total = 0
RunService.Heartbeat:Connect(function(dt)
	total += dt * 1.5
	_G.FSRainbowIdx = total
end)

local function isRainbowTrail() -- 6 equivalent calls inferred from this helper
	return (LocalPlayer:GetAttribute("EquippedTrail") or "default_trail") == "trail_rainbow_gamepass"
end

local function getRainbowColor() -- 7 equivalent calls inferred from this helper
	local v10 = math.floor(total) % 6 + 1
	local v11 = v10 % 6 + 1
	return v9[v10]:Lerp(v9[v11], total % 1)
end

local function getTrailColors() -- 7 equivalent calls inferred from this helper
	local equippedTrail = LocalPlayer:GetAttribute("EquippedTrail") or "default_trail"
	local v10 = v8[equippedTrail] or v8.default_trail
	return v10.w, v10.b
end

local v10 = {
	trail_deep_blue = true,
	trail_dark_matter = true,
	trail_void = true,
	trail_shadow = true,
	trail_nightmare = true,
	trail_demonic = true,
	trail_indigo = true,
	trail_halloween = true,
	trail_gradient_ocean = true,
	trail_wormhole = true
}
local v11 = {
	trail_dark_matter = true,
	trail_void = true,
	trail_shadow = true,
	trail_nightmare = true
}
local v12 = { trail_void = true, trail_shadow = true, trail_nightmare = true }
local v13 = { trail_void = true, trail_halloween = true }
local color = Color3.fromRGB(61, 123, 198)
local color2 = Color3.fromRGB(0, 175, 0)

local function getDimmedTrailColors()
	local equippedTrail = LocalPlayer:GetAttribute("EquippedTrail") or "default_trail"

	if equippedTrail == "default_trail" then
		return color, color2
	end

	if isRainbowTrail() then -- inferred equivalent call
		local lerped = getRainbowColor():Lerp(Color3.fromRGB(0, 0, 0), 0.35) -- inferred equivalent call
		return lerped, lerped
	else
		local trailColors, v14 = getTrailColors() -- inferred equivalent call
		local v15 = v11[equippedTrail] and 0.15 or 0.35
		local lerped = trailColors:Lerp(Color3.fromRGB(0, 0, 0), v15)

		if v13[equippedTrail] then
			return lerped, (v14:Lerp(trailColors, equippedTrail == "trail_void" and 1.25 or 0.45))
		end

		if not v10[equippedTrail] then
			return lerped, v14:Lerp(Color3.fromRGB(0, 0, 0), 0.35)
		end

		local lerped2 = trailColors:Lerp(v14, 0.5)
		local v16 = v12[equippedTrail] and 0 or v15
		return lerped, (lerped2:Lerp(Color3.fromRGB(0, 0, 0), v16))
	end
end

local frame = nil
local v14 = {}
local RunService2 = game:GetService("RunService")
local v15 = {}
RunService2.Heartbeat:Connect(function()
	if (LocalPlayer:GetAttribute("EquippedTrail") or "default_trail") ~= "trail_rainbow_gamepass" then
		return
	end

	local lerped = getRainbowColor():Lerp(Color3.fromRGB(0, 0, 0), 0.35) -- inferred equivalent call

	for k in pairs(v15) do
		local child2 = keyFrame:FindFirstChild((tostring(k)))

		if child2 then
			child2.ImageColor3 = lerped
		end
	end
end)
local children = {}

local function getKeyButton(p) -- 2 equivalent calls inferred from this helper
	if children[p] then
		return children[p]
	end

	local child2 = keyFrame:FindFirstChild((tostring(p)))

	if child2 then
		children[p] = child2
	end

	return child2
end

local function startTrail(p)
	if not (frame and frame.Parent and frame) then
		return
	end

	local keyButton = getKeyButton(p) -- inferred equivalent call

	if not keyButton or v14[p] then
		return
	end

	local trailColors, v16 = getTrailColors() -- inferred equivalent call
	local rainbowTrail = isRainbowTrail() -- inferred equivalent call
	local isVip = (LocalPlayer:GetAttribute("EquippedTrail") or "") == "trail_vip"
	local blackKey = isBlackKey(p) -- inferred equivalent call
	local color3

	if rainbowTrail then
		color3 = getRainbowColor() -- inferred equivalent call

		if not color3 then
			if blackKey then
				color3 = v16 or trailColors
			else
				color3 = trailColors
			end
		end
	elseif blackKey then
		color3 = v16 or trailColors
	else
		color3 = trailColors
	end

	if isVip then
		color3 = Color3.fromRGB(255, 200, 0)
	end

	local absolutePosition = keyButton.AbsolutePosition
	local absoluteSize = keyButton.AbsoluteSize
	local absolutePosition2 = pianoContainer.AbsolutePosition

	if absoluteSize.X == 0 or absoluteSize.Y == 0 then
		return
	end

	local v17 = math.max(4, absoluteSize.X - 4)
	local relX = absolutePosition.X - absolutePosition2.X + absoluteSize.X / 2
	local v18 = absolutePosition.Y - absolutePosition2.Y
	local frame2 = Instance.new("Frame")
	frame2.BackgroundColor3 = color3
	frame2.BorderSizePixel = 0
	frame2.BackgroundTransparency = 0
	frame2.ZIndex = 3
	frame2.Size = UDim2.new(0, v17, 0, 4)
	frame2.Position = UDim2.new(0, relX - v17 / 2, 0, v18 - 4)
	local uiCorner = Instance.new("UICorner", frame2)
	uiCorner.CornerRadius = UDim.new(0, 3)
	local uiStroke = Instance.new("UIStroke", frame2)
	uiStroke.Color = color3
	uiStroke.Thickness = 2
	uiStroke.Transparency = 0.1

	if isVip then
		uiStroke.Thickness = 3
		uiStroke.Color = Color3.fromRGB(255, 240, 120)
		uiStroke.Transparency = 0
		local uiGradient = Instance.new("UIGradient", frame2)
		uiGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 200)),
			ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 200, 20)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 110, 0)),
			ColorSequenceKeypoint.new(0.7, Color3.fromRGB(255, 200, 20)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 200))
		})
		uiGradient.Rotation = 90
	end

	frame2.Parent = frame
	local v19 = v18
	local heartbeatConnection = nil
	heartbeatConnection = RunService2.Heartbeat:Connect(function(dt)
		if not frame2.Parent then
			heartbeatConnection:Disconnect()
			return
		end

		v19 = math.max(v18 - 1500, v19 - 180 * dt)
		local v20 = v18 - v19
		local now = tick()
		frame2.Size = UDim2.new(0, v17, 0, v20)
		frame2.Position = UDim2.new(0, relX - v17 / 2, 0, v19)

		if rainbowTrail then
			local rainbowColor = getRainbowColor() -- inferred equivalent call
			frame2.BackgroundColor3 = rainbowColor
			uiStroke.Color = rainbowColor
		end

		if isVip then
			uiStroke.Transparency = math.abs((math.sin(now * 5))) * 0.3
		end
	end)
	v14[p] = {
		frame = frame2,
		conn = heartbeatConnection,
		relX = relX,
		w = v17,
		isRainbow = rainbowTrail,
		isVip = isVip
	}
	pcall(function()
		if Room_TrailForwarded then
			local trailColors2, v20 = getTrailColors() -- inferred equivalent call
			Room_TrailForwarded:FireServer("start", p, trailColors2, v20, isRainbowTrail(), isVip) -- inferred equivalent call
		end
	end)
end

local function endTrail(p)
	local v16 = v14[p]

	if not v16 then
		return
	end

	v14[p] = nil
	pcall(function()
		if Room_TrailForwarded then
			Room_TrailForwarded:FireServer("stop", p)
		end
	end)

	if v16.conn then
		v16.conn:Disconnect()
	end

	local frame2 = v16.frame
	local isRainbow = v16.isRainbow
	local _isVip = v16.isVip

	if not (frame2 and frame2.Parent) then
		return
	end

	local position = frame2.Position
	local size = frame2.Size
	local v17 = (position.Y.Offset + size.Y.Offset + 50) / 180
	TweenService:Create(frame2, TweenInfo.new(v17, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
		Position = UDim2.new(0, position.X.Offset, 0, -(size.Y.Offset + 50)),
		BackgroundTransparency = 0
	}):Play()

	if isRainbow then
		local uiStroke = frame2:FindFirstChildOfClass("UIStroke")
		local heartbeatConnection = nil
		heartbeatConnection = RunService2.Heartbeat:Connect(function()
			if not frame2.Parent then
				heartbeatConnection:Disconnect()
				return
			end

			local rainbowColor = getRainbowColor() -- inferred equivalent call
			frame2.BackgroundColor3 = rainbowColor

			if uiStroke then
				uiStroke.Color = rainbowColor
			end
		end)
	end

	task.delay(v17 + 0.1, function()
		if frame2 and frame2.Parent then
			frame2:Destroy()
		end
	end)
end

local function setupTrailCanvas()
	_G.FSGetDimmedTrailColors = getDimmedTrailColors
	_G.FSStartTrail = startTrail
	_G.FSEndTrail = endTrail

	function _G.FSStartRemoteTrail(p, p2, p3, isRainbow, p4)
		if not (frame and frame.Parent) then
			return
		end

		local keyButton = getKeyButton(p) -- inferred equivalent call

		if not keyButton or v14["remote_" .. p] then
			return
		end

		local trailColors, v16 = getTrailColors() -- inferred equivalent call
		local v17 = p2 or trailColors
		local v18 = p3 or v16
		local isVip = p4 == true
		local color3

		if isVip then
			color3 = Color3.fromRGB(255, 200, 0)
		elseif isRainbow then
			color3 = getRainbowColor() -- inferred equivalent call

			if not color3 then
				if isBlackKey(p) then -- inferred equivalent call
					color3 = v18 or v17
				else
					color3 = v17
				end
			end
		elseif isBlackKey(p) then -- inferred equivalent call
			color3 = v18 or v17
		else
			color3 = v17
		end

		local absolutePosition = keyButton.AbsolutePosition
		local absoluteSize = keyButton.AbsoluteSize

		if absoluteSize.X == 0 or absoluteSize.Y == 0 then
			return
		end

		local absolutePosition2 = pianoContainer.AbsolutePosition
		local v19 = math.max(4, absoluteSize.X - 4)
		local relX = absolutePosition.X - absolutePosition2.X + absoluteSize.X / 2
		local v20 = absolutePosition.Y - absolutePosition2.Y
		local frame2 = Instance.new("Frame")
		frame2.BackgroundColor3 = color3
		frame2.BorderSizePixel = 0
		frame2.BackgroundTransparency = 0
		frame2.ZIndex = 3
		frame2.Size = UDim2.new(0, v19, 0, 4)
		frame2.Position = UDim2.new(0, relX - v19 / 2, 0, v20 - 4)
		local uiCorner = Instance.new("UICorner", frame2)
		uiCorner.CornerRadius = UDim.new(0, 3)
		local uiStroke = Instance.new("UIStroke", frame2)

		if isVip then
			frame2.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
			frame2.BackgroundTransparency = 0.05
			local uiGradient = Instance.new("UIGradient", frame2)
			uiGradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 240, 120)),
				ColorSequenceKeypoint.new(0.35, Color3.fromRGB(220, 160, 20)),
				ColorSequenceKeypoint.new(0.65, Color3.fromRGB(255, 210, 60)),
				ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 240, 120))
			})
			uiGradient.Rotation = 90
			uiStroke.Color = Color3.fromRGB(255, 230, 80)
			uiStroke.Thickness = 3
			uiStroke.Transparency = 0.1
		else
			uiStroke.Color = color3
			uiStroke.Thickness = 2
			uiStroke.Transparency = 0.2
		end

		frame2.Parent = frame
		local v21 = v20
		local total2 = 0
		local heartbeatConnection = nil
		heartbeatConnection = RunService2.Heartbeat:Connect(function(dt)
			if not frame2.Parent then
				heartbeatConnection:Disconnect()
				return
			end

			v21 = math.max(v20 - 1500, v21 - 180 * dt)
			local v22 = math.max(4, v20 - v21)
			frame2.Size = UDim2.new(0, v19, 0, v22)
			frame2.Position = UDim2.new(0, relX - v19 / 2, 0, v21)

			if isRainbow and not isVip then
				local rainbowColor = getRainbowColor() -- inferred equivalent call
				frame2.BackgroundColor3 = rainbowColor
				uiStroke.Color = rainbowColor
			end

			if isVip then
				total2 += dt * 3
				uiStroke.Transparency = math.abs((math.sin(total2))) * 0.35 + 0.1
			end
		end)
		v14["remote_" .. p] = {
			frame = frame2,
			conn = heartbeatConnection,
			relX = relX,
			w = v19,
			isRainbow = isRainbow,
			isVip = isVip
		}
	end

	function _G.FSEndRemoteTrail(p)
		local v16 = v14["remote_" .. p]

		if not v16 then
			return
		end

		v14["remote_" .. p] = nil

		if v16.conn then
			v16.conn:Disconnect()
		end

		local frame2 = v16.frame
		local isRainbow = v16.isRainbow

		if not (frame2 and frame2.Parent) then
			return
		end

		local position = frame2.Position
		local size = frame2.Size
		local v17 = math.max(0.1, (position.Y.Offset + size.Y.Offset + 50) / 180)
		TweenService:Create(frame2, TweenInfo.new(v17, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
			Position = UDim2.new(0, position.X.Offset, 0, -(size.Y.Offset + 50)),
			BackgroundTransparency = 0
		}):Play()

		if isRainbow then
			local uiStroke = frame2:FindFirstChildOfClass("UIStroke")
			local heartbeatConnection = nil
			heartbeatConnection = RunService2.Heartbeat:Connect(function()
				if not frame2.Parent then
					heartbeatConnection:Disconnect()
					return
				end

				local v18 = math.floor(total) % 6 + 1
				local v19 = v18 % 6 + 1
				local lerped = v9[v18]:Lerp(v9[v19], total % 1)
				frame2.BackgroundColor3 = lerped

				if uiStroke then
					uiStroke.Color = lerped
				end
			end)
		end

		task.delay(v17 + 0.1, function()
			if frame2 and frame2.Parent then
				frame2:Destroy()
			end
		end)
	end

	local fsPianoEvents = game.ReplicatedStorage:FindFirstChild("FSPianoEvents")

	if fsPianoEvents then
		fsPianoEvents.IsActive.Value = true

		if eventConnection then
			eventConnection:Disconnect()
		end

		if eventConnection2 then
			eventConnection2:Disconnect()
		end

		eventConnection = fsPianoEvents.TrailStart.Event:Connect(function(p)
			pcall(startTrail, p)
		end)
		eventConnection2 = fsPianoEvents.TrailEnd.Event:Connect(function(p)
			pcall(endTrail, p)
		end)
	end

	if frame and frame.Parent then
		frame:Destroy()
	end

	frame = Instance.new("Frame")
	frame.Name = "_TrailCanvas"
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.Position = UDim2.new(0, 0, 0, 0)
	frame.BackgroundTransparency = 1
	frame.ZIndex = 3
	frame.ClipsDescendants = false
	frame.Parent = pianoContainer
end

setupTrailCanvas()

local function updateScreen()
	_G.FSTransposition = fsTransposition
	_G.FSLocalVolume = fsLocalVolume

	if not screen then
		return
	end

	local volume = screen:FindFirstChild("Volume")

	if volume and volume:FindFirstChild("Value") then
		UILogic.UpdateTextLabel(volume.Value, fsLocalVolume)
	end

	local transposition = screen:FindFirstChild("Transposition")

	if transposition and transposition:FindFirstChild("Value") then
		UILogic.UpdateTextLabel(transposition.Value, fsTransposition)
	end
end

local function updateSustainLED()
	_G.PianoSustainPacket = v4
	_G.FSSustainPacket = v4
	pcall(function()
		if _G.OnSustainChanged then
			_G.OnSustainChanged(v4)
		end
	end)

	if not optionFrame then
		return
	end

	local btn = findBtn("Sustain")
	local led = btn and btn:FindFirstChild("LED")

	if led then
		UILogic.GlowCheck(led, v4)
	end
end

local function playNote(p, p2, _)
	if v7[p2] then
		return
	end

	local current_SoundfontID = PlayerVariables.Current_SoundfontID or 25
	local soundfont = Soundfonts[current_SoundfontID]

	if not soundfont then
		for _, soundfont2 in pairs(Soundfonts) do
			soundfont = soundfont2
			break
		end
	end

	if not soundfont then
		return
	end

	local v16 = fsVelocity
	v7[p2] = p
	PianoLogic[soundfont.PacketType](
		p,
		soundfont.AssetIds,
		soundfont.Offset,
		soundfont.MaxLifetime,
		soundfont.Fadeout,
		fsTransposition,
		soundfont.PacketType,
		v4,
		flag2,
		v16,
		fsLocalVolume,
		soundfont.VolumeModifier,
		p2
	)
	UILogic.PlayNote(keyFrame, p, getDimmedTrailColors())

	if isRainbowTrail() then -- inferred equivalent call
		v15[p] = true
	end

	startTrail(p)
	pcall(function()
		if Room_VisualNote then
			local trailColors, v17 = getTrailColors() -- inferred equivalent call
			Room_VisualNote:FireServer(p, true, trailColors, v17)
		end
	end)
	pcall(function()
		if _G.RoomRecordNote then
			_G.RoomRecordNote(game.Players.LocalPlayer.UserId)
		end
	end)

	if _G.FSOnNotePlay then
		pcall(_G.FSOnNotePlay, p, true)
	end
end

local function stopNote(p)
	local v16 = v7[p]

	if not v16 then
		return
	end

	local current_SoundfontID = PlayerVariables.Current_SoundfontID or 25
	local soundfont = Soundfonts[current_SoundfontID]

	if not soundfont then
		for _, soundfont2 in pairs(Soundfonts) do
			soundfont = soundfont2
			break
		end
	end

	v7[p] = nil
	PianoLogic.FinishNonSustainNote(p, not soundfont and 0.5 or soundfont.Fadeout or 0.5)
	FinishNonSustainedNotesRemote:FireServer(p, soundfont and soundfont.Fadeout or 0.5)
	pcall(function()
		UILogic.FinishNote(keyFrame, v16)
	end)
	v15[v16] = nil
	endTrail(v16)
	pcall(function()
		if Room_VisualNote then
			Room_VisualNote:FireServer(v16, false)
		end
	end)
end

local function StopAllNotes()
	local current_SoundfontID = PlayerVariables.Current_SoundfontID or 25
	local soundfont = Soundfonts[current_SoundfontID]

	if not soundfont then
		for _, soundfont2 in pairs(Soundfonts) do
			soundfont = soundfont2
			break
		end
	end

	for k, v16 in pairs(v7) do
		local v17 = k
		local v18 = v16
		pcall(function()
			PianoLogic.FinishNonSustainNote(v17, soundfont and soundfont.Fadeout or 0.5)
			UILogic.FinishNote(keyFrame, v18)
		end)
		endTrail(v16)
	end

	table.clear(v7)
	PianoLogic.FadeoutAllSustainedNotes(0.5)

	for _, v16 in pairs(v14) do
		if v16.conn then
			v16.conn:Disconnect()
		end

		if v16.frame and v16.frame.Parent then
			v16.frame:Destroy()
		end
	end

	table.clear(v14)
	v5 = nil
	v6 = false
end

_G.FSStopAllNotes = StopAllNotes

function _G.FSForceResetAllKeyColors()
	for _, child2 in ipairs(keyFrame:GetChildren()) do
		local name = tonumber(child2.Name)

		if not name then
			continue
		end

		if isBlackKey(name) then -- inferred equivalent call
			child2.ImageColor3 = Color3.fromRGB(0, 0, 0)
		else
			child2.ImageColor3 = Color3.fromRGB(255, 255, 255)
		end
	end
end

local function playMouseNote(name, _)
	local v16 = "mouse_" .. tostring(name)

	if v7[v16] then
		return
	end

	local current_SoundfontID = PlayerVariables.Current_SoundfontID or 25
	local soundfont = Soundfonts[current_SoundfontID]

	if not soundfont then
		for _, soundfont2 in pairs(Soundfonts) do
			soundfont = soundfont2
			break
		end
	end

	if not soundfont then
		return
	end

	local v17 = fsVelocity
	v7[v16] = name
	PianoLogic[soundfont.PacketType](
		name,
		soundfont.AssetIds,
		soundfont.Offset,
		soundfont.MaxLifetime,
		soundfont.Fadeout,
		fsTransposition,
		soundfont.PacketType,
		v4,
		flag2,
		v17,
		fsLocalVolume,
		soundfont.VolumeModifier,
		Enum.KeyCode.Unknown
	)
	UILogic.PlayNote(keyFrame, name, getDimmedTrailColors())

	if isRainbowTrail() then -- inferred equivalent call
		v15[name] = true
	end

	startTrail(name)
	pcall(function()
		if Room_VisualNote then
			local trailColors, v18 = getTrailColors() -- inferred equivalent call
			Room_VisualNote:FireServer(name, true, trailColors, v18)
		end
	end)
	pcall(function()
		if _G.RoomRecordNote then
			_G.RoomRecordNote(game.Players.LocalPlayer.UserId)
		end
	end)

	if _G.FSOnNotePlay then
		pcall(_G.FSOnNotePlay, name, true)
	end
end

local function stopMouseNote(p)
	local v16 = "mouse_" .. tostring(p)
	local v17 = v7[v16]

	if not v17 then
		return
	end

	local current_SoundfontID = PlayerVariables.Current_SoundfontID or 25
	local soundfont = Soundfonts[current_SoundfontID]

	if not soundfont then
		for _, soundfont2 in pairs(Soundfonts) do
			soundfont = soundfont2
			break
		end
	end

	v7[v16] = nil
	PianoLogic.FinishNonSustainNote(Enum.KeyCode.Unknown, not soundfont and 0.5 or soundfont.Fadeout or 0.5)
	v15[v17] = nil
	FinishNonSustainedNotesRemote:FireServer(Enum.KeyCode.Unknown, soundfont and soundfont.Fadeout or 0.5)
	pcall(function()
		UILogic.FinishNote(keyFrame, v17)
	end)
	endTrail(v17)
	pcall(function()
		if Room_VisualNote then
			Room_VisualNote:FireServer(v17, false)
		end
	end)
end

local function setupKeyMouseBindings(button)
	local name = tonumber(button.Name)

	if not name then
		return
	end

	button.InputBegan:Connect(function(input)
		if not v3 or _G.FSPianoScrollBlocked then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			v6 = true
			_G.FSIsMouseDown = true

			if v5 and v5 ~= name then
				stopMouseNote(v5)
			end

			v5 = name
			playMouseNote(name, button)
		end
	end)
	button.InputEnded:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			v6 = false
			_G.FSIsMouseDown = false

			if v5 == name then
				stopMouseNote(name)
				v5 = nil
			end
		end
	end)
	button.MouseEnter:Connect(function()
		if not (v3 and v6) or _G.FSPianoScrollBlocked then
			return
		end

		if v5 and v5 ~= name then
			stopMouseNote(v5)
		end

		v5 = name
		playMouseNote(name, button)
	end)
end

local function setupAllKeyBindings()
	for _, button in ipairs(keyFrame:GetChildren()) do
		if button:IsA("TextButton") or button:IsA("ImageButton") then
			setupKeyMouseBindings(button)
		end
	end
end

local function getKeyAtTouch(position)
	local pianoBlocker = PlayerGui:FindFirstChild("PianoBlocker")

	if pianoBlocker and pianoBlocker.Enabled then
		return nil
	end

	local zIndex = -1
	local v16 = nil

	for _, button in ipairs(keyFrame:GetChildren()) do
		if not button:IsA("ImageButton") then
			continue
		end

		local absolutePosition = button.AbsolutePosition
		local absoluteSize = button.AbsoluteSize
		local name = tonumber(button.Name)
		local v17 = name and isBlackKey(name) and 5 or 0 -- inferred equivalent call

		if not (position.X >= absolutePosition.X - v17 and position.X <= absolutePosition.X + absoluteSize.X + v17 and position.Y >= absolutePosition.Y - v17) then
			continue
		end

		if not (position.Y <= absolutePosition.Y + absoluteSize.Y + v17 and zIndex < button.ZIndex) then
			continue
		end

		zIndex = button.ZIndex
		v16 = button
	end

	return v16
end

local function setupTouchInput()
	if not v then
		return
	end

	UserInputService.TouchStarted:Connect(function(p)
		if not v3 or _G.FSPianoScrollBlocked then
			return
		end

		v6 = true
		local keyAtTouch = getKeyAtTouch(p.Position)
		local name = keyAtTouch and tonumber(keyAtTouch.Name)

		if name then
			if v5 and v5 ~= name then
				stopMouseNote(v5)
			end

			v5 = name
			playMouseNote(name, keyAtTouch)
		end
	end)
	UserInputService.TouchMoved:Connect(function(p)
		if not (v3 and v6) or _G.FSPianoScrollBlocked then
			return
		end

		local keyAtTouch = getKeyAtTouch(p.Position)

		if keyAtTouch then
			local name = tonumber(keyAtTouch.Name)

			if name and v5 ~= name then
				if v5 then
					stopMouseNote(v5)
				end

				v5 = name
				playMouseNote(name, keyAtTouch)
			end
		end
	end)
	UserInputService.TouchEnded:Connect(function(_)
		v6 = false

		if v5 then
			stopMouseNote(v5)
			v5 = nil
		end
	end)
end

local function ProcessPianoAction(_, p, p2)
	if not v3 then
		return Enum.ContextActionResult.Pass
	end

	local keyCode = p2.KeyCode

	if keyCode == Enum.KeyCode.LeftBracket or keyCode == Enum.KeyCode.RightBracket then
		return Enum.ContextActionResult.Pass
	end

	if keyCode == Enum.KeyCode.Minus then
		if p == Enum.UserInputState.Begin and _G.FSMultiTransposerNext then
			_G.FSMultiTransposerNext()
		end
	elseif keyCode == Enum.KeyCode.Equals then
		if p == Enum.UserInputState.Begin and _G.FSMultiTransposerPrev then
			_G.FSMultiTransposerPrev()
		end
	else
		if keyCode == Enum.KeyCode.I or keyCode == Enum.KeyCode.O then
			local _ = p == Enum.UserInputState.Begin
		end

		if keyCode == Enum.KeyCode.Space then
			if p == Enum.UserInputState.Begin then
				v4 = not v4
				SustainRemote:FireServer(v4)

				if not v4 then
					PianoLogic.FadeoutAllSustainedNotes(0.5)
					FinishNonSustainedNotesRemote:FireServer(0.5)
				end

				updateSustainLED()
			elseif p == Enum.UserInputState.End then
				v4 = not v4
				SustainRemote:FireServer(v4)

				if not v4 then
					PianoLogic.FadeoutAllSustainedNotes(0.5)
					FinishNonSustainedNotesRemote:FireServer(0.5)
				end

				updateSustainLED()
			end
		elseif keyCode == Enum.KeyCode.LeftShift or keyCode == Enum.KeyCode.RightShift then
			if p == Enum.UserInputState.Begin then
				fsTransposition = PianoLogic.Transpose(1, fsTransposition)
			elseif p == Enum.UserInputState.End then
				fsTransposition = PianoLogic.Transpose(-1, fsTransposition)
			end

			updateScreen()
		elseif keyCode == Enum.KeyCode.LeftControl or keyCode == Enum.KeyCode.RightControl then
			if p == Enum.UserInputState.Begin then
				flag2 = true
			elseif p == Enum.UserInputState.End then
				flag2 = false
			end
		elseif keyCode == Enum.KeyCode.LeftAlt or keyCode == Enum.KeyCode.RightAlt then
			if p == Enum.UserInputState.Begin then
				flag = true
			elseif p == Enum.UserInputState.End then
				flag = false
			end
		elseif keyCode == Enum.KeyCode.Up then
			if p == Enum.UserInputState.Begin then
				fsTransposition = PianoLogic.Transpose(1, fsTransposition)
				updateScreen()
			end
		elseif keyCode == Enum.KeyCode.Down then
			if p == Enum.UserInputState.Begin then
				fsTransposition = PianoLogic.Transpose(-1, fsTransposition)
				updateScreen()
			end
		elseif keyCode == Enum.KeyCode.Left then
			if p == Enum.UserInputState.Begin then
				fsLocalVolume = PianoLogic.Volume(-10, fsLocalVolume)
				updateScreen()
			end
		elseif keyCode == Enum.KeyCode.Right then
			if p == Enum.UserInputState.Begin then
				fsLocalVolume = PianoLogic.Volume(10, fsLocalVolume)
				updateScreen()
			end
		elseif p == Enum.UserInputState.Begin then
			local current_SoundfontID = PlayerVariables.Current_SoundfontID or 25
			local soundfont = Soundfonts[current_SoundfontID]

			if not soundfont then
				for _, soundfont2 in pairs(Soundfonts) do
					soundfont = soundfont2
					break
				end
			end

			if not soundfont then
				return Enum.ContextActionResult.Sink
			end

			local value = keyCode.Value

			if not value or value <= 0 or value > 255 then
				return Enum.ContextActionResult.Sink
			end

			local lower = string.char(value):lower()
			local v16 = string.char(value)

			if flag then
				local KeymapLogic = require(workspace.Piano_Dependencies.Modules.Logic.KeymapLogic)
				local value2 = keyCode.Value
				local v17 = value2
					and value2 > 0
					and value2 <= 255
					and ("1234567890qwertyuiopasdfghjklzxc"):find(string.char(value2), 1, true)

				if not v17 then
					return Enum.ContextActionResult.Sink
				end

				fsVelocity = tonumber(KeymapLogic:VelocityKeyCodes()[v17]) or fsVelocity
				_G.FSVelocity = fsVelocity
				local velocityBar = pianoContainer:FindFirstChild("VelocityBar", true)

				if not velocityBar then
					return Enum.ContextActionResult.Sink
				end

				velocityBar.Visible = true

				if velocityBar:FindFirstChild("Bar") then
					local v18 = math.clamp(fsVelocity / 99, 0, 1)
					local offset = velocityBar.Size.X.Offset
					velocityBar.Bar.Position = UDim2.new(
						0,
						6,
						velocityBar.Bar.Position.Y.Scale,
						velocityBar.Bar.Position.Y.Offset
					)
					local v19 = math.max(-12, 6 - offset * v18)
					velocityBar.Bar.Size = UDim2.new(
						v18,
						v19,
						velocityBar.Bar.Size.Y.Scale,
						velocityBar.Bar.Size.Y.Offset
					)
				end

				if velocityBar:FindFirstChild("_hideTask") then
					task.cancel(velocityBar._hideTask)
				end

				velocityBar._hideTask = task.delay(3, function()
					velocityBar.Visible = false
				end)
				return Enum.ContextActionResult.Sink
			else
				local v17

				if flag2 then
					v17 = ("trewq0987654321yuiopasdfghj"):find(lower, 1, true)
						or ("trewq0987654321yuiopasdfghj"):find(v16, 1, true)
				else
					v17 = ("1!2@34$5%6^78*9(0qQwWeErtTyYuiIoOpPasSdDfgGhHjJklLzZxcCvVbBnm"):find(lower, 1, true)
						or ("1!2@34$5%6^78*9(0qQwWeErtTyYuiIoOpPasSdDfgGhHjJklLzZxcCvVbBnm"):find(v16, 1, true)
				end

				if v17 then
					local v18

					if flag2 then
						local KeymapLogic = require(workspace.Piano_Dependencies.Modules.Logic.KeymapLogic)
						v18 = (KeymapLogic.Piano88KeyCodes[v17] or v17) + fsTransposition
					else
						v18 = v17 + fsTransposition
					end

					if not v7[keyCode] then
						v7[keyCode] = v18
						PianoLogic[soundfont.PacketType](
							v18,
							soundfont.AssetIds,
							soundfont.Offset,
							soundfont.MaxLifetime,
							soundfont.Fadeout,
							fsTransposition,
							soundfont.PacketType,
							v4,
							flag2,
							fsVelocity,
							fsLocalVolume,
							soundfont.VolumeModifier,
							keyCode
						)
						UILogic.PlayNote(keyFrame, v18, getDimmedTrailColors())

						if isRainbowTrail() then -- inferred equivalent call
							v15[v18] = true
						end

						startTrail(v18)
						pcall(function()
							if Room_VisualNote then
								local trailColors, v19 = getTrailColors() -- inferred equivalent call
								Room_VisualNote:FireServer(v18, true, trailColors, v19)
							end
						end)
						pcall(function()
							if _G.RoomRecordNote then
								_G.RoomRecordNote(game.Players.LocalPlayer.UserId)
							end
						end)

						if _G.FSOnNotePlay then
							pcall(_G.FSOnNotePlay, v18, true)
						end
					end
				end
			end
		else
			local v16 = p == Enum.UserInputState.End and v7[keyCode]

			if v16 then
				local current_SoundfontID = PlayerVariables.Current_SoundfontID or 25
				local soundfont = Soundfonts[current_SoundfontID]

				if not soundfont then
					for _, soundfont2 in pairs(Soundfonts) do
						soundfont = soundfont2
						break
					end
				end

				v7[keyCode] = nil
				PianoLogic.FinishNonSustainNote(keyCode, not soundfont and 0.5 or soundfont.Fadeout or 0.5)
				FinishNonSustainedNotesRemote:FireServer(keyCode, soundfont and soundfont.Fadeout or 0.5)
				pcall(function()
					UILogic.FinishNote(keyFrame, v16)
				end)
				v15[v16] = nil
				endTrail(v16)
				pcall(function()
					if Room_VisualNote then
						Room_VisualNote:FireServer(v16, false)
					end
				end)
			end
		end
	end

	return Enum.ContextActionResult.Sink
end

local enumItems = Enum.KeyCode:GetEnumItems()

local function bindKeyboard() -- 1 equivalent call inferred from this helper
	ContextActionService:BindActionAtPriority(
		"FSPianoInput",
		ProcessPianoAction,
		false,
		Enum.ContextActionPriority.High.Value,
		table.unpack(enumItems)
	)
	ContextActionService:BindActionAtPriority(
		"FSPianoIO",
		ProcessPianoAction,
		false,
		4000,
		Enum.KeyCode.I,
		Enum.KeyCode.O
	)
end

local function unbindKeyboard()
	_G.FSStartTrail = nil
	_G.FSEndTrail = nil
	local fsPianoEvents = game.ReplicatedStorage:FindFirstChild("FSPianoEvents")

	if fsPianoEvents then
		fsPianoEvents.IsActive.Value = false
	end

	if eventConnection then
		eventConnection:Disconnect()
		eventConnection = nil
	end

	if eventConnection2 then
		eventConnection2:Disconnect()
		eventConnection2 = nil
	end

	ContextActionService:UnbindAction("FSPianoInput")
	ContextActionService:UnbindAction("FSPianoIO")
end

local function closeAllPanels() -- 3 equivalent calls inferred from this helper
	_G.FSPianoActive = false
	local autoPlayer = LocalPlayer.PlayerGui:FindFirstChild("AutoPlayer")

	if autoPlayer then
		local frame2 = autoPlayer:FindFirstChild("Frame")

		if frame2 then
			frame2.Visible = false
		end

		autoPlayer.Enabled = false
	end

	if settFrame then
		settFrame.Visible = false
	end

	if soundfonts then
		soundfonts.Visible = false
	end

	if sheets then
		sheets.Visible = false
	end
end

local screenGui = nil
local imageButton = nil
local uiStroke = nil

local function SetOpen(enabled)
	v3 = enabled
	child.Enabled = enabled
	local character = LocalPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")

	if enabled then
		if humanoid then
			humanoid.WalkSpeed = 0
			humanoid.JumpHeight = 0
		end

		bindKeyboard() -- inferred equivalent call
		_G.FSPianoActive = true
		workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable

		if _G.FSCameraLockConn then
			_G.FSCameraLockConn:Disconnect()
		end

		local _g = _G
		local RunService3 = game:GetService("RunService")
		_g.FSCameraLockConn = RunService3.Heartbeat:Connect(function()
			if workspace.CurrentCamera.CameraType ~= Enum.CameraType.Scriptable then
				workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
			end
		end)
		_G.FSTransposition = fsTransposition
		_G.PianoLogicInstance = PianoLogic

		function _G.FSPlayServerNote(...)
			local v16 = { ... }
			pcall(function()
				PianoLogic.PlayServerNote(table.unpack(v16))
			end)
		end

		_G.FSUILogic = UILogic
		_G.FSAnimRemote = Remotes:FindFirstChild("AnimationRemote")
		_G.FSSustRemote = SustainRemote

		if imageButton then
			imageButton.Visible = false
		end

		updateSustainLED()
		updateScreen()
		setupTrailCanvas()
	else
		if humanoid then
			humanoid.WalkSpeed = walkSpeed
			humanoid.JumpHeight = jumpHeight
		end

		StopAllNotes()
		unbindKeyboard()
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

		if _G.FSCameraLockConn then
			_G.FSCameraLockConn:Disconnect()
			_G.FSCameraLockConn = nil
		end

		closeAllPanels() -- inferred equivalent call

		if imageButton then
			imageButton.Visible = true
		end
	end
end

local function createOpenButton()
	local fsPianoOpenButton = LocalPlayer.PlayerGui:FindFirstChild("FSPianoOpenButton")

	if fsPianoOpenButton then
		fsPianoOpenButton:Destroy()
	end

	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FSPianoOpenButton"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screenGui.DisplayOrder = 10
	screenGui.Parent = LocalPlayer.PlayerGui
	imageButton = Instance.new("ImageButton")
	imageButton.Size = UDim2.new(0, 56, 0, 56)
	imageButton.Position = UDim2.new(0, 14, 1, -76)
	imageButton.AnchorPoint = Vector2.new(0, 1)
	imageButton.BackgroundColor3 = Color3.fromRGB(25, 25, 38)
	imageButton.BorderSizePixel = 0
	imageButton.Image = "rbxassetid://7127354156"
	imageButton.ImageColor3 = Color3.fromRGB(100, 180, 255)
	imageButton.Parent = screenGui
	local uiCorner = Instance.new("UICorner", imageButton)
	uiCorner.CornerRadius = UDim.new(0, 14)
	uiStroke = Instance.new("UIStroke", imageButton)
	uiStroke.Color = Color3.fromRGB(70, 130, 210)
	uiStroke.Thickness = 2
	local textLabel = Instance.new("TextLabel", imageButton)
	textLabel.Size = UDim2.new(1, 0, 0, 14)
	textLabel.Position = UDim2.new(0, 0, 1, 3)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "PIANO"
	textLabel.TextColor3 = Color3.fromRGB(160, 210, 255)
	textLabel.TextSize = 10
	textLabel.Font = Enum.Font.GothamBold
	imageButton.MouseButton1Click:Connect(function()
		SetOpen(not v3)
	end)
end

local DraggableObject = require(dependencies:WaitForChild("DraggableObject"))

local function makeDraggable(instance)
	if not instance then
		return
	end

	local isResizing = instance:FindFirstChild("IsResizing")
	local v16 = DraggableObject.new(instance)

	function v16.DragStarted()
		if isResizing then
			isResizing.Value = true
		end
	end

	function v16.DragEnded()
		if isResizing then
			isResizing.Value = false
		end
	end

	v16:Enable()
end

local DraggableObject2 = require(dependencies:WaitForChild("DraggableObject"))

local function makeDraggable2(instance)
	if not instance then
		return
	end

	local isResizing = instance:FindFirstChild("IsResizing")
	local v16 = DraggableObject2.new(instance)

	function v16.DragStarted()
		if isResizing then
			isResizing.Value = true
		end
	end

	function v16.DragEnded()
		if isResizing then
			isResizing.Value = false
		end
	end

	v16:Enable()
end

local function setupOptionButtons()
	if not optionFrame then
		return
	end

	local btn = findBtn("Soundfonts")

	if btn and soundfonts then
		makeDraggable2(soundfonts)
		btn.MouseButton1Click:Connect(function()
			soundfonts.Visible = not soundfonts.Visible

			if sheets then
				sheets.Visible = false
			end

			if settFrame then
				settFrame.Visible = false
			end
		end)
	end

	local btn2 = findBtn("Sheets")

	if btn2 and sheets then
		makeDraggable2(sheets)
		btn2.MouseButton1Click:Connect(function()
			sheets.Visible = not sheets.Visible

			if soundfonts then
				soundfonts.Visible = false
			end

			if settFrame then
				settFrame.Visible = false
			end

			local resizeBridge = sheets.Visible and sheets:FindFirstChild("_ResizeBridge")

			if resizeBridge then
				task.wait()
				resizeBridge.Value = "REINIT"
			end
		end)
	end

	local btn3 = findBtn("Power")

	if btn3 then
		btn3.MouseButton1Click:Connect(function()
			if v3 then
				v3 = false
				child.Enabled = false
				local character = LocalPlayer.Character
				local humanoid = character and character:FindFirstChildOfClass("Humanoid")

				if humanoid then
					humanoid.WalkSpeed = walkSpeed
					humanoid.JumpHeight = jumpHeight
				end

				StopAllNotes()
				unbindKeyboard()
				workspace.CurrentCamera.CameraType = Enum.CameraType.Custom

				if _G.FSCameraLockConn then
					_G.FSCameraLockConn:Disconnect()
					_G.FSCameraLockConn = nil
				end

				closeAllPanels() -- inferred equivalent call

				if imageButton then
					imageButton.Visible = true
				end
			end
		end)
	end

	local btn4 = findBtn("Sustain")

	if btn4 then
		btn4.MouseButton1Click:Connect(function()
			v4 = not v4
			SustainRemote:FireServer(v4)

			if not v4 then
				PianoLogic.FadeoutAllSustainedNotes(0.5)
				FinishNonSustainedNotesRemote:FireServer(0.5)
			end

			updateSustainLED()
		end)
	end

	local btn5 = findBtn("VolumeUp")

	if btn5 then
		btn5.MouseButton1Click:Connect(function()
			fsLocalVolume = PianoLogic.Volume(10, fsLocalVolume)
			updateScreen()
		end)
	end

	local btn6 = findBtn("VolumeDown")

	if btn6 then
		btn6.MouseButton1Click:Connect(function()
			fsLocalVolume = PianoLogic.Volume(-10, fsLocalVolume)
			updateScreen()
		end)
	end

	local btn7 = findBtn("TransposeUp")

	if btn7 then
		btn7.Activated:Connect(function()
			fsTransposition = PianoLogic.Transpose(1, fsTransposition)
			updateScreen()
		end)
	end

	local btn8 = findBtn("TransposeDown")

	if btn8 then
		btn8.Activated:Connect(function()
			fsTransposition = PianoLogic.Transpose(-1, fsTransposition)
			updateScreen()
		end)
	end
end

function _G.FSSetTransposition(value)
	fsTransposition = math.clamp(value, -24, 24)
	updateScreen()
end

child.Enabled = false

if soundfonts then
	soundfonts.Visible = false
end

if sheets then
	sheets.Visible = false
end

if settFrame then
	settFrame.Visible = false
end

createOpenButton()
setupAllKeyBindings()
setupTouchInput()
setupOptionButtons()
task.defer(function()
	_G.PianoSustainPacket = v4
	_G.FSSustainPacket = v4
	_G.FSLocalVolume = fsLocalVolume
	SetOpen(true)
end)
UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		v6 = false
		_G.FSIsMouseDown = false

		if v5 then
			stopMouseNote(v5)
			v5 = nil
		end
	end
end)
UserInputService.WindowFocusReleased:Connect(function()
	if v3 then
		StopAllNotes()
	end
end)
local GuiService = game:GetService("GuiService")
GuiService.MenuOpened:Connect(function()
	if v3 then
		StopAllNotes()
	end
end)
LocalPlayer.CharacterAdded:Connect(function(character)
	if v3 then
		v3 = false
		child.Enabled = false
		unbindKeyboard()
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		closeAllPanels() -- inferred equivalent call
		StopAllNotes()
	end

	task.wait(0.5)
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if humanoid then
		walkSpeed = humanoid.WalkSpeed
		jumpHeight = humanoid.JumpHeight
	end

	task.wait(1)

	if not LocalPlayer.PlayerGui:FindFirstChild("FSPianoOpenButton") then
		createOpenButton()
	end
end)
task.spawn(function()
	while true do
		task.wait(0.3)

		if not v3 then
			continue
		end

		for k, v16 in pairs(v7) do
			if typeof(k) ~= "EnumItem" or UserInputService:IsKeyDown(k) then
				continue
			end

			local current_SoundfontID = PlayerVariables.Current_SoundfontID or 25
			local soundfont = Soundfonts[current_SoundfontID]

			if not soundfont then
				for _, soundfont2 in pairs(Soundfonts) do
					soundfont = soundfont2
					break
				end
			end

			local v17 = k
			local v18 = v16
			pcall(function()
				PianoLogic.FinishNonSustainNote(v17, soundfont and soundfont.Fadeout or 0.5)
				UILogic.FinishNote(keyFrame, v18)
			end)
			endTrail(v16)
			local v19 = v16
			pcall(function()
				if Room_VisualNote then
					Room_VisualNote:FireServer(v19, false)
				end
			end)
			v7[k] = nil
		end

		if not v5 or v6 then
			continue
		end

		stopMouseNote(v5)
		v5 = nil
	end
end)
print("[FSPiano] v12 zagrushen!")