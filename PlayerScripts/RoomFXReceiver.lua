local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
game:GetService("Players")
local Room_FXForwarded = ReplicatedStorage:WaitForChild("Room_FXForwarded")
local Room_PlayerLeft = ReplicatedStorage:WaitForChild("Room_PlayerLeft")
local Room_PlayerKicked = ReplicatedStorage:WaitForChild("Room_PlayerKicked")
local v = {
	"EqualizerSoundEffect",
	"ReverbSoundEffect",
	"ChorusSoundEffect",
	"FlangeSoundEffect",
	"TremoloSoundEffect",
	"EchoSoundEffect",
	"PitchShiftSoundEffect"
}
local v2 = {
	Equalizer = "EqualizerSoundEffect",
	Reverb = "ReverbSoundEffect",
	Chorus = "ChorusSoundEffect",
	Flange = "FlangeSoundEffect",
	Tremolo = "TremoloSoundEffect",
	EchoDelay = "EchoSoundEffect"
}
local Piano = SoundService:WaitForChild("Piano")

local function getOrCreatePlayerGroup(p)
	local name = "Player_" .. p
	local child = SoundService:FindFirstChild(name)

	if child then
		return child
	end

	local soundGroup = Instance.new("SoundGroup")
	soundGroup.Name = name
	soundGroup.Volume = 1
	soundGroup.Parent = SoundService

	for _, childName in ipairs(v) do
		local child2 = Piano:FindFirstChild(childName)

		if not child2 then
			continue
		end

		local clone = child2:Clone()
		clone.Enabled = false
		clone.Parent = soundGroup
	end

	return soundGroup
end

_G.RoomFX_GetOrCreateGroup = getOrCreatePlayerGroup

local function removePlayerGroup(userId) -- 1 equivalent call inferred from this helper
	local child = SoundService:FindFirstChild("Player_" .. userId)

	if child then
		child:Destroy()
	end
end

Room_FXForwarded.OnClientEvent:Connect(function(p, p2)
	local playerGroup = getOrCreatePlayerGroup(p)

	for k, childName in pairs(v2) do
		local v3 = p2[k]

		if not v3 then
			continue
		end

		local child = playerGroup:FindFirstChild(childName)

		if not child then
			continue
		end

		child.Enabled = v3.enabled

		if not v3.props then
			continue
		end

		for k2, v4 in pairs(v3.props) do
			local v5 = k2
			local v6 = v4
			pcall(function()
				child[v5] = v6
			end)
		end
	end

	local pitchShiftSoundEffect = playerGroup:FindFirstChild("PitchShiftSoundEffect")

	if pitchShiftSoundEffect and p2.__pitch then
		pitchShiftSoundEffect.Enabled = true
		pitchShiftSoundEffect.Octave = p2.__pitch
	end
end)
Room_PlayerLeft.OnClientEvent:Connect(function(p)
	if p.userId then
		removePlayerGroup(p.userId) -- inferred equivalent call
	elseif p.roomClosed then
		for _, child in ipairs(SoundService:GetChildren()) do
			if child.Name:sub(1, 7) == "Player_" then
				child:Destroy()
			end
		end
	end
end)
Room_PlayerKicked.OnClientEvent:Connect(function()
	for _, child in ipairs(SoundService:GetChildren()) do
		if child.Name:sub(1, 7) == "Player_" then
			child:Destroy()
		end
	end
end)
print("[RoomFXReceiver v2] loaded")