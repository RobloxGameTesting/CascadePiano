local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
return function(cmdr)
	local util = cmdr.Util
	local Window = require(script:WaitForChild("Window"))
	Window.Cmdr = cmdr
	local AutoComplete = require(script:WaitForChild("AutoComplete"))
	local autoComplete = AutoComplete(cmdr)
	Window.AutoComplete = autoComplete

	function Window.ProcessEntry(p)
		local trimString = util.TrimString(p)

		if #trimString == 0 then
			return
		end

		Window:AddLine(Window:GetLabel() .. " " .. trimString, Color3.fromRGB(255, 223, 93))
		Window:AddLine(cmdr.Dispatcher:EvaluateAndRun(trimString, LocalPlayer, { IsHuman = true }))
	end

	function Window.OnTextChanged(value)
		local evaluate = cmdr.Dispatcher:Evaluate(value, LocalPlayer, true)
		local splitString = util.SplitString(value)
		local v = table.remove(splitString, 1)
		local v2

		if evaluate then
			splitString = util.MashExcessArguments(splitString, #evaluate.Object.Args)

			if #splitString == #evaluate.Object.Args then
				v2 = true
			else
				v2 = false
			end
		else
			v2 = false
		end

		local v3 = v and #splitString > 0

		if value:sub(#value, #value):match("%s") and not v2 then
			splitString[#splitString + 1] = ""
			v3 = true
		end

		if evaluate and v3 then
			local v4, v5 = evaluate:Validate()
			Window:SetIsValidInput(v4, ("Validation errors: %s"):format(v5 or ""))
			local v6 = {}
			local argument = evaluate:GetArgument(#splitString)

			if argument then
				local textSegmentInProgress = argument.TextSegmentInProgress
				local isPartial = false

				if argument.RawSegmentsAreAutocomplete then
					for i, rawSegment in ipairs(argument.RawSegments) do
						v6[i] = { rawSegment, rawSegment }
					end
				else
					local autocomplete, v7 = argument:GetAutocomplete()
					isPartial = (v7 or {}).IsPartial or false

					for k, v8 in pairs(autocomplete) do
						v6[k] = { textSegmentInProgress, v8 }
					end
				end

				local v7

				if #textSegmentInProgress > 0 then
					v7, v5 = argument:Validate()
				else
					v7 = true
				end

				if not v2 and v7 then
					Window:HideInvalidState()
				end

				return autoComplete:Show(v6, {
					at = v2 and #value - #textSegmentInProgress + (value:sub(#value, #value):match("%s") and -1 or 0),
					prefix = #argument.RawSegments ~= 1 and "" or argument.Prefix or "",
					isLast = #evaluate.Arguments == #evaluate.ArgumentDefinitions and #textSegmentInProgress > 0,
					numArgs = #splitString,
					command = evaluate,
					arg = argument,
					name = argument.Name .. (argument.Required and "" or "?"),
					type = argument.Type.DisplayName,
					description = v7 == false and v5 or argument.Object.Description,
					invalid = not v7,
					isPartial = isPartial
				})
			end
		elseif v and #splitString == 0 then
			Window:SetIsValidInput(true)
			local command = cmdr.Registry:GetCommand(v)
			local v4 = nil

			if command then
				v4 = {
					command.Name,
					command.Name,
					options = { name = command.Name, description = command.Description }
				}
				local v5 = command.Args and command.Args[1]

				if type(v5) == "function" then
					v5 = v5(evaluate)
				end

				if v5 and not v5.Optional and v5.Default == nil then
					Window:SetIsValidInput(false, "This command has required arguments.")
					Window:HideInvalidState()
				end
			else
				Window:SetIsValidInput(
					false,
					("%q is not a valid command name. Use the help command to see all available commands."):format(v)
				)
			end

			local v5 = { v4 }

			for _, v6 in pairs(cmdr.Registry:GetCommandNames()) do
				if not (v:lower() == v6:lower():sub(1, #v) and (v4 == nil or v4[1] ~= v)) then
					continue
				end

				local command2 = cmdr.Registry:GetCommand(v6)
				v5[#v5 + 1] = {
					v,
					v6,
					options = { name = command2.Name, description = command2.Description }
				}
			end

			return autoComplete:Show(v5)
		end

		Window:SetIsValidInput(false, "Use the help command to see all available commands.")
		autoComplete:Hide()
	end

	Window:UpdateLabel()
	Window:UpdateWindowHeight()
	return { Window = Window, AutoComplete = autoComplete }
end