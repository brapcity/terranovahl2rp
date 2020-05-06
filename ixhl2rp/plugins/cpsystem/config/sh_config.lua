--[[
	© 2020 TERRANOVA Civil Protection System
	Configuration file
--]]

-- [[ Config settings ]] --
cpSystem.config.cpDefaultDescription = "This is the default description for CPs, set it in the config file.";
cpSystem.config.cpDefaultRank = "D";
cpSystem.config.commandsAccess = {
	["set_cp_id"] = 2,
	["set_cp_rank"] = 2,
	["set_cp_tagline"] = 2,
	["get_cp_access_level"] = 0,
	["view_data"] = 0
}

-- [[ Rank Setup ]] --

-- Rank Access < id | class name | abbreviation > --
Schema.ranks.access.Add(2, "Universal Union", "UU");
Schema.ranks.access.Add(1, "Civil Protection", "CPF");
Schema.ranks.access.Add(0, "Civil Protection", "CPF");

-- Rank <rank tag | rank access level> --
Schema.ranks.Add("A", 2);
Schema.ranks.Add("E", 1);
Schema.ranks.Add("Z", 0);
Schema.ranks.Add("G", 0);
Schema.ranks.Add("D", 0);

-- [[ CP Taglines ]] --
cpSystem.config.taglines = {
	"APEX",
	"BLADE",
	"DAGGER",
	"DASH",
	"DEFENDER",
	"ECHO",
	"FIST",
	"GHOST",
	"GRID",
	"HAMMER",
	"HELIX",
	"HERO",
	"HUNTER",
	"HURRICANE",
	"ICE",
	"ION",
	"JET",
	"JUDGE",
	"JURY",
	"KILO",
	"KING",
	"LINE",
	"LOCK",
	"MACE",
	"NOMAD",
	"NOVA",
	"PHANTOM",
	"QUICKSAND",
	"RANGER",
	"RAZOR",
	"REAPER",
	"SAVAGE",
	"SCAR",
	"SHADOW",
	"SLASH",
	"SPEAR",
	"STAB",
	"STAR",
	"STINGER",
	"STORM",
	"STRIKE",
	"SUNDOWN",
	"SWIFT",
	"SWORD",
	"UNIFORM",
	"UNION",
	"VAMP",
	"VICE",
	"VICTOR",
	"WINDER",
	"XRAY",
	"YELLOW",
	"ZONE"
}

-- [[ Ingame config ]] --
-- [[ You can access these ingame, and is recommended you change their data ingame instead. ]] --
ix.config.Add("City Name", "C17", "The abbreviation used for the 'city' value in Civil Protection System.", nil, {
	category = "[TN] Civil Protection System"
})

ix.config.Add("Abbreviation", "CPF", "The text abbreviation used for the 'abbreviation' value in the Civil Protection System.", nil, {
	category = "[TN] Civil Protection System"
})

ix.config.Add("Naming Scheme", "city.abbreviation:rank.tagline-id", "Naming scheme for civil protection units. values: city, abbreviation, rank, tagline, id, division", nil, {
	category = "[TN] Civil Protection System"
})

ix.config.Add("Dispatch Access Level", 1, "The access level that can access dispatch commands. Access level is tied to ranks in the server file config.", nil, {
	data = {min = 0, max = Schema.ranks.access.GetSize()},
	category = "[TN] Civil Protection System"
})
