return {
	Name = "message",
	Aliases = { "msg" },
	Description = "Send a developer message. [DEV ONLY]",
	Group = "DefaultAdmin",
	Args = {
		{ Type = "messagetype", Name = "type", Description = "\"server\" or \"global\"" },
		{ Type = "string", Name = "message", Description = "The message text" }
	}
}