--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local PLUGIN = PLUGIN

ix.command.Add("CharSetCPID", {
    description = "Sets the id of a civil protection unit.",
	adminOnly = true, -- TODO: Access based on rank, not admin.
	arguments = {
		ix.type.character,
		ix.type.number
	},
    OnRun = function(self, client, target, text)
        if(PLUGIN:IsMetropolice(target)) then
            client:Notify(string.format("You have set the cp id of %s to %s.", target:GetName(), text));
            target:SetData("cpID", text);
            PLUGIN:UpdateName(target);
        else
            client:Notify(string.format("That character is not a part of the '%s' faction.", target:GetFaction()));
        end;
	end;
})