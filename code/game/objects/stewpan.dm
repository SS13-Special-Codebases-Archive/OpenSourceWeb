/obj/structure/fireplace/hearth
	icon = 'icons/obj/stewpan.dmi'
	icon_state = "cauldron0"
	on_state =  "cauldron1"
	off_state = "cauldron0"
	c_color = "#ff7a7a"
	f_force = 1
	r_range = 4
	density = 0
	var/comesoff = 1

/obj/structure/fireplace/hearth/New()
	..()
	if(comesoff)
		turn_off()
/obj/structure/fireplace/hearth/lighted
	comesoff = 0

/obj/item/weapon/reagent_containers/glass/beaker/stewpan
	name = "pot"
	desc = "A pot to stew yourself."
	icon = 'icons/obj/stewpan.dmi'
	icon_state = "sempty"
	item_state = "cannonball"
	var/fervendo = 0
	var/leftToFerver = 200
	drop_sound = 'helm_drop.ogg'

/obj/item/weapon/reagent_containers/glass/beaker/stewpan/process()
	var/turf/T = get_turf(src)
	var/obj/structure/fireplace/hearth/H = locate() in T
	if(!H || !H.lit || !reagents.total_volume > 0) {
		fervendo = 0
		leftToFerver = 200
		return
	}

	fervendo = 1
	leftToFerver -= 8
	leftToFerver = max(0, leftToFerver-8)
	playsound(src.loc, pick('sound/effects/life/bubbles1.ogg', 'sound/effects/life/bubbles2.ogg', 'sound/effects/life/bubbles3.ogg', 'sound/effects/life/bubbles4.ogg', 'sound/effects/life/bubbles5.ogg' ,'sound/effects/life/bubbles6.ogg'), rand(60,85), 1)


	if(leftToFerver == 0)
		visible_message("The stew is ready!")
		var/name = ""

		for(var/atom/content in src.contents)
			reagents.remove_reagent("water", 5)
			content.reagents.trans_to(src, content.reagents.total_volume)
			name += " [content.name], "
			qdel(content)
		src.name = "Pot of [name]"


/obj/item/weapon/reagent_containers/glass/beaker/stewpan/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /mob/living/simple_animal/mouse))
		var/mob/living/simple_animal/mouse/M = W
		user.drop_item(M)
		contents.Add(M)
	if(istype(W, /obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/S = W
		user.drop_item(S)
		contents.Add(S)
	update_icon()

/obj/item/weapon/reagent_containers/glass/beaker/stewpan/update_icon()
	var/water_volume = reagents.get_reagent_amount("water")
	if(water_volume >= 5)
		if(contents.len >= 1 || reagents.get_reagent_amount("nutriment") > 1)
			icon_state = "sfull"
		else
			icon_state = "swater"
	else
		icon_state = "sempty"


/obj/item/weapon/reagent_containers/glass/beaker/bowl
	name = "bowl"
	desc = "A bowl."
	icon = 'icons/obj/stewpan.dmi'
	icon_state = "snack_bowl0"
	item_state = "cannonball"
	appearance_flags = KEEP_TOGETHER

/obj/item/weapon/reagent_containers/glass/beaker/bowl/update_icon()
	if(reagents)
		if(reagents.total_volume >= reagents.maximum_volume/2)
			src.icon_state = "snack_bowl10"
		else if(reagents.total_volume > 0)
			src.icon_state = "snack_bowl5"
		else
			src.icon_state = "snack_bowl0"

/obj/item/weapon/reagent_containers/glass/beaker/bowl/attackby(obj/item/weapon/W as obj, mob/living/carbon/human/user as mob)
	..()
	if(reagents.total_volume <= 0) return
	if(istype(W, /obj/item/weapon/kitchen/utensil/spoon))
		var/obj/item/weapon/kitchen/utensil/spoon/S = W
		user.visible_message("<span class='examinebold'>[user]</span> <span class='examine'>drinks from [src] with the [S]!</span>")
		reagents.trans_to(user, 5)
		update_icon()
		playsound(src.loc, pick('sound/webbers/npc_human_eatsoup_slurp_01.ogg', 'sound/webbers/npc_human_eatsoup_slurp_02.ogg', 'sound/webbers/npc_human_eatsoup_slurp_03.ogg', 'sound/webbers/npc_human_eatsoup_slurp_04.ogg', 'sound/webbers/npc_human_eatsoup_slurp_05.ogg' ,'sound/webbers/npc_human_eatsoup_slurp_06.ogg'), rand(60,90), 1)
		if(user.royalty)
			user.add_event("royalty", /datum/happiness_event/misc/spoon)
			user.rotate_plane()

	if(istype(W, /obj/item/weapon/kitchen/utensil/fork))
		if(!user.royalty)
			to_chat(user, "I don't know how to eat with a fork.") // Brazilian reality
			return
		var/obj/item/weapon/kitchen/utensil/fork/F = W
		user.visible_message("<span class='examinebold'>[user]</span> <span class='examine'>eats from [src] with the [F]!</span>")
		reagents.trans_to(user, 5)
		update_icon()
		playsound(src.loc, pick('sound/webbers/npc_human_eatsoup_slurp_01.ogg', 'sound/webbers/npc_human_eatsoup_slurp_02.ogg', 'sound/webbers/npc_human_eatsoup_slurp_03.ogg', 'sound/webbers/npc_human_eatsoup_slurp_04.ogg', 'sound/webbers/npc_human_eatsoup_slurp_05.ogg' ,'sound/webbers/npc_human_eatsoup_slurp_06.ogg'), rand(60,90), 1)