
/*
 * Backpack
 */

/obj/item/weapon/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	icon_state = "backpack"
	item_state = "backpack"
	w_class = 4.0
	flags = FPRINT|TABLEPASS
	slot_flags = SLOT_BACK	//ERROOOOO
	max_w_class = 3
	max_combined_w_class = 21
	var/RightLeft = FALSE
	var/diffcolor = null

/obj/item/weapon/storage/backpack/equipped/(mob/user, var/slot)
	if((slot_back || slot_back2) && !is_satchel)
		src.close(user)

/obj/item/weapon/storage/backpack/attack_hand(mob/user)
	if(!ishuman(user))
		if(src == user.back && !is_satchel)  // you have to hold backpacks, sorry my guys
			to_chat(user, "<span class ='combat'>[pick(nao_consigoen)] I can't reach my [src]!</span>")
			return
	else
		var/mob/living/carbon/human/H = user
		if((src == H.back || src == H.back2) && !is_satchel)  // you have to hold backpacks, sorry my guys
			to_chat(H, "<span class ='combat'>[pick(nao_consigoen)] I can't reach my [src]!</span>")
			return

	..()

/obj/item/weapon/storage/backpack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	playsound(src.loc, "rustle", 50, 1, -5)
	..()


/obj/item/weapon/storage/backpack/coinbag
	name = "coin bag"
	slot_flags = SLOT_BELT
	icon = 'icons/obj/clothing/amulets.dmi'
	icon_state = "coin_bag"
	item_state = "coin_bag"
	w_class = 1
	max_combined_w_class = 4
	neck_use = TRUE
	storage_slots = 4

/obj/item/weapon/storage/backpack/coinbag/guest/New()
	..()
	new/obj/item/weapon/spacecash/gold/c20(src)
	new/obj/item/weapon/spacecash/gold/c10(src)

/*
 * Backpack Types
 */

/obj/item/weapon/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = "bluespace=4"
	icon_state = "holdingpack"
	max_w_class = 4
	max_combined_w_class = 28

	New()
		..()
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if(crit_fail)
			user << "\red The Bluespace generator isn't working."
			return
		if(istype(W, /obj/item/weapon/storage/backpack/holding) && !W.crit_fail)
			user << "\red The Bluespace interfaces of the two devices conflict and malfunction."
			qdel(W)
			return
			/* //BoH+BoH=Singularity, commented out.
		if(istype(W, /obj/item/weapon/storage/backpack/holding) && !W.crit_fail)
			investigate_log("has become a singularity. Caused by [user.key]","singulo")
			user << "\red The Bluespace interfaces of the two devices catastrophically malfunction!"
			qdel(W)
			var/obj/machinery/singularity/singulo = new /obj/machinery/singularity (get_turf(src))
			singulo.energy = 300 //should make it a bit bigger~
			message_admins("[key_name_admin(user)] detonated a bag of holding")
			log_game("[key_name(user)] detonated a bag of holding")
			qdel(src)
			return
			*/
		..()

	proc/failcheck(mob/user as mob)
		if (prob(src.reliability)) return 1 //No failure
		if (prob(src.reliability))
			user << "\red The Bluespace portal resists your attempt to add another item." //light failure
		else
			user << "\red The Bluespace generator malfunctions!"
			for (var/obj/O in src.contents) //it broke, delete what was in it
				qdel(O)
			crit_fail = 1
			icon_state = "brokenpack"

/obj/item/weapon/storage/backpack/holding/belt //It is here instead of belts so it works with all the BoH code.
	name = "belt of holding"
	desc = "An experimental belt that opens into a small, localized pocket of Blue Space."
	icon_state = "holdingbelt"
	item_state = "holdingbelt"
	max_w_class = 3 //It is a backpack for your belt!
	max_combined_w_class = 28
	storage_slots = 14

	slot_flags = SLOT_BELT

/obj/item/weapon/storage/backpack/lord
	name = "baron's cloak"
	desc = "A fancy dark cloak for the lord."
	icon_state = "lord"
	item_state = "baroncloak"
	storage_slots = 3
	is_satchel = TRUE
	RightLeft = TRUE

/obj/item/weapon/storage/backpack/new_cut
	name = "New Cut's gang cloak"
	desc = "A fancy dark cloak for the lord."
	icon_state = "new_cut"
	item_state = "new_cut"
	storage_slots = 3
	is_satchel = TRUE
	RightLeft = TRUE

/obj/item/weapon/storage/backpack/new_cut_alt
	name = "New Cut's gang cloak"
	desc = "A fancy dark cloak for the lord."
	icon_state = "new_cut_alt"
	item_state = "new_cut_alt"
	storage_slots = 3
	is_satchel = TRUE
	RightLeft = TRUE


/obj/item/weapon/storage/backpack/capelp
	name = "leather cape"
	desc = "A fancy leather cape."
	icon_state = "capelp"
	item_state = "capelp"
	storage_slots = 2
	is_satchel = TRUE
	diffcolor = "#800000"

/obj/item/weapon/storage/backpack/capelp/New()
	. = ..()
	diffcolor = pick("#800000", "#ff8c69", "#753843", "#722f37")

/obj/item/weapon/storage/backpack/consyte
	name = "consyte's cloak"
	icon_state = "consyte"
	item_state = "consyte"
	storage_slots = 2
	is_satchel = TRUE
	RightLeft = TRUE


/obj/item/weapon/storage/backpack/merccloak
	name = "black's cloak"
	desc = "A fancy dark cloak for the mercenaries."
	icon_state = "ath"
	item_state = "ath"
	storage_slots = 2
	is_satchel = TRUE
	RightLeft = TRUE

/obj/item/weapon/storage/backpack/svalinncloak
	name = "svalinn cloak"
	desc = "A fancy leather cloak."
	icon_state = "svalinn-cloak"
	item_state = "svalinn-cloak"
	storage_slots = 2
	is_satchel = TRUE

/obj/item/weapon/storage/backpack/coldpack
	name = "coldpack"
	desc = "Portable freezer."
	icon_state = "fridge"
	item_state = "fridge"
	storage_slots = 6
	is_satchel = FALSE

/obj/item/weapon/storage/backpack/bfather
	name = "lord's cloak"
	desc = "A fancy red cloak for the lord."
	icon_state = "bfather"
	item_state = "bfather"
	storage_slots = 3
	is_satchel = TRUE

/obj/item/weapon/storage/backpack/count
	name = "count's cloak"
	desc = "A fancy brown cloak for the lord."
	icon_state = "count"
	item_state = "count"
	storage_slots = 3
	is_satchel = TRUE

/obj/item/weapon/storage/backpack/count/countess
	name = "countess's cloak"
	desc = "A fancy black cloak for the lord."
	icon_state = "countess"
	item_state = "countess"
	storage_slots = 3
	is_satchel = TRUE
	RightLeft = TRUE

/obj/item/weapon/storage/backpack/santabag
	name = "Santa's Gift Bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space in Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state = "giftbag"
	w_class = 4.0
	storage_slots = 20
	max_w_class = 3
	max_combined_w_class = 400 // can store a ton of shit!

/obj/item/weapon/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear and proudly declaring your insanity."
	icon_state = "cultpack"

/obj/item/weapon/storage/backpack/clown
	name = "Giggles von Honkerton"
	desc = "It's a backpack made by Honk! Co."
	icon_state = "clownpack"
	item_state = "clownpack"

/obj/item/weapon/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack especially designed for use in a sterile environment."
	icon_state = "medicalpack"
	item_state = "medicalpack"

/obj/item/weapon/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack."
	icon_state = "securitypack"
	item_state = "securitypack"

/obj/item/weapon/storage/backpack/captain
	name = "captain's backpack"
	desc = "It's a special backpack made exclusively for Nanotrasen officers."
	icon_state = "captainpack"
	item_state = "captainpack"

/obj/item/weapon/storage/backpack/industrial
	name = "backpack"
	icon_state = "engiepack"
	item_state = "backpack_eng"

/obj/item/weapon/storage/backpack/migrant
	name = "backpack"
	icon_state = "engiepack"
	item_state = "engiepack"
	var/maincolor
	var/icon/mob
	flags = FPRINT | TABLEPASS
	update_icon(var/mob/living/carbon/human/user)
		/*if(user?.gender == FEMALE)
			mob = new/icon("icon" = 'icons/mob/uniform_f.dmi', "icon_state" = "migrant")
		else
			mob = new/icon("icon" = 'icons/mob/uniform.dmi', "icon_state" = "migrant")
		mob.SwapColor(color2,maincolor)
		mob.SwapColor(color1,secondcolor)
		mob.Blend(migover,ICON_OVERLAY)*/
		var/image/stateover
		stateover = image("icon" = 'icons/obj/storage.dmi', "icon_state" = "backpackolay")
		stateover.color = maincolor
		src.overlays += stateover
/*
 * Satchel Types
 */

/obj/item/weapon/storage/backpack/satchel
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "satchel"
	item_state = "satchel"
	is_satchel = TRUE
	storage_slots = 4

/obj/item/weapon/storage/backpack/satchel/smith/New()
	. = ..()
	if(prob(40))
		src.contents += new/obj/item/weapon/ore/refined/lw/ironlw
		src.contents += new/obj/item/weapon/ore/refined/lw/ironlw
		src.contents += new/obj/item/weapon/ore/refined/lw/copperlw
		src.contents += new/obj/item/weapon/ore/refined/lw/silverlw
	else if(prob(20))
		src.contents += new/obj/item/weapon/ore/refined/lw/ironlw
		src.contents += new/obj/item/weapon/ore/refined/lw/goldlw
		src.contents += new/obj/item/weapon/ore/refined/lw/copperlw
		src.contents += new/obj/item/weapon/ore/refined/lw/silverlw
	else
		src.contents += new/obj/item/weapon/ore/refined/lw/ironlw
		src.contents += new/obj/item/weapon/ore/refined/lw/ironlw
		src.contents += new/obj/item/weapon/ore/refined/lw/copperlw
		src.contents += new/obj/item/weapon/ore/refined/lw/ironlw

/obj/item/weapon/storage/backpack/minisatchel
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "minisatchel"
	item_state = "satchel"
	is_satchel = TRUE
	storage_slots = 3

/obj/item/weapon/storage/backpack/minisatchel/francisco/New()
	. = ..()
	storage_slots = 4
	src.contents += new/obj/item/stack/bullets/Richter/six
	src.contents += new/obj/item/stack/bullets/rifle/nine
	src.contents += new/obj/item/device/camera
	src.contents += new/obj/item/weapon/gun/projectile/newRevolver/duelista/richter

/obj/item/weapon/storage/backpack/minisatchel/satchelthanati/New()
	. = ..()
	name = "bomb satchel"
	desc = "Torn and weathered. Seems like it could fit a few sticks of dynamite."
	storage_slots = 7
	src.contents += new/obj/item/weapon/flame/candle/tnt/bundle
	src.contents += new/obj/item/weapon/flame/candle/tnt/stick
	src.contents += new/obj/item/weapon/flame/candle/tnt/stick
	src.contents += new/obj/item/weapon/flame/candle/tnt/stick
	src.contents += new/obj/item/weapon/flame/candle/tnt/stick
	src.contents += new/obj/item/weapon/flame/candle/tnt/stick
	src.contents += new/obj/item/weapon/flame/candle/tnt/stick


/obj/item/weapon/storage/backpack/minisatchelchurch
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "minisatchel2"
	item_state = "satchel"
	is_satchel = TRUE
	storage_slots = 6


/obj/item/weapon/storage/backpack/minisatchelchurch2
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "minisatchel3"
	item_state = "satchel"
	is_satchel = TRUE
	storage_slots = 6


/obj/item/weapon/storage/backpack/beltsatchelchurch
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "beltsatchel"
	item_state = "satchel"
	is_satchel = TRUE
	storage_slots = 3
	slot_flags = SLOT_BELT


/obj/item/weapon/storage/backpack/beltsatchel
	name = "leather satchel"
	desc = "It's a very fancy satchel made with fine leather."
	icon_state = "beltsatchel2"
	item_state = "satchel"
	is_satchel = TRUE
	storage_slots = 3
	slot_flags = SLOT_BELT

/obj/item/weapon/storage/backpack/beltsatchelthanati
	name = "bomb belt satchel"
	desc = "Torn and weathered. You can make out the initials 'A.H'. Hmm."
	icon_state = "beltsatchel2"
	item_state = "satchel"
	is_satchel = TRUE
	storage_slots = 7
	slot_flags = SLOT_BELT

/obj/item/weapon/storage/backpack/beltsatchelthanati/bomb/New()
	. = ..()
	src.contents += new/obj/item/weapon/flame/candle/tnt/bundle
	src.contents += new/obj/item/weapon/flame/candle/tnt/stick
	src.contents += new/obj/item/weapon/flame/candle/tnt/stick
	src.contents += new/obj/item/weapon/flame/candle/tnt/stick
	src.contents += new/obj/item/weapon/flame/candle/tnt/stick
	src.contents += new/obj/item/weapon/flame/candle/tnt/stick
	src.contents += new/obj/item/weapon/flame/candle/tnt/stick



/obj/item/weapon/storage/backpack/satchel_norm
	name = "satchel"
	desc = "A trendy looking satchel."
	icon_state = "satchel-norm"

/obj/item/weapon/storage/backpack/satchel_eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"
	item_state = "engiepack"

/obj/item/weapon/storage/backpack/satchel_med
	name = "medical satchel"
	desc = "A sterile satchel used in medical departments."
	icon_state = "satchel-med"
	item_state = "medicalpack"

/obj/item/weapon/storage/backpack/satchel_vir
	name = "virologist satchel"
	desc = "A sterile satchel with virologist colours."
	icon_state = "satchel-vir"

/obj/item/weapon/storage/backpack/satchel_chem
	name = "chemist satchel"
	desc = "A sterile satchel with chemist colours."
	icon_state = "satchel-chem"

/obj/item/weapon/storage/backpack/satchel_gen
	name = "geneticist satchel"
	desc = "A sterile satchel with geneticist colours."
	icon_state = "satchel-gen"

/obj/item/weapon/storage/backpack/satchel_tox
	name = "scientist satchel"
	desc = "Useful for holding research materials."
	icon_state = "satchel-tox"

/obj/item/weapon/storage/backpack/satchel_sec
	name = "security satchel"
	desc = "A robust satchel for security related needs."
	icon_state = "satchel-sec"
	item_state = "securitypack"

/obj/item/weapon/storage/backpack/satchel_hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant related work."
	icon_state = "satchel_hyd"

/obj/item/weapon/storage/backpack/satchel_cap
	name = "captain's satchel"
	desc = "An exclusive satchel for Nanotrasen officers."
	icon_state = "satchel-cap"
	item_state = "captainpack"