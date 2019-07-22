# multidimensions
Licenses: code: LGPL-2.1, media: CC BY-SA-4.0  
Version: 1.95  

# the info is currently incorrect, changing it later, but the mod is fully working





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

Advanced information:
The dimensions starts at +4000 height and there are 2000 height between them
all diamnsions are 31000x2000x31000 big (exept the earth that are 31000x35000x31000)
the earth alternativ starts at y+4000... ground 5000, eath alternativ 2 y+6000, ground y+7000...

If you are teleporting using commands you can easily teleport between y+5000, y+7000, y+9000...

Used settings:
unlimited_player_transfer_distance=false
player_transfer_distance=50
[Main manu[--> [Settings[ --> [Advanced Settings[ --> [Server / Singleplayer[ --> [Game]
