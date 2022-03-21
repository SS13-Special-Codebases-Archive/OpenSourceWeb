/*-------------------------- FABRICA E GESCHEF -----------------------
|  Coisas de Factory & Geschef
|
|  Shoemaking - 100%
|
|  Food Export - 0%
|
|  Cans - 0%
|
|  Geschef - 0%
|
|  Factory Kid - 80%
*-------------------------------------------------------------------*/

//Máquina
/obj/structure/factory/shoemaking
	name = "shoemaking bench"
	icon = 'icons/obj/objects.dmi'
	anchored = TRUE
	density = TRUE

	icon_state = "shoework"
	var/onCooldown = FALSE

//Quantidade de materiais
/obj/structure/factory/shoemaking/examine()
	..()
	if(contents.len >= 1)
		to_chat(usr, "<span class='passive'>it has [contents.len] leather in it.</span>")
	else
		to_chat(usr, "<span class='combatbold'>it's empty!</span>")

//Colocar material
/obj/structure/factory/shoemaking/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(onCooldown)
		return
	if(istype(W, /obj/item/stack/sheet/leather) && src.contents.len < 5)
		var/obj/item/stack/sheet/leather/L = W
		L.use(1)
		new /obj/item/stack/sheet/leather(src)
		playsound(src, 'newchem_insert.ogg', 80, 1)
		return
	else
		..()

//Criar Sapatos
/obj/structure/factory/shoemaking/attack_hand(mob/user as mob)
	if(onCooldown)
		return
	if(!ishuman(user))	return

	var/mob/living/carbon/human/Shoemaker = user

	if(Shoemaker.stat != 0)	return

	if(!Shoemaker.check_perk(/datum/perk/shoemaking))
		to_chat(usr, "<span class='combatbold'>[pick(nao_consigoen)] How do I use this?</span>")
		return

	if(src.contents.len >= 1)
		playsound(src, 'fabric_production.ogg', 80, 1)
		if(do_after(user, 28))
			onCooldown = TRUE
			var/obj/item/I = pick(src.contents)
			qdel(I)
			playsound(src, 'mach1.ogg', 80, 1)
			spawn(10)
				onCooldown = FALSE
				new /obj/item/clothing/shoes/lw/geschef(src.loc)
				to_chat(user, "<span class='passive'>Shoe made!</span>")
			return
		else
			return
	else
		to_chat(usr, "<span class='combatbold'>[pick(nao_consigoen)] I have ([contents.len]/5) amounts of leather!</span>")
		return
	..()

//////////////////////
/////////ITEMS////////
//////////////////////

/obj/item/clothing/shoes/lw/geschef
	name = "shoes"
	icon_state = "geschef"
	item_worth = 8
	New()
		..()
		item_worth = rand(8,10)