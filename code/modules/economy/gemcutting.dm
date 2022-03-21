/*
||riotmigrant's memoirs||

Based on craft and DX (potentially IN too)
There are low quality versions of gems. I don't know how you generate those in lifeweb buuut
I'll do a quality variable when gemcutting, quality++ on critsuccess, quality-- on critfail (they won't know)
If quality is negative by the time gemcutting is done, you'll get a low quality gem
A gem allowed you to craft the cave crown (intended for allmig but still neat)
Gemcutter migrant role is a thing
Wanderlust gemcutting machines were a thing, idk how they worked but maybe will do factory machines later down the line for bookie

*/



var/list/gemlist = list("quartz","ruby","emerald","sapphire","diamond","topaz")

/obj/item/gem
    name = "gem"
    desc = "A beautiful stone!"
    icon = 'icons/life/LFWB_USEFUL.dmi'
    icon_state = "ruby"
    //drop_sound
    var/gemquality = 0 // used to determine failed gem
    var/finished = 0
    var/whatgem = ""
    var/progress = 0
    drop_sound = 'sound/effects/gemdrop.ogg'

/obj/item/gem/New()
    ..()
    drop_sound = pick(list('sound/effects/gemdrop.ogg', 'sound/effects/gemdrop1.ogg', 'sound/effects/gemdrop2.ogg'))
    if(whatgem == "")
        whatgem = "[pick(gemlist)]"
    update_icon()

/obj/item/gem/update_icon()
    ..()
    if(finished)
        if(gemquality < 0)
            icon_state = "[whatgem]_fail"
            name = whatgem
            item_worth = gemworth() * rand(0.3,0.4)
        else
            icon_state = "[whatgem]_cut"
            name = whatgem
            item_worth = gemworth() * rand(0.9,1.1)
    else
        icon_state = "[whatgem]"
        item_worth = gemworth() * rand(0.05,0.1)

/obj/item/gem/attackby(obj/item/W as obj, mob/living/carbon/human/user as mob)
    var/swag = null
    if(user.check_perk(/datum/perk/gemcutting))
        swag = 8
    if(istype(W, /obj/item/weapon/chisel))
        user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
        playsound(user.loc, 'stonestone.ogg', 65, 1)
        if(finished)
            return
        if(progress >= 100)
            finished = 1
            update_icon()
            return
        var/list/roll_result = roll3d6(user,SKILL_CRAFT,swag)
        switch(roll_result[GP_RESULT])
            if(GP_CRITSUCCESS)
                user.visible_message("<span class='passive'>[user] cuts the gem.</span>")
                progress++
                gemquality++
            if(GP_SUCCESS)
                user.visible_message("<span class='passive'>[user] cuts the gem.</span>")
                progress++
            if(GP_FAILED)
                user.visible_message("<span class='combat'>[user] cuts the gem.</span>")
            if(GP_CRITFAIL)
                user.visible_message("<span class='combat'>[user] cuts the gem.</span>")
                gemquality--

/obj/item/gem/proc/gemworth()
    switch(whatgem)
        if("diamond")
            return 466
        if("ruby")
            return 400
        if("emerald")
            return 366
        if("sapphire")
            return 300
        if("topaz")
            return 200
        if("quartz")
            return 133

/obj/item/gem/diamond
    finished = 1
    whatgem = "diamond"
    icon_state = "diamond_cut" // mapping purposes

/obj/item/gem/uncutdiamond
    whatgem = "diamond"
    icon_state = "diamond" // mapping purposes