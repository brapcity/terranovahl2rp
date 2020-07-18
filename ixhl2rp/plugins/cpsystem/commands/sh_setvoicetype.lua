--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]


ix.command.Add("CharSetCPVoiceType", {
	description = "Sets the voice type of a unit.",
    adminOnly = true,
    arguments = {
		ix.type.character,
		ix.type.string
	},
    OnRun = function(self, client, target, text)
        if(target:IsMetropolice()) then
            local acceptedInput = false

            for k, v in pairs(cpSystem.config.voiceTypes) do
                if(v:lower() == text:lower()) then
                    acceptedInput = true
                    break
                end
            end

            if(acceptedInput) then
                target:SetData("cpVoiceType", text)

                if(target:GetPlayer() != client) then
                    client:Notify(string.format("%s has set your voice type to %s.", client:GetName(), text))
                end

                client:Notify(string.format("You have set %s's voice type to %s.", target:GetName(), text))
            else
                local typesString = ""

                for i = 1, #cpSystem.config.voiceTypes do
                    if(i == 1) then
                        typesString = typesString .. cpSystem.config.voiceTypes[i]
                    else 
                        typesString = typesString .. ", " .. cpSystem.config.voiceTypes[i]
                    end
                end

                client:Notify(string.format("%s is not a valid voice type. Voice types: %s", text, typesString))
            end
        else
            client:Notify(target:GetName() .. " is not a part of the Civil Protection faction.")
        end
	end
})