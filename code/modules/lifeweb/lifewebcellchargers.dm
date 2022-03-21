var/list/lifewebAreas = list()
var/global/list/chargers = list()
var/list/affectedItems = list()

/obj/machinery/web_recharger
	name = "battery charger"
	icon = 'LW2.dmi'
	icon_state = "battery_station"
	anchored = 1
	use_power = 1
	density = 1
	flammable = 0
	var/active_area
	var/blood_usage = 0
	var/obj/item/weapon/cell/web/charging = null
	var/powered = FALSE
	var/image/powerOverlay

obj/item/weapon/cell/web/New()
    ..()

    for(var/x = 0; x <= charge; x++)
        item_worth++

obj/item/weapon/cell/web/empty/New()
    ..()

    charge = 0
    item_worth = 15

/obj/machinery/web_recharger/attackby(obj/item/W, mob/user)
    updatepoweroverlay()
    if(!charging)
        if(istype(W, /obj/item/weapon/cell/web))
            var/obj/item/weapon/cell/web/oldCell = W
            charging = new /obj/item/weapon/cell/web(src)
            charging.charge = oldCell.charge
            powered = TRUE

            overlays += icon(W.icon, W.icon_state)
            if(ishuman(user))
                var/mob/living/carbon/human/H = user
                var/obj/item/I = H.get_active_hand()
                del(I)
            playsound(user, 'sound/LW2/lwButton.ogg', 85, 1, -1)
            updatepoweroverlay()

/obj/machinery/web_recharger/attack_hand(mob/user)
    updatepoweroverlay()
    if(charging)
        if(ishuman(user))
            var/mob/living/carbon/human/H = user

            var/obj/item/I = H.get_active_hand()
            var/obj/item/weapon/cell/web/oldCell = charging

            if(!I)
                var/obj/item/weapon/cell/web/handCell = null
                if(H.hand)
                    H.equip_to_slot_or_del(new /obj/item/weapon/cell/web(H), slot_l_hand)

                    if(istype(H.l_hand, /obj/item/weapon/cell/web))
                        handCell = H.l_hand

                else
                    H.equip_to_slot_or_del(new /obj/item/weapon/cell/web(H), slot_r_hand)

                    if(istype(H.r_hand, /obj/item/weapon/cell/web))
                        handCell = H.r_hand

                handCell.charge = oldCell.charge

                for(var/x = 0; x <= handCell.charge; x++)
                    handCell.item_worth++

                H.update_inv_l_hand()
                H.update_inv_r_hand()

            overlays -= icon(charging.icon, charging.icon_state)
            charging = null
            powered = FALSE
            updatepoweroverlay()
            return 1
    return 0

/obj/machinery/web_recharger/New()
    ..()
    charging = new /obj/item/weapon/cell/web(src)
    //var/powered = TRUE
    overlays += icon('LW2.dmi', "bbattery")

    powerOverlay = image('LW2.dmi', icon_state="battery_station_overlay")
    overlays += powerOverlay
    for(var/area/A in world)
        if(A.name == active_area)
            lifewebAreas += A
    chargers += src
    updatepoweroverlay()

/obj/machinery/web_recharger/proc/updatepoweroverlay()
    overlays -= powerOverlay

    var/newIconState = "battery_station_overlay"
    if(charging)
        switch(charging.charge)
            if(0 to 25)
                newIconState = "ob0"
            if(26 to 50)
                newIconState = "ob25"
            if(51 to 75)
                newIconState = "ob75"
            if(76 to INFINITY)
                newIconState = "ob100"
    powerOverlay = image('LW2.dmi', icon_state=newIconState)
    overlays += powerOverlay

/obj/machinery/light/New()
    ..()
    var/area/A = get_area(src)
    A.webItems += src

/obj/machinery/lamppost/New()
    ..()
    layer = 3.6
    var/area/A = get_area(src)
    A.webItems += src
    plane = 22

/obj/machinery/redlamp/New()
    ..()
    var/area/A = get_area(src)
    A.webItems += src

/obj/machinery/door/airlock/New()
    ..()
    var/area/A = get_area(src)
    A.webItems += src

/obj/machinery/web_recharger/process()
    updatepoweroverlay()
    for(var/area/A in lifewebAreas)
        if(A.name == active_area)
            for(var/obj/machinery/light/lamp in A.webItems)
                if(charging || energyInvestimento) //FOASE
                    if(charging.charge || energyInvestimento)
                        lamp.on = TRUE
                        lamp.update()
                        continue
                lamp.on = FALSE
                lamp.update()
            for(var/obj/machinery/lamppost/lamp in A.webItems)
                if(charging || energyInvestimento)
                    if(charging.charge || energyInvestimento)
                        lamp.on = TRUE
                        lamp.update()
                        continue
                lamp.on = FALSE
                lamp.update()
            for(var/obj/machinery/redlamp/lamp in A.webItems)
                if(charging || energyInvestimento)
                    if(charging.charge || energyInvestimento)
                        lamp.on = TRUE
                        lamp.update()
                        continue
                lamp.on = FALSE
                lamp.update()
            for(var/obj/machinery/door/airlock/door in A.webItems)
                if(charging || energyInvestimento)
                    if(charging.charge || energyInvestimento)
                        door.lwOn = TRUE
                        continue
                door.lwOn = FALSE

    var/subtractAmount = 1 / rand(9, 12)
    if(charging)
        if((charging.charge -2) < 0)
            charging.charge = 0
            subtractAmount = 0
        charging.charge -= subtractAmount

/obj/machinery/door/airlock/attackby(obj/item/W, mob/user)
    if(!lwOn)
        if(istype(W, /obj/item/weapon/crowbar))
            open()
            return 0
    ..()

/obj/item/weapon/cell/web/examine()
    to_chat(usr, "The battery meter shows... <b>[charge]</b>")

/obj/machinery/web_recharger/examine()
    ..()
    if(charging)
        to_chat(usr, "The battery meter shows... <b>[charging.charge]</b>")

/obj/item/weapon/cell/crap/leet/examine()
    to_chat(usr, "The battery meter shows... <b>[charge / 10]</b")

/obj/item/weapon/cell/crap/leet/attackby(obj/item/W, mob/user)
    if(istype(W, /obj/item/weapon/cell/web))
        var/obj/item/weapon/cell/web/WW = W

        if(WW.charge >= 10 && charge < 1000)
            WW.charge -= 10
            playsound(user, 'sound/weapons/BEEP.ogg', 100, 1)

            charge = 1000
