/* 
||riotmigrant's memoirs||

How I recall the portable trader (forgot its actual name) working, is it needed to be on the surface (area/surface or something)
because it was essentially amazon drone pick up and drops. I believe it worked on an global interval but I might make it manual pickups
I'm unsure if a datum/controller is necessary but we'll see
The portable trader will also have some unique supply packs and not come in crates (datums/portablepacks.dm)
Intended for trader and siege trader, which will also coinside with drug dealer & its outlaw alternative (infochip)
You could also buy back slaves from the soulbreakers (depending on their class i.e. noble)
I think the merchant had a special link/hole to the surface or something that allowed them to have the portable trader in their shop
I also think you could communicate on the portable traders like an IRC
I don't think you could directly insert coins either but I could be wrong.
Unsure if taxes affect the machine.

From Wiki:
Trader carries a commstation with 300 obols and a mysterious package, in which they will find what they put there before the journey.
Drugdealer has a chip for the commstation that opens Foxic's Pleasure and a sample package hidden in their whistle.

I wrote this so I know what to code + I think it's good practice to write everything you know about the thing so no missing features.
*/

/obj/item/device/portabletrader

    name = "commstation"
    desc = "A trading device that only operates within the bounds of the surface."
	icon_state = "powersink0"
	item_state = "electronic"
	w_class = 8.0
    var/mode = 0
    var/chipped = 0 //for drug dealer migrant chip
    var/last_viewed_group = "categories"
	flags = FPRINT | TABLEPASS | CONDUCT

/obj/item/device/portabletrader/attack_hand(var/mob/user)
    if(mode == 0)
        ..()
    else // mode == 1
        //topic

/obj/item/device/portabletrader/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/clothing/head/amulet/drugchip))
        chipped = 1
        qdel(I)
        playsound(src.loc, 'sound/effects/coininsert.ogg', 30, 0)
        return

/obj/item/device/portabletrader/RightClick(mob/living/carbon/human/user as mob)
    if(ishuman(user))
        if(mode == 0)
            icon_state = "powersink1"
            playsound(get_turf(src), 'sound/effects/phasein.ogg', 30, 1)
            mode = 1
        else // mode == 1
            icon_state = "powersink0"
            playsound(get_turf(src), 'sound/effects/teleport.ogg', 50, 1)
            mode = 0



// For Drug Dealer
/obj/item/clothing/head/amulet/drugchip
	name = "C-19 infochip"
	desc = "Used to access a certain black market."
	icon_state = "C-19"
	item_worth = 20
	w_class = 1.0
	neck_use = TRUE
//For Outlaw Drug Dealer
/obj/item/clothing/head/amulet/drugchip/outlaw
	name = "C-19 infochip ver.2"
// For Trader
/obj/item/traderpackage
    name = "parcel"
    icon = 'icons/life/LFWB_USEFUL.dmi'
	icon_state = "package2"
    w_class = 1.0

/obj/item/traderpackage/attack_self(var/mob/user)
    var/whoyouchoose = input(user, "What's inside?", "parcel") as null|anything in list("Hatchet","Pickaxe","Hammer & Tongs","Chisel","Surgical Tools","Skinning Knife","Silver Coins","Fishing Rod","Pitchfork","Horn")

    switch(whoyouchoose)
        if("Hatchet")
            new /obj/item/weapon/hatchet(user.loc)
        if("Pickaxe")
            new /obj/item/weapon/pickaxe(user.loc)
        if("Hammer & Tongs")
            new /obj/item/weapon/carverhammer(user.loc)
            new /obj/item/weapon/alicate(user.loc)
        if("Chisel")
            new /obj/item/weapon/chisel(user.loc)
        if("Surgical Tools")
            //
        if("Skinning Knife")
            //
        if("Silver Coins")
            //
        if("Fishing Rod")
            //
        if("Pitchfork")
            //
        if("Horn")
            //
    //playsound + message
    qdel(src)
