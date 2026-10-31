return {
	Name = "invis",
	Aliases = { "invisible", "stealth" },
	Description = "Выдаёт инструмент невидимости игроку. Использование: invis [player]",
	Group = "DefaultAdmin",
	Args = {
		{
			Type = "player",
			Name = "player",
			Description = "Игрок, которому выдать инструмент (по умолчанию — вы сами)",
			Optional = true
		}
	}
}