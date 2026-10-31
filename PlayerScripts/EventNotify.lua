local SocialService = game:GetService("SocialService")
local Players = game:GetService("Players")
task.wait(5)
local LocalPlayer = Players.LocalPlayer
local success, result = pcall(function()
	return SocialService:GetUserRsvpStatusForEventAsync(LocalPlayer, "6095863064526193300")
end)

if success and result == Enum.RsvpStatus.Going then
	return
end

SocialService:PromptRsvpToEventAsync("6095863064526193300")