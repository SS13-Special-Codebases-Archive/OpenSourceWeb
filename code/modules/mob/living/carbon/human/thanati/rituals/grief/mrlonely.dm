//BRUNO DO FUTURO ALGUM DIA VOCE PODE PRECISAR DISSO E VOLTAR NESSE CODE ALGUM DIA E TUDO MAIS
//OVERRIDE COM OBJETO DE IMAGEM LEMBRA O QUE ISSO FAZ NA HORA QUE TU PRECISAR

/client/proc/handleHalucLone(var/range = 12)

    for(var/mob/living/carbon/human/H in view(mob, range))
        if(H in fire)
            continue
        if(H == mob)
            continue

        var/image/I = image('icons/fire/burnmotherfucker.dmi', H, "fire_s", H.layer)
        I.override = 1

        images += I
        fire += H


/proc/loneliness(var/text = null, var/mob/usr, var/turf/C)
    to_chat(usr, "<b><i>You feel your heart beating stronger!</b></i>")
    for(var/obj/item/weapon/photo/P in C.contents)
        for(var/mob/living/carbon/human/H in P.info)
            if(!H.client)
                return
            if(istype(H.amulet, /obj/item/clothing/head/amulet/holy/cross))
                return
            if(H.job == "Count" || H.job == "Bishop" || H.job == "Priest")
                return
            H.mrlonely = 1
            for(var/mob/living/carbon/human/HH in view(H, 14))
                if(HH == H)
                    continue
                var/image/I = image('icons/fire/burnmotherfucker.dmi', HH, "fire_s", H.layer)
                I.override = 1
                H.client.images += I
                H.client.fire += HH
            return 1
    return

/mob/living/carbon/human/examine(mob/user)
    if(ishuman(usr))
        var/mob/living/carbon/human/H = usr

        if(H.mrlonely)
            to_chat(usr, "<span class='passivebold'>Something is there but you can't see it.</span>")
            return
    ..()

/mob/living/carbon/human/Life()
    ..()
    if(client)
        var/client/C = client
        if(mrlonely)
            C.handleHalucLone()