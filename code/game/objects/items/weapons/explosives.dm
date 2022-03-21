/obj/item/weapon/plastique
	name = "plastic explosives"
	desc = "Used to put holes in specific areas without too much extra hole."
	gender = PLURAL
	icon = 'icons/obj/assemblies.dmi'
	icon_state = "plastic-explosive0"
	item_state = "plasticx"
	flags = FPRINT | NOBLUDGEON
	w_class = 2.0
	origin_tech = "syndicate=2"
	var/timer = 10
	var/atom/target = null
	var/datum/wires/explosive/c4/wires = null
	var/open_panel = 0
	var/image_overlay = null
	var/planted = FALSE

/obj/item/weapon/plastique/New()
	wires = new(src)
	image_overlay = image(icon, "plastic-explosive2")
	..()

/obj/item/weapon/plastique/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/weapon/screwdriver))
		open_panel = !open_panel
		user << "<span class='notice'>You [open_panel ? "open" : "close"] the wire panel.</span>"
	else if(istype(I, /obj/item/weapon/wirecutters) || istype(I, /obj/item/device/multitool) || istype(I, /obj/item/device/assembly/signaler ))
		wires.Interact(user)
	else
		..()

/obj/item/weapon/plastique/afterattack(atom/target as obj|turf, mob/user as mob, flag)
	if (!flag)
		return
	if (istype(target, /turf/unsimulated) || istype(target, /turf/simulated/shuttle) || istype(target, /obj/item/weapon/storage/))
		return
/*	if (istype(target, /obj/machinery/door/poddoor/))
		user << "\red Wait, it's famous titanium blast door! You think, that planting C4 on it is a stupid thing"
		return*/
	to_chat(user, "<i>Planting explosives...</i>")
	if(ismob(target))

		user.attack_log += "\[[time_stamp()]\] <font color='red'> [user.real_name] tried planting [name] on [target:real_name] ([target:ckey])</font>"
		msg_admin_attack("[user.real_name] ([user.ckey]) tried planting [name] on [target:real_name] ([target:ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

		user.visible_message("\red [user.name] is trying to plant some kind of explosive on [target.name]!")

	if(do_after(user, 2) && in_range(user, target))
		user.drop_item()
		target = target
		loc = target
		if (ismob(target))
			target:attack_log += "\[[time_stamp()]\]<font color='orange'> Had the [name] planted on them by [user.real_name] ([user.ckey])</font>"
			user.visible_message("\red [user.name] finished planting an explosive on [target.name]!")
			playsound(get_turf(src), 'sound/weapons/c4armed.ogg', 60, 1)
			//log_admin("ATTACK: [user] ([user.ckey]) planted [src] on [target] ([target:ckey]).")
			message_admins("ATTACK: [user] ([user.ckey])(<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>) planted [src] on [target] ([target:ckey]).", 2)
			log_attack("[user] ([user.ckey]) planted [name] on [target.name] ([target:ckey])")
		target.overlays += image_overlay
		planted = TRUE

/obj/item/weapon/plastique/proc/calltimer()
	spawn(timer*10)
		explode(get_turf(src))


/obj/item/weapon/plastique/attack_hand(mob/living/user as mob)
	if(planted)
		to_chat(user, "[timer] SECONDS")
		calltimer()
		return
	..()

/obj/item/weapon/plastique/proc/explode(var/turf/location)
	if(target)
		target.overlays -= image_overlay
		if(isliving(target))
			var/mob/living/Li = target
			Li.gib()
		else if(target != location)
			target.ex_act(2)
	location.ex_act(2)
	explosion(location,2, 0, 3, 6)
	qdel(src)

/obj/item/weapon/plastique/attack(mob/M as mob, mob/user as mob, def_zone)
	return

/obj/item/weapon/plastique/thanati/explode(var/turf/location)
	if(target)
		target.overlays -= image_overlay
		if(isliving(target))
			var/mob/living/Li = target
			Li.gib()
		else if(target != location)
			target.ex_act(2)
	location.ex_act(2)
	explosion(location,5, 5, 5, 6)
	qdel(src)