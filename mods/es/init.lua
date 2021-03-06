--Extreme Survival created by maikerumine
-- Minetest 0.4.13 mod: "Extreme Survival"
-- namespace: es
--https://github.com/maikerumine

--License:
--~~~~~~~~
--Code:
--(c) Copyright 2015 maikerumine; modified zlib-License
--see "LICENSE.txt" for details.

--Media(if not stated differently):
--(c) Copyright (2014-2015) maikerumine; CC-BY-SA 3.0

es = {}
--NOTE:  THIS--v  v--MUST BE FIRST IN THE INIT FOR EVERYTHING TO WORK
enable_stairsplus = true

local load_start = os.clock()
local modpath = minetest.get_modpath("es")
es.modpath = modpath

-- REMOVE NODES DO NOT USE IN YOUR WORLD
--dofile(modpath.."/technodrem.lua")
--dofile(modpath.."/moreorerem.lua")
--dofile(modpath.."/villrem.lua")

-- Alias
dofile(modpath.."/alias.lua")

-- Anticheat by RND
dofile(modpath.."/anticheat.lua")

-- Armor [abort migration]
dofile(modpath.."/armor.lua")

-- Craft recipes for items
dofile(modpath.."/crafting.lua")

-- Shutdown
dofile(modpath.."/shutdown.lua")

--Spawn
dofile(modpath.."/spawn.lua")

-- Nodes
dofile(modpath.."/nodes.lua")
dofile(modpath.."/crushingfurnace.lua")

-- Ore Generation
dofile(modpath.."/oregen.lua")

-- Tools
dofile(modpath.."/tools.lua")
dofile(modpath.."/screwdriver.lua")
--dofile(modpath.."/hoes.lua")

-- Climate  very laggy
--dofile(minetest.get_modpath("es").."/freeze.lua")
--dofile(minetest.get_modpath("es").."/snow.lua")
--dofile(minetest.get_modpath("es").."/thaw.lua")

--MOREBLOCKS / STAIRSPLUS SUPPORT
if moreblocks then
dofile(modpath.."/mostair.lua")
end

--STAIR SUPPORT
if stairs then
dofile(modpath.."/stair.lua")
end

--MAP GENERATION SELECTION SWITCH
--Enter a number between 0 and 5 to choose map style.
es.MAP_SETTING = 0;

-- Map Generation
--(CURRENTLY YOU NEED TO REPLACE THE DEFAULT WITH
--the one that says stone IF YOU WANT AN ALL STONE WORLD.)
--MAP GENERATION SELECTION SWITCH
--ES OVERRIDE  SETTINGS IN INIT FILE IN ES FOLDER

	if es.MAP_SETTING == 0 then	--DEFAULT MAPGEN
		dofile(minetest.get_modpath("default").."/mapgen.lua")
	end
	if es.MAP_SETTING == 1 then	--ALL STONE LIKE JUST TEST
		dofile(modpath.."/mapgen-stone.lua")
	end
	if es.MAP_SETTING == 2 then	--ALL DESERT -STONE STARTS AT -413
		dofile(modpath.."/mapgen-desert.lua")
	end
	if es.MAP_SETTING == 3 then	--STONE, DESERT, ALPINE CLIMATE
		dofile(modpath.."/mapgen-es.lua")
	end
	if es.MAP_SETTING == 4 then	--NO DESERT OR COLD CLIMATE
		dofile(modpath.."/mapgen-v7green.lua")
	end
	if es.MAP_SETTING == 5 then	--ALWAYS CURRENT  FROM MINETEST_GAME
		dofile(modpath.."/mapgen-v7green_current.lua")
	end

--MAPFIX CODE  (USE WHEN DARK SHADOWS FORM, TYPE /MAPFIX)
minetest.register_chatcommand("mapfix", {
	params = "<size>",
	description = "Recalculate the flowing liquids of a chunk",
	func = function(name, param)
		local pos = minetest.get_player_by_name(name):getpos()
		local size = tonumber(param) or 40
		if size > 50 and not minetest.check_player_privs(name, {server=true}) then
			return false, "You need the server privilege to exceed the radius of 50 blocks"
		end
		local minp, maxp = {x = math.floor(pos.x - size), y = math.floor(pos.y - size), z = math.floor(pos.z - size)}, {x = math.ceil(pos.x + size), y = math.ceil(pos.y + size), z = math.ceil(pos.z + size)}
		local vm = minetest.get_voxel_manip()
		vm:read_from_map(minp, maxp)
		vm:calc_lighting()
		vm:update_liquids()
		vm:write_to_map()
		vm:update_map()
		return true, "Done."
	end,
})
