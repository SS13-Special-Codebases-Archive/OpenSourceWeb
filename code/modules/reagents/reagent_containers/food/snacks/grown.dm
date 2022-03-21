

// ***********************************************************
// Foods that are produced from hydroponics ~~~~~~~~~~
// Data from the seeds carry over to these grown foods
// ***********************************************************

//Grown foods
//Subclass so we can pass on values
/obj/item/weapon/reagent_containers/food/snacks/grown/
	var/plantname
	var/potency = -1
	var/seed_name = null //used to fill plant with reagents. Falls back to plantname if not set
	icon = 'icons/obj/harvest.dmi'
	New(newloc,newpotency)
		if (!isnull(newpotency))
			potency = newpotency
		..()
		src.pixel_x = rand(-5.0, 5)
		src.pixel_y = rand(-5.0, 5)
	var/no_seeds = FALSE

/obj/item/weapon/reagent_containers/food/snacks/grown/New()
	..()
	item_worth = rand(3,4)
	//Handle some post-spawn var stuff.
	spawn(1)
		var/seed_datum = plantname
		if(seed_name)
			seed_datum = seed_name
		// Fill the object up with the appropriate reagents.
		if(!isnull(seed_datum))
			var/datum/seed/S = seed_types[seed_datum]
			if(!S || !S.chems)
				return

			potency = S.potency

			for(var/rid in S.chems)
				var/list/reagent_data = S.chems[rid]
				var/rtotal = reagent_data[1]
				if(reagent_data.len > 1 && potency > 0)
					rtotal += round(potency/reagent_data[2])
				reagents?.add_reagent(rid,max(1,rtotal))

		if(reagents.total_volume > 0)
			bitesize = 1+round(reagents.total_volume / 2, 1)

/obj/item/weapon/reagent_containers/food/snacks/grown/corn
	name = "ear of corn"
	desc = "Needs some butter!"
	plantname = "corn"
	icon_state = "corn"
	potency = 40
	filling_color = "#FFEE00"

/obj/item/weapon/reagent_containers/food/snacks/grown/cherries
	name = "cherries"
	desc = "Great for toppings!"
	icon_state = "cherry"
	filling_color = "#FF0000"
	gender = PLURAL
	plantname = "cherry"

/obj/item/weapon/reagent_containers/food/snacks/grown/poppy
	name = "poppy"
	desc = "Long-used as a symbol of rest, peace, and death."
	icon_state = "poppy"
	potency = 30
	filling_color = "#CC6464"
	plantname = "poppies"

/obj/item/weapon/reagent_containers/food/snacks/grown/harebell
	name = "harebell"
	desc = "\"I'll sweeten thy sad grave: thou shalt not lack the flower that's like thy face, pale primrose, nor the azured hare-bell, like thy veins; no, nor the leaf of eglantine, whom not to slander, out-sweeten�d not thy breath.\""
	icon_state = "harebell"
	potency = 1
	filling_color = "#D4B2C9"
	plantname = "harebells"

/obj/item/weapon/reagent_containers/food/snacks/grown/potato
	name = "potato"
	desc = "Boil 'em! Mash 'em! Stick 'em in a stew!"
	icon_state = "potato"
	potency = 25
	filling_color = "#E6E8DA"
	plantname = "potato"
	no_seeds = TRUE

/obj/item/weapon/reagent_containers/food/snacks/grown/beet
	name = "beet"
	desc = "A beet."
	icon_state = "beet"
	potency = 25
	filling_color = "#E6E8DA"
	plantname = "beet"
	seed_name = "carrot" //TEMP
/obj/item/weapon/reagent_containers/food/snacks/grown/turnip
	name = "turnip"
	desc = "A turnip."
	icon_state = "turnip"
	potency = 25
	filling_color = "#E6E8DA"
	plantname = "turnip"
	seed_name = "carrot" //TEMP
/obj/item/weapon/reagent_containers/food/snacks/grown/onion
	name = "onion"
	desc = "A onion."
	icon_state = "turnip"
	potency = 25
	filling_color = "#E6E8DA"
	plantname = "onion"
	seed_name = "onion" //TEMP

/obj/item/weapon/reagent_containers/food/snacks/grown/garlic
	name = "garlic"
	desc = "A garlic."
	icon_state = "cabbage"
	potency = 25
	filling_color = "#E6E8DA"
	plantname = "garlic"

/obj/item/weapon/reagent_containers/food/snacks/grown/pigtail
	name = "pigtail"
	desc = "A pigtail."
	icon_state = "pigtail"
	potency = 25
	filling_color = "#E6E8DA"
	plantname = "pigtail"
	seed_name = "pigtail" //TEMP.

/obj/item/weapon/reagent_containers/food/snacks/grown/sweetpod
	name = "sweet pod"
	desc = "A sweet pod."
	icon_state = "sweetpod"
	potency = 25
	filling_color = "#E6E8DA"
	plantname = "sweetpod"
	seed_name = "sweetpod" //TEMP.

/obj/item/weapon/reagent_containers/food/snacks/grown/grapes
	name = "bunch of grapes"
	desc = "Nutritious!"
	icon_state = "grapes"
	filling_color = "#A332AD"
	plantname = "grapes"

/obj/item/weapon/reagent_containers/food/snacks/grown/greengrapes
	name = "bunch of green grapes"
	desc = "Nutritious!"
	icon_state = "greengrapes"
	potency = 25
	filling_color = "#A6FFA3"
	plantname = "greengrapes"

/obj/item/weapon/reagent_containers/food/snacks/grown/peanut
	name = "peanut"
	desc = "Nuts!"
	icon_state = "peanut"
	filling_color = "857e27"
	potency = 25
	plantname = "peanut"

/obj/item/weapon/reagent_containers/food/snacks/grown/cabbage
	name = "cabbage"
	desc = "Ewwwwwwwwww. Cabbage."
	icon_state = "cabbage"
	potency = 25
	filling_color = "#A2B5A1"
	plantname = "cabbage"

/obj/item/weapon/reagent_containers/food/snacks/grown/berries
	name = "bunch of berries"
	desc = "Nutritious!"
	icon_state = "berrypile"
	filling_color = "#C2C9FF"
	plantname = "berries"

/obj/item/weapon/reagent_containers/food/snacks/grown/plastellium
	name = "clump of plastellium"
	desc = "Hmm, needs some processing"
	icon_state = "plastellium"
	filling_color = "#C4C4C4"
	plantname = "plastic"

/obj/item/weapon/reagent_containers/food/snacks/grown/shand
	name = "S'rendarr's Hand leaf"
	desc = "A leaf sample from a lowland thicket shrub. Smells strongly like wax."
	icon_state = "shand"
	filling_color = "#70C470"
	plantname = "shand"

/obj/item/weapon/reagent_containers/food/snacks/grown/mtear
	name = "sprig of Messa's Tear"
	desc = "A mountain climate herb with a soft, cold blue flower, known to contain an abundance of healing chemicals."
	icon_state = "mtear"
	filling_color = "#70C470"
	plantname = "mtuear"

/obj/item/weapon/reagent_containers/food/snacks/grown/New()
	..()
	desc = "A [name]."

/obj/item/weapon/reagent_containers/food/snacks/grown/mtear/attack_self(mob/user as mob)
	if(istype(user.loc,/turf/space))
		return
	var/obj/item/stack/medical/ointment/tajaran/poultice = new /obj/item/stack/medical/ointment/tajaran(user.loc)

	poultice.heal_burn = potency
	qdel(src)

	user << "<span class='notice'>You mash the petals into a poultice.</span>"

/obj/item/weapon/reagent_containers/food/snacks/grown/shand/attack_self(mob/user as mob)
	if(istype(user.loc,/turf/space))
		return
	var/obj/item/stack/medical/bruise_pack/tajaran/poultice = new /obj/item/stack/medical/bruise_pack/tajaran(user.loc)

	poultice.heal_brute = potency
	qdel(src)

	user << "<span class='notice'>You mash the leaves into a poultice.</span>"

/obj/item/weapon/reagent_containers/food/snacks/grown/glowberries
	name = "bunch of glow-berries"
	desc = "Nutritious!"
	var/light_on = 1
	var/brightness_on = 2 //luminosity when on
	filling_color = "#D3FF9E"
	icon_state = "glowberrypile"
	plantname = "glowberries"

/obj/item/weapon/reagent_containers/food/snacks/grown/glowberries/Destroy()


	..()

/obj/item/weapon/reagent_containers/food/snacks/grown/glowberries/pickup(mob/user)



/obj/item/weapon/reagent_containers/food/snacks/grown/glowberries/dropped(mob/user)



/obj/item/weapon/reagent_containers/food/snacks/grown/cocoapod
	name = "cocoa pod"
	desc = "Can be ground into cocoa powder."
	icon_state = "cocoapod"
	potency = 50
	filling_color = "#9C8E54"
	plantname = "cocoa"

/obj/item/weapon/reagent_containers/food/snacks/grown/sugarcane
	name = "sugarcane"
	desc = "Sickly sweet."
	icon_state = "sugarcane"
	potency = 50
	filling_color = "#C0C9AD"
	plantname = "sugarcane"

/obj/item/weapon/reagent_containers/food/snacks/grown/poisonberries
	name = "bunch of poison-berries"
	desc = "Taste so good, you could die!"
	icon_state = "poisonberrypile"
	gender = PLURAL
	potency = 15
	filling_color = "#B422C7"
	plantname = "poisonberries"

/obj/item/weapon/reagent_containers/food/snacks/grown/deathberries
	name = "bunch of death-berries"
	desc = "Taste so good, you could die!"
	icon_state = "deathberrypile"
	gender = PLURAL
	potency = 50
	filling_color = "#4E0957"
	plantname = "deathberries"

/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiavulgaris
	name = "ambrosia vulgaris branch"
	desc = "This is a plant containing various healing chemicals."
	icon_state = "ambrosiavulgaris"
	potency = 10
	filling_color = "#125709"
	plantname = "ambrosia"

/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus
	name = "ambrosia deus branch"
	desc = "Eating this makes you feel immortal!"
	icon_state = "ambrosiadeus"
	potency = 10
	filling_color = "#229E11"
	plantname = "ambrosiadeus"

/obj/item/weapon/reagent_containers/food/snacks/grown/apple
	name = "apple"
	desc = "It's a little piece of Eden."
	icon_state = "apple"
	potency = 15
	filling_color = "#DFE88B"
	plantname = "apple"

/obj/item/weapon/reagent_containers/food/snacks/grown/apple/poisoned
	name = "apple"
	desc = "It's a little piece of Eden."
	icon_state = "apple"
	potency = 15
	filling_color = "#B3BD5E"
	plantname = "poisonapple"

/obj/item/weapon/reagent_containers/food/snacks/grown/goldapple
	name = "golden apple"
	desc = "Emblazoned upon the apple is the word 'Kallisti'."
	icon_state = "goldapple"
	potency = 15
	filling_color = "#F5CB42"
	plantname = "goldapple"

/obj/item/weapon/reagent_containers/food/snacks/grown/watermelon
	name = "watermelon"
	desc = "It's full of watery goodness."
	icon_state = "watermelon"
	potency = 10
	filling_color = "#FA2863"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/watermelonslice
	slices_num = 5
	plantname = "watermelon"

/obj/item/weapon/reagent_containers/food/snacks/grown/pumpkin
	name = "pumpkin"
	desc = "It's large and scary."
	icon_state = "pumpkin"
	potency = 10
	filling_color = "#FAB728"
	plantname = "pumpkin"

/obj/item/weapon/reagent_containers/food/snacks/grown/pumpkin/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/surgery_tool/circular_saw) || istype(W, /obj/item/weapon/hatchet) || istype(W, /obj/item/weapon/twohanded/fireaxe) || istype(W, /obj/item/weapon/kitchen/utensil/knife) || istype(W, /obj/item/weapon/kitchenknife) || istype(W, /obj/item/weapon/melee/energy))
		user.show_message("<span class='notice'>You carve a face into [src]!</span>", 1)
		new /obj/item/clothing/head/pumpkinhead (user.loc)
		qdel(src)
		return

/obj/item/weapon/reagent_containers/food/snacks/grown/lime
	name = "lime"
	desc = "It's so sour, your face will twist."
	icon_state = "lime"
	potency = 20
	filling_color = "#28FA59"
	plantname = "lime"

/obj/item/weapon/reagent_containers/food/snacks/grown/lemon
	name = "lemon"
	desc = "When life gives you lemons, be grateful they aren't limes."
	icon_state = "lemon"
	potency = 20
	filling_color = "#FAF328"
	plantname = "lemon"

/obj/item/weapon/reagent_containers/food/snacks/grown/orange
	name = "orange"
	desc = "It's an tangy fruit."
	icon_state = "orange"
	potency = 20
	filling_color = "#FAAD28"
	plantname = "orange"

/obj/item/weapon/reagent_containers/food/snacks/grown/whitebeet
	name = "white-beet"
	desc = "You can't beat white-beet."
	icon_state = "whitebeet"
	potency = 15
	filling_color = "#FFFCCC"
	plantname = "whitebeet"

/obj/item/weapon/reagent_containers/food/snacks/grown/banana
	name = "banana"
	desc = "It's an excellent prop for a comedy."
	icon = 'icons/obj/items.dmi'
	icon_state = "banana"
	item_state = "banana"
	filling_color = "#FCF695"
	trash = /obj/item/weapon/bananapeel
	plantname = "banana"

/obj/item/weapon/reagent_containers/food/snacks/grown/chili
	name = "chili"
	desc = "It's spicy! Wait... IT'S BURNING ME!!"
	icon_state = "chilipepper"
	filling_color = "#FF0000"
	plantname = "chili"

/obj/item/weapon/reagent_containers/food/snacks/grown/eggplant
	name = "eggplant"
	desc = "Maybe there's a chicken inside?"
	icon_state = "eggplant"
	filling_color = "#550F5C"
	plantname = "eggplant"

/obj/item/weapon/reagent_containers/food/snacks/grown/soybeans
	name = "soybeans"
	desc = "It's pretty bland, but oh the possibilities..."
	gender = PLURAL
	filling_color = "#E6E8B7"
	icon_state = "soybeans"
	plantname = "soybean"

/obj/item/weapon/reagent_containers/food/snacks/grown/tomato
	name = "tomato"
	desc = "I say to-mah-to, you say tom-mae-to."
	icon_state = "tomato"
	filling_color = "#FF0000"
	potency = 10
	plantname = "tomato"

/obj/item/weapon/reagent_containers/food/snacks/grown/tomato/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/tomato_smudge(src.loc)
	src.visible_message("<span class='notice'>The [src.name] has been squashed.</span>","<span class='moderate'>You hear a smack.</span>")
	qdel(src)
	return

/obj/item/weapon/reagent_containers/food/snacks/grown/killertomato
	name = "killer-tomato"
	desc = "I say to-mah-to, you say tom-mae-to... OH GOD IT'S EATING MY LEGS!!"
	icon_state = "killertomato"
	potency = 10
	filling_color = "#FF0000"
	potency = 30
	plantname = "killertomato"

/obj/item/weapon/reagent_containers/food/snacks/grown/killertomato/attack_self(mob/user as mob)
	if(istype(user.loc,/turf/space))
		return
	new /mob/living/simple_animal/tomato(user.loc)
	qdel(src)

	user << "<span class='notice'>You plant the killer-tomato.</span>"

/obj/item/weapon/reagent_containers/food/snacks/grown/bloodtomato
	name = "blood-tomato"
	desc = "So bloody...so...very...bloody....AHHHH!!!!"
	icon_state = "bloodtomato"
	potency = 10
	filling_color = "#FF0000"
	plantname = "bloodtomato"

/obj/item/weapon/reagent_containers/food/snacks/grown/bloodtomato/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/blood/splatter(src.loc)
	src.visible_message("<span class='notice'>The [src.name] has been squashed.</span>","<span class='moderate'>You hear a smack.</span>")
	src.reagents.reaction(get_turf(hit_atom))
	for(var/atom/A in get_turf(hit_atom))
		src.reagents.reaction(A)
	qdel(src)
	return

/obj/item/weapon/reagent_containers/food/snacks/grown/bluetomato
	name = "blue-tomato"
	desc = "I say blue-mah-to, you say blue-mae-to."
	icon_state = "bluetomato"
	potency = 10
	filling_color = "#586CFC"
	plantname = "bluetomato"

/obj/item/weapon/reagent_containers/food/snacks/grown/bluetomato/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/blood/oil(src.loc)
	src.visible_message("<span class='notice'>The [src.name] has been squashed.</span>","<span class='moderate'>You hear a smack.</span>")
	src.reagents.reaction(get_turf(hit_atom))
	for(var/atom/A in get_turf(hit_atom))
		src.reagents.reaction(A)
	qdel(src)
	return

/obj/item/weapon/reagent_containers/food/snacks/grown/bluetomato/Crossed(AM as mob|obj)
	if (istype(AM, /mob/living/carbon))
		var/mob/M =	AM
		if (istype(M, /mob/living/carbon/human) && (isobj(M:shoes) && M:shoes.flags&NOSLIP) || M.buckled)
			return

		M.stop_pulling()
		M << "\blue You slipped on the [name]!"
		playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
		M.Stun(8)
		M.Weaken(5)

/obj/item/weapon/reagent_containers/food/snacks/grown/wheat
	name = "wheat"
	desc = "Sigh... wheat... a-grain?"
	gender = PLURAL
	icon_state = "wheat"
	filling_color = "#F7E186"
	plantname = "wheat"

/obj/item/weapon/reagent_containers/food/snacks/grown/weed
	name = "cannabis"
	desc = "Smoke weed everyday."
	gender = PLURAL
	icon_state = "weed"
	filling_color = "#F7E186"
	plantname = "weed"

/obj/item/weapon/reagent_containers/food/snacks/grown/ricestalk
	name = "rice stalk"
	desc = "Rice to see you."
	gender = PLURAL
	icon_state = "rice"
	filling_color = "#FFF8DB"
	plantname = "rice"

/obj/item/weapon/reagent_containers/food/snacks/grown/kudzupod
	name = "kudzu pod"
	desc = "<I>Pueraria Virallis</I>: An invasive species with vines that rapidly creep and wrap around whatever they contact."
	icon_state = "kudzupod"
	filling_color = "#59691B"
	plantname = "kudzu"

/obj/item/weapon/reagent_containers/food/snacks/grown/icepepper
	name = "ice-pepper"
	desc = "It's a mutant strain of chili"
	icon_state = "icepepper"
	potency = 20
	filling_color = "#66CEED"
	plantname = "icechili"

/obj/item/weapon/reagent_containers/food/snacks/grown/carrot
	name = "carrot"
	desc = "It's good for the eyes!"
	icon_state = "carrot"
	potency = 10
	filling_color = "#FFC400"
	plantname = "carrot"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom
	var/real_name = "mushroom"
	var/cooked = FALSE
	var/seedtype
	var/firstpick = FALSE

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/pickup(mob/user)
	if(!firstpick)
		firstpick = TRUE
		playsound(src.loc, pick('itm_ingredient_mushroom_up_01.ogg','itm_ingredient_mushroom_up_02.ogg','itm_ingredient_mushroom_up_03.ogg','itm_ingredient_mushroom_up_04.ogg'), 70, 0)

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/morfiannik
	name = "Morfiannik"
	desc = "You probably shouldn't eat this."
	icon_state = "morfiannik"
	potency = 10
	filling_color = "#FF4800"
	plantname = "morfiannik"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/podgnylnik
	name = "Podgnylnik"
	desc = "You probably shouldn't eat this."
	icon_state = "podgnylnik"
	potency = 10
	filling_color = "#FF0000"
	plantname = "podgnylnik"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/ljutogreeb
	name = "Ljutogreeb"
	desc = "You probably shouldn't eat this."
	icon_state = "ljutogreeb"
	potency = 35
	filling_color = "#FFDEDE"
	plantname = "ljutogreeb"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/otorvyannik
	name = "Otorvyannik"
	desc = "You probably shouldn't eat this."
	icon_state = "otorvyannik"
	potency = 15
	filling_color = "#F714BE"
	plantname = "otorvyannik"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/plumphelmet
	name = "Plump-helmet"
	seed_name = "plumphelmet"
	desc = "You probably shouldn't eat this."
	icon_state = "plumphelmet"
	potency = 8
	filling_color = "#F714BE"
	plantname = "plump"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/gryab
	name = "Gryab"
	desc = "You probably shouldn't eat this."
	icon_state = "gryab"
	potency = 8
	filling_color = "#F714BE"
	plantname = "gryab"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/ovrajnik
	name = "Ovrajnik"
	desc = "You probably shouldn't eat this."
	icon_state = "ovrajnik"
	potency = 8
	filling_color = "#F714BE"
	plantname = "ovrajnik"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/slezjak
	name = "Slezjak"
	desc = "You probably shouldn't eat this."
	icon_state = "slezjak"
	potency = 8
	filling_color = "#F714BE"
	plantname = "slezjak"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/zelegreeb
	name = "Zelegreeb"
	desc = "You probably shouldn't eat this."
	icon_state = "zelegreeb"
	potency = 8
	filling_color = "#F714BE"
	plantname = "zelegreeb"
	seedtype = /obj/item/seeds/plumpmycelium

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/bezglaznik
	name = "Bezglaznik"
	desc = "You probably shouldn't eat this."
	icon_state = "bezglaznik"
	potency = 8
	filling_color = "#F714BE"
	plantname = "bezglaznik"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/barhovik
	name = "Barhovik"
	desc = "You probably shouldn't eat this."
	icon_state = "barhovik"
	potency = 8
	filling_color = "#F714BE"
	plantname = "barhovik"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/krovnik
	name = "Krovnik"
	desc = "You probably shouldn't eat this."
	icon_state = "krovnik"
	potency = 8
	filling_color = "#F714BE"
	plantname = "krovnik"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/corniy
	name = "Corniy"
	desc = "You probably shouldn't eat this."
	icon_state = "corniy"
	potency = 8
	filling_color = "#F714BE"
	plantname = "corniy"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/zheleznyak
	name = "Zheleznyak"
	desc = "You probably shouldn't eat this."
	icon_state = "zheleznyak"
	potency = 8
	filling_color = "#F714BE"
	plantname = "zheleznyak"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/walkingmushroom
	name = "walking mushroom"
	desc = "<I>Plumus Locomotus</I>: The beginning of the great walk."
	icon_state = "walkingmushroom"
	filling_color = "#FFBFEF"
	potency = 30
	plantname = "walkingmushroom"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/walkingmushroom/attack_self(mob/user as mob)
	if(istype(user.loc,/turf/space))
		return
	new /mob/living/simple_animal/mushroom(user.loc)
	qdel(src)

	user << "<span class='notice'>You plant the walking mushroom.</span>"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/chanterelle
	name = "chanterelle cluster"
	desc = "<I>Cantharellus Cibarius</I>: These jolly yellow little shrooms sure look tasty!"
	icon_state = "chanterelle"
	filling_color = "#FFE991"
	plantname = "mushrooms"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/glowshroom
	name = "glowshroom cluster"
	desc = "<I>Mycena Bregprox</I>: This species of mushroom glows in the dark. Or does it?"
	icon_state = "glowshroom"
	filling_color = "#DAFF91"
	potency = 30
	plantname = "glowshroom"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/glowshroom/attack_self(mob/user as mob)
	if(istype(user.loc,/turf/space))
		return
	var/obj/effect/glowshroom/planted = new /obj/effect/glowshroom(user.loc)

	planted.delay = 50
	planted.endurance = 100
	planted.potency = potency
	qdel(src)

	user << "<span class='notice'>You plant the glowshroom.</span>"

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/glowshroom/Destroy()


	..()

/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/glowshroom/pickup(mob/user)



/obj/item/weapon/reagent_containers/food/snacks/grown/mushroom/glowshroom/dropped(mob/user)




// *************************************
// Complex Grown Object Defines -
// Putting these at the bottom so they don't clutter the list up. -Cheridan
// *************************************

/obj/item/weapon/reagent_containers/food/snacks/grown/bluespacetomato
	name = "blue-space tomato"
	desc = "So lubricated, you might slip through space-time."
	icon_state = "bluespacetomato"
	potency = 20
	origin_tech = "bluespace=3"
	filling_color = "#91F8FF"
	plantname = "bluespacetomato"

/obj/item/weapon/reagent_containers/food/snacks/grown/bluespacetomato/throw_impact(atom/hit_atom)
	..()
	var/mob/M = usr
	var/outer_teleport_radius = potency/10 //Plant potency determines radius of teleport.
	var/inner_teleport_radius = potency/15
	var/list/turfs = new/list()
	var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
	if(inner_teleport_radius < 1) //Wasn't potent enough, it just splats.
		new/obj/effect/decal/cleanable/blood/oil(src.loc)
		src.visible_message("<span class='notice'>The [src.name] has been squashed.</span>","<span class='moderate'>You hear a smack.</span>")
		qdel(src)
		return
	for(var/turf/T in orange(M,outer_teleport_radius))
		if(T in orange(M,inner_teleport_radius)) continue
		if(istype(T,/turf/space)) continue
		if(T.density) continue
		if(T.x>world.maxx-outer_teleport_radius || T.x<outer_teleport_radius)	continue
		if(T.y>world.maxy-outer_teleport_radius || T.y<outer_teleport_radius)	continue
		turfs += T
	if(!turfs.len)
		var/list/turfs_to_pick_from = list()
		for(var/turf/T in orange(M,outer_teleport_radius))
			if(!(T in orange(M,inner_teleport_radius)))
				turfs_to_pick_from += T
		turfs += pick(/turf in turfs_to_pick_from)
	var/turf/picked = pick(turfs)
	if(!isturf(picked)) return
	switch(rand(1,2))//Decides randomly to teleport the thrower or the throwee.
		if(1) // Teleports the person who threw the tomato.
			s.set_up(3, 1, M)
			s.start()
			new/obj/effect/decal/cleanable/molten_item(M.loc) //Leaves a pile of goo behind for dramatic effect.
			M.loc = picked //
			sleep(1)
			s.set_up(3, 1, M)
			s.start() //Two set of sparks, one before the teleport and one after.
		if(2) //Teleports mob the tomato hit instead.
			for(var/mob/A in get_turf(hit_atom))//For the mobs in the tile that was hit...
				s.set_up(3, 1, A)
				s.start()
				new/obj/effect/decal/cleanable/molten_item(A.loc) //Leave a pile of goo behind for dramatic effect...
				A.loc = picked//And teleport them to the chosen location.
				sleep(1)
				s.set_up(3, 1, A)
				s.start()
	new/obj/effect/decal/cleanable/blood/oil(src.loc)
	src.visible_message("<span class='notice'>The [src.name] has been squashed, causing a distortion in space-time.</span>","<span class='moderate'>You hear a splat and a crackle.</span>")
	qdel(src)
	return
