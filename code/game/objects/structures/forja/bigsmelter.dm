/obj/structure/bigForgeDecor
	name = "forge"
	desc = "A forge."
	icon = 'icons/obj/bigforge.dmi'
	icon_state = "furnace_d0"
	density = 1
	anchored = 1
	plane = 22

/obj/item/weapon/storage/forge/bigForge
	name = "forge"
	desc = "A smelter used to forge ores"
	icon = 'icons/obj/bigforge.dmi'
	icon_state = "furnace0"
	density = 0
	anchored = 1
	storage_slots = 4
	density = 1

/obj/item/weapon/storage/forge/bigForge/update_icon()
	if(on)
		icon_state = "furnace1"
		for(var/obj/structure/bigForgeDecor/B in range(2, src))
			B.icon_state = "furnace_d1"
	else
		icon_state = "furnace0"
		for(var/obj/structure/bigForgeDecor/B in range(2, src))
			B.icon_state = "furnace_d0"

/obj/item/weapon/storage/forge/bigForge/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(on)
		return

	if(istype(W, /obj/item/weapon/ore/lw) && !(src.contents.len >= storage_slots))             // SLOT CARVAO
		var/obj/item/weapon/ore/lw/L = W
		user.drop_item(sound = 0)
		src.contents += L

	if(istype(W, /obj/item/weapon/flame) && src.contents.len >= 2)
		var/COAL,IRON = 0
		on = 1
		update_icon()
		for(var/obj/item/weapon/ore/lw/L in src.contents)
			if(istype(L, /obj/item/weapon/ore/lw/coal))
				COAL += 1
			if(istype(L, /obj/item/weapon/ore/lw/ironlw))
				IRON += 1
		while(on && COAL ==1 )
			sleep(10)
			tocomplete += 10
			playsound(src.loc, 'sound/effects/smelter_sound.ogg', 50, 1)
			if(tocomplete >= 160)
				if(IRON == 3)
					for(var/i = 1; i <= 4; i++)
						var/obj/item/weapon/ore/refined/lw/steellw/S = new(src.loc)
						sleep(2)
						S.throw_at(get_edge_target_turf(src, src.dir), 4, 2)
						src.contents.Cut()
				else
					for(var/i = 1, i <= src.contents.len, i++)
						var/contentes = src.contents[i] //Isso é proposital
						if(!istype(contentes, /obj/item/weapon/ore/lw/coal))
							var/obj/item/weapon/ore/lw/A = contentes
							new A.refined_type(src.loc)
							if(i <= src.contents.len)
								src.contents.Cut()
							A.loc = src.contents
				on = 0
				tocomplete = 0
				playsound(src.loc, 'sound/lfwbsounds/smelter_fin.ogg', 50, 1)
				update_icon()
				break