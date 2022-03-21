/proc/jinxed(var/text = null, var/mob/usr, var/turf/C)
    if(ishuman(usr))
        var/mob/living/carbon/human/H = usr
        to_chat(usr, "<i><b>You feel something happening</b></i>")
        H.jinxed = 1

/mob/living/carbon/human/examine(mob/user)
    if(ishuman(usr))
        var/mob/living/carbon/human/H = usr

        for(var/obj/item/I in src)
            if(I.sanctified || I == /obj/item/weapon/melee/classic_baton/crossofravenheart && H.jinxed)
                var/list/sancList = list("They wield a holy weapon! It won't work!", "They're hold something holy to them!", "They are sanctified!")
                to_chat(H, "<span class ='jogtowalk'>[pick(sancList)]</span>")
                return

        if(H.combat_mode)
            if(H.jinxed)
                var/list/endList = list("He needs to die.", "Victory is already ours.", "His end is near.", "Just do it.")
                var/list/insecureList = list("I shouldn't be doing this...", "I don't trust my will...", "Maybe I should surrender?", "Maybe I should run?")

                H.adjustStaminaLoss(rand(30, 40))
                src.dicked = 1 // i don't think this even does anything

                to_chat(H, "<span class='combatglow'>[pick(endList)]</span>")
                to_chat(src, "<span class='combatglow'>[pick(insecureList)]</span>")
                return
    ..()