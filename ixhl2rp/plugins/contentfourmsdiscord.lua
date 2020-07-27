local PLUGIN = PLUGIN
PLUGIN.name = "Link Commands"
PLUGIN.author = "Ayreborne"
PLUGIN.description = "Adds links to the various Terra-Nova Content"

PLUGIN.urls = {
	["Discord"] = "https://discord.gg/4fTSp6Y",
	["Forums"] = "https://forum.terranova-rp.com/index.php",
	["Content"] = "https://steamcommunity.com/sharedfiles/filedetails/?id=2079140662"
}

-- Adding commands for URLs.
for k,v in pairs(PLUGIN.urls) do
	ix.command.Add(k, {
		description = "Directs you to our " .. k .. ".",
		OnRun = function(self, client)
			local lua = "gui.OpenURL('" .. v .. "')"
			client:SendLua(lua)
		end
	})
end