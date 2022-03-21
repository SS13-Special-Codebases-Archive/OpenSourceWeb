/obj/item/weapon/cell
	name = "power cell"
	desc = "A rechargable electrochemical power cell."
	icon = 'icons/obj/power.dmi'
	icon_state = "cell"
	item_state = "cell"
	origin_tech = "powerstorage=1"
	flags = FPRINT|TABLEPASS
	force = 6.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5
	w_class = 2.0
	var/charge = 0	// note %age conveted to actual charge in New
	var/maxcharge = 1000
	m_amt = 700
	g_amt = 50
	var/rigged = 0		// true if rigged to explode
	var/minor_fault = 0 //If not 100% reliable, it will build up faults.
	var/construction_cost = list("metal"=750,"glass"=75)
	var/construction_time=100

	suicide_act(mob/user)
		viewers(user) << "\red <b>[user] is licking the electrodes of the [src.name]! It looks like \he's trying to commit suicide.</b>"
		return (FIRELOSS)

/obj/item/weapon/cell/web
	name = "battery cell"
	icon = 'LW2.dmi'
	icon_state = "bbattery"
	item_state = "lfwbcell"
	w_class = 4.0
	charge = 100
	maxcharge = 100
	item_worth = 5
	slot_flags = SLOT_BACK

/obj/item/weapon/cell/crap
	name = "Battery Cell"
	desc = "" //TOTALLY TRADEMARK INFRINGEMENT
	icon_state = "cartridge100"
	origin_tech = "powerstorage=0"
	maxcharge = 300
	g_amt = 40

	updateicon()
		if(charge < 0.01)
			icon_state = "cartridge0"
		if(charge/maxcharge >=0.95)
			icon_state = "cartridge100"
		else if(charge/maxcharge >=0.75)
			icon_state = "cartridge80"
		else if(charge/maxcharge >=0.55)
			icon_state = "cartridge60"
		else if(charge/maxcharge >=0.25)
			icon_state = "cartridge40"
		else if(charge/maxcharge >=0.15)
			icon_state = "cartridge20"
		else
			icon_state = "cartridge0"

/obj/item/weapon/cell/crap/leet
	name = " rechargable battery"
	desc = "Baterias da antiguidade, uma raridade hoje em dia." //TOTALLY TRADEMARK INFRINGEMENT
	origin_tech = "powerstorage=1"
	maxcharge = 1000 // 10 shots

/obj/item/weapon/cell/crap/leet/sparq
	name = "\improper sparq beam recharger"
	icon_state = "sparq100"
	origin_tech = "powerstorage=1"
	maxcharge = 500 // 3 Tiro

	updateicon()
		return

/obj/item/weapon/cell/crap/leet/noctis
	name = "\improper noctis recharger"
	icon_state = "noctis"
	origin_tech = "powerstorage=1"
	maxcharge = 1000 // 3 Tiro

	updateicon()
		return


/obj/item/weapon/cell/crap/plasmacutter
	maxcharge = 16 // shoot cost 2, yeah

/obj/item/weapon/cell/crap/adv_plasmacutter
	maxcharge = 30 // same here

/obj/item/weapon/cell/crap/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/secborg
	name = "security borg rechargable D battery"
	origin_tech = "powerstorage=0"
	maxcharge = 600	//600 max charge / 100 charge per shot = six shots
	g_amt = 40

/obj/item/weapon/cell/secborg/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/high
	name = "high-capacity power cell"
	origin_tech = "powerstorage=2"
	icon_state = "hcell"
	maxcharge = 10000
	g_amt = 60

/obj/item/weapon/cell/high/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/super
	name = "super-capacity power cell"
	origin_tech = "powerstorage=5"
	icon_state = "scell"
	maxcharge = 20000
	g_amt = 70
	construction_cost = list("metal"=750,"glass"=100)

/obj/item/weapon/cell/super/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/hyper
	name = "hyper-capacity power cell"
	origin_tech = "powerstorage=6"
	icon_state = "hpcell"
	maxcharge = 30000
	g_amt = 80
	construction_cost = list("metal"=500,"glass"=150,"gold"=200,"silver"=200)

/obj/item/weapon/cell/hyper/empty/New()
	..()
	charge = 0

/obj/item/weapon/cell/infinite
	name = "infinite-capacity power cell!"
	icon_state = "icell"
	origin_tech =  null
	maxcharge = 30000
	g_amt = 80
	use()
		return 1

/obj/item/weapon/cell/potato
	name = "potato battery"
	desc = "A rechargable starch based power cell."
	origin_tech = "powerstorage=1"
	icon = 'icons/obj/power.dmi' //'icons/obj/harvest.dmi'
	icon_state = "potato_cell" //"potato_battery"
	charge = 100
	maxcharge = 300
	m_amt = 0
	g_amt = 0
	minor_fault = 1