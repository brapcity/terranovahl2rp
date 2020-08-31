--[[
	© 2020 TERRANOVA do not share, re-distribute or modify
    without permission of its author (zacharyenriquee@gmail.com).
    
    This content is only intended to be used on the TERRANOVA
    Half-Life 2 Roleplay server. Please respect the developers.
--]]

PLUGIN.name = "Crafting"
PLUGIN.description = "Description has not been completed yet."
PLUGIN.author = "Adolphus & Ayreborne"
PLUGIN.recipes = {}

ix.util.IncludeFolder(PLUGIN, "meta")
ix.util.Include("sv_hooks.lua")

-- Called when the plugins are being loaded and we need to include any recipes or professions.
function PLUGIN:OnLoaded()
	for _, path in ipairs(self.paths or {}) do
		ix.profession.LoadFromDir(path.."/professions")
		ix.stations.LoadFromDir(path.."/stations")

		for k, v in pairs(ix.profession.stored) do
			ix.recipe.LoadFromDir(path.."/recipes/".. v.uniqueID, v.uniqueID)
		end
	end
end