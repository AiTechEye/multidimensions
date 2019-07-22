local ores={
	["default:stone_with_coal"]=200,
	["default:stone_with_iron"]=400,
	["default:stone_with_copper"]=500,
	["default:stone_with_gold"]=2000,
	["default:stone_with_mese"]=10000,
	["default:stone_with_diamond"]=20000,
	["default:mese"]=40000,
	["default:gravel"]=3000
}

local plants = {
	["flowers:mushroom_brown"] = 1000,
	["flowers:mushroom_red"] = 1000,
	["flowers:mushroom_brown"] = 1000,
	["flowers:rose"] = 1000,
	["flowers:tulip"] = 1000,
	["flowers:dandelion_yellow"] = 1000,
	["flowers:geranium"] = 1000,
	["flowers:viola"] = 1000,
	["flowers:dandelion_white"] = 1000,
	["default:junglegrass"] = 2000,
	["default:papyrus"] = 2000,
	["default:grass_3"] = 10,

	["multidimensions:tree"] = 1000,
	["multidimensions:aspen_tree"] = 1000,
	["multidimensions:pine_tree"] = 1000,
}

multidimensions.register_dimension("earthlike1",{
	ground_ores = table.copy(plants),
	stone_ores = table.copy(ores),
	sand_ores={["default:clay"]=100},
	node={description="Alternative earth"},
	craft = {
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
		{"default:wood","default:mese","default:wood",},
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	}
})

multidimensions.register_dimension("earthlike2",{
	ground_ores = table.copy(plants),
	stone_ores = table.copy(ores),
	sand_ores={["default:clay"]=100},
	node={description="Alternative earth 2"},
	map={spread={x=20,y=18,z=20}},
	ground_limit=550,
	craft = {
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
		{"default:aspen_wood","default:mese","default:aspen_wood",},
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	}
})

multidimensions.register_dimension("savana",{
	ground_ores = {
		["default:dry_shrub"]=50,
		["default:dry_grass_4"]=10,
		["multidimensions:acacia_tree"]=5000,
		["multidimensions:jungle_tree"]=7000,
	},
	grass="default:dirt_with_dry_grass",
	stone_ores = table.copy(ores),
	sand_ores={["default:clay"]=100},
	node={description="Savana"},
	craft = {
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
		{"default:acacia","default:mese","default:acacia",},
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	}
})

multidimensions.register_dimension("cold",{
	ground_ores = {
		["default:snow"]=100,
		["multidimensions:pine_treesnow"]=8000,
	},
	dirt="default:snowblock",
	grass="default:snowblock",
	water="default:ice",
	stone="default:ice",
	sand="default:ice",
	node={description="cold"},
	craft = {
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
		{"default:aspen_wood","default:mese","default:aspen_wood",},
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	}
})

multidimensions.register_dimension("desert",{
	dirt="default:desert_sand",
	grass="default:desert_sand",
	stone="default:desert_stone",
	sand="default:desert_sand",
	node={description="desert"},
	enable_water=false,
	map={octaves=2,persist=0.3,lacunarity=2},
	craft = {
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
		{"default:desert_stone","default:mese","default:desert_stone",},
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	}
})

multidimensions.register_dimension("hot",{
	ground_ores = {
		["fire:permanent_flame"]=10,
	},
	dirt="default:stone",
	grass="default:stone",
	sand="default:lava_source",
	water="default:lava_source",
	map={octaves=3,persist=0.6,lacunarity=2},
	node={description="Hot"},
	craft = {
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
		{"default:torch","default:mese","default:torch",},
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	}
})


multidimensions.register_dimension("water",{
	dirt="default:water_source",
	grass="default:water_source",
	sand="default:stone",
	node={description="Water"},
	flatland=1,
	stone="default:water_source",
	air="default:water_source",
	craft = {
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
		{"default:sand","default:mese","default:sand",},
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	}
})

multidimensions.register_dimension("sandstone",{
	dirt="default:sandstone",
	grass="default:sandstone",
	sand="default:sandstone",
	node={description="Sandstone"},
	stone="default:sandstone",
	enable_water=false,
	craft = {
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
		{"default:sandstone","default:mese","default:sandstone",},
		{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	}
})	