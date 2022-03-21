/obj/var/blunt = FALSE

#define QDEL_NULL_LIST(x) if(x) { for(var/y in x) { qdel(y) }}; if(x) {x.Cut(); x = null; } // Second x check to handle items that LAZYREMOVE on qdel.

#define QDEL_NULL(x) if(x) { qdel(x) ; x = null }

#define QDEL_IN(item, time) addtimer(CALLBACK(GLOBAL_PROC, .proc/qdel, item), time, TIMER_STOPPABLE)

/obj/item
	name = "item"
	icon = 'icons/obj/items.dmi'
	var/image/blood_overlay = null //this saves our blood splatter overlay, which will be processed not to go over the edges of the sprite
	var/abstract = 0
	var/item_state = null
	var/bigitem = FALSE
	var/r_speed = 1.0
	var/health = null
	var/burn_point = null
	var/burning = null
	var/hitsound = "swing_hit"
	var/drop_sound = 'sound/effects/smallfall.ogg'
	var/equip_sound = null
	var/w_class = 3.0
	var/parry_chance = 5

	var/sacrificedItem = 0

	flags = FPRINT | TABLEPASS
	var/slot_flags = 0		//This is used to determine on which slots an item can fit.
	pass_flags = PASSTABLE
	pressure_resistance = 5
//	causeerrorheresoifixthis
	var/obj/item/master = null
	var/pickupsound = null
	var/dropsound = null
	var/blooded_icon = null
	var/blood_suffix = null
	var/full = ""
	var/heat_protection = 0 //flags which determine which body parts are protected from heat. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/cold_protection = 0 //flags which determine which body parts are protected from cold. Use the HEAD, UPPER_TORSO, LOWER_TORSO, etc. flags. See setup.dm
	var/max_heat_protection_temperature //Set this variable to determine up to which temperature (IN KELVIN) the item protects against heat damage. Keep at null to disable protection. Only protects areas set by heat_protection flags
	var/min_cold_protection_temperature //Set this variable to determine down to which temperature (IN KELVIN) the item protects against cold damage. 0 is NOT an acceptable number due to if(varname) tests!! Keep at null to disable protection. Only protects areas set by cold_protection flags

	var/icon_action_button //If this is set, The item will make an action button on the player's HUD when picked up. The button will have the icon_action_button sprite from the screen1_action.dmi file.
	var/action_button_name //This is the text which gets displayed on the action button. If not set it defaults to 'Use [name]'. Note that icon_action_button needs to be set in order for the action button to appear.

	//Since any item can now be a piece of clothing, this has to be put here so all items share it.
	var/flags_inv //This flag is used to determine when items in someone's inventory cover others. IE helmets making it so you can't see glasses, etc.
	var/item_color = null
	var/body_parts_covered = 0 //see setup.dm for appropriate bit flags
	//var/heat_transfer_coefficient = 1 //0 prevents all transfers, 1 is invisible
	var/gas_transfer_coefficient = 1 // for leaking gas from turf to mask and vice-versa (for masks right now, but at some point, i'd like to include space helmets)
	var/permeability_coefficient = 1 // for chemicals/diseases
	var/siemens_coefficient = 1 // for electrical admittance/conductance (electrocution checks and shit)
	var/slowdown = 0 // How much clothing is slowing you down. Negative values speeds you up
	var/canremove = 1 //Mostly for Ninja code at this point but basically will not allow the item to be removed if set to 0. /N
	var/armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	var/list/allowed = null //suit storage stuff.
	var/obj/item/device/uplink/hidden/hidden_uplink = null // All items can have an uplink hidden inside, just remember to add the triggers.
	var/icon_override = null  //Used to override hardcoded clothing dmis in human clothing proc.
	var/wielded = 0
	var/wieldsound = 'sound/weapons/thudswoosh.ogg'
	var/unwieldsound = null
	var/wielded_icon = null
	var/force_unwielded = 0
	var/force_wielded = 0
	var/quality = 0
	var/sanctified = 0
	var/organ = 0
	var/weight = 0.1
	var/durability = 100
	var/weapon_speed_delay = 8
	var/next_attack_time = 0
	var/improved = 0
	var/accuracy = 0 // negative = chance to hit, positive = chance to miss
	var/can_improv = FALSE
	var/can_be_smelted_to = /obj/item/weapon/ore/refined/lw/ironlw

/obj/item/Crossed(H as mob|obj)
	..()
	if(ishuman(H))
		var/mob/living/carbon/human/descriptive_var_name = H
		if(descriptive_var_name.m_intent == "walk" && prob(40)) return
		if(istype(src, /obj/item/device/radio/intercom))
			return
		if(istype(src, /obj/item/weapon/storage/forge))
			return
		src.pixel_y = initial(pixel_y) + rand(-4,4)
		src.pixel_x = initial(pixel_x) + rand(-4,4)

/obj/item/New()
	..()
	. = ..()
	durability = rand(81,100)
	sharpness = rand(60,100)
	if(sanctified)
		name += " blessed"
	switch(quality)
		if(1)
			name = "-[name]-"
			force += 3
			item_worth = item_worth*2
			if(istype(src, /obj/item/clothing))
				armor["melee"] = initial(armor["melee"])
				armor["melee"] += 3
		if(2)
			name = "+[name]+"
			force += 6
			item_worth = item_worth*3
			if(istype(src, /obj/item/clothing))
				armor["melee"] = initial(armor["melee"])
				armor["melee"] += 5
		if(3)
			name = "*[name]*"
			force += 7
			item_worth = item_worth*4
			if(istype(src, /obj/item/clothing))
				armor["melee"] = initial(armor["melee"])
				armor["melee"] += 6
		if(4)
			name = "≡[name]≡"
			force += 9
			item_worth = item_worth*5
			if(istype(src, /obj/item/clothing))
				armor["melee"] = initial(armor["melee"])
				armor["melee"] += 7
		if(5)
			name = "☼[name]☼"
			force += 10
			item_worth = item_worth*12
			if(istype(src, /obj/item/clothing))
				armor["melee"] = initial(armor["melee"])
				armor["melee"] += 9
		if(6)
			name = "<i>[name]</i>"
			force += 12
			//item_worth = item_worth*120
			item_worth = item_worth*20
			if(istype(src, /obj/item/clothing))
				armor["melee"] = initial(armor["melee"])
				armor["melee"] += 10

/obj/item/proc/QualityToThingo(obj/item/A)
	switch(A)
		if(1)
			return " It's a well-crafted item."
		if(2)
			return " It's a finely-crafted item."
		if(3)
			return " It's a superior quality item."
		if(4)
			return " It's an exceptional item."
		if(5)
			return " It's a masterful item."
		if(6)
			return " It's an Artifact item."

/obj/item/device
	icon = 'icons/obj/device.dmi'

/obj/item/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(50))
				qdel(src)
				return
		if(3.0)
			if (prob(5))
				qdel(src)
				return
		else
	return

/obj/item/blob_act()
	return

//user: The mob that is suiciding
//damagetype: The type of damage the item will inflict on the user
//BRUTELOSS = 1
//FIRELOSS = 2
//TOXLOSS = 4
//OXYLOSS = 8
//Output a creative message and then return the damagetype done
/obj/item/proc/suicide_act(mob/user)
	return

/obj/item/verb/move_to_top()
	set name = "Move To Top"
	set category = "Object"
	set src in oview(1)

	if(!istype(src.loc, /turf) || usr.stat || usr.restrained() )
		return

	var/turf/T = src.loc

	src.loc = null

	src.loc = T

/obj/item/examine()
	set src in view()

	var/TheSpec
	var/TheReach
	if(istype(src, /obj/item/weapon))
		var/obj/item/weapon/W = src
		if(W.w_class >= 1)
			TheReach = "Reach: "
			switch(W.w_class)
				if(1)
					TheReach += "•"
				if(2)
					TheReach += "••"
				if(3)
					TheReach += "•••"
				if(4)
					TheReach += "••••"
				if(5)
					TheReach += "•••••"
				if(6)
					TheReach += "••••••"
		switch(W.speciality)
			if(SKILL_FLAIL)
				TheSpec = "[generatehintbox("https://cdn.discordapp.com/attachments/781574628229382144/828004675676012595/unknown.png","IMPROVISED. Lesser chance to hit. A little better than nothing.")]"
			if(SKILL_SWORD)
				TheSpec = "[generatehintbox("https://cdn.discordapp.com/attachments/781574628229382144/828016818261458954/sword.png","SWORD - Cuts or stabs. Your finesse of wieldy or unwieldy blades.")]"
			if(SKILL_SWING)
				TheSpec = "[generatehintbox("https://cdn.discordapp.com/attachments/781574628229382144/828016821218312242/club.png","CLUB/AXES - Smashes bones. Your control in assaults and parrying with crushing weapons.")]"


	if(!isobserver(usr))
		usr.visible_message("<span class='looksatbold'>[usr.name]</span> <span class='looksat'>looks at [src].</span>")
		if(get_dist(usr,src) > 5)//Don't get descriptions of things far away.
			to_chat(usr, "<span class='passivebold'>It's too far away to see clearly.</span>")
			return

	var/randtext = null
	var/valuetext = "No idea."

	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		if(H.my_stats.it <= 5)
			randtext = pick("Yoh!","Doh!","Haha")
		if(H.check_perk(/datum/perk/ref/value))
			valuetext = "[src.item_worth]"

		to_chat(H, "<div class='firstdivexamine'><div class='box'><span class='statustext'>This is a [src.blood_DNA ? "bloody " : ""][icon2html(src, usr)]</span> <span class='uppertext'>[src.name].[QualityToThingo(src?.quality)] [randtext]</span>\n<span class='statustext'>[src.desc]</span>\n[TheReach]<span class='bname'>Cost: [valuetext] </span><hr class='linexd'>[TheSpec]</div></div>")

	if(src.sharp)
		if(src.sharpness > 75)
			to_chat(usr, "<span class='passive'>It's well sharpened, it's </span><span class='passivebold'>[sharpness]%</span><span class='passive'> sharp!</span>")
		else
			if(src.sharpness > 50)
				to_chat(usr, "<span class='passive'>it's <span class='passivebold'>[sharpness]%</span><span class='passive'> sharp!</span>")
			else
				if(src.sharpness < 50)
					to_chat(usr, "<span class='combat'>It's blunt, it's <span class='combatbold'>[sharpness]%</span><span class='combat'> sharp!</span>")
				else
					if(src.sharpness <= 1)
						to_chat(usr, "<span class='combat'>It's completely blunt!</span>")

	if(src.durability)
		if(src.durability == 0)
			to_chat(usr, "<span class='combat'>it's broken!</span>")
		else
			if(src.durability < 20)
				to_chat(usr, "<span class='combat'>it's heavily damaged!</span>")
			else
				if(src.durability < 50)
					to_chat(usr, "<span class='combat'>it's damaged!</span>")
				else
					if(src.durability < 80)
						to_chat(usr, "<span class='combat'>it's slightly damaged!</span>")
	return


/obj/item/proc/damageItem(var/damagetype)
	var/modifier = 1
	switch(damagetype)
		if("HARD")
			modifier += 6
		if("SOFT")
			modifier = 1
		if("MEDIUM")
			modifier += 4
	if(durability > 0)
		durability -= modifier
	if(durability <= 0)
		durability = 0
		playsound(src.loc, 'breaksound.ogg', 100, 1)
		src.visible_message("<span class='combatbold'>[src]</span><span class='combat'> breaks!</span>")
		qdel(src)


/obj/item/proc/damageSharp(var/damagetype)
	if(!src.sharp)
		return
	var/modifier = 1
	switch(damagetype)
		if("HARD")
			modifier += 3
		if("SOFT")
			modifier = 1
		if("MEDIUM")
			modifier += 2
	if(sharpness > 0)
		sharpness = max(1, sharpness-modifier)
/*
/obj/item/weapon/reagent_containers/food/snacks/organ/Click(location, control, params, var/proximity_flag)

	if(world.time <= usr.next_move)
		return 1
	if(usr.stat || usr.paralysis || usr.stunned || usr.weakened)
		return 1
	if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech
		return 1

	usr.face_atom(src)

	if(src.Adjacent(usr))
		proximity_flag = 1

	if(src?.owner?.loc?.Adjacent(usr) && src.owner == src.loc)
		proximity_flag = 1

	if(proximity_flag > 0)
		var/list/modifiers = params2list(params)
		if(modifiers["shift"])
			src.examine(usr)

		else if(modifiers["left"])
			if(istype(usr, /mob/living/carbon/human))
				var/mob/living/carbon/human/H = usr
				if(H.get_active_hand() == null)
					if(H.s_active && istype(src.loc, /mob/living/carbon/human))
						var/datum/organ/internal/heart/Heart = src.owner.internal_organs_by_name[pick("heart")]
						if(Heart && Heart.escritura)
							if(istype(src, /obj/item/weapon/reagent_containers/food/snacks/organ/heart))
								src.escritura = Heart.escritura
						H.s_active.remove_from_storage(src)
						H.put_in_hands(src)
						if(connected)
							H.coisa(src, src.owner, 0)
							src.organ_data.damage += 60
							health -= 60
							connected = FALSE
						var/damage_organ = rand(30, 40)
						src.organ_data.damage += damage_organ
						health -= damage_organ
						src.removed(src.owner, H)
						H.visible_message("[H] exhumes [src.owner]!")
						playsound(H.loc, pick('sound/lfwbsounds/itm_ingredient_heart_01.ogg', 'sound/lfwbsounds/itm_ingredient_heart_02.ogg'), 100)
		src.attack_hand(usr)
		usr.next_move = world.time + 2
*/
/obj/item/attack_hand(mob/user as mob)
	if (!user) return
	if (hasorgans(user))
		var/datum/organ/external/temp = user:organs_by_name["r_hand"]
		if (user.hand)
			temp = user:organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(src, "<span class='combat'>[pick(nao_consigoen)] I can't use my [temp.display_name].</span>")
			return

	if(istype(user, /mob/living/carbon/human))
		if(!(user.IsAdvancedToolUser()) && (src.w_class < 4) && !(istype(src, /obj/item/clothing/mask/facehugger)))
			user << "<span class='notice'>Your claws aren't capable of such a manipulation!"
			return
		var/mob/living/carbon/human/H = user
		if(istype(H.amulet, /obj/item/clothing/head/amulet/breaker))
			return

	if (istype(src.loc, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = src.loc
		if(istype(S, /obj/item/weapon/storage/forge))
			var/obj/item/weapon/storage/forge/F = S
			if(F.on || F.tocomplete)
				return
		S.remove_from_storage(src)

	src.throwing = 0
	if (src.loc == user)
		//canremove==0 means that object may not be removed. You can still wear it. This only applies to clothing. /N
		if(!src.canremove)
			return
		else
			if(user.middle_click_intent == "steal")
				to_chat(user, "<i>You begin to slowly pick up [src] without making any noise.</i>")
				if(do_after(user, 28))
					user.u_equip(src)
					user.put_in_active_hand(src)
					src.pickup(user, FALSE)
				else
					return
			else
				if(istype(src, /obj/item/clothing/suit/armor/vest))
					if(do_after(user, 28))
						user.u_equip(src)
						user.put_in_active_hand(src)
						src.pickup(user, TRUE)
					else
						return
				else
					user.u_equip(src)
					user.put_in_active_hand(src)
					src.pickup(user, TRUE)
	else
		if(isliving(src.loc))
			return
		user.next_move = max(user.next_move+2,world.time + 2)
		if(user.middle_click_intent == "steal")
			to_chat(user, "<i>You begin to slowly pick up [src] without making any noise.</i>")
			if(do_after(user, 28))
				src.pickup(user, FALSE)
				user.put_in_active_hand(src)
			else
				return
		else
			src.pickup(user, TRUE)
			user.put_in_active_hand(src)

	add_fingerprint(user)
	user.put_in_active_hand(src)

	if(iszombie(user) || istype(user?:species, /datum/species/human/alien))						//Dirty, but in such a way it will not break the item's layer
		var/mob/living/carbon/human/H = user
		if(H.l_hand)
			if(!istype(H.l_hand, /obj/item/weapon/grab))
				H.drop_from_inventory(H.l_hand)
		if(H.r_hand)
			if(!istype(H.r_hand, /obj/item/weapon/grab))
				H.drop_from_inventory(H.r_hand)
	return

/obj/item/attack_paw(mob/user as mob)

	if (istype(src.loc, /obj/item/weapon/storage))
		for(var/mob/M in range(1, src.loc))
			if (M.s_active == src.loc)
				if (M.client)
					M.client.screen -= src
	src.throwing = 0
	if (src.loc == user)
		//canremove==0 means that object may not be removed. You can still wear it. This only applies to clothing. /N
		if(istype(src, /obj/item/clothing) && !src:canremove)
			return
		else
			user.u_equip(src)
	else
		if(istype(src.loc, /mob/living))
			return
		src.pickup(user)
		user.next_move = max(user.next_move+2,world.time + 2)

	user.put_in_active_hand(src)
	return

// Due to storage type consolidation this should get used more now.
// I have cleaned it up a little, but it could probably use more.  -Sayu
/obj/item/weapon/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(istype(W,/obj/item/weapon/censer))
		if(sanctified)
			return
		sanctified = 1
		var/nameNew = name
		name = "[pick("Blessed","Holy","Sanctified")] [nameNew]"

	if(istype(W, /obj/item/weapon/carverhammer) && can_improv)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.my_skills.GET_SKILL(SKILL_SMITH) > 3)
				if(src.durability < 100)
					src.durability = min(100, durability += rand(5,7))
					user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>repairs \the [src]!</span>")
					playsound(src.loc, 'sound/effects/forge.ogg', 50, 1)
					src.sound2()
				else
					var/what = input("WEAPON IMPROVEMENTS", "Smithing") in list("Balanced", "Strengthened", "Piercing", "Name")
					switch(what)
						if("Balanced")
							if(improved) return
							accuracy = rand(-5,-10)
							improved = 1
							force -= rand(4, 6)
							user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>improves \the [src]!</span>")
							playsound(src.loc, 'sound/effects/forge.ogg', 50, 1)
							src.name = "balanced [name]"
						if("Strengthned")
							if(improved) return
							force += rand(5,10)
							weapon_speed_delay += 8
							user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>improves \the [src]!</span>")
							playsound(src.loc, 'sound/effects/forge.ogg', 50, 1)
							improved = 1
							src.name = "strengthned [name]"
						if("Piercing")
							if(improved) return
							force += rand(4,8) // :^)
							user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>improves \the [src]!</span>")
							playsound(src.loc, 'sound/effects/forge.ogg', 50, 1)
							improved = 1
							src.name = "piercing [name]"
						if("Name")
							var/naem = input("What name?", "[src]") as text
							if(length(naem) > 25)
								to_chat(user, "Hmm. Too long.")
								return
							if(findtext(naem, config.ic_filter_regex))
								to_chat(user, "What?")
								return
							user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>names \the [src] as [naem]!</span>")
							name = naem
							playsound(src.loc, 'sound/effects/forge.ogg', 50, 1)

			else
				if(src.durability < 100)
					src.durability -= rand(5,7)
					user.visible_message("<span class='combatbold'>[user]</span> <span class='combat'>damages \the [src]!</span>")
					playsound(src.loc, 'sound/effects/forge.ogg', 50, 1)
					src.sound2()

	if(istype(W, /obj/item/weapon/stone))
		if(!src.sharp)
			return
		src.sharpness = min(100, sharpness+rand(1,3))
		user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>sharpens \the [src]!</span>")
		playsound(user.loc, pick('sharpen_long1.ogg','sharpen_long2.ogg','sharpen_short1.ogg','sharpen_short2.ogg'), 65, 1)
		src.sound2()
		if(prob(12))
			usr.visible_message("<span class='bname'>[src]</span> makes a spark!")
			var/turf/newLoc = get_step(loc, usr.dir)
			for(var/obj/O in newLoc)
				if(istype(O, /obj/item/weapon/flame/torch))
					var/obj/item/weapon/flame/torch/T = O
					T.turn_on()
				if(istype(O, /obj/structure/fireplace))
					var/obj/structure/fireplace/T = O
					T.turn_on()
				if(istype(O, /obj/structure/campfire))
					var/obj/structure/campfire/T = O
					if(!T.spent)
						T.on = TRUE
						T.checkfire()

	if(istype(W,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = W
		if(S.use_to_pickup)
			if(S.collection_mode) //Mode is set to collect all items on a tile and we clicked on a valid one.
				if(isturf(src.loc))
					var/list/rejections = list()
					var/success = 0
					var/failure = 0

					for(var/obj/item/I in src.loc)
						if(I.type in rejections) // To limit bag spamming: any given type only complains once
							continue
						if(!S.can_be_inserted(I))	// Note can_be_inserted still makes noise when the answer is no
							rejections += I.type	// therefore full bags are still a little spammy
							failure = 1
							continue
						success = 1
						S.handle_item_insertion(I, 1)	//The 1 stops the "You put the [src] into [S]" insertion message from being displayed.
					if(success && !failure)
						user << "<span class='notice'>You put everything in [S].</span>"
					else if(success)
						user << "<span class='notice'>You put some things in [S].</span>"
					else
						user << "<span class='notice'>You fail to pick anything up with [S].</span>"

			else if(S.can_be_inserted(src))
				S.handle_item_insertion(src)

	return

/obj/item/Destroy()
	qdel(hidden_uplink)
	hidden_uplink = null
	if(ismob(loc))
		var/mob/m = loc
		m.drop_from_inventory(src)
		m.update_inv_r_hand()
		m.update_inv_l_hand()
		src.loc = null
	else
		src.loc = null
	return ..()


/obj/item/proc/talk_into(mob/M as mob, text)
	return

/obj/item/proc/moved(mob/user as mob, old_loc as turf)
	return

/obj/item/proc/dropped(mob/user as mob)
	if(user)
		playsound(user.loc, dropsound, 50, 0)
	else
		playsound(src.loc, dropsound, 50, 0)
	if(wielded)
		unwield(user)

	update_twohanding()
	if(user)
		if(user.l_hand)
			user.l_hand.update_twohanding()
			user.update_inv_l_hand()
			src.item_state = "[initial(item_state)]"
			if(blooded_icon)
				src.item_state = "[initial(item_state)+blood_suffix]"
		if(user.r_hand)
			user.r_hand.update_twohanding()
			user.update_inv_r_hand()
			src.item_state = "[initial(item_state)]"
			if(blooded_icon)
				src.item_state = "[initial(item_state)+blood_suffix]"
	..()

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user, var/togglesound)
	if(user.loc)
		if(!togglesound)
			playsound(user.loc, pickupsound, 75, 0)
		return
	return

// called when this item is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/obj/item/proc/on_exit_storage(obj/item/weapon/storage/S as obj, var/new_location)
	return

/obj/item/proc/nigga_cat(obj/item/W as obj, mob/target as mob)

// called when this item is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/obj/item/proc/on_enter_storage(obj/item/weapon/storage/S as obj)
	return

// called when "found" in pockets and storage items. Returns 1 if the search should end.
/obj/item/proc/on_found(mob/finder as mob)
	return

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
// note this isn't called during the initial dressing of a player
/obj/item/proc/equipped(var/mob/user, var/slot)
	return

//the mob M is attempting to equip this item into the slot passed through as 'slot'. Return 1 if it can do this and 0 if it can't.
//If you are making custom procs but would like to retain partial or complete functionality of this one, include a 'return ..()' to where you want this to happen.
//Set disable_warning to 1 if you wish it to not give you outputs.
/obj/item/proc/mob_can_equip(M as mob, slot, disable_warning = 0)
	if(!slot) return 0
	if(!M) return 0

	if(ishuman(M))
		//START HUMAN
		var/mob/living/carbon/human/H = M

		switch(slot)
			if(slot_l_hand)
				if(H.l_hand)
					return 0
				return 1
			if(slot_r_hand)
				if(H.r_hand)
					return 0
				return 1
			if(slot_wear_mask)
				if(H.wear_mask)
					return 0
				if( !(slot_flags & SLOT_MASK) )
					return 0
				return 1
			if(slot_back)
				if(H.back)
					return 0
				if( !(slot_flags & SLOT_BACK) )
					return 0
				return 1
			if(slot_wear_suit)
				if(H.wear_suit)
					return 0
				if( !(slot_flags & SLOT_OCLOTHING) )
					return 0
				return 1
			if(slot_gloves)
				if(H.gloves)
					return 0
				if( !(slot_flags & SLOT_GLOVES) )
					return 0
				return 1
			if(slot_shoes)
				if(H.shoes)
					return 0
				if( !(slot_flags & SLOT_FEET) )
					return 0
				return 1
			if(slot_belt)
				if(H.belt)
					return 0
				if(!H.w_uniform)
					if(!disable_warning)
						H << "\red You need a jumpsuit before you can attach this [name]."
					return 0
				if( !(slot_flags & SLOT_BELT) )
					return
				return 1
			if(slot_glasses)
				if(H.glasses)
					return 0
				if( !(slot_flags & SLOT_EYES) )
					return 0
				return 1
			if(slot_wrist_r)
				if(H.wrist_r)
					return 0
				if(!wrist_use)
					return 0
				return 1
			if(slot_wrist_l)
				if(H.wrist_l)
					return 0
				if(!wrist_use)
					return 0
				return 1
			if(slot_amulet)
				if(H.amulet)
					return 0
				if(!neck_use)
					return 0
				return 1
			if(slot_back2)
				if(H.back2)
					return 0
				if( !(slot_flags & SLOT_BACK) )
					return 0
				return 1
			if(slot_head)
				if(H.head)
					return 0
				if( !(slot_flags & SLOT_HEAD) )
					return 0
				return 1
			if(slot_l_ear)
				if(H.l_ear)
					return 0
				if( !(slot_flags & SLOT_EARS) )
					return 0
				if( (slot_flags & SLOT_TWOEARS) && H.r_ear )
					return 0
				if(istype(src, /obj/item/device/radio/headset/bracelet))
					return 0
				return 1
			if(slot_r_ear)
				if(H.r_ear)
					return 0
				if( !(slot_flags & SLOT_EARS) )
					return 0
				if( (slot_flags & SLOT_TWOEARS) && H.l_ear )
					return 0
				if(istype(src, /obj/item/device/radio/headset/bracelet))
					return 0
				return 1
			if(slot_w_uniform)
				if(H.w_uniform)
					return 0
				if( !(slot_flags & SLOT_ICLOTHING) )
					return 0
				return 1
			if(slot_wear_id)
				if(H.wear_id)
					return 0
				if( !(slot_flags & SLOT_ID) )
					return 0
				return 1
			if(slot_l_store)
				if(H.l_store)
					return 0
				if(!H.w_uniform)
					if(!disable_warning)
						H << "\red You need a jumpsuit before you can attach this [name]."
					return 0
				if(slot_flags & SLOT_DENYPOCKET)
					return 0
				if( w_class <= 2 || (slot_flags & SLOT_POCKET) )
					return 1
			if(slot_r_store)
				if(H.r_store)
					return 0
				if(!H.w_uniform)
					if(!disable_warning)
						H << "\red You need a jumpsuit before you can attach this [name]."
					return 0
				if(slot_flags & SLOT_DENYPOCKET)
					return 0
				if( w_class <= 2 || (slot_flags & SLOT_POCKET) )
					return 1
				return 0
			if(slot_s_store)
				if(H.s_store)
					return 0
				if(!H.w_uniform)
					if(!disable_warning)
						H << "\red You need a jumpsuit before you can attach this [name]."
					return 0
				if( !(slot_flags & SLOT_BELT) )
					return
				return 1
			if(slot_handcuffed)
				if(H.handcuffed)
					return 0
				if(!istype(src, /obj/item/weapon/handcuffs))
					return 0
				return 1
			if(slot_legcuffed)
				if(H.legcuffed)
					return 0
				if(!istype(src, /obj/item/weapon/legcuffs))
					return 0
				return 1
			if(slot_in_backpack)
				if (H.back && istype(H.back, /obj/item/weapon/storage/backpack))
					var/obj/item/weapon/storage/backpack/B = H.back
					if(B.contents.len < B.storage_slots && w_class <= B.max_w_class)
						return 1
				return 0
		return 0 //Unsupported slot
		//END HUMAN

	else if(ismonkey(M))
		//START MONKEY
		var/mob/living/carbon/monkey/MO = M
		switch(slot)
			if(slot_l_hand)
				if(MO.l_hand)
					return 0
				return 1
			if(slot_r_hand)
				if(MO.r_hand)
					return 0
				return 1
			if(slot_wear_mask)
				if(MO.wear_mask)
					return 0
				if( !(slot_flags & SLOT_MASK) )
					return 0
				return 1
			if(slot_back)
				if(MO.back)
					return 0
				if( !(slot_flags & SLOT_BACK) )
					return 0
				return 1
		return 0 //Unsupported slot

		//END MONKEY


/obj/item/verb/verb_pickup()
	set src in oview(1)
	set category = "Object"
	set name = "Pick up"

	if(!(usr)) //BS12 EDIT
		return
	if(!usr.canmove || usr.stat || usr.restrained() || !Adjacent(usr))
		return
	if(src.z != usr.z)
		return
	if((!istype(usr, /mob/living/carbon)) || (istype(usr, /mob/living/carbon/brain)))//Is humanoid, and is not a brain
		usr << "\red You can't pick things up!"
		return
	if( usr.stat || usr.restrained() )//Is not asleep/dead and is not restrained
		usr << "\red You can't pick things up!"
		return
	if(src.anchored) //Object isn't anchored
		usr << "\red You can't pick that up!"
		return
	if(!usr.hand && usr.r_hand) //Right hand is not full
		usr << "\red Your right hand is full."
		return
	if(usr.hand && usr.l_hand) //Left hand is not full
		usr << "\red Your left hand is full."
		return
	if(!istype(src.loc, /turf)) //Object is on a turf
		usr << "\red You can't pick that up!"
		return
	//All checks are done, time to pick it up!
	usr.UnarmedAttack(src)
	return


//This proc is executed when someone clicks the on-screen UI button. To make the UI button show, set the 'icon_action_button' to the icon_state of the image of the button in screen1_action.dmi
//The default action is attack_self().
//Checks before we get to here are: mob is alive, mob is not restrained, paralyzed, asleep, resting, laying, item is on the mob.
/obj/item/proc/ui_action_click()
	if( src in usr )
		attack_self(usr)


/obj/item/proc/IsShield()
	return 0

/obj/item/clean_blood()
	. = ..()
	if(blood_overlay)
		overlays.Remove(blood_overlay)
	if(istype(src, /obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = src
		G.transfer_blood = 0
	if(blooded_icon)
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
		blooded_icon = 0
		if(ismob(loc))
			var/mob/user = loc
			user.update_inv_r_hand()
			user.update_inv_l_hand()

/obj/item/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0
	if(!M)
		return
	if(istype(src, /obj/item/weapon/melee/energy))
		return

	//if we haven't made our blood_overlay already
	if(!blood_overlay && !blooded_icon && !blood_suffix)
		generate_blood_overlay()

	if(!blood_overlay && !blooded_icon && blood_suffix)
		generate_blood_icon()

	//apply the blood-splatter overlay if it isn't already in there
	if(!blood_DNA.len && blood_overlay)
		blood_overlay.color = blood_color
		overlays += blood_overlay

	//if this blood isn't already in the list, add it

	if(blood_DNA[M.dna.unique_enzymes])
		return 0 //already bloodied with this blood. Cannot add more.
	blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	return 1 //we applied blood to the item

var/global/list/blood_overlay_cache = list()

/obj/item/proc/generate_blood_overlay()
	if(blood_overlay)
		return

	if(blood_overlay_cache["[icon]" + icon_state])
		blood_overlay = blood_overlay_cache["[icon]" + icon_state]
		return

	var/icon/I = new /icon(icon, icon_state)
	I.Blend(new /icon('icons/effects/blood.dmi', rgb(255,255,255)),ICON_ADD) //fills the icon_state with white (except where it's transparent)
	I.Blend(new /icon('icons/effects/blood.dmi', "itemblood"),ICON_MULTIPLY) //adds blood and the remaining white areas become transparant
	blood_overlay = image(I)
	blood_overlay.appearance_flags |= NO_CLIENT_COLOR
	blood_overlay_cache["[icon]" + icon_state] = blood_overlay

/obj/item/proc/generate_blood_icon(mob/user)
	if(blood_overlay)
		return
	if(blooded_icon)
		return
	blooded_icon = TRUE
	icon_state = "[initial(icon_state)+"_blood"]"
	item_state = "[initial(item_state)+blood_suffix]"
	if(user)
		user.update_inv_r_hand()
		user.update_inv_l_hand()

/obj/item/proc/showoff(mob/user)
	for (var/mob/M in view(user))
		M.show_message("[user] holds up [src]. <a HREF=?src=\ref[M];lookitem=\ref[src]>Take a closer look.</a>",1)

/mob/living/carbon/verb/showoff()
	set name = "Show Held Item"
	set category = "Object"

	var/obj/item/I = get_active_hand()
	if(I && !I.abstract)
		I.showoff(src)

//IS12 WIELD DO THUX

/mob/proc/do_wield()//The proc we actually care about.
	if(!isliving(src))//So ghosts can't do this.
		return
	var/obj/item/I = get_active_hand()
	if(!I)
		return
	I.attempt_wield(src)


/obj/item/proc/unwield(mob/user)
	if(!wielded || !user)
		return
	wielded = 0
	if(force_unwielded)
		force = force_unwielded
	else
		force = (force / 1.5)
/*	var/sf = findtext(name," (Wielded)")
	if(sf)
		name = copytext(name,1,sf)
	else //something wrong
		name = "[initial(name)]"*/
	update_unwield_icon()
	update_icon()
	if(user)
		user.update_inv_r_hand()
		user.update_inv_l_hand()
		user.moreactions.overlays -= "moreactions_2h"

	if(unwieldsound)
		playsound(loc, unwieldsound, 50, 1)
	var/obj/item/weapon/twohanded/offhand/O = user.get_inactive_hand()
	if(O && istype(O))
		user.drop_from_inventory(O)
	return

/obj/item/proc/wield(mob/user)
	if(wielded)
		return
	if(!is_held_twohanded(user))
		return
	if(user.get_inactive_hand())
		to_chat(user, "<span class='warning'>You need your other hand to be empty!</span>")
		return
	wielded = 1
	if(force_wielded)
		force = force_wielded
	else
		force = (force * 1.5)
	//name = "wielded [name]"
	update_wield_icon()
	update_icon()//Legacy
	if(user)
		user.update_inv_r_hand()
		user.update_inv_l_hand()
		user.moreactions.overlays += "moreactions_2h"
	user.visible_message("<span class='combatbold'>[user]</span> <span class='combat'>squeezes his</span> <span class='combatbold'>[user.r_hand ? "right hand" : "left hand"]</span><span class='combat'>!</span>")
	if(wieldsound)
		playsound(loc, wieldsound, 50, 1)
	var/obj/item/weapon/twohanded/offhand/O = new(user) ////Let's reserve his other hand~
	O.name = "[name]"
	O.desc = "Your second grip on the [name]"
	user.put_in_inactive_hand(O)
	return


/obj/item/proc/update_wield_icon()
	if(wielded && wielded_icon)
		item_state = wielded_icon

/obj/item/proc/update_unwield_icon()//That way it doesn't interupt any other special icon_states.
	if(!wielded && wielded_icon)
		item_state = "[initial(item_state)]"

//For general weapons.
/obj/item/proc/attempt_wield(mob/user)
	if(wielded) //Trying to unwield it
		unwield(user)
	else //Trying to wield it
		wield(user)

//Checks if the item is being held by a mob, and if so, updates the held icons
/obj/item/proc/update_twohanding()
	update_held_icon()

/obj/item/proc/update_held_icon()
	if(ismob(src.loc))
		var/mob/M = src.loc
		if(M.l_hand == src)
			M.update_inv_l_hand()
		else if(M.r_hand == src)
			M.update_inv_r_hand()

/obj/item/proc/is_held_twohanded(mob/living/M)
	var/check_hand
	if(M.l_hand == src && !M.r_hand)
		check_hand = BP_R_HAND //item in left hand, check right hand
	else if(M.r_hand == src && !M.l_hand)
		check_hand = BP_L_HAND //item in right hand, check left hand
	else
		return FALSE

	//would check is_broken() and is_malfunctioning() here too but is_malfunctioning()
	//is probabilistic so we can't do that and it would be unfair to just check one.
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		//var/obj/item/weapon/reagent_containers/food/snacks/organ/external/hand = H.organs_by_name[check_hand]
		var/datum/organ/external/hand = H.organs_by_name[check_hand]
		if(istype(hand) && hand.is_usable())
			return TRUE
	return FALSE

//OFFHAND PRO WIELD

/obj/item/weapon/twohanded/offhand
	name = "offhand"
	icon = 'icons/mob/screen1_White.dmi'
	icon_state = "offhand"
/*
/obj/item/weapon/twohanded/offhand/RightClick(mob/user)
	var/obj/item/I = user.get_active_hand()
	var/obj/item/II = user.get_inactive_hand()
	if(I)
		I.unwield(user)
	if(II)
		II.unwield(user)

	loc = null
	if(!QDELETED(src))
		qdel(src)
*/
/obj/item/weapon/twohanded/offhand/unwield()
	//if(wielded)//Only delete if we're wielded
	wielded = FALSE
	loc = null
	qdel(src)
	/*if(!QDELETED(src))
		qdel(src)*/

/obj/item/weapon/twohanded/offhand/wield()
	if(wielded)//Only delete if we're wielded
		wielded = FALSE
		loc = null
		qdel(src)
	/*if(!QDELETED(src))
		qdel(src)*/

/obj/item/weapon/twohanded/offhand/dropped(mob/user)
	..()
	var/obj/item/I = user.get_active_hand()
	var/obj/item/II = user.get_inactive_hand()
	if(I)
		I.unwield(user)
	if(II)
		II.unwield(user)
	loc = null
	qdel(src)
/*
	if(!QDELETED(src))
		qdel(src)
*/
/mob/verb/wield_hotkey()//For the hotkeys.
	set name = ".wield"
	do_wield()

/obj/item/kick_act(mob/living/carbon/human/user as mob)
	if(!..())//If we can't kick then this doesn't happen.
		return

	var/turf/target = get_turf(src.loc)
	var/range = src.throw_range
	var/throw_dir = get_dir(user, src)
	for(var/i = 1; i < range; i++)
		var/turf/new_turf = get_step(target, throw_dir)
		target = new_turf
		if(new_turf.density)
			break
	src.throw_at(target, rand(1,3), src.throw_speed)
	visible_message("<span class='hitbold'>[user]</span> <span class='hit'>kicks <span class='hitbold'>[src]!</span>")
	playsound(user.loc, 'sound/effects/kick1.ogg', 50, 0)
