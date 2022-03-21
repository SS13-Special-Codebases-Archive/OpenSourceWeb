var/list/phone_numbers = list()
var/list/dial_sounds = list()
var/list/rim_cards = list()
var/list/mob_phone_sounds = list('mob0.ogg','mob1.ogg','mob2.ogg','mob3.ogg','mob4.ogg','mob5.ogg','mob6.ogg','mob7.ogg','mob8.ogg','mob9.ogg')

/obj/item/device/rim_card
    name = "RIM-Card"
    icon_state = "rc1"
    icon = 'icons/life/device.dmi'
    w_class = 1.0
    var/phone_number = null
    var/obj/item/device/rim_card/called_by = null
    var/obj/item/device/rim_card/called_who = null
    var/in_call = FALSE
    var/obj/item/device/cellphone/Phone = null
    New()
        ..()
        repeat_phonerand
        phone_number = rand(1000,4000)
        while(phone_numbers.Find(phone_number))
            goto repeat_phonerand
        phone_numbers.Add(phone_number)
        icon_state = pick("rc1","rc2","rc3")
        rim_cards.Add(src)

/obj/item/device/cellphone/Donator/New()
	var/obj/item/device/rim_card/RIM = new
	rimcard = RIM
	RIM.loc = src
	RIM.Phone = src

/obj/item/device/cellphone
    name = "cellphone"
    icon_state = "1mp0"
    icon = 'icons/life/device.dmi'
    w_class = 1.0
    var/off_state = "1mp0"
    var/on_state = "1mp1"
    var/obj/item/device/rim_card/rimcard = null
    var/on = FALSE
    var/ringing = FALSE
    var/calling = FALSE
    var/ringtone = 'mob_ringing.ogg'
    New()
        ..()
        ringtone = pick('mob_ringing.ogg','mob_ringing2.ogg')

/obj/item/device/cellphone/proc/CheckCallRing()
    ringagain
    if(ringing && !src.rimcard.in_call)
        spawn(100)
            if(ringing && !src.rimcard.in_call)
                playsound(src, ringtone, 80, 0)
                src.visible_message("<span class='passive'>[src] rings!</span>")
                goto ringagain
    else
        if(calling && !src.rimcard.in_call)
            spawn(50)
                if(calling && !src.rimcard.in_call)
                    playsound(src, 'phone_calling.ogg', 30, 0)
                    goto ringagain
/obj/item/device/cellphone/examine()
    set src in view()
    ..()
    if ((in_range(src, usr) || loc == usr))
        if(!rimcard)
            to_chat(usr, "<span class='combatbold'>It has no RIM-card.</span>")
        if(rimcard)
            to_chat(usr, "<span class='passive'>The phone number is [rimcard.phone_number].</span>")

/obj/item/device/cellphone/attackby(obj/item/W, mob/user)
    if(!rimcard)
        if(istype(W, /obj/item/device/rim_card))
            var/obj/item/device/rim_card/RIM = W
            user.drop_from_inventory(RIM)
            rimcard = RIM
            RIM.loc = src
            RIM.Phone = src
            to_chat(user, "<span class='passive'>You insert a RIM-card in \the [src]</span>")
            playsound(src, 'sound/lfwbcombatuse/energy_reload.ogg', 50, 0)
            return
    else
        to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> there is a RIM-card already!</span>")
        return

/obj/item/device/cellphone/attack_self(mob/user as mob)
    if(rimcard)
        if(!on)
            to_chat(user, "<span class='passive'>You turn on \the [src]</span>")
            playsound(src, pick(mob_phone_sounds), 90, 0)
            on = TRUE
            icon_state = on_state
            return
        else
            if(calling && !src.rimcard.in_call)
                to_chat(user, "<span class='passive'>The call is canceled.</span>")
                src.calling = FALSE
                playsound(src, pick(mob_phone_sounds), 90, 0)
                src.rimcard.called_by = null
                src.rimcard.called_who.Phone.ringing = FALSE
                src.rimcard.called_who = null
                return
            else
                if(ringing && !src.rimcard.in_call)
                    to_chat(user, "<span class='passive'>You pick up the phone.</span>")
                    src.rimcard.in_call = TRUE
                    playsound(src, pick(mob_phone_sounds), 90, 0)
                    src.rimcard.called_by.in_call = TRUE
                    src.rimcard.called_by.called_who.in_call = TRUE
                    return
                else
                    if(src.rimcard.in_call)
                        to_chat(user, "<span class='combat'>You hang up the phone.</span>")
                        src.rimcard.in_call = FALSE
                        playsound(src, pick(mob_phone_sounds), 90, 0)
                        src.rimcard.called_by.in_call = FALSE
                        src.rimcard.called_by.called_who.in_call = FALSE
                        src.rimcard.Phone.ringing = FALSE
                        src.rimcard.Phone.calling = FALSE
                        src.rimcard.called_by.called_who.Phone.ringing = FALSE
                        src.rimcard.called_by.called_who.Phone.calling = FALSE
                        return
                    else
                        playsound(src, pick(mob_phone_sounds), 90, 0)
                        var/cellphone_opt = input(user,"Select an option","Cellphone") in list("Call Number","Number List","(CANCEL)")
                        switch(cellphone_opt)
                            if("Call Number")
                                var/call_number = input("Insert a 4 digit phone number.","Cellphone") as num
                                var/numcheck = num2text(call_number)
                                if(length(numcheck) > 4)
                                    to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> the number is too long!</span>")
                                    playsound(src, pick(mob_phone_sounds), 90, 0)
                                    return
                                if(length(numcheck) < 4)
                                    to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> the number is too short!</span>")
                                    playsound(src, pick(mob_phone_sounds), 90, 0)
                                    return
                                if(call_number == rimcard.phone_number)
                                    to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> I can't call to my own number!</span>")
                                    playsound(src, pick(mob_phone_sounds), 90, 0)
                                    return
                                if(!phone_numbers.Find(call_number))
                                    to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> this phone number doesn't exist!</span>")
                                    playsound(src, pick(mob_phone_sounds), 90, 0)
                                    return
                                for(var/obj/item/device/rim_card/RI in rim_cards)
                                    if(RI.phone_number == call_number)
                                        if(!RI.Phone)
                                            to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> their RIM-card is inactive!</span>")
                                            playsound(src, pick(mob_phone_sounds), 90, 0)
                                            return
                                        if(RI.Phone)
                                            if(RI.in_call || RI.Phone.ringing)
                                                to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> they're busy!</span>")
                                                playsound(src, pick(mob_phone_sounds), 90, 0)
                                                return
                                            else
                                                playsound(src, pick(mob_phone_sounds), 90, 0)
                                                spawn(3)
                                                    playsound(src, pick(mob_phone_sounds), 90, 0)
                                                    spawn(3)
                                                        playsound(src, pick(mob_phone_sounds), 90, 0)
                                                        spawn(3)
                                                            playsound(src, pick(mob_phone_sounds), 90, 0)
                                                            src.rimcard.called_who = RI
                                                            RI.called_by = src.rimcard
                                                            RI.Phone.ringing = TRUE
                                                            src.calling = TRUE
                                                            RI.Phone.CheckCallRing()
                                                            src.CheckCallRing()
                                                            return
                            if("Number List")
                                to_chat(user, "\n<div class='firstdivmood'><div class='moodbox'><span class='graytext'>Firethorn-Range Phone Number List: \n[english_list(phone_numbers)]</span></div></div>")
                                return
    else
        to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)]</span><span class='combat'> I need a RIM-card!</span>")
        return