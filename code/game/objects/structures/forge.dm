/**************************************************************
***************************************************************
************** SE ALGUEM ALGUM DIA LER ISSO *******************
************** ISSO E PURO PUNHETA CODING. ********************
************** REFACA SE PUDER, NAO TENTE *********************
************** CONTINUAR A PUNHETOVISK. ***********************
***************************************************************
**************************************************************/

//e assim todos continuaram a punhetovisk.... - thuxtk

/**************************************************************
***************************************************************
************** ENTAO DO PO DA TERRA  O SENHOR******************
************** CRIOU O SER HUMANO....    . ********************
**************************************************************/

////////////////////////////FORJA/////////////////////////////
/obj/structure/forja
	name = "forge"
	desc = "A forge used to heat metals."
	icon = 'icons/obj/forja.dmi'
	icon_state = "forja0"
	density = 1
	anchored = 1
	var/onfire = 0
	var/brightness_red = 3
	var/brightness_green = 3
	var/brightness_blue = 2

/obj/structure/forja/update_icon()
	if(onfire)
		icon_state = "forja1"
		src.SetLuminosity(brightness_red, brightness_green, brightness_blue)
	else
		icon_state = "forja0"
		src.SetLuminosity(0)

/obj/structure/forja/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/F = W
		if(F.lit)
			onfire = 1
			update_icon()
		else	if(onfire)
			F.lit = 1
			F.update_icon()

	if(istype(W, /obj/item/weapon/alicate))
		var/obj/item/weapon/alicate/A = W
		if(A.stored && A.storedby && onfire)
			user.visible_message("<span class='notice'><B>[user]</B> heats the ingot in the [src]!")
			A.quentura += 10
			A.update_icon()


/obj/structure/forja/attack_hand(mob/user as mob)
	onfire = 0
	update_icon()

////////////////////////////BIGORNA/////////////////////////////

/obj/structure/anvil
	name = "anvil"
	desc = "An anvil used for blacksmithing."
	icon_state = "anvil"
	density = 1
	anchored = 1
	var/metalin
	var/completo
	var/oquefazer
	var/quentura

/obj/structure/anvil/New()
	processing_objects.Add(src)
	. = ..()

/obj/structure/anvil/Destroy()
	processing_objects.Remove(src)
	. = ..()

/obj/structure/anvil/process()
	if(!metalin) return
	if(quentura <= 0) return
	quentura--
	update_icon()

/obj/structure/anvil/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/alicate))
		var/obj/item/weapon/alicate/A = W
		if(!A.stored && !A.storedby && metalin)
			A.stored = 1
			A.storedby = "Iron ore"
			A.quentura = 0
			A.update_icon()
			if(oquefazer)
				A.item_to_become = oquefazer
				oquefazer = null
			metalin = 0
			A.completou = 1
			completo = 0
			update_icon()
			return

		if(A.stored && A.storedby)
			if(!A.quentura)
				to_chat(user, "<span class='notice'>The ingot is too cold.</span>")
			else if(A.quentura)
				quentura = A.quentura
				A.stored = 0
				A.storedby = ""
				A.quentura = 0
				A.update_icon()
				if(!oquefazer && A.item_to_become)
					oquefazer = A.item_to_become
				metalin = 1
				update_icon()
	if(istype(W, /obj/item/weapon/sledgehammer))
		if(!quentura)
			to_chat(user, "<span class = 'notice'>The ingot is too cold.</span>")
			return
		if(metalin && oquefazer && completo < 100 )
			completo += rand(7,12)
			playsound(src.loc, 'sound/effects/forge.ogg', 25, 1)
			user.visible_message("<span class='notice'><B>[user]</B> strikes the ingot!")
		if(metalin && !oquefazer)	
			oquefazer = input("What do you want to forge?", "Farweb") in list("long sword","bastard sword","sabre", "bardiche", "spear", "falchion", "axe", "pitchfork","iron plate armor","Iron mask", "iron cuirass", "iron breastplate", "iron open helmet", "dildo", "steel gauntlets", "elite helmet", "skull open iron helmet","squire armor", "sledgehammer","Alicate de aço","Shovel","Pickaxe","Club","Light Club","Dagger", "combat knife","knife","handcuffs","chain","klevetz","crossbow","bolt","shield")
		if(completo >= 100)
			to_chat(user, "<span class='notice'><b>The ingot is done.</b> I need to quench it.</span>")

/obj/structure/anvil/update_icon()
	if(metalin && quentura >= 1)
		icon_state = "anvil1"
		return
	if(metalin && quentura == 0)
		icon_state = "anvil2"
		return
	else
		icon_state = "anvil"
		return

/**************************ITEMS******************************/

/obj/item/weapon/sledgehammer
	name = "forge hammer"
	icon_state = "sledgehammer"
	item_state = "sledgehammer"
	force = 20
	desc = "A hammer used by blacksmiths to strike metal."
	w_class = 3
	slot_flags = SLOT_BELT

/obj/item/weapon/alicate
	name = "tongs"
	desc = "A set of steel pliers used by blacksmiths to handle hot metals."
	icon_state = "tongue"
	item_state = "tongue"
	w_class = 3
	slot_flags = SLOT_BELT
	force = 5
	var/stored = 1
	var/storedby = ""
	var/quentura = 0
	var/completou = 0
	var/item_to_become // para smith, pra virar algo na quench

/obj/item/weapon/alicate/attack_self(mob/living/user)
	if(stored && storedby == "Iron ore")
		stored = 0
		storedby = 0
		update_icon()
		new /obj/item/weapon/ore/refined/ironlw(user.loc)

/obj/item/weapon/alicate/update_icon()
	if(stored && storedby)
		if(quentura)
			icon_state = "tongue_hot"
		else
			icon_state = "tongue_cold"
	else
		icon_state = "tongue"

/obj/item/weapon/alicate/process()
	if(!stored)
		return
	quentura--
	update_icon()

/**************************ITEMS******************************/

/obj/structure/forge
	name = "Smelter"
	desc = "A smelter used to smelt metals."
	icon_state = "smelter"
	density = 0
	anchored = 1
	var/content = ""
	var/contentcoal = "" // Oh senhor, me desculpe pelo PUNHEITORREIRA coding.
	var/on = 0
	var/tocomplete = 0

/obj/structure/forge/update_icon()
	if(on)
		icon_state = "smelter1"
	else
		icon_state = "smelter"

/obj/structure/forge/proc/ByName()
	switch(content)
		if("Iron ore")
			return /obj/item/weapon/ore/refined/ironlw

/obj/structure/forge/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(on)
		return


	// AQUI E O DE FERRO
	if(istype(W, /obj/item/weapon/ore/ironlw))
		var/obj/item/weapon/ore/ironlw/I = W
		if(content == "")
			content = "[I.name]"
		qdel(I)


	// AQUI E O DE CARVAO
	if(istype(W, /obj/item/weapon/ore/coal))
		var/obj/item/weapon/ore/coal/I = W
		if(contentcoal == "")
			contentcoal = "[I.name]"
		qdel(I)

	if(istype(W, /obj/item/weapon/flame))
		if(!content || !contentcoal) return
		on = 1
		update_icon()
		if(on)
			while(1)
				sleep(10)
				tocomplete += 10
				playsound(src.loc, 'sound/effects/smelter_sound.ogg', 50, 0)
				if(tocomplete >= 100)
					new/obj/item/weapon/ore/refined/ironlw(src.loc)
					on = 0
					tocomplete = 0
					content = ""
					update_icon()
					break

/obj/structure/water
	name = "water barrel"
	desc = "A water barrel with water inside. Duh."
	icon_state = "water_barrel"
	density = 1
	anchored = 0

/obj/structure/water/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/alicate))
		var/obj/item/weapon/alicate/A = W
		if(A.stored && A.storedby && A.completou)
			if(A.item_to_become == "long sword")
				new/obj/item/weapon/claymore(user.loc)
			if(A.item_to_become == "bastard sword")
				new/obj/item/weapon/claymore/bastard(user.loc)
			if(A.item_to_become == "sabre")
				new/obj/item/weapon/claymore/sabre(user.loc)
			if(A.item_to_become == "bardiche")
				new/obj/item/weapon/claymore/bardiche(user.loc)
			if(A.item_to_become == "spear")
				new/obj/item/weapon/claymore/spear(user.loc)
			if(A.item_to_become == "falchion")
				new/obj/item/weapon/claymore/falchion(user.loc)
			if(A.item_to_become == "axe")
				new/obj/item/weapon/hatchet(user.loc)
			if(A.item_to_become == "pitchfork")
				new/obj/item/weapon/minihoe(user.loc)
			if(A.item_to_become == "iron plate armor")
				new/obj/item/clothing/suit/armor/vest/iron_plate(user.loc)
			if(A.item_to_become == "iron breastplate")
				new/obj/item/clothing/suit/armor/vest/iron_breastplate(user.loc)
			if(A.item_to_become == "iron cuirass")
				new/obj/item/clothing/suit/armor/vest/iron_cuirass(user.loc)
			if(A.item_to_become == "steel gauntlets")
				new/obj/item/clothing/gloves/combat/gauntlet/steel(user.loc)
			if(A.item_to_become == "iron open helmet")
				new/obj/item/clothing/head/helmet/lw/ironopenhelmet(user.loc)
			if(A.item_to_become == "elite helmet")
				new/obj/item/clothing/head/helmet/lw/elitehelmet(user.loc)
			if(A.item_to_become == "skull open iron helmet")
				new/obj/item/clothing/head/helmet/lw/openskulliron(user.loc)
			if(A.item_to_become == "dildo")
				new/obj/item/weapon/dildo(user.loc)
			if(A.item_to_become == "squire armor")
				new/obj/item/clothing/suit/armor/vest/squire(user.loc)
			if(A.item_to_become == "sledgehammer")
				new/obj/item/weapon/sledgehammer(user.loc)
			if(A.item_to_become == "Alicate de aço")
				new/obj/item/weapon/alicate(user.loc)
			if(A.item_to_become == "Shovel")
				new/obj/item/weapon/shovel(user.loc)
			if(A.item_to_become == "Iron mask")
				new/obj/item/clothing/mask/ironmask(user.loc)
			if(A.item_to_become == "Pickaxe")
				new/obj/item/weapon/pickaxe(user.loc)
			if(A.item_to_become == "Club")
				new/obj/item/weapon/melee/classic_baton/club(user.loc)
			if(A.item_to_become == "Light Club")
				new/obj/item/weapon/melee/classic_baton/smallclub(user.loc)
			if(A.item_to_become == "Dagger")
				new/obj/item/weapon/kitchen/utensil/knife/dagger(user.loc)
			if(A.item_to_become == "combat knife")
				new/obj/item/weapon/kitchen/utensil/knife/combat(user.loc)
			if(A.item_to_become == "knife")
				new/obj/item/weapon/kitchenknife(user.loc)
			if(A.item_to_become == "handcuffs")
				new/obj/item/weapon/handcuffs(user.loc)
			if(A.item_to_become == "chain")
				new/obj/item/weapon/melee/chainofcommand(user.loc)
			if(A.item_to_become == "klevetz")
				new/obj/item/weapon/melee/classic_baton/klevetz(user.loc)
			if(A.item_to_become == "crossbow")
				new/obj/item/weapon/crossbow(user.loc)
			if(A.item_to_become == "bolt")
				new/obj/item/weapon/arrow(user.loc)
			if(A.item_to_become == "shield")
				new/obj/item/weapon/shield/wood(user.loc)
			var/sound_to_go = pick('sound/effects/quench_barrel1.ogg', 'sound/effects/quench_barrel2.ogg')
			playsound(src.loc, sound_to_go, 50, 0)
			A.stored = 0
			A.storedby = ""
			A.item_to_become = null
			A.quentura = 0
			A.update_icon()
			A.completou = 0