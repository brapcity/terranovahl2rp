--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharSetCPTagline", {
    description = "Sets the tagline of a civil protection unit.",
    permission = "Set CP Tagline",
	arguments = {
		ix.type.character,
		ix.type.string
	},
    OnRun = function(self, client, target, text)
        local character = client:GetCharacter()
        
        if(character:HasOverride() or ix.ranks.HasPermission(character:GetRank().uniqueID, "Set CP Tagline")) then
            if(target:IsMetropolice()) then
                if(PLUGIN:TaglineExists(text)) then
                    client:Notify(string.format("You have set the tagline of %s to %s.", target:GetName(), text));

                    -- Remove only if the input is different from the current tagline.
                    if(text != target:GetData("cpTagline")) then
                        PLUGIN:RemoveFromCache(target:GetPlayer(), target)
                    end

                    target:SetData("cpTagline", text);
                    target:UpdateCPStatus()
                else
                    client:Notify(string.format("The tagline '%s' does not exist.", text));
                end;
            else
                client:Notify(string.format("That character is not a part of the '%s' faction.", target:GetFaction()));
            end;
        else
            client:Notify("This command requires the 'Set CP Tagline' permission, which you do not have.");
        end;
	end;
})