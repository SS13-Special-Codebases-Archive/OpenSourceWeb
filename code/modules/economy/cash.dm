/obj/item/weapon/spacecash
	name = "0 obol"
	gender = PLURAL
	icon = 'icons/obj/coins.dmi'
	icon_state = "1"
	opacity = 0
	density = 0
	anchored = 0.0
	force = 1.0
	throwforce = 1.0
	throw_speed = 1
	throw_range = 2
	w_class = 1.0
	drop_sound = list('phy_coin_h_01.ogg','phy_coin_h_02.ogg','phy_coin_h_03.ogg','phy_coin_h_04.ogg')
	var/singularvalue = 1
	var/access = list()
	access = access_crate_cash
	var/worth = 0
	var/last
	New()
		..()
		item_worth = worth
		update_icon()
		updateValues()
	Destroy()
		if(ismob(loc))
			var/mob/m = loc
			m.drop_from_inventory(src)
			m.update_inv_r_hand()
			m.update_inv_l_hand()
		return QDEL_HINT_PUTINPOOL

/obj/item/weapon/spacecash/update_icon()
	item_worth = worth
	if(worth > singularvalue)
		name = "[worth / singularvalue] obols"
		icon_state = "[worth]"
	else
		name = "[worth / singularvalue] obol"
		if(last)
			icon_state = "coin0"
		else
			icon_state = "coin1"

/obj/item/weapon/spacecash/proc/updateValues(){
	if(worth <= 0){
		qdel(src)
		return
	}
	update_icon()
}

/obj/item/weapon/spacecash/c1
	name = "1 obol"
	icon_state = "1"
	worth = 1

/obj/item/weapon/spacecash/c2
	name = "2 obols"
	icon_state = "2"
	worth = 2

/obj/item/weapon/spacecash/c3
	name = "3 obols"
	icon_state = "3"
	worth = 3

/obj/item/weapon/spacecash/c4
	name = "4 obols"
	icon_state = "4"
	worth = 4

/obj/item/weapon/spacecash/c5
	name = "5 obols"
	icon_state = "5"
	worth = 5

/obj/item/weapon/spacecash/c6
	name = "6 obols"
	icon_state = "6"
	worth = 6

/obj/item/weapon/spacecash/c7
	name = "7 obols"
	icon_state = "7"
	worth = 7

/obj/item/weapon/spacecash/c8
	name = "8 obols"
	icon_state = "8"
	worth = 8

/obj/item/weapon/spacecash/c9
	name = "9 obols"
	icon_state = "9"
	worth = 9

/obj/item/weapon/spacecash/c10
	name = "10 obols"
	icon_state = "10"
	worth = 10

/obj/item/weapon/spacecash/c11
	name = "11 obols"
	icon_state = "11"
	worth = 11

/obj/item/weapon/spacecash/c12
	name = "12 obols"
	icon_state = "12"
	worth = 12

/obj/item/weapon/spacecash/c13
	name = "13 obols"
	icon_state = "13"
	worth = 13

/obj/item/weapon/spacecash/c14
	name = "14 obols"
	icon_state = "14"
	worth = 14

/obj/item/weapon/spacecash/c15
	name = "15 obols"
	icon_state = "15"
	worth = 15

/obj/item/weapon/spacecash/c16
	name = "16 obols"
	icon_state = "16"
	worth = 16

/obj/item/weapon/spacecash/c17
	name = "17 obols"
	icon_state = "17"
	worth = 17

/obj/item/weapon/spacecash/c18
	name = "18 obols"
	icon_state = "18"
	worth = 18

/obj/item/weapon/spacecash/c19
	name = "19 obols"
	icon_state = "19"
	worth = 19

/obj/item/weapon/spacecash/c20
	name = "20 obols"
	icon_state = "20"
	worth = 20

//////////SILVER///////////
/obj/item/weapon/spacecash/silver
	icon = 'gold4.dmi'
	item_state = "scoin"
	singularvalue = 4
	silver = TRUE

/obj/item/weapon/spacecash/silver/c1
	name = "1 silver obol"
	icon_state = "4"
	worth = 4

/obj/item/weapon/spacecash/silver/c2
	name = "2 silver obols"
	icon_state = "8"
	worth = 8

/obj/item/weapon/spacecash/silver/c3
	name = "3 silver obols"
	icon_state = "12"
	worth = 12

/obj/item/weapon/spacecash/silver/c4
	name = "4 silver obols"
	icon_state = "16"
	worth = 16

/obj/item/weapon/spacecash/silver/c5
	name = "5 silver obols"
	icon_state = "20"
	worth = 20

/obj/item/weapon/spacecash/silver/c6
	name = "6 silver obols"
	icon_state = "24"
	worth = 24

/obj/item/weapon/spacecash/silver/c7
	name = "7 silver obols"
	icon_state = "28"
	worth = 28

/obj/item/weapon/spacecash/silver/c8
	name = "8 silver obols"
	icon_state = "32"
	worth = 32

/obj/item/weapon/spacecash/silver/c9
	name = "9 silver obols"
	icon_state = "36"
	worth = 36

/obj/item/weapon/spacecash/silver/c10
	name = "10 silver obols"
	icon_state = "40"
	worth = 40

/obj/item/weapon/spacecash/silver/c11
	name = "11 silver obols"
	icon_state = "44"
	worth = 44

/obj/item/weapon/spacecash/silver/c12
	name = "12 silver obols"
	icon_state = "48"
	worth = 48

/obj/item/weapon/spacecash/silver/c13
	name = "13 silver obols"
	icon_state = "52"
	worth = 52

/obj/item/weapon/spacecash/silver/c14
	name = "14 silver obols"
	icon_state = "56"
	worth = 56

/obj/item/weapon/spacecash/silver/c15
	name = "15 silver obols"
	icon_state = "60"
	worth = 60

/obj/item/weapon/spacecash/silver/c16
	name = "16 silver obols"
	icon_state = "64"
	worth = 64

/obj/item/weapon/spacecash/silver/c17
	name = "17 silver obols"
	icon_state = "68"
	worth = 68

/obj/item/weapon/spacecash/silver/c18
	name = "18 silver obols"
	icon_state = "72"
	worth = 72

/obj/item/weapon/spacecash/silver/c19
	name = "19 silver obols"
	icon_state = "76"
	worth = 76

/obj/item/weapon/spacecash/silver/c20
	name = "20 silver obols"
	icon_state = "80"
	worth = 80

//////////GOLD///////////
/obj/item/weapon/spacecash/gold
	icon = 'icons/obj/gold.dmi'
	item_state = "goldcoin"
	singularvalue = 16

/obj/item/weapon/spacecash/gold/c1
	name = "1 gold obol"
	icon_state = "16"
	worth = 16

/obj/item/weapon/spacecash/gold/c2
	name = "2 gold obols"
	icon_state = "32"
	worth = 32

/obj/item/weapon/spacecash/gold/c3
	name = "3 gold obols"
	icon_state = "48"
	worth = 48

/obj/item/weapon/spacecash/gold/c4
	name = "4 gold obols"
	icon_state = "64"
	worth = 64

/obj/item/weapon/spacecash/gold/c5
	name = "5 gold obols"
	icon_state = "80"
	worth = 80

/obj/item/weapon/spacecash/gold/c6
	name = "6 gold obols"
	icon_state = "96"
	worth = 96

/obj/item/weapon/spacecash/gold/c7
	name = "7 gold obols"
	icon_state = "112"
	worth = 112

/obj/item/weapon/spacecash/gold/c8
	name = "8 gold obols"
	icon_state = "128"
	worth = 128

/obj/item/weapon/spacecash/gold/c9
	name = "9 gold obols"
	icon_state = "144"
	worth = 144

/obj/item/weapon/spacecash/gold/c10
	name = "10 gold obols"
	icon_state = "160"
	worth = 160

/obj/item/weapon/spacecash/gold/c11
	name = "11 gold obols"
	icon_state = "176"
	worth = 176

/obj/item/weapon/spacecash/gold/c12
	name = "12 gold obols"
	icon_state = "192"
	worth = 192

/obj/item/weapon/spacecash/gold/c13
	name = "13 gold obols"
	icon_state = "208"
	worth = 208

/obj/item/weapon/spacecash/gold/c14
	name = "14 gold obols"
	icon_state = "224"
	worth = 224

/obj/item/weapon/spacecash/gold/c15
	name = "15 gold obols"
	icon_state = "240"
	worth = 240

/obj/item/weapon/spacecash/gold/c16
	name = "16 gold obols"
	icon_state = "256"
	worth = 256

/obj/item/weapon/spacecash/gold/c17
	name = "17 gold obols"
	icon_state = "272"
	worth = 272

/obj/item/weapon/spacecash/gold/c18
	name = "18 gold obols"
	icon_state = "288"
	worth = 288

/obj/item/weapon/spacecash/gold/c19
	name = "19 gold obols"
	icon_state = "304"
	worth = 304

/obj/item/weapon/spacecash/gold/c20
	name = "20 gold obols"
	icon_state = "320"
	worth = 320

proc/spawn_money(var/sum, spawnloc)
	var/cash_type
	for(var/i in list(20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1))
		cash_type = text2path("/obj/item/weapon/spacecash/c[i]")
		while(sum >= i)
			sum -= i
			PoolOrNew(cash_type, spawnloc)
	return

proc/spawn_money_silver(var/sum, spawnloc)
	var/cash_type
	for(var/i in list(20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1))
		cash_type = text2path("/obj/item/weapon/spacecash/silver/c[i]")
		while(sum >= i)
			sum -= i
			PoolOrNew(cash_type, spawnloc)
	return

proc/spawn_money_gold(var/sum, spawnloc)
	var/cash_type
	for(var/i in list(20,19,18,17,16,15,14,13,12,11,10,9,8,7,6,5,4,3,2,1))
		cash_type = text2path("/obj/item/weapon/spacecash/gold/c[i]")
		while(sum >= i)
			sum -= i
			PoolOrNew(cash_type, spawnloc)
	return

/obj/item/weapon/spacecash/attackby(obj/item/W, mob/living/carbon/human/H)
	..()
	updateValues()
	if(istype(W, /obj/item/weapon/spacecash))
		var/obj/item/weapon/spacecash/C = W;

		if(singularvalue != C.singularvalue)
			return


		var/srcAmount = worth / singularvalue; // STACK DE MOEDA QUE RECEBE QUANTIDADE DE MOEDAS ATUAL
		var/otherAmount = C.worth / C.singularvalue; // FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF

		var/newValue = otherAmount + srcAmount

		var/rest = 20 - newValue

		if(srcAmount >= 20)
			return

		if(newValue > 20)
			if(rest <= 0)
				rest *= -1

			C.worth = rest * C.singularvalue
			C.updateValues()

			worth = 20 * singularvalue
			updateValues()
			return


		worth = newValue * singularvalue
		updateValues()
		qdel(C)


/obj/item/weapon/spacecash/attack_hand(mob/living/carbon/human/H)
	if(!ismob(loc) || H.r_hand != src && H.l_hand != src)
		return ..()

	if(H.get_active_hand())
		return



	var/amount = worth / singularvalue
	var/list/options = list("CANCEL")
	for(var/x = amount; x > 0; x--)
		options.Add(x)


	var/amountDraw = input("How much?", "") in options
	if(amountDraw == "CANCEL")
		return

	if(!ismob(loc))
		return


	var/amountToBeRemoved = amountDraw * singularvalue
	if(amountToBeRemoved > worth)
		return
	var/handSlot = !H.hand ? slot_r_hand : slot_l_hand

	worth -= amountToBeRemoved

	H.equip_to_slot_or_del(new type(H), handSlot)
	updateValues()
	if(istype(H.get_active_hand(), /obj/item/weapon/spacecash))
		var/obj/item/weapon/spacecash/O = H.get_active_hand()

		O.worth = amountToBeRemoved
		O.updateValues()

/obj/item/weapon/spacecash/attack_self(var/mob/living/carbon/human/user) //coinflipping
	if(worth == singularvalue)
		last = rand(0, 1)
		update_icon()
		if(last)
			return to_chat(user, "You got skull!")
		return to_chat(user, "You got cross!")