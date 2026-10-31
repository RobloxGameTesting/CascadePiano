return {
	Name = "noclip",
	Aliases = { "nc" },
	Description = "Noclip + Fly (client-side)",
	Group = "DefaultAdmin",
	Args = {
		{ Type = "players", Name = "Players" },
		{ Type = "boolean", Name = "Enabled", Optional = true }
	},
	Run = function(_, list, p)
		for _, v in ipairs(list) do
			local character = v.Character

			if not character then
				continue
			end

			local v2

			if p == nil then
				v2 = not character:GetAttribute("Noclip")
			else
				v2 = p
			end

			character:SetAttribute("Noclip", v2)
		end

		return "Noclip + Fly обновлён"
	end
}