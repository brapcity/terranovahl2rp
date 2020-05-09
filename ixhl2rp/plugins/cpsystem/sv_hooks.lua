--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
	without permission of its author (zacharyenriquee@gmail.com).
--]]

local Schema = Schema;
local PLUGIN = PLUGIN;

function PLUGIN:LoadData()
	for _, v in ipairs(self:GetData() or {}) do
		local entity = ents.Create("ix_uniformgen")
		entity:SetPos(v.pos)
		entity:SetAngles(v.angles)
		entity:Spawn()

		entity:SetModel(v.model)
		entity:SetSkin(v.skin or 0)
		entity:SetSolid(SOLID_BBOX)
		entity:PhysicsInit(SOLID_BBOX)

		local physObj = entity:GetPhysicsObject()

		if (IsValid(physObj)) then
			physObj:EnableMotion(false)
			physObj:Sleep()
		end
	end
end

function PLUGIN:SaveData()
	local data = {}

	for _, entity in ipairs(ents.FindByClass("ix_uniformgen")) do
		data[#data + 1] = {
			pos = entity:GetPos(),
			angles = entity:GetAngles(),
			model = entity:GetModel(),
		}
	end

	self:SetData(data)
end

function Schema:PlayerFootstep(client, position, foot, soundName, volume)
	local factionTable = ix.faction.Get(client:Team());
	local character = client:GetCharacter();

	if(character:IsUndercover()) then
		client:EmitSound(soundName);
		return true;
	end;

	if (factionTable.runSounds and client:IsRunning()) then
		client:EmitSound(factionTable.runSounds[foot]);
		return true;
	end

	client:EmitSound(soundName);
	return true;
end

function PLUGIN:PlayerLoadedCharacter(client, character, oldCharacter)
	local faction = character:GetFaction()
	
	if(faction == FACTION_SCN) then
		print("this")
		character:SetClass(CLASS_SCN);
	end;

 	-- Updates player name if the city has been changed. --
	if(faction == FACTION_MPF) then
		if(character:GetName() == PLUGIN:GetCPName(character)) then
			if(!string.find(character:GetName(), ix.config.Get("City Name"))) then 
				character:SetName(PLUGIN:GetCPName(character));
			end;
		end;
	end;

	-- Adds player to the correct class --
	if(faction == FACTION_MPF) then
		if (!string.find(character:GetName(), ix.config.Get("City Name"))) then
			character:SetClass(CLASS_MPUH);  
		else
			character:SetClass(CLASS_MPU); 		
		end;
	end;
end;

-- Called just after a player spawns.
function PLUGIN:PlayerSpawn(client)
	if (client:IsCombine()) then
		netstream.Start(client, "RecalculateHUDObjectives", PLUGIN.socioStatus)
	end;
end;

function PLUGIN:CanPlayerEquipItem(client, item)
	local character = client:GetCharacter();

	if(item.base == "base_cp_gasmask" or item.name == "Civil Protection Trenchcoat") then
		if(character:IsUndercover()) then
			if(!PLUGIN:IsWearingUniform(character)) then
				client:Notify(string.format("You cant equip %s without a uniform on!", item.name))
				return false;
			end;
		end;
	end;

	return true;
end

netstream.Hook("ViewDataUpdate", function(client, target, text, combinePoints)
	if (IsValid(target) and client:GetCharacter() and target:GetCharacter()) then
		local data = {
			text = text,
			editor = client:GetCharacter():GetName(),
			points = combinePoints
		}

		target:GetCharacter():SetData("combineData", data)
		Schema:AddCombineDisplayMessage("@cViewDataFiller", nil, client)
	end
end)