/mob/living/var/tophat_item
/mob/living/var/special_item
/mob/living/var/specialdesc
/mob/living/var/soap_item
/mob/living/var/pjack_item

/obj/structure/lifeweb/var/list/itemstake = list()
/obj/structure/lifeweb/var/amount_book = 1
/obj/structure/lifeweb/var/amount_pen = 1

/obj/structure/lifeweb/RightClick(mob/user)
	if(!donation_storage)
		return
	if(get_dist(src, user) > 1)
		return
	var/mob/living/carbon/human/H = user
	var/pickeditem
	init_items(H)
	pickeditem = input(H,"Select a object to take from \the [src].","[src]",pickeditem) in itemstake
	if(!pickeditem)
		return
	var/dist = get_dist(user,src)
	if(dist > 1)
		return
	if(pickeditem)
		spawn_item(pickeditem, H)
		itemstake = list()
	..()

/obj/structure/lifeweb/proc/init_items(var/mob/living/carbon/human/H)
	itemstake = list()
	if(H.ckey == "redvent")
		itemstake.Add("*Tattered Hood*")
	if(H.ckey == "slojanko")
		itemstake.Add("*Revealing Dress*")
	if(H.religion == "Thanati" && !H.alreadyhasrobe)
		itemstake.Add("*Thanati Robes*")
	if(H.ckey in pjack)
		itemstake.Add("*Pumpkin Jack*")
	if(H.ckey in waterbottledonation)
		itemstake.Add("*Water Bottle*")
	if(H.ckey in weeDonator)
		itemstake.Add("*Weed*")
	if(H.ckey in baliset)
		itemstake.Add("*Baliset*")
		itemstake.Add("*Guitar*")
		itemstake.Add("*Accordion*")
	if(H.ckey in luxurydonation)
		itemstake.Add("*Amulet of Lechery*")
	if(H.ckey == "absenceofwords" || H.ckey == "spookypineapple" || H.ckey == "bailol" || H.ckey == "stimusz")
		itemstake.Add("*Black Cloak*")
	if(H.ckey == "absenceofwords" || H.ckey == "spookypineapple" || H.ckey == "stimusz")
		itemstake.Add("*Sailor Cloak*")
	if(H.ckey == "absenceofwords" || H.ckey == "spookypineapple")
		itemstake.Add("*Tricorn*")
	if(H.ckey == "absenceofwords" || H.ckey == "spookypineapple")
		itemstake.Add("*Sailor Shirt*")
	if(H.ckey in mobilephone)
		itemstake.Add("*Mobile Phone*")
	if(H.ckey == "sunkeneyes")
		itemstake.Add("*Witch Hat*")
	if(H.ckey == "notapresident")
		itemstake.Add("*Svalinn Cloak*")
	if(is_dreamer(H))
		itemstake.Add("*Dreamer's Diary*")
		itemstake.Add("*Dreamer's Pen*")
	if(H.special)
		if(H.special_item)
			itemstake.Add("*Special*")
	if(H.vice == "Photographer")
		itemstake.Add("*Camera*" && prob(45))
	if(H.ckey in coolboombox)
		if(H.ckey == "spookypineapple")
			itemstake.Add("*Boombox*")
		else
			itemstake.Add("*Conceivable Boombox*")
	if(H.ckey in hiden_obols)
		itemstake.Add("*Obols*")
	if(H.ckey in weeDonator)
		itemstake.Add("*Joint*")

/obj/structure/lifeweb/proc/spawn_item(var/pickeditem, var/mob/living/carbon/human/receiver)
	var/spawnitem
	switch(pickeditem)
		if("*Tattered Hood*")
			spawnitem = /obj/item/clothing/head/donor/redvent/tatteredhood
		if("*Conceivable Boombox*")
			spawnitem = /obj/item/weapon/ghettobox/special
		if("*Weed*")
			spawnitem = /obj/item/clothing/mask/cigarette/weed
		if("*Baliset*")
			spawnitem = /obj/item/weapon/musical_instrument/baliset
		if("*Guitar*")
			spawnitem = /obj/item/weapon/musical_instrument/baliset/guitar
		if("*Accordion*")
			spawnitem = /obj/item/weapon/musical_instrument/bayan
		if("*Boombox*")
			spawnitem = /obj/item/weapon/ghettobox
		if("*Joint*")
			spawnitem = /obj/item/clothing/mask/cigarette/weed
		if("*Camera*")
			spawnitem = /obj/item/device/camera
		if("*Revealing Dress*")
			spawnitem = /obj/item/clothing/suit/donor/slojanko/dress
		if("*Witch Hat*")
			spawnitem = /obj/item/clothing/suit/donor/slojanko/dress
		if("*Svalinn Cloak*")
			spawnitem = /obj/item/weapon/storage/backpack/svalinncloak
		if("*Mobile Phone*")
			spawnitem = /obj/item/device/cellphone/Donator
		if("*Water Bottle*")
			spawnitem = /obj/item/weapon/reagent_containers/glass/bottle/waterbottle
		if("*Thanati Robes*")
			if(!receiver.alreadyhasrobe)
				spawnitem = /obj/item/clothing/suit/storage/thanati/thanati
				receiver.alreadyhasrobe = TRUE
		if("*Pumpkin Jack*")
			if(!receiver.pjack_item)
				spawnitem = /obj/item/toy/pumpkinjack
				receiver.pjack_item = TRUE
		if("*Amulet of Lechery*")
			spawnitem = /obj/item/clothing/head/amulet/lechery
		if("*Dreamer's Diary*")
			if(amount_book)
				spawnitem = /obj/item/weapon/book/dreamer
				amount_book = 0
		if("*Dreamer's Pen*")
			if(amount_pen)
				spawnitem = /obj/item/weapon/pen
				amount_pen = 0
		if("*Black Cloak*")
			spawnitem = /obj/item/clothing/suit/hood/donor/absenceofwords/blackcloak
		if("*Sailor Cloak*")
			spawnitem = /obj/item/clothing/suit/donor/sailorcloak
		if("*Tricorn*")
			spawnitem = /obj/item/clothing/head/tricorn
		if("*Sailor Shirt*")
			spawnitem = /obj/item/clothing/under/sailorshirt
		if("*Special*")
			spawnitem = receiver.special_item
			receiver.special_item = null
		if("*Obols*")
			spawnitem = text2path("/obj/item/weapon/spacecash/silver/c10")
	if(spawnitem in receiver.donationsUsed){
		return
	}
	receiver.donationsUsed += spawnitem
	var/obj/item/W = new spawnitem(receiver.loc)
	receiver.put_in_active_hand(spawnitem)
	if(spawnitem == /obj/item/device/cellphone)
		var/obj/item/device/cellphone/C = W
		var/obj/item/device/rim_card/R = new()
		C.rimcard = R
		R.loc = src
		R.Phone = src
	to_chat(receiver, "<i>Oh, it's here...</i>")