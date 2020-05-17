--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of the author.
--]]

local PLUGIN = PLUGIN;

ITEM.base = "base_outfit"
ITEM.name = "Legs";
ITEM.model = "models/props_junk/cardboard_box004a.mdl";
ITEM.outfitCategory = "legs";
ITEM.category = "Clothing";
ITEM.description = "Legs Base";
ITEM.width = 1;
ITEM.height = 1;

if (CLIENT) then
	function ITEM:PopulateTooltip(tooltip)
		local panel = tooltip:AddRowAfter("name", "slot")
		panel:SetBackgroundColor(derma.GetColor("Info", tooltip))
		panel:SetText("Slot: " .. self.outfitCategory or "")
		panel:SizeToContents()
	end
end