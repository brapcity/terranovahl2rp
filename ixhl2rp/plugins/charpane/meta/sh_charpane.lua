--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

ix.charPanel = ix.charPanel or {}
ix.charPanels = ix.charPanels or {
	[0] = {}
}

function ix.charPanel.CreatePanel(id)
	local panel = setmetatable({id = id, slots = {}, vars = {}, receivers = {}}, ix.meta.charPanel)
		ix.charPanels[id] = panel

	return panel
end

function ix.charPanel.RestoreCharPanel(panelID, callback)
	if (!isnumber(panelID) or panelID < 0) then
		error("Attempt to restore inventory with an invalid ID!")
	end

	ix.charPanel.CreatePanel(panelID)

	local query = mysql:Select("ix_items")
		query:Select("item_id")
		query:Select("inventory_id")
		query:Select("panel_id")
		query:Select("unique_id")
		query:Select("data")
		query:Select("character_id")
		query:Select("player_id")
		query:Where("panel_id", panelID)
		query:Callback(function(result)
			local badItemsUniqueID = {}

			if (istable(result) and #result > 0) then
				local invSlots = {}
				local badItems = {}

				for _, item in ipairs(result) do
					local itemPanelID = tonumber(item.panel_id)

					if (itemPanelID != panelID) then
						badItemsUniqueID[#badItemsUniqueID + 1] = item.unique_id
						badItems[#badItems + 1] = tonumber(item.item_id)

						continue
					end

					local inventory = ix.charPanels[panelID]
					local itemID = tonumber(item.item_id)
					local data = util.JSONToTable(item.data or "[]")
					local characterID, playerID = tonumber(item.character_id), tostring(item.player_id)

					if (itemID) then
						local item2 = ix.item.New(item.unique_id, itemID)

						if (item2) then
							invSlots[itemPanelID] = invSlots[itemPanelID] or {}
							local slots = invSlots[itemPanelID]

							item2.data = {}

							if (data) then
								item2.data = data
							end

							item2.invID = itemInvID
							item2.characterID = characterID
							item2.playerID = (playerID == "" or playerID == "NULL") and nil or playerID


							if (item2.OnRestored) then
								--item2:OnRestored(item2, itemInvID)
							end
						else
							badItemsUniqueID[#badItemsUniqueID + 1] = item.unique_id
							badItems[#badItems + 1] = itemID
						end
					end
				end

				for k, v in pairs(invSlots) do
					ix.charPanels[k].slots = v
				end

				if (!table.IsEmpty(badItems)) then
					local deleteQuery = mysql:Delete("ix_items")
						deleteQuery:WhereIn("item_id", badItems)
					deleteQuery:Execute()
				end
			end

			if (callback) then
				callback(ix.charPanels[panelID], badItemsUniqueID)
			end
		end)
	query:Execute()
end

local META = ix.meta.charPanel or {}
META.__index = META
META.slots = META.slots or {}
META.vars = META.vars or {}
META.receivers = META.receivers or {}

function META:__tostring()
	return "charpanel["..(self.id or 0).."]"
end

function META:GetID()
	return self.id or 0
end

function META:GetOwner()
	for _, v in ipairs(player.GetAll()) do
		if (v:GetCharacter() and v:GetCharacter().id == self.owner) then
			return v
		end
	end
end

function META:SetOwner(owner, fullUpdate)
	if (type(owner) == "Player" and owner:GetNetVar("char")) then
		owner = owner:GetNetVar("char")
	elseif (!isnumber(owner)) then
		return
	end
	if (SERVER) then
		if (fullUpdate) then
			for _, v in ipairs(player.GetAll()) do
				if (v:GetNetVar("char") == owner) then
					self:Sync(v, true)

					break
				end
			end
		end

		local query = mysql:Update("ix_charpanels")
			query:Update("character_id", owner)
			query:Where("panel_id", self:GetID())
		query:Execute()
	end

	self.owner = owner
end

function META:OnCheckAccess(client)
	local bAccess = false

	for _, v in ipairs(self:GetReceivers()) do
		if (v == client) then
			bAccess = true
			break
		end
	end

	return bAccess
end

function META:GetItemAt(category)
	if (self.slots and self.slots[category]) then
		return self.slots[category]
	end
end

function META:Remove(id, bNoReplication, _, bTransferring)
    local category
    for k, v in pairs(self.slots) do
        local item = self.slots[k]

        if(item and item.id == id) then
            self.slots[k] = nil

            category = category or k;
        end;
    end;

	if (SERVER and !bNoReplication) then
		local receivers = self:GetReceivers()

        if (istable(receivers)) then
            --[[ TODO
			net.Start("ixInventoryRemove")
				net.WriteUInt(id, 32)
				net.WriteUInt(self:GetID(), 32)
            net.Send(receivers)
            --]]
		end

		-- we aren't removing the item - we're transferring it to another inventory
		if (!bTransferring) then
			--hook.Run("InventoryItemRemoved", self, ix.item.instances[id])
		end
	end

	return category
end

function META:AddReceiver(client)
	self.receivers[client] = true
end

function META:RemoveReceiver(client)
	self.receivers[client] = nil
end

function META:GetReceivers()
	local result = {}

	if (self.receivers) then
		for k, _ in pairs(self.receivers) do
			if (IsValid(k) and k:IsPlayer()) then
				result[#result + 1] = k
			end
		end
	end

	return result
end

if (SERVER) then

end

ix.meta.charPanel = META