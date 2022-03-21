/obj/machinery/lwvend
	var/obols = 8
	var/list/products	= list(list(name = "Lighter", path = /obj/item/weapon/flame/lighter, price = 12, code = "lighter"),
	list(name = "Bandages", path = /obj/item/stack/medical/bruise_pack, price = 8, code = "bandages"),
	list(name = "Cigarrete Pack", path = /obj/item/weapon/storage/fancy/cigarettes, price = 30, code = "cigpacket"))
	name = "Vendor"
	icon = 'vending.dmi'
	icon_state = "snack"
	anchored = 1
	density = 1
	var/taxes = 1

/obj/machinery/lwvend/New()
	..()
	vending_list.Add(src)

/obj/machinery/lwvend/attackby(obj/item/I as obj, mob/living/carbon/human/user as mob)
	if(istype(I,/obj/item/weapon/spacecash))
		src.obols += I:worth
		qdel(I)
		playsound(src.loc, 'sound/effects/coininsert.ogg', 30, 0)



/obj/machinery/lwvend/attack_hand(mob/living/carbon/human/user as mob)
	playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
	var/illiterate = FALSE
	if(user.check_perk(/datum/perk/illiterate))
		illiterate = TRUE
	var/dat
	dat += {"<META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'> <style type='text/css'> @font-face {font-family: Gothic;src: url(gothic.ttf);} @font-face {font-family: Book;src: url(book.ttf);} @font-face {font-family: Hando;src: url(hando.ttf);} @font-face {font-family: Eris;src: url(eris.otf);} @font-face {font-family: Brandon;src: url(brandon.otf);} @font-face {font-family: VRN;src: url(vrn.otf);} @font-face {font-family: NEOM;src: url(neom.otf);} @font-face {font-family: PTSANS;src: url(PTSANS.ttf);} @font-face {font-family: Type;src: url(type.ttf);} @font-face {font-family: Enlightment;src: url(enlightment.ttf);} @font-face {font-family: Arabic;src: url(arabic.ttf);} @font-face {font-family: Digital;src: url(digital.ttf);} @font-face {font-family: Cond;src: url(cond2.ttf);} @font-face {font-family: Semi;src: url(semi.ttf);} @font-face {font-family: Droser;src: url(Droser.ttf);} .goth {font-family: Gothic, Verdana, sans-serif;} .book {font-family: Book, serif;} .hando {font-family: Hando, Verdana, sans-serif;} .typewriter {font-family: Type, Verdana, sans-serif;} .arabic {font-family: Arabic, serif; font-size:180%;} .droser {font-family: Droser, Verdana, sans-serif;} </style> <style type='text/css'> @charset 'utf-8'; body {font-family: PTSANS;cursor: url('pointer.cur'), auto;} a {text-decoration:none;outline: none;border: none;margin:-1px;} a:focus{outline:none;} a:hover {color:#0d0d0d;background:#505055;outline: none;border: none;} a.active { text-decoration:none; color:#533333;} a.inactive:hover {color:#0d0d0d;background:#bb0000} a.active:hover {color:#bb0000;background:#0f0f0f} a.inactive:hover { text-decoration:none; color:#0d0d0d; background:#bb0000}</style>
	<body background bgColor=#0d0d0d text=#533333 alink=#777777 vlink=#777777 link=#777777>
	<TT><CENTER><b>[src.name]</b></CENTER></TT><br>
	"}
	dat += "<TABLE width=100%><TR><TD><TT><B>Item:</B></TT></TD> <TD><TT><B>Price:</B></TT></TD><TD></TD><TD></TD><TD></TD></TR>"
	for(var/list/L in products)
		var/ProductPrice =  L["price"]
		var/ProductName = L["name"]
		var/path = L["path"]
		var/code = L["code"]

		if(src.taxes)
			ProductPrice = round(ProductPrice + ((ProductPrice / 100) * TaxUponSells))

		var/atom/A = new path()
		//dat += "<A href='?src=\ref[src];[code]=1'>[ProductName]</A><BR><span class='materials'>[recipeContents]</span><BR><BR>"
		if(illiterate)
			dat += "<TR><TD><TT><FONT Color = '836363'><B><BIG>[icon2html(A, user)] [Illiterate(ProductName,100)]</BIG></B></TT></TD> <TD><TT>[ProductPrice]</TT></TD></font></TT></TD> "
		else
			dat += "<TR><TD><TT><FONT Color = '836363'><B><BIG>[icon2html(A, user)] [ProductName]</BIG></B></TT></TD> <TD><TT>[ProductPrice]</TT></TD></font></TT></TD> "
		if(ProductPrice > obols)
			if(illiterate)
				dat += "<TD><TT><font Color = 'red'>[Illiterate("NOT ENOUGH MONEY",100)]</font></TD></TT></TR>"
			else
				dat += "<TD><TT><font Color = 'red'>NOT ENOUGH MONEY</font></TD></TT></TR>"
		else
			if(illiterate)
				dat += "<TD><TT><A href='?src=\ref[src];[code]=1'>[Illiterate("Purchase",100)]</A></TT></TR>"
			else
				dat += "<TD><TT><A href='?src=\ref[src];[code]=1'>Purchase</A></TT></TR>"
		qdel(A)
	if(illiterate)
		dat += "</TABLE><br><TT><b>[Illiterate("Obols Loaded",100)]: [obols]</b><br></TT><BR><TT><A href='?src=\ref[src];change=1'>[Illiterate("Change",100)]</A></TT>"
	else
		dat += "</TABLE><br><TT><b>Obols Loaded: [obols]</b><br></TT><BR><TT><A href='?src=\ref[src];change=1'>Change</A></TT>"

	user << browse(dat, "window=vending;size=575x450")

/obj/machinery/lwvend/Topic(href, href_list)
	if(..())
		return
	var/hrefParsed = splittext(href, ";")[2]

	if(href_list["change"])
		playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
		if(src.obols)
			to_chat(usr, "<i>[src] has [src.obols] obols.</i>")
			var/withdraw = input("How much you want to withdraw | There is [src.obols] obols in [src].","[src]",src.obols)
			if(!withdraw)
				return
			if(withdraw > src.obols)
				to_chat(usr, "There's not enough obols to withdraw that amount!")
			if(withdraw < 0)
				to_chat(usr, "negro nem tente")
				usr << 'olha-o-macaco.ogg'
				return
			if(withdraw <= src.obols)
				to_chat(usr, "<i>You withdraw [withdraw] from [src].</i>")
				playsound(src.loc, 'sound/effects/coin_m.ogg', 30, 0)
				spawn_money(withdraw,src.loc)
				src.obols -= withdraw
	for(var/list/L in products)
		var/ProductPrice =  L["price"]
		var/newItemPath =  L["path"]
		if("[L["code"]]=1" == hrefParsed)
			if(src.obols < ProductPrice)
				to_chat(usr, "Not enough obols, [ProductPrice] required!")
				return
			if(src.obols >= ProductPrice)
				src.obols -= ProductPrice
				var/atom/newItem = new newItemPath(src.loc)
				newItem.dir = usr.dir
				if(src.taxes)
					supply_shuttle.points += (ProductPrice / 100) * TaxUponSells
				if(istype(newItem, /obj/item/coupon/pusher))
					debt = 0
					for(var/mob/living/carbon/human/H in player_list)
						if(H.job == "Pusher")
							if(H.gender == MALE)
								to_chat(H, "<b>Good boy</b>, your debt has been paid. <i>[debt]</i>")
							else
								to_chat(H, "<b>Good girl</b>, your debt has been paid. <i>[debt]</i>")
var/debt = 1

/obj/machinery/lwvend/onion
	plane = 21
	obols = 0
	taxes = 0
	products = list(
	list(name = "Grenade", path = /obj/item/weapon/grenade/syndieminibomb/frag, price = 120, code = "grenade"),
	list(name = "Knife", path = /obj/item/weapon/kitchen/utensil/knife, price = 10, code = "knife"),
	list(name = "Lockpick", path = /obj/item/weapon/lockpick, price = 30, code = "lockpick"),
	list(name = "Karek Magazine (.380)", path = /obj/item/ammo_magazine/external/uzi380, price = 35, code = "uzi380"),
	list(name = "Zippo Lighter", path = /obj/item/weapon/flame/lighter/zippo, price = 12, code = "zippo"),
	list(name = "Fetish Clothes (Red)", path = /obj/item/clothing/suit/hooker, price = 24, code = "fetshred"),
	list(name = "Fetish Clothes (Black)", path = /obj/item/clothing/suit/hooker/domina, price = 30, code = "fetshbl"),
	list(name = "Mini-Pistol", path = /obj/item/weapon/gun/projectile/automatic/pistol/ml23, price = 130, code = "minipistol"),
	list(name = "Flashbang Grenade", path = /obj/item/weapon/grenade/flashbang, price = 130, code = "flashbang"),
	list(name = "9mm Magazine", path = /obj/item/ammo_magazine/external/mc9mm, price = 20, code = "mc9mm"),
	list(name = "9mm Baton Magazine", path = /obj/item/ammo_magazine/external/mc9mm, price = 10, code = "mc9mmb"),
	list(name = "Poison Fruit", path = /obj/item/weapon/reagent_containers/food/snacks/grown/apple/poisoned, price = 25, code = "poison"),
	list(name = "Buffout Pills", path = /obj/item/weapon/storage/pill_bottle/buffout, price = 50, code = "buffout"),
	list(name = "Mentats Can", path = /obj/item/weapon/storage/pill_bottle/mentats, price = 30, code = "mentats"),
	list(name = "DOB", path = /obj/item/weapon/reagent_containers/pill/lifeweb/blotter/DOB, price = 11, code = "DOB"),
	list(name = "Weed", path = /obj/item/clothing/mask/cigarette/weed, price = 11, code = "weed"),
	list(name = "Camouflage Generator", path = /obj/item/weapon/cloaking_device, price = 50, code = "camogen"),
	list(name = "Syringe", path = /obj/item/weapon/reagent_containers/syringe, price = 12, code = "syringe"),
	list(name = "Screamer 23", path = /obj/item/weapon/gun/projectile/automatic/pistol/magnum66/screamer23, price = 250, code = "screamer23"),
	list(name = "Mobile Phone", path = /obj/item/device/cellphone, price = 12, code = "phone"),
	list(name = "Magazine (.45)", path = /obj/item/ammo_magazine/external/sm45/pusher/full, price = 24, code = "sm45"),
	list(name = "Fake Golden Obols", path = /obj/item/weapon/fakecash/gold/c20, price = 30, code = "fakegold"),
	list(name = "Condom (S)", path = /obj/item/condom_wrapper/small, price = 4, code = "consmall"),
	list(name = "Condom (M)", path = /obj/item/condom_wrapper/regular, price = 8, code = "conmed"),
	list(name = "Condom (XXL)", path = /obj/item/condom_wrapper/large, price = 12, code = "conlarge"),
	list(name = "Uzi Submachinegun", path = /obj/item/weapon/gun/projectile/automatic/mini_uzi, price = 610, code = "uzi"),
	list(name = "Neoduelista Revolver", path = /obj/item/weapon/gun/projectile/newRevolver/duelista, price = 85, code = "neoduelista"),
	list(name = "Neoduelista ammo (5)", path = /obj/item/stack/bullets/Newduelista/five, price = 30, code = "neoammo5"),
	list(name = "MDMA Bottle", path = /obj/item/weapon/storage/pill_bottle/mdma, price = 50, code = "mdmabottle"),
	list(name = "MDMA Pill", path = /obj/item/weapon/reagent_containers/pill/lifeweb/mdma, price = 13, code = "mdmapill"),
	list(name = "Mice 69 Pill", path = /obj/item/weapon/reagent_containers/pill/lifeweb/mice69, price = 2, code = "mice"),
	list(name = "Mice 69 Bottle", path = /obj/item/weapon/storage/pill_bottle/mice69, price = 14, code = "micebottle"),
	list(name = "Cigarette Packet", path = /obj/item/weapon/storage/fancy/cigarettes, price = 18, code = "cigarettes"),
	list(name = "Dentrine Pill", path = /obj/item/weapon/reagent_containers/pill/lifeweb/dentrine, price = 42, code = "dentrine"),
	list(name = "Telescopic Baton", path = /obj/item/weapon/melee/telebaton, price = 115, code = "telebaton"),
	list(name = "Neoduelista ammo (1)", path = /obj/item/stack/bullets/Newduelista, price = 5, code = "neoammo1"),
	list(name = "Sawn-Off Shotgun", path = /obj/item/weapon/gun/projectile/newRevolver/duelista/doublebarrel/sawnOff, price = 163, code = "sawnoff"),
	list(name = "Vinici-Us", path = /obj/item/weapon/reagent_containers/pill/lifeweb/blotter/vinici_us, price = 23, code = "vinicius"),
	list(name = "Heroin", path = /obj/item/weapon/reagent_containers/syringe/heroin, price = 10, code = "cocaine"),
	list(name = "Cocaine", path = /obj/item/weapon/storage/pacote/cocaina, price = 45, code = "heroin"),
	list(name = "Buckshot (3)", path = /obj/item/stack/bullets/buckshot/three, price = 16, code = "buckshot"),
	list(name = "Pusher Debt", path = /obj/item/coupon/pusher, price = 100, code = "debt"))
	name = "ONION"
	icon = 'vending.dmi'
	icon_state = "onion"
	anchored = 1
	density = 0

/obj/machinery/lwvend/onion/process()
	if(debt <= 0)
		for(var/mob/living/carbon/human/H in mob_list)
			if(H.job == "Pusher")
				H?.mind.time_to_pay = "good boy."
		for(var/obj/machinery/information_terminal/IM in vending_list)
			IM.despusherize()
		processing_objects.Remove(src)

/obj/machinery/lwvend/onion/New()
	..()
	processing_objects.Add(src)

/obj/machinery/lwvend/sanctuary
	obols = 8
	products	= list(list(name = "Dentrine", path = /obj/item/weapon/reagent_containers/pill/lifeweb/dentrine, price = 42, code = "dentrine"),
	list(name = "Bandages", path = /obj/item/stack/medical/bruise_pack, price = 8, code = "bandages"),
	list(name = "Inaprovaline Bottle", path = /obj/item/weapon/reagent_containers/glass/bottle/lifeweb/inaprovaline, price = 18, code = "inaprovaline"),
	list(name = "Syringe", path = /obj/item/weapon/reagent_containers/syringe, price = 12, code = "syringe"),
	list(name = "Vaccine", path = /obj/item/weapon/reagent_containers/syringe/antiviral, price = 25, code = "vaccine"),
	list(name = "Suture", path = /obj/item/weapon/surgery_tool/suture, price = 12, code = "suture"),
	list(name = "Syringe (Antibiotic)", path = /obj/item/weapon/reagent_containers/syringe/antibiotic, price = 20, code = "antibiotic"))
	name = "Sanctuary Vendor"
	icon = 'vending.dmi'
	icon_state = "snack"
	anchored = 1
	density = 1

/obj/machinery/lwvend/innvend
	obols = 12
	products	= list(list(name = "Eggs", path = /obj/item/weapon/storage/fancy/egg_box, price = 10, code = "eggs"),
	list(name = "Flour", path = /obj/item/weapon/reagent_containers/food/drinks/flour, price = 8, code = "flour"),
	list(name = "Milk", path = /obj/item/weapon/reagent_containers/food/drinks/milk, price = 8, code = "milk"),
	list(name = "Dough", path = /obj/item/weapon/reagent_containers/food/snacks/dough, price = 10, code = "dough"),
	list(name = "Butter", path = /obj/item/weapon/reagent_containers/food/snacks/breadsys/butterpack, price = 6, code = "butter"),
	list(name = "Peppermill", path = /obj/item/weapon/reagent_containers/food/condiment/peppermill, price = 8, code = "pepper"),
	list(name = "Salt Shaker", path = /obj/item/weapon/reagent_containers/food/condiment/saltshaker, price = 8, code = "salt"),
	list(name = "Raw Meat", path = /obj/item/weapon/reagent_containers/food/snacks/meat, price = 25, code = "meat"),
	list(name = "Vodka", path = /obj/item/weapon/reagent_containers/glass/bottle/vodka, price = 18, code = "vodka"),
	list(name = "Absinthe", path = /obj/item/weapon/reagent_containers/glass/bottle/absinthe, price = 20, code = "absinthe"),
	list(name = "Rum", path = /obj/item/weapon/reagent_containers/glass/bottle/rum, price = 20, code = "rum"),
	list(name = "Whiskey", path = /obj/item/weapon/reagent_containers/glass/bottle/whiskey, price = 30, code = "whiskey"),
	list(name = "Wine", path = /obj/item/weapon/reagent_containers/glass/bottle/wine, price = 40, code = "wine"),
	list(name = "Vintage Wine", path = /obj/item/weapon/reagent_containers/glass/bottle/pwine, price = 80, code = "oldwine"),
	list(name = "Vermouth", path = /obj/item/weapon/reagent_containers/glass/bottle/vermouth, price = 50, code = "vermouth"),
	list(name = "Beer", path = /obj/item/weapon/reagent_containers/glass/bottle/beer, price = 8, code = "beer"),
	list(name = "Salami", path = /obj/item/weapon/reagent_containers/food/snacks/breadsys/salamistick, price = 12, code = "salami"))
	name = "Innkeep Vendor"
	icon = 'vending.dmi'
	icon_state = "production"
	anchored = 1
	density = 1

// NEW START

/obj/machinery/computerVendor
	name = "vendor"
	desc = "A vendor used to buy and sell items."
	icon = 'vending.dmi'
	icon_state = "snack"
	anchored = 1
	density = 1
	var/obols = 1
	var/locked = 1
	var/acceptableJobs = list()

/obj/machinery/computerVendor/New()
	..()
	icon_state = pick("sustom1", "dustom1", "rustom1")

/obj/machinery/computerVendor/smith
	acceptableJobs = list("Armorsmith", "Metalsmith", "Weaponsmith")

/obj/machinery/computerVendor/bookkeeper
	acceptableJobs = list("Grayhound", "Bookkeeper")

/obj/item/var/priceSet = 0

/obj/machinery/computerVendor/RightClick(mob/living/carbon/human/user as mob)
	if(user.job in acceptableJobs)
		locked = locked ? 0 : 1
		playsound(src.loc, pick('sound/webbers/lw_key.ogg'), rand(30,50), 0)
		to_chat(user, "<span class='baron'><i> I [locked ? "lock" : "unlock"] the [src].</i></span>")
	..()

/obj/machinery/computerVendor/attackby(obj/item/I as obj, mob/living/carbon/human/user as mob)
	if(istype(I,/obj/item/weapon/spacecash))
		src.obols += I:worth
		qdel(I)
		playsound(src.loc, 'sound/effects/coininsert.ogg', 30, 0)
		return
	if(istype(I,/obj/item/weapon/wrench))
		if(!anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			src.anchored = 1
			return
		if(anchored)
			playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
			src.anchored = 0
			return
	else
		if(!locked)
			var/howmuchwillitcost = input("How much will it cost?","[src]",20)
			user.drop_from_inventory(I)
			contents.Add(I)
			I.priceSet = howmuchwillitcost
			playsound(src.loc, pick('sound/webbers/lw_key.ogg'), rand(30,50), 0)
			to_chat(user, "<span class='baron'><i> I added the [I] to the [src] for [howmuchwillitcost].</i></span>")
			playsound(src.loc, pick('sound/webbers/console_input1.ogg', 'sound/webbers/console_input2.ogg', 'sound/webbers/console_input3.ogg'), 100, 0, -5)

/obj/machinery/computerVendor/attack_hand(mob/living/carbon/human/user as mob)
	if(!locked)
		var/list/listToRemove = list()
		for(var/obj/item/I in src.contents)
			listToRemove.Add(I)
		var/obj/item/whichToRemove = input("What item do i want to remove?", "[src]") in listToRemove
		src.contents -= whichToRemove
		whichToRemove.loc = src.loc
		playsound(src.loc, pick('sound/webbers/console_input1.ogg', 'sound/webbers/console_input2.ogg', 'sound/webbers/console_input3.ogg'), 100, 0, -5)
		return
	playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
	var/illiterate = FALSE
	if(user.check_perk(/datum/perk/illiterate))
		illiterate = TRUE
	var/dat
	dat += {"<META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'> <style type='text/css'> @font-face {font-family: Gothic;src: url(gothic.ttf);} @font-face {font-family: Book;src: url(book.ttf);} @font-face {font-family: Hando;src: url(hando.ttf);} @font-face {font-family: Eris;src: url(eris.otf);} @font-face {font-family: Brandon;src: url(brandon.otf);} @font-face {font-family: VRN;src: url(vrn.otf);} @font-face {font-family: NEOM;src: url(neom.otf);} @font-face {font-family: PTSANS;src: url(PTSANS.ttf);} @font-face {font-family: Type;src: url(type.ttf);} @font-face {font-family: Enlightment;src: url(enlightment.ttf);} @font-face {font-family: Arabic;src: url(arabic.ttf);} @font-face {font-family: Digital;src: url(digital.ttf);} @font-face {font-family: Cond;src: url(cond2.ttf);} @font-face {font-family: Semi;src: url(semi.ttf);} @font-face {font-family: Droser;src: url(Droser.ttf);} .goth {font-family: Gothic, Verdana, sans-serif;} .book {font-family: Book, serif;} .hando {font-family: Hando, Verdana, sans-serif;} .typewriter {font-family: Type, Verdana, sans-serif;} .arabic {font-family: Arabic, serif; font-size:180%;} .droser {font-family: Droser, Verdana, sans-serif;} </style> <style type='text/css'> @charset 'utf-8'; body {font-family: PTSANS;cursor: url('pointer.cur'), auto;} a {text-decoration:none;outline: none;border: none;margin:-1px;} a:focus{outline:none;} a:hover {color:#0d0d0d;background:#505055;outline: none;border: none;} a.active { text-decoration:none; color:#533333;} a.inactive:hover {color:#0d0d0d;background:#bb0000} a.active:hover {color:#bb0000;background:#0f0f0f} a.inactive:hover { text-decoration:none; color:#0d0d0d; background:#bb0000}</style>
	<body background bgColor=#0d0d0d text=#533333 alink=#777777 vlink=#777777 link=#777777>
	<TT><CENTER><b>[src.name]</b></CENTER></TT><br>
	"}
	dat += "<TABLE width=100%><TR><TD><TT><B>Item:</B></TT></TD> <TD><TT><B>Price:</B></TT></TD><TD></TD><TD></TD><TD></TD></TR>"
	for(var/obj/item/A in contents)
		var/ProductPrice = A.priceSet
		var/ProductName = A.name


		//dat += "<A href='?src=\ref[src];[code]=1'>[ProductName]</A><BR><span class='materials'>[recipeContents]</span><BR><BR>"
		if(illiterate)
			dat += "<TR><TD><TT><FONT Color = '836363'><B><BIG>[icon2html(A, user)] [Illiterate(ProductName,100)]</BIG></B></TT></TD> <TD><TT>[ProductPrice]</TT></TD></font></TT></TD> "
		else
			dat += "<TR><TD><TT><FONT Color = '836363'><B><BIG>[icon2html(A, user)] [ProductName]</BIG></B></TT></TD> <TD><TT>[ProductPrice]</TT></TD></font></TT></TD> "
		if(ProductPrice > obols)
			if(illiterate)
				dat += "<TD><TT><font Color = 'red'>[Illiterate("NOT ENOUGH MONEY",100)]</font></TD></TT></TR>"
			else
				dat += "<TD><TT><font Color = 'red'>NOT ENOUGH MONEY</font></TD></TT></TR>"
		else
			if(illiterate)
				dat += "<TD><TT><A href='?src=\ref[src];code=[A.name]'>[Illiterate("Purchase",100)]</A></TT></TR>"
			else
				dat += "<TD><TT><A href='?src=\ref[src];code=[A.name]'>Purchase</A></TT></TR>"
	if(illiterate)
		dat += "</TABLE><br><TT><b>[Illiterate("Obols Loaded",100)]: [obols]</b><br></TT><BR><TT><A href='?src=\ref[src];change=1'>[Illiterate("Change",100)]</A></TT>"
	else
		dat += "</TABLE><br><TT><b>Obols Loaded: [obols]</b><br></TT><BR><TT><A href='?src=\ref[src];change=1'>Change</A></TT>"

	user << browse(dat, "window=vending;size=575x450")

/obj/machinery/computerVendor/Topic(href, href_list)
	if(..())
		return


	if(href_list["change"])
		playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
		if(usr.job in acceptableJobs)
			if(src.obols)
				to_chat(usr, "<i>[src] has [src.obols] obols.</i>")
				var/withdraw = input("How much you want to withdraw | There is [src.obols] obols in [src].","[src]",src.obols)
				if(!withdraw)
					return
				if(withdraw > src.obols)
					to_chat(usr, "There's not enough obols to withdraw that amount!")
				if(withdraw < 0)
					to_chat(usr, "That is an invalid amount to withdraw!")
				if(get_dist(usr,src) > 1)
					return
				if(withdraw <= src.obols)
					to_chat(usr, "<i>You withdraw [withdraw] from [src].</i>")
					playsound(src.loc, 'sound/effects/coin_m.ogg', 30, 0)
					spawn_money(withdraw,src.loc)
					src.obols -= withdraw
					playsound(src.loc, pick('sound/webbers/console_input1.ogg', 'sound/webbers/console_input2.ogg', 'sound/webbers/console_input3.ogg'), 100, 0, -5)
		else
			to_chat(usr, "Fnord. You can't.")
	for(var/obj/item/L in contents)
		var/ProductPrice =  L.priceSet

		if(href_list["code"])
			if(src.obols < ProductPrice)
				to_chat(usr, "Not enough obols, [ProductPrice] required!")
				return
			if(src.obols >= ProductPrice && href_list["code"] == L.name)
				contents -= L
				L.loc = src.loc
				playsound(src.loc, pick('sound/webbers/console_input1.ogg', 'sound/webbers/console_input2.ogg', 'sound/webbers/console_input3.ogg'), 100, 0, -5)
				playsound(src.loc, L.drop_sound, 100, 0, -5)
				src.obols -= ProductPrice