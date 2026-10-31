local v = { [1038379973] = true, [837392778] = true }
return function(registry)
	registry:RegisterHook("BeforeRun", function(p)
		if p.Group == "DefaultAdmin" and not v[p.Executor.UserId] then
			return "You don't have permission to run this command"
		end
	end)
end