return {
	Name = "notesAmountId",
	Aliases = { "notesid" },
	Description = "Add, subtract, or set notes by UserId. [DEV ONLY]",
	Group = "DefaultAdmin",
	Args = {
		{ Type = "integer", Name = "userId", Description = "Target player's UserId" },
		{ Type = "string", Name = "mode", Description = "\"add\", \"sub\" or \"set\"" },
		{ Type = "integer", Name = "amount", Description = "Amount of notes" }
	}
}