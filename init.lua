multidimensions={
	start_y=4000,
	max_distance=50, --(50 is 800)
	max_distance_chatt=800,
	limited_chat=true,
	limeted_nametag=true,
	teleports=true,
	craftable=true,
	remake_home=true,
	remake_bed=true,
	dimensions={},
	user={},
	levels={{4,994},{994,998},{998,1000}},


	craftable_teleporters=true,

	dim_num=1,
	registered_dimensions={},


	map={
		offset=0,
		scale=1,
		spread={x=100,y=18,z=100},
		seeddiff=24,
		octaves=5,
		persist=0.7,
		lacunarity=1,
		flags="absvalue",
	},

	map2={
		offset=0,
		scale=1,
		spread={x=350,y=18,z=350},
		seeddiff=24,
		octaves=3,
		persist=0.6,
		lacunarity=2,
		flags="absvalue",
	},


}


dofile(minetest.get_modpath("multidimensions") .. "/api.lua")
dofile(minetest.get_modpath("multidimensions") .. "/dimensions.lua")
dofile(minetest.get_modpath("multidimensions") .. "/tools.lua")