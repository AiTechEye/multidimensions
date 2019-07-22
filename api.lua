multidimensions.register_dimension=function(name,def)
	multidimensions.dim_num = multidimensions.dim_num +1

	def = def or			{}

	def.min_y = def.min_y or			multidimensions.dim_num*1000
	def.max_y = def.max_y or			(multidimensions.dim_num+1)*1000

	def.dirt_start = (def.dirt_start or		501) + def.min_y
	def.dirt_depth = (def.dirt_depth or		3)
	def.ground_limit = (def.ground_limit or		530) + def.min_y
	def.water_depth = def.water_depth or		8
	def.enable_water = def.enable_water == nil
	def.terrain_density = def.terrain_density or	0.4
	def.flatland = def.flatland		


	def.stone = minetest.get_content_id(def.stone or "default:stone")
	def.dirt = minetest.get_content_id(def.dirt or "default:dirt")
	def.grass = minetest.get_content_id(def.grass or "default:dirt_with_grass")
	def.air = minetest.get_content_id(def.air or "air")
	def.water = minetest.get_content_id(def.water or "default:water_source")
	def.sand = minetest.get_content_id(def.sand or "default:sand")
	def.bedrock = minetest.get_content_id(def.bedrock or "multidimensions:bedrock")



	def.map = def.map or {}
	def.map.offset = def.map.offset or 0
	def.map.scale = def.map.scale or 1
	def.map.spread = def.map.spread or {x=100,y=18,z=100}
	def.map.seeddiff = def.map.seeddiff or 24
	def.map.octaves = def.map.octaves or 5
	def.map.persist = def.map.persist or 0.7
	def.map.lacunarity = def.map.lacunarity or 1
	def.map.flags = def.map.flags or "absvalue"

	--def.stone_ores {}
	--def.dirt_ores {}
	--def.grass_ores {}
	--def.ground_ores {}
	--def.air_ores {}
	--def.water_ores {}
	--def.sand_ores {}

	for i1,v1 in pairs(table.copy(def)) do
		if i1:sub(-5,-1) == "_ores" then
			for i2,v2 in pairs(v1) do
				local n = minetest.get_content_id(i2)
				def[i1][n] = {}
				local t = type(v2)
				if t == "number" then
					def[i1][n] = {chance=v2}
				elseif t ~="table" then
					error("Multidimensions: ("..name..") ore "..i2.." defines as number (chance) or table, is: ".. t)
				else
					def[i1][n] = i2
					def[i1][n].chance = def[n].chance or 1000
				end
				def[i1][i2]=nil
			end
		end
	end

	def.teleporter = def.teleporter == nil

	local node = def.teleporter and table.copy(def.node or {})
	local craft = def.teleporter and def.craft and table.copy(def.craft) or nil

	def.node = nil
	def.craft = nil


	multidimensions.registered_dimensions[name]=def

	if def.teleporter then
		node.description = node.description or		"Teleport to dimension " .. name
		node.tiles = node.tiles or			{"default_steel_block.png"}
		node.groups = node.groups or		{cracky=2,not_in_creative_inventory=multidimensions.craftable_teleporters and 0 or 1}
		node.sounds = node.sounds or		default.node_sound_wood_defaults()
		node.after_place_node = function(pos, placer, itemstack)
			local meta=minetest.get_meta(pos)
			meta:set_string("owner",placer:get_player_name())
			meta:set_string("infotext",node.description)		
		end
		node.on_rightclick = function(pos, node, player, itemstack, pointed_thing)
			local owner=minetest.get_meta(pos):get_string("owner")
			local pos2={x=pos.x,y=def.dirt_start+def.dirt_depth+2,z=pos.z}
			if not minetest.is_protected(pos2, owner) then
				multidimensions.move(player,pos2)
			end
		end
		node.mesecons = {effector = {
			action_on = function (pos, node)
			local owner=minetest.get_meta(pos):get_string("owner")
			local pos2={x=pos.x,y=def.dirt_start+def.dirt_depth+2,z=pos.z}
			for i, ob in pairs(minetest.get_objects_inside_radius(pos, 5)) do
				multidimensions.move(ob,pos2)
			end
			return false
		end}},
		minetest.register_node("multidimensions:teleporter_" .. name, node)

		if multidimensions.craftable_teleporters and craft then
			minetest.register_craft({
				output = "multidimensions:teleporter_" .. name,
				recipe = craft,
			})
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	for i,d in pairs(multidimensions.registered_dimensions) do
	if minp.y> d.min_y and maxp.y< d.max_y then
		local depth = 18
		local height = d.dirt_start
		local ground_limit = d.ground_limit
		local dirt_depth = d.dirt_depth
		local water_depth = d.water_depth
		local lenth = maxp.x-minp.x+1
		local cindx = 1
		local map = minetest.get_perlin_map(d.map,{x=lenth,y=lenth,z=lenth}):get_3d_map_flat(minp)
		local enable_water = d.enable_water
		local terrain_density = d.terrain_density
		local flatland = d.flatland

		local miny = d.min_y
		local maxy = d.max_y

		local dirt = d.dirt
		local stone =d.stone
		local grass = d.grass
		local air = d.air
		local water = d.water
		local sand = d.sand
		local bedrock = d.bedrock

		local vm,min,max = minetest.get_mapgen_object("voxelmanip")
		local area = VoxelArea:new({MinEdge = min, MaxEdge = max})
		local data = vm:get_data()

		for z=minp.z,maxp.z do
		for y=minp.y,maxp.y do
			local id=area:index(minp.x,y,z)
		for x=minp.x,maxp.x do
			local den = math.abs(map[cindx]) - math.abs(height-y)/(depth*2) or 0

			if y == miny or y == maxy then
				data[id] = bedrock
			elseif enable_water and den < 0.3 and y <= height+d.dirt_depth+1 and y >= height-water_depth  then	
				data[id] = water
				if y+1 == height+d.dirt_depth+1 then -- fix water holes
					data[id+area.ystride] = water
				else
					data[id-area.ystride]=sand
				end
			elseif y < height then
				data[id] = stone
			elseif y >= height and y <= height+dirt_depth then
				data[id] = dirt
				data[id+area.ystride]=grass
			elseif not flatland then
				if y >= height and y<= ground_limit and den > terrain_density then
					data[id] = dirt
					data[id+area.ystride]=grass
					data[id-area.ystride]=stone
					if den > 1 then
						data[id]=d.stone
					end
				end
			else
				data[id] = air
			end
			cindx=cindx+1
			id=id+1
		end
		end
		end

		for i1,v1 in pairs(data) do
			local da = data[i1]
			local typ
			if da == air and d.ground_ores and data[i1-area.ystride] == grass then
				typ = "ground"
			elseif da == grass and d.grass_ores then
				typ = "grass"
			elseif da == dirt and d.dirt_ores then
				typ = "dirt"
			elseif da == stone and d.stone_ores then
				typ = "stone"
			elseif da == air and d.air_ores then
				typ = "air"
			elseif da == water and d.water_ores then
				typ = "water"
			elseif da == sand and d.sand_ores then
				typ = "sand"
			end
			if typ then
				for i2,v2 in pairs(d[typ.."_ores"]) do
					if math.random(1,v2.chance) == 1 then
						data[i1]=i2
					end
				end
			end
		end
		vm:set_data(data)
		vm:write_to_map()
		vm:update_liquids()
	end
	end
end)

minetest.register_node("multidimensions:bedrock", {
	description = "Bedrock",
	tiles = {"default_stone.png","default_cloud.png","default_stone.png","default_stone.png","default_stone.png","default_stone.png",},
	groups = {unbreakable=1,not_in_creative_inventory = 1},
	paramtype = "light",
	sunlight_propagates = true,
	drop = "",
	diggable = false,
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("multidimensions:tree", {
	drawtype="airlike",
	groups = {multidimensions_tree=1,not_in_creative_inventory=1},
})
minetest.register_node("multidimensions:pine_tree", {
	drawtype="airlike",
	groups = {multidimensions_tree=1,not_in_creative_inventory=1},
})
minetest.register_node("multidimensions:pine_treesnow", {
	drawtype="airlike",
	groups = {multidimensions_tree=1,not_in_creative_inventory=1},
})
minetest.register_node("multidimensions:jungle_tree", {
	drawtype="airlike",
	groups = {multidimensions_tree=1,not_in_creative_inventory=1},
})
minetest.register_node("multidimensions:aspen_tree", {
	drawtype="airlike",
	groups = {multidimensions_tree=1,not_in_creative_inventory=1},
})
minetest.register_node("multidimensions:acacia_tree", {
	drawtype="airlike",
	groups = {multidimensions_tree=1,not_in_creative_inventory=1},
})
minetest.register_node("multidimensions:large_cactus", {
	drawtype="airlike",
	groups = {multidimensions_tree=1,not_in_creative_inventory=1},
})


minetest.register_lbm({
	name = "multidimensions:lbm",
	run_at_every_load = true,
	nodenames = {"group:multidimensions_tree"},
	action = function(pos, node)
		minetest.set_node(pos, {name = "air"})
		local tree=""
		if node.name=="multidimensions:tree" then
			tree=minetest.get_modpath("default") .. "/schematics/apple_tree.mts"
		elseif node.name=="multidimensions:pine_tree" then
			tree=minetest.get_modpath("default") .. "/schematics/pine_tree.mts"
		elseif node.name=="multidimensions:pine_treesnow" then
			tree=minetest.get_modpath("default") .. "/schematics/snowy_pine_tree_from_sapling.mts"
		elseif node.name=="multidimensions:jungle_tree" then
			tree=minetest.get_modpath("default") .. "/schematics/jungle_tree.mts"
		elseif node.name=="multidimensions:aspen_tree" then
			tree=minetest.get_modpath("default") .. "/schematics/aspen_tree.mts"
		elseif node.name=="multidimensions:acacia_tree" then
			tree=minetest.get_modpath("default") .. "/schematics/acacia_tree.mts"
		elseif node.name=="multidimensions:large_cactus" then
			tree=minetest.get_modpath("default") .. "/schematics/large_cactus.mts"
		end
		minetest.place_schematic({x=pos.x,y=pos.y,z=pos.z}, tree, "random", {}, true)
	end,
})

if multidimensions.limited_chat then
minetest.register_on_chat_message(function(name, message)
	local msger = minetest.get_player_by_name(name)
	local pos1 = msger:get_pos()
	for _,player in ipairs(minetest.get_connected_players()) do
		local pos2 = player:get_pos()
		if player:get_player_name()~=name and vector.distance(pos1,pos2)<multidimensions.max_distance_chatt then
			minetest.chat_send_player(player:get_player_name(), "<"..name.."> "..message)
		end
	end
	return true
end)
end


minetest.register_node("multidimensions:teleporter0", {
	description = "Teleport to dimension earth",
	tiles = {"default_steel_block.png","default_steel_block.png","default_mese_block.png^[colorize:#1e6600cc"},
	groups = {choppy=2,oddly_breakable_by_hand=1},
	is_ground_content = false,
	sounds = default.node_sound_wood_defaults(),
	after_place_node = function(pos, placer, itemstack)
		local meta=minetest.get_meta(pos)
		meta:set_string("owner",placer:get_player_name())
		meta:set_string("infotext","Teleport to dimension earth")
	end,
	on_rightclick = function(pos, node, player, itemstack, pointed_thing)
		local owner=minetest.get_meta(pos):get_string("owner")
		local pos2={x=pos.x,y=0,z=pos.z}
		if minetest.is_protected(pos2, owner)==false then
			multidimensions.move(player,pos2)
		end
	end,
	mesecons = {effector = {
		action_on = function (pos, node)
		local owner=minetest.get_meta(pos):get_string("owner")
		local pos2={x=pos.x,y=0,z=pos.z}
		for i, ob in pairs(minetest.get_objects_inside_radius(pos, 5)) do
			multidimensions.move(ob,pos2)
		end
		return false
	end}},
})

if multidimensions.limeted_nametag==true and minetest.settings:get_bool("unlimited_player_transfer_distance")~=false then
	minetest.settings:set_bool("unlimited_player_transfer_distance",false)
	minetest.settings:set_bool("player_transfer_distance",multidimensions.max_distance)
	--minetest.settings:save()
elseif multidimensions.limeted_nametag==false and minetest.settings:get_bool("unlimited_player_transfer_distance")==false then
	minetest.settings:set_bool("unlimited_player_transfer_distance",true)
	minetest.settings:set_bool("player_transfer_distance",0)
end