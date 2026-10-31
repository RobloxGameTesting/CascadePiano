return {
	Name = "kick",
	Aliases = { "boot" },
	Description = "Kicks a player or set of players.",
	Group = "DefaultAdmin",
	Args = {
		{
			Type = "players",
			Name = "players",
			Description = "The players to kick. (type 'all' kick everyone on the server)"
		},
		{
			Type = "string",
			Name = "reason",
			Description = "Причина кика (необязательно).",
			Optional = true
		}
	}
}