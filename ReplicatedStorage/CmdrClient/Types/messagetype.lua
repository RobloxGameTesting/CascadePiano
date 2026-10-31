return function(registry)
	registry:RegisterType("messagetype", {
		Transform = function(value)
			return string.lower(value)
		end,
		Validate = function(p)
			if p == "server" or p == "global" then
				return true
			end

			return false, "Must be \"server\" or \"global\""
		end,
		Autocomplete = function(list)
			local result = {}

			for _, v in ipairs({ "server", "global" }) do
				if v:sub(1, #list) == list then
					table.insert(result, v)
				end
			end

			return result
		end,
		Parse = function(p)
			return p
		end
	})
end