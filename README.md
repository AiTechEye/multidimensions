# multidimensions
Licenses: code: LGPL-2.1, media: CC BY-SA-4.0  
Version: 2.4

Multi dimensions
This mod adds a few dimensions to the game (you can add more)

You can find the "Dimensions teleport tool" in creative to go to them, or type "/giveme dim"
(You need the "dimensions" privilege to use it)
Teleport yourself to dimensions by point in air/blocks, or teleport other players/objects by pointing them.

There are also crafable "teleport blocks" (click to teleport, and works with mesecons)

All teleported players that not have the "dimensions" privilege will get there spawnpoin and home set in the new dimension (using "beds" and "sethome")
They cant get back unless teleporting in somehow or have/making "teleport blocks"

Player cant see or hear players from "other diamnsions" or just if they are 800 blocks away

You can change settings in the init.lua

Used settings:
unlimited_player_transfer_distance=false
player_transfer_distance=50
[Main manu[--> [Settings[ --> [Advanced Settings[ --> [Server / Singleplayer[ --> [Game]


---
# The API Documentation

This mod contains an API for registering and generating new dimensions, or worlds, at different heights in the game world. For this purpose, several methods and functions have been implemented, with many parameters to customize mapgen even more.

Before proceeding, one should at minimum a basic level of understanding of [Lua Programming Language](http://www.lua.org/pil/) and basic programming concepts.

Below is an example of how to register a new dimension using the API:

```lua

multidimensions.clear_dimensions() -- clear all dimensions

multidimensions.register_dimension("name",{

  ground_ores = {
    ["default:tree"] = 1000,            -- (chance) ... spawns on ground, used by trees, grass, flowers...
    ["default:stone"] = {chance=1000}, 	-- same as above
    ["default:dirt_with_snow"] = {	-- names will be remade to content_id
    	chance=5000,	     -- chance
	min_heat=10,	     -- min heat
	max_heat=40,	     -- max heat
	chunk=3,	     -- chunk size
    },
  },
  stone_ores = {},     	     -- works as above, but in stone
  deep_stone_ores = {},
  dirt_ores = {},
  grass_ores = {},
  air_ores = {},
  water_ores = {},
  sand_ores = {},
  
  self = {},		    -- can contain everything, var like dirt="default:dirt" will be remade to dirt=content_id
  
  dim_y = 2000,             -- dimension start (don't change if you don't know what you're doing)
  dim_height =  1000,	    -- dimension height
  deep_y = 240,
  
  dirt_start 501,           -- when dirt begins to appear (default is 501)
  dirt_depth = 3,	    -- dirt depth
  ground_limit = 530,	    -- ground y limit (ground ends here)
  water_depth = 8,	    -- depth fron ground and down
  enable_water = nil,       -- (nil = true)
  terrain_density = 0.4,    -- or ground density
  cave_threshold = 0.075,   -- threshold below which caves carved
  flatland = nil,           -- (nil = false)
  teleporter = nil,         -- (nil = true) dimension teleporter
  gravity = 1,		    -- (1 = default) dimension gravity
  
  stone = "default:stone",
  dirt = "default:dirt",
  grass = "default:dirt_with_grass",
  air = "air",
  water = "default:water_source",
  sand = "default:sand",
  bedrock = "multidimensions:bedrock", -- at dimension edges
  
  map = {
    offset = 0,
    scale = 1,
    spread = {x=100,y=18,z=100},
    seeddiff = 24,
    octaves = 5,
    persist = 0.7,
    lacunarity = 1,
    flags = "absvalue",
   },
   
   cavemap = {
    offset = 0,
    scale = 1,
    spread = {x=70,y=30,z=70},
    seeddiff = 128,
    octaves = 5,
    persist = 0.2,
    lacunarity = 1.4,
    flags = "defaults, absvalue",
   },
   
   craft = { -- teleport craft recipe
	{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
	{"default:wood","default:mese","default:wood",},
	{"default:obsidianbrick", "default:steel_ingot", "default:obsidianbrick"},
   }

   on_generate=function(self,data,id,area,x,y,z)
	if y <= self.dirt_start+5 then
		data[id] = self.air
	else
		return
	end
	return data -- to return changes
   end,
   
   -- data: active generating area (VoxelArea)
   -- index: data index
   -- self: {dim_start, dim_end, dim_height, ground_limit, heat, humidity, dirt, stone, grass, air, water, sand, bedrock ... and your inputs
    area: (VoxelArea:new({MinEd...)
   
   sky = {{r=219, g=168, b=117},"plain",{}}, -- same as:set_sky()
   
   on_enter=function(player) --on enter dimension
   end,
   
   on_leave=function(player) --on leave dimension
   end,
   
})
```


---
## Methods and Functions

Lorem ipsum add info here later
