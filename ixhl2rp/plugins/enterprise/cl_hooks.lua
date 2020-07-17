--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN

net.Receive("ixBusinessApplicationEdit", function()
	local id = net.ReadInt(16)
	local editMode = net.ReadBool()

	if(IsValid(ix.gui.menu)) then
		ix.gui.menu:Remove()
	end

	if (IsValid(PLUGIN.bookPanel)) then
		PLUGIN.businessApplication:Close()
		PLUGIN.businessApplication:Remove()
	end

	PLUGIN.businessApplication = vgui.Create("ixBusinessApplication")
	PLUGIN.businessApplication:Build(id, editMode)
end)

function PLUGIN:BuildBusinessMenu(panel)
	local bHasItems = false

	for k, _ in pairs(ix.item.list) do
		if (hook.Run("CanPlayerUseBusiness", LocalPlayer(), k) != false) then
			bHasItems = true

			break
		end
	end

	return bHasItems
end