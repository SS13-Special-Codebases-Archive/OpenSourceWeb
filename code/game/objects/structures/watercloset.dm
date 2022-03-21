//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos

/obj/structure/toilet
	name = "toilet"
	desc = "For your excrements."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet10"
	density = 0
	anchored = 1
	var/open = 1			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie

/obj/structure/toilet/stone
	name = "toilet"
	icon_state = "cavetoilet2"

/obj/structure/toilet/wood
	name = "toilet"
	icon_state = "cavetoilet"

/obj/structure/toilet/bone
	name = "toilet"
	icon_state = "bonetoilet"

/obj/structure/toilet/stone/New()
	open = 1

/obj/structure/toilet/New()
	open = 1
	//update_icon()

/obj/structure/toilet/attack_hand(mob/living/user as mob)
	if(swirlie)
		usr.visible_message("<span class='danger'>[user] slams the toilet seat onto [swirlie.name]'s head!</span>", "<span class='notice'>You slam the toilet seat onto [swirlie.name]'s head!</span>", "You hear reverberating porcelain.")
		swirlie.adjustBruteLoss(8)
		return

/obj/structure/toilet/update_icon()
	icon_state = "toilet[open][cistern]"

/obj/structure/toilet/attackby(obj/item/I as obj, mob/living/user as mob)
	if(istype(I, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = I

		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting

			if(G.state>1)
				if(!GM.loc == get_turf(src))
					user << "<span class='notice'>[GM.name] needs to be on the toilet.</span>"
					return
				if(open && !swirlie)
					user.visible_message("<span class='danger'>[user] starts to give [GM.name] a swirlie!</span>", "<span class='notice'>You start to give [GM.name] a swirlie!</span>")
					swirlie = GM
					if(do_after(user, 30, 5, 0))
						user.visible_message("<span class='danger'>[user] gives [GM.name] a swirlie!</span>", "<span class='notice'>You give [GM.name] a swirlie!</span>", "You hear a toilet flushing.")
						if(!GM.internal)
							GM.adjustOxyLoss(5)
					swirlie = null
				else
					user.visible_message("<span class='danger'>[user] slams [GM.name] into the [src]!</span>", "<span class='notice'>You slam [GM.name] into the [src]!</span>")
					GM.adjustBruteLoss(8)
			else
				user << "<span class='notice'>You need a tighter grip.</span>"

/obj/structure/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = 0
	anchored = 1

/obj/structure/urinal/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = I
		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting
			if(G.state>1)
				if(!GM.loc == get_turf(src))
					user << "<span class='notice'>[GM.name] needs to be on the urinal.</span>"
					return
				user.visible_message("<span class='danger'>[user] slams [GM.name] into the [src]!</span>", "<span class='notice'>You slam [GM.name] into the [src]!</span>")
				GM.adjustBruteLoss(8)
			else
				user << "<span class='notice'>You need a tighter grip.</span>"



/obj/machinery/shower
	name = "shower"
	desc = "The HS-451."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	density = 0
	anchored = 1
	use_power = 0
	plane = 15
	var/on = 0
	var/obj/effect/mist/mymist = null
	var/ismist = 0				//needs a var so we can make it linger~
	var/watertemp = "normal"	//freezing, normal, or boiling
	var/mobpresent = 0		//true if there is a mob on the shower's loc, this is to ease process()
	var/loaded = 0
//add heat controls? when emagged, you can freeze to death in it?

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	layer = MOB_LAYER + 1
	anchored = 1
	mouse_opacity = 0

/obj/machinery/shower/attack_hand(mob/M as mob)
	if(loaded <= 0)
		return
	if(on)
		return

	on = TRUE
	update_icon()
	playsound(src.loc, 'visor.ogg', 30, 1, -1)
	if (M.loc == loc)
		wash(M)
	for (var/atom/movable/G in src.loc)
		G.clean_blood()
	spawn(50)
		on = FALSE
		update_icon()
		loaded--

/obj/machinery/shower/attackby(obj/item/I as obj, mob/living/carbon/human/user as mob)
	if(!istype(I, /obj/item/weapon/spacecash))
		return ..()
	var/obj/item/weapon/spacecash/C = I
	if(C.worth != C.singularvalue)
		return

	loaded += C.singularvalue
	qdel(C)
	playsound(src.loc, 'sound/effects/coininsert.ogg', 30, 0)
	fakesay("Thank you for your choice.")

/obj/machinery/shower/update_icon()	//this is terribly unreadable, but basically it makes the shower mist up
	overlays.Cut()					//once it's been on for a while, in addition to handling the water overlay.
	if(mymist)
		qdel(mymist)

	if(on)
		overlays += image('icons/obj/watercloset.dmi', src, "water", MOB_LAYER + 1, dir)
		if(!ismist)
			spawn(25)
				if(src && on)
					ismist = 1
					mymist = new /obj/effect/mist(loc)
		else
			ismist = 1
			mymist = new /obj/effect/mist(loc)
	else if(ismist)
		ismist = 1
		mymist = new /obj/effect/mist(loc)
		spawn(125)
			if(src && !on)
				qdel(mymist)
				ismist = 0

/obj/machinery/shower/Crossed(atom/movable/O)
	..()
	if(!on) return
	wash(O)

/obj/machinery/shower/examine()
	..()
	if(loaded > 0)
		to_chat(usr, "<span class='passivebold'>USES LEFT: [loaded]<br>ENJOY YOUR SHOWER</span>")

//Yes, showers are super powerful as far as washing goes.
/obj/machinery/shower/proc/wash(atom/movable/O as obj|mob)
	if(!on) return

	if(isliving(O))
		var/mob/living/L = O
		L.ExtinguishMob()
		L.fire_stacks = -20 //Douse ourselves with water to avoid fire more easily
		L.on_fire = 0
		L.bodytemperature = max(200, L.bodytemperature-95)
		if(iscarbon(O))
			var/mob/living/carbon/M = O
			M.set_hygiene(HYGIENE_LEVEL_CLEAN )
			M.add_event("shower", /datum/happiness_event/nice_shower)
			if(M.r_hand)
				M.r_hand.clean_blood()
			if(M.l_hand)
				M.l_hand.clean_blood()
			if(M.back)
				if(M.back.clean_blood())
					M.update_inv_back(0)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				var/washgloves = 1
				var/washshoes = 1
				var/washmask = 1
				var/washears = 1
				var/washglasses = 1

				if(H.wear_suit)
					washgloves = !(H.wear_suit.flags_inv & HIDEGLOVES)
					washshoes = !(H.wear_suit.flags_inv & HIDESHOES)

				if(H.head)
					washmask = !(H.head.flags_inv & HIDEMASK)
					washglasses = !(H.head.flags_inv & HIDEEYES)
					washears = !(H.head.flags_inv & HIDEEARS)

				if(H.wear_mask)
					if (washears)
						washears = !(H.wear_mask.flags_inv & HIDEEARS)
					if (washglasses)
						washglasses = !(H.wear_mask.flags_inv & HIDEEYES)

				H.clean_blood()
				if(ishuman(H))
					H:update_inv_gloves()

				if(H.head)
					if(H.head.clean_blood())
						H.update_inv_head(0)
				if(H.wear_suit)
					if(H.wear_suit.clean_blood())
						H.update_inv_wear_suit(0)
				else if(H.w_uniform)
					if(H.w_uniform.clean_blood())
						H.update_inv_w_uniform(0)
				if(H.gloves && washgloves)
					if(H.gloves.clean_blood())
						H.update_inv_gloves(0)
				if(H.shoes && washshoes)
					if(H.shoes.clean_blood())
						H.update_inv_shoes(0)
				if(H.wear_mask && washmask)
					if(H.wear_mask.clean_blood())
						H.update_inv_wear_mask(0)
				if(H.glasses && washglasses)
					if(H.glasses.clean_blood())
						H.update_inv_glasses(0)
				if(H.l_ear && washears)
					if(H.l_ear.clean_blood())
						H.update_inv_ears(0)
				if(H.r_ear && washears)
					if(H.r_ear.clean_blood())
						H.update_inv_ears(0)
				if(H.belt)
					if(H.belt.clean_blood())
						H.update_inv_belt(0)
			else
				if(M.wear_mask)						//if the mob is not human, it cleans the mask without asking for bitflags
					if(M.wear_mask.clean_blood())
						M.update_inv_wear_mask(0)
		else
			O.clean_blood()

	if(isturf(loc))
		var/turf/tile = loc
		loc.clean_blood()
		for(var/obj/effect/E in tile)
			if(istype(E,/obj/effect/rune) || istype(E,/obj/effect/decal/cleanable) || istype(E,/obj/effect/overlay))
				qdel(E)

/obj/machinery/shower/proc/call_update_shower()
	if(!on)
		update_icon()

/obj/item/weapon/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"
	item_state = "rubberducky"



/obj/structure/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = 1
	var/busy = 0 	//Something's being washed at the moment
	var/broken = 0

/obj/structure/sink/bite_act(mob/M as mob)
	var/mob/living/carbon/human/H = M
	if(get_dist(src,M) >= 2)
		return
	if(broken)
		to_chat(H, "<span class='combatbold'>[pick(nao_consigoen)] it's broken!</span>")
		return

	if(M.wear_mask && M.wear_mask.flags & MASKCOVERSMOUTH)
		to_chat(M, "<span class='combat'>[pick(nao_consigoen)] my mask is in the way!</span>")
		return

	var/datum/reagents/reagents = new/datum/reagents(3)
	reagents.add_reagent("water", 3)
	reagents.reaction(H, INGEST)
	reagents.trans_to(H, 3)
	visible_message("<span class='bname'>⠀[H]</span> drinks from \the [src]!</span>")
	H.bladder += rand(1,3) //For peeing
	H.hidratacao += 10
	spawn(10)
		H.add_event("sink", /datum/happiness_event/misc/iwanttodie)
	playsound(M.loc, 'sound/effects/sink.ogg', rand(10, 50), 1)
	playsound(M.loc, 'sound/items/drink.ogg', rand(10, 50), 1)
	if(prob(1))
		broken = TRUE
	return

/obj/structure/sink/attack_hand(mob/M as mob)
	if(isrobot(M) || isAI(M))
		return

	if(broken)
		to_chat(M, "<span class='combatbold'>[pick(nao_consigoen)] it's broken!</span>")
		return

	if(!Adjacent(M))
		return

	if(busy)
		M << "\red Someone's already washing here."
		return

	playsound(src.loc, 'sound/effects/sink.ogg', rand(10, 50), 1)
	M.visible_message("<span class='passivebold'>[M]</span><span class='passive'> starts washing his hands using \the [src].</span>")

	if (ishuman(M))
		busy = 1
		do_after(usr,40)
		busy = 0

	if(prob(1))
		broken = TRUE

	if(!Adjacent(M)) return		//Person has moved away from the sink

	M.clean_blood()
	if(ishuman(M))
		M:update_inv_gloves()
	M.visible_message("<span class='passivebold'>[M]</span><span class='passive'> washes their hands using \the [src].</span>")


/obj/structure/sink/attackby(obj/item/O as obj, mob/user as mob)
	if(busy)
		user << "\red Someone's already washing here."
		return

	if(prob(1))
		broken = TRUE

	if(broken)
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.check_perk(/datum/perk/ancitech))
				to_chat(user, "<span class='passive'>You begin repairing \the [src]...</span>")
				if(do_after(user, 30))
					broken = FALSE
		to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)] it's broken!</span>")
		return

	if (istype(O, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/RG = O
		RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("<span class='passivebold'>[user]</span><span class='passive'> fills \the [RG] using \the [src].</span>")
		playsound(src.loc, 'sound/effects/sink.ogg', rand(35, 50), 1)
		return

	else if(istype(O, /obj/item/clothing/mask/sleeve))
		var/obj/item/clothing/mask/sleeve/S = O
		S.soaked = 10
		to_chat(user, "<span class='passive'>You soak \the [S] in \the [src]</span>")

	var/turf/location = user.loc
	if(!isturf(location)) return

	var/obj/item/I = O
	if(!I || !istype(I,/obj/item)) return

	to_chat(usr, "\blue I start washing \the [I].")
	playsound(src.loc, 'sound/effects/sink.ogg', rand(10, 50), 1)

	busy = 1
	do_after(usr,40)
	busy = 0

	if(user.loc != location) return				//User has moved
	if(!I) return 								//Item's been destroyed while washing
	if(user.get_active_hand() != I) return		//Person has switched hands or the item in their hands

	O.clean_blood()
	user.visible_message("<span class='passivebold'>[user]</span><span class='passive'> washes a [I] using \the [src].</span>")


/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink_alt"


/obj/structure/sink/puddle	//splishy splashy ^_^
	name = "puddle"
	icon_state = "puddle"

/obj/structure/sink/puddle/attack_hand(mob/M as mob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

/obj/structure/sink/puddle/attackby(obj/item/O as obj, mob/user as mob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"
