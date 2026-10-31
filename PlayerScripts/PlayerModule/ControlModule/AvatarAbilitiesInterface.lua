local CommonUtils = script.Parent.Parent:WaitForChild("CommonUtils")
local FlagUtil = require(CommonUtils:WaitForChild("FlagUtil"))

if not FlagUtil.getUserFlag("UserAllowAbilityControls") then
	return
end

local Players = game:GetService("Players")
local abilityManagerActor = nil
local humanoid = nil
local bindableEvent = Instance.new("BindableEvent")
local evaluateStateMachineChangedConnection = nil
local flag = false

local function characterAdded(character)
	abilityManagerActor = nil
	humanoid = nil

	if evaluateStateMachineChangedConnection then
		evaluateStateMachineChangedConnection:Disconnect()
		evaluateStateMachineChangedConnection = nil
	end

	if character then
		abilityManagerActor = character:FindFirstChild("AbilityManagerActor")
		humanoid = character:FindFirstChildOfClass("Humanoid")

		while not humanoid do
			character.ChildAdded:wait()
			humanoid = character:FindFirstChildOfClass("Humanoid")
		end

		bindableEvent:Fire()
		evaluateStateMachineChangedConnection = humanoid:GetPropertyChangedSignal("EvaluateStateMachine"):Connect(function()
			bindableEvent:Fire()
		end)
	end
end

local function lazyInit() -- 2 equivalent calls inferred from this helper
	if flag then
		return
	end

	flag = true
	local localPlayer = Players.LocalPlayer

	if localPlayer then
		localPlayer.characterAdded:Connect(characterAdded)

		if localPlayer.Character then
			characterAdded(localPlayer.Character)
		end
	end
end

local AvatarAbilitiesInterface = {}

function AvatarAbilitiesInterface.isEnabled()
	lazyInit() -- inferred equivalent call
	return abilityManagerActor ~= nil and humanoid and not humanoid.EvaluateStateMachine
end

function AvatarAbilitiesInterface.GetEnabledChangedSignal()
	lazyInit() -- inferred equivalent call
	return bindableEvent.Event
end

return AvatarAbilitiesInterface