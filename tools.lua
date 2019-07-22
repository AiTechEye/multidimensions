minetest.register_privilege("dimensions", {
	description = "Can use dimensions teleport tool",
	give_to_singleplayer= false,
})

minetest.register_alias("dim", "multidimensions:teleporttool")

multidimensions.setrespawn=function(object,pos)
	if not object:is_player() then return false end
	local name=object:get_player_name()
	if minetest.check_player_privs(name, {dimensions=true}) then return false end
	if multidimensions.remake_bed and minetest.get_modpath("beds")~=nil then
		beds.spawn[name]=pos
		beds.save_spawns()
	end
	if multidimensions.remake_home and minetest.get_modpath("sethome")~=nil then
		sethome.set(name, pos)
	end
end

multidimensions.form=function(player,object)
	local name=player:get_player_name()
	local buttons=""
	local y=1
	local x=3
	local n=2
	local info=""
	multidimensions.user[name]={}
	multidimensions.user[name].pos=object:get_pos()
	multidimensions.user[name].object=object
	if object:is_player() and object:get_player_name()==name then
		info="Teleport you"
	elseif object:is_player() and object:get_player_name()~=name then
		info="Teleport "..object:get_player_name()
	else
		info="Teleport object"
	end
	buttons="button_exit[0,1;3,1;earth;earth]"
	for i, but in pairs(multidimensions.registered_dimensions) do
		buttons=buttons .."button_exit[" .. x.. "," .. y .. ";3,1;" .. i .. ";" .. i .. "]"
		if x==3 then
			y=y+1
			x=0
		else
			x=3
		end
		n=n+1
	end
	local gui=""
	gui=""
	.."size[6.5," .. (y+1) .."]"
	.."label[2,0;" .. info .."]" 
	..buttons
	minetest.after(0.1, function(gui)
		return minetest.show_formspec(player:get_player_name(), "multidimensions.form",gui)
	end, gui)
end

minetest.register_on_player_receive_fields(function(player, form, pressed)
	if form=="multidimensions.form" then
		local name=player:get_player_name()
		local pos=multidimensions.user[name].pos
		local object=multidimensions.user[name].object
		local y=0
		local pos=object:get_pos()
		multidimensions.user[name]=nil

		if pressed.earth then
			multidimensions.move(object,{x=pos.x,y=0,z=pos.z})
			return
		end

		for i, v in pairs(multidimensions.registered_dimensions) do
			local pos2={x=pos.x,y=v.dirt_start+v.dirt_depth+1,z=pos.z}
			if pressed[i] and minetest.is_protected(pos2, name)==false then
				multidimensions.move(object,pos2)
				return
			end
		end
		return
	end
end)

minetest.register_tool("multidimensions:teleporttool", {
	description = "Dimensions teleport tool",
	inventory_image = "default_stick.png^[colorize:#e9ff00ff",
on_use = function(itemstack, user, pointed_thing)
	local pos=user:get_pos()
	local name=user:get_player_name()

	if minetest.check_player_privs(name, {dimensions=true})==false then
		itemstack:replace(nil)
		minetest.chat_send_player(name,"You need the dimensions privilege to use this tool")
		return itemstack
	end

	local object={}
	if pointed_thing.type=="object" then
		object=pointed_thing.ref
	else
		object=user
	end
	multidimensions.form(user,object)
	return itemstack
end
})

multidimensions.move=function(object,pos)
	local move=false
	object:set_pos(pos)
	multidimensions.setrespawn(object,pos)
	minetest.after(1, function(pos,object,move)
		for i=1,100,1 do
			local nname=minetest.get_node(pos).name
			if nname~="air" and nname~="ignore" then
				pos.y=pos.y+1
				move=true
			elseif move then
				object:set_pos(pos)
				multidimensions.setrespawn(object,pos)
				break
			end
		end
	end, pos,object,move)
	minetest.after(5, function(pos,object,move)
		for i=1,100,1 do
			local nname=minetest.get_node(pos).name
			if nname~="air" and nname~="ignore" then
				pos.y=pos.y+1
				move=true
			elseif move then
				object:set_pos(pos)
				multidimensions.setrespawn(object,pos)
				break
			end
		end
	end, pos,object,move)
	return true
end