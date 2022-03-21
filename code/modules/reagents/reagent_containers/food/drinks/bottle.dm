

///////////////////////////////////////////////Alchohol bottles! -Agouri //////////////////////////
//Functionally identical to regular drinks. The only difference is that the default bottle size is 100. - Darem
//Bottles now weaken and break when smashed on people's heads. - Giacom

/obj/item/weapon/reagent_containers/glass/bottle
	amount_per_transfer_from_this = 10
	volume = 100
	item_state = "broken_beer" //Generic held-item sprite until unique ones are made.
	var/const/duration = 13 //Directly relates to the 'weaken' duration. Lowered by armor (i.e. helmets)
	var/isGlass = 1 //Whether the 'bottle' is made of glass or not so that milk cartons dont shatter when someone gets hit by it

/obj/item/weapon/reagent_containers/glass/bottle/proc/smash(mob/living/target as mob, mob/living/user as mob)

	//Creates a shattering noise and replaces the bottle with a broken_bottle
	if(!target || !user)

		var/obj/item/weapon/broken_bottle/B = new /obj/item/weapon/broken_bottle(loc)
		if(prob(33))
			new/obj/item/weapon/shard(loc) // Create a glass shard at the target's location!
		B.icon_state = src.icon_state
		var/icon/I = new('icons/obj/drinks.dmi', src.icon_state)
		I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
		I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
		playsound(src, "shatter", 70, 1)
		B.icon = I
		if(src.reagents.total_volume)
			src.add_fluid_by_transfer(get_turf(src), src.reagents.total_volume)
		qdel(src)
	else
		user.drop_item()
		var/obj/item/weapon/broken_bottle/B = new /obj/item/weapon/broken_bottle(user.loc)
		user.put_in_active_hand(B)
		if(prob(33))
			new/obj/item/weapon/shard(target.loc) // Create a glass shard at the target's location!
		if(src.reagents.total_volume)
			src.add_fluid_by_transfer(get_turf(src), src.reagents.total_volume)
		B.icon_state = src.icon_state

		var/icon/I = new('icons/obj/drinks.dmi', src.icon_state)
		I.Blend(B.broken_outline, ICON_OVERLAY, rand(5), 1)
		I.SwapColor(rgb(255, 0, 220, 255), rgb(0, 0, 0, 0))
		B.icon = I

		playsound(src, "shatter", 70, 1)
		user.put_in_active_hand(B)
		src.transfer_fingerprints_to(B)

		qdel(src)

/obj/item/weapon/reagent_containers/glass/bottle/throw_impact(atom/hit_atom, speed)
	..(hit_atom, speed)
	if(prob(33))
		if(isliving(hit_atom))
			var/mob/living/target = hit_atom
			if(src.reagents)
				for(var/mob/O in viewers(target, null))
					O.show_message(text("\blue <B>The contents of the [src] splashes all over [target]!</B>"), 1)
				//src.reagents.reaction(target, TOUCH)
		smash()

/obj/item/weapon/reagent_containers/glass/bottle/bullet_act()
	smash()

/obj/item/weapon/reagent_containers/glass/bottle/attack(mob/living/target as mob, mob/living/user as mob)

	if(!target)
		return

	if(user.a_intent != "hurt" || !isGlass)
		return ..()


	force = 15 //Smashing bottles over someoen's head hurts.

	var/datum/organ/external/affecting = user.zone_sel.selecting //Find what the player is aiming at

	var/armor_block = 0 //Get the target's armour values for normal attack damage.
	var/armor_duration = 0 //The more force the bottle has, the longer the duration.

	//Calculating duration and calculating damage.
	if(ishuman(target))

		var/mob/living/carbon/human/H = target
		var/headarmor = 0 // Target's head armour
		armor_block = H.run_armor_check(affecting, "melee", src.isBlunts()) // For normal attack damage

		//If they have a hat/helmet and the user is targeting their head.
		if(istype(H.head, /obj/item/clothing/head) && affecting == "head")

			// If their head has an armour value, assign headarmor to it, else give it 0.
			if(H.head.armor["melee"])
				headarmor = H.head.armor["melee"]
			else
				headarmor = 0
		else
			headarmor = 0

		//Calculate the weakening duration for the target.
		armor_duration = (duration - headarmor) + force

	else
		//Only humans can have armour, right?
		armor_block = target.run_armor_check(affecting, "melee", src.isBlunts())
		if(affecting == "head")
			armor_duration = duration + force
	armor_duration /= 10

	//Apply the damage!
	target.apply_damage(force, BRUTE, affecting, armor_block)

	// You are going to knock someone out for longer if they are not wearing a helmet.
	if(affecting == "head" && istype(target, /mob/living/carbon/))

		//Display an attack message.
		for(var/mob/O in viewers(user, null))
			if(target != user) O.show_message(text("\red <B>[target] has been hit over the head with a bottle of [src.name], by [user]!</B>"), 1)
			else O.show_message(text("\red <B>[target] hit himself with a bottle of [src.name] on the head!</B>"), 1)
		//Weaken the target for the duration that we calculated and divide it by 5.

	else
		//Default attack message and don't weaken the target.
		for(var/mob/O in viewers(user, null))
			if(target != user) O.show_message(text("\red <B>[target] has been attacked with a bottle of [src.name], by [user]!</B>"), 1)
			else O.show_message(text("\red <B>[target] has attacked himself with a bottle of [src.name]!</B>"), 1)

	//Attack logs
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Has attacked [target.name] ([target.ckey]) with a bottle!</font>")
	target.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been smashed with a bottle by [user.name] ([user.ckey])</font>")
	msg_admin_attack("[user.name] ([user.ckey]) attacked [target.name] ([target.ckey]) with a bottle. (INTENT: [uppertext(user.a_intent)]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[user.x];Y=[user.y];Z=[user.z]'>JMP</a>)")

	//The reagents in the bottle splash all over the target, thanks for the idea Nodrak
	if(src.reagents)
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\blue <B>The contents of the [src] splashes all over [target]!</B>"), 1)
		//src.reagents.reaction(target, TOUCH)

	//Finally, smash the bottle. This kills (del) the bottle.
	src.smash(target, user)

	return

//Keeping this here for now, I'll ask if I should keep it here.
/obj/item/weapon/broken_bottle

	name = "Broken Bottle"
	desc = "A bottle with a sharp broken bottom."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "broken_bottle"
	force = 9.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	item_state = "beer"
	attack_verb = list("slashed", "attacked")
	sharp = 1
	edge = 0
	var/icon/broken_outline = icon('icons/obj/drinks.dmi', "broken")

/obj/item/weapon/broken_bottle/attack(mob/living/carbon/M as mob, mob/living/carbon/user as mob)
	playsound(loc, 'sound/weapons/bladeslice.ogg', 50, 1, -1)
	return ..()


/obj/item/weapon/reagent_containers/glass/bottle/gin
	name = "gin"
	desc = "Gin, the woman's whiskey."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "ginbottle"
	item_state = "broken_beer"
	New()
		..()
		reagents.add_reagent("gin", 100)

/obj/item/weapon/reagent_containers/glass/bottle/whiskey
	name = "whiskey"
	desc = "A mash of grain turned into a man's best friend."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "whiskeybottle"
	item_state = "broken_beer"
	New()
		..()
		reagents.add_reagent("whiskey", 100)

/obj/item/weapon/reagent_containers/glass/bottle/vodka
	name = "vodka"
	desc = "From Salar, with love."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "vodkabottle"
	item_state = "broken_beer"
	New()
		..()
		reagents.add_reagent("vodka", 100)

/obj/item/weapon/reagent_containers/glass/bottle/tequilla
	name = "tequila"
	desc = "Made from premium petroleum distillates."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "tequillabottle"
	item_state = "broken_beer"
	New()
		..()
		reagents.add_reagent("tequilla", 100)

/obj/item/weapon/reagent_containers/glass/bottle/rum
	name = "rum"
	desc = "For hardy sailors and seaspotters."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "rumbottle"
	item_state = "broken_beer"
	New()
		..()
		reagents.add_reagent("rum", 100)

/obj/item/weapon/reagent_containers/glass/bottle/vermouth
	name = "vermouth"
	desc = "Sweet, sweet dryness."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "vermouthbottle"
	item_state = "broken_beer"
	New()
		..()
		reagents.add_reagent("vermouth", 100)

/obj/item/weapon/reagent_containers/glass/bottle/cognac
	name = "cognac"
	desc = "Don't mix this with anything or it's considered a sin."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "cognacbottle"
	item_state = "broken_beer"
	New()
		..()
		reagents.add_reagent("cognac", 100)

/obj/item/weapon/reagent_containers/glass/bottle/wine
	name = "cave wine"
	desc = "Argubly stronger than standard liquor."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "winebottle"
	item_state = "broken_beer"
	New()
		..()
		reagents.add_reagent("wine", 100)

/obj/item/weapon/reagent_containers/glass/bottle/absinthe
	name = "absinthe"
	desc = "One sip of this and you just know you're gonna have a good time."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "absinthebottle"
	item_state = "broken_beer"
	New()
		..()
		reagents.add_reagent("absinthe", 100)

/obj/item/weapon/reagent_containers/glass/bottle/pwine
	name = "velvet wine"
	desc = "What a delightful packaging for a surely high quality wine! The vintage must be amazing!"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "pwinebottle"
	item_state = "broken_beer"
	New()
		..()
		reagents.add_reagent("pwine", 100)

//////////////////////////JUICES AND STUFF ///////////////////////

/obj/item/weapon/reagent_containers/glass/bottle/orangejuice
	name = "Orange Juice"
	desc = "Full of vitamins and deliciousness!"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "orangejuice"
	item_state = "carton"
	isGlass = 0
	New()
		..()
		reagents.add_reagent("orangejuice", 100)

/obj/item/weapon/reagent_containers/glass/bottle/cream
	name = "Milk Cream"
	desc = "It's cream. Made from milk. What else did you think you'd find in there?"
	icon = 'icons/obj/drinks.dmi'
	icon_state = "cream"
	item_state = "carton"
	isGlass = 0
	New()
		..()
		reagents.add_reagent("cream", 100)

/obj/item/weapon/reagent_containers/glass/bottle/tomatojuice
	name = "Tomato Juice"
	desc = "Well, at least it LOOKS like tomato juice. You can't tell with all that redness."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "tomatojuice"
	item_state = "carton"
	isGlass = 0
	New()
		..()
		reagents.add_reagent("tomatojuice", 100)

/obj/item/weapon/reagent_containers/glass/bottle/limejuice
	name = "Lime Juice"
	desc = "Sweet-sour goodness."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "limejuice"
	item_state = "carton"
	isGlass = 0
	New()
		..()
		reagents.add_reagent("limejuice", 100)

/obj/item/weapon/reagent_containers/glass/bottle/waterbottle
	name = "Water Bottle"
	icon_state = "waterbottle"
	icon = 'icons/obj/drinks.dmi'
	item_state = "broken_beer"
	isGlass = 0
	New()
		..()
		reagents.add_reagent("water", 100)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/glass/bottle/ale
	name = "Magm-Ale"
	desc = "A true dorf's drink of choice."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "alebottle"
	item_state = "beer"
	isGlass = 0
	New()
		..()
		reagents.add_reagent("ale", 100)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)

/obj/item/weapon/reagent_containers/glass/bottle/beer
	name = "Beer"
	desc = "Contains only water, malt and hops."
	icon = 'icons/obj/drinks.dmi'
	icon_state = "beer"
	item_state = "beer"
	isGlass = 1
	New()
		..()
		reagents.add_reagent("beer", 100)
		src.pixel_x = rand(-10.0, 10)
		src.pixel_y = rand(-10.0, 10)


