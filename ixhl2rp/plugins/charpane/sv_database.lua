--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author.
--]]

local PLUGIN = PLUGIN;

-- Called when server is starting, if the database doesnt exist it will create.
function PLUGIN:DatabaseConnected()
    local query

	-- New table to hold character panel data.
	query = mysql:Create("ix_charpanels")
		query:Create("panel_id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
		query:Create("character_id", "INT(11) UNSIGNED NOT NULL")
		query:PrimaryKey("panel_id")
	query:Execute()

	-- Added panel_id to the item table.
	query = mysql:Create("ix_items")
		query:Create("item_id", "INT(11) UNSIGNED NOT NULL AUTO_INCREMENT")
		query:Create("inventory_id", "INT(11) UNSIGNED NOT NULL")
		query:Create("panel_id", "INT(11) UNSIGNED DEFAULT NULL")
		query:Create("unique_id", "VARCHAR(60) NOT NULL")
		query:Create("character_id", "INT(11) UNSIGNED DEFAULT NULL")
		query:Create("player_id", "VARCHAR(20) DEFAULT NULL")
		query:Create("data", "TEXT DEFAULT NULL")
		query:Create("x", "SMALLINT(4) NOT NULL")
		query:Create("y", "SMALLINT(4) NOT NULL")
		query:PrimaryKey("item_id")
	query:Execute()
end;

-- Called when all tables are being wiped.
function PLUGIN:OnWipeTables()
    local query

    query = mysql:Drop("ix_charpanels")
	query:Execute()
end

function PLUGIN:PlayerLoadedCharacter(client, character, currentChar)
	local charID = character:GetID();

	local charPanelQuery = mysql:Select("ix_charpanels")
		charPanelQuery:Select("panel_id")
		charPanelQuery:Where("character_id", charID)
		charPanelQuery:Callback(function(info)
			if (istable(info) and #info > 0) then
				local row = info[1];

				ix.charPanel.RestoreCharPanel(tonumber(row.panel_id), function(charPanel)
					character:SetCharPanel(charPanel)
					charPanel:SetOwner(lastID)
					charPanel:Sync(client)
				end, true)
			else
				local insertQuery = mysql:Insert("ix_charpanels")
					insertQuery:Insert("character_id", charID)
					insertQuery:Callback(function(_, status, lastID)
						local charPanel = ix.charPanel.CreatePanel(lastID);
						character:SetCharPanel(charPanel)
						charPanel:SetOwner(lastID)		
						charPanel:Sync(client)
					end)
				insertQuery:Execute()
			end
		end)
	charPanelQuery:Execute()
end