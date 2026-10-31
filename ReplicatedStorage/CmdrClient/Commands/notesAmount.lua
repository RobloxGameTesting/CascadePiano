return {
	Name = "notesAmount",
	Aliases = { "setnotes" },
	Description = "Add, subtract, or set a player's note balance. [DEV ONLY]",
	Group = "DefaultAdmin",
	Args = {
		{
			Type = "player",
			Name = "player",
			Description = "Target player (name) or type 'id' to use UserId"
		},
		{ Type = "string", Name = "mode", Description = "\"add\", \"sub\" or \"set\"" },
		{ Type = "integer", Name = "amount", Description = "Amount of notes" }
	}
}