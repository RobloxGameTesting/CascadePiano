return {
	Name = "playerStats",
	Aliases = { "pstats" },
	Description = "Show player statistics: balance, playtime, notes pressed, gamepasses. [DEV ONLY]",
	Group = "DefaultAdmin",
	Args = {
		{ Type = "player", Name = "player", Description = "Target player" }
	}
}