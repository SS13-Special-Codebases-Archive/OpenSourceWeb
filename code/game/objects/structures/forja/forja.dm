#define MAX_SMITHING 100
#define RNG_SMITH rand(1,2)

/obj/structure/water
	name = "water barrel"
	desc = "A water barrel, with water inside?"
	icon_state = "water_barrel"
	density = 1
	anchored = 0
	var/quenched = FALSE


/obj/structure/sharpener
	name = "grinding stone"
	desc = "A grinding stone used to sharpen weapons"
	icon = 'structures.dmi'
	icon_state = "grinding"
	density = 1
	anchored = 0

/obj/structure/sharpener/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item))
		if(!W.sharp && !W.edge)
			return
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		visible_message("<span class = 'passive'><span class='passivebold'>[user]</span> begins to sharpen \the [W]!</span>")
		playsound(src.loc, 'sound/effects/bladegrind.ogg', rand(25, 50), 1)
		if(do_after(user, 30))
			W.sharpness = 100
			visible_message("<span class = 'passive'><span class='passivebold'>[user]</span> sharpens \the [W]!</span>")
			return

/obj/structure/water/bite_act(mob/M as mob)
	var/mob/living/carbon/human/H = M
	if(get_dist(src,M) >= 2)
		return

	if(M.wear_mask && M.wear_mask.flags & MASKCOVERSMOUTH)
		to_chat(M, "<span class='combat'>[pick(nao_consigoen)] my mask is in the way!</span>")
		return

	var/datum/reagents/reagents = new/datum/reagents(2)
	reagents.add_reagent("water", 2)
	if(quenched)
		reagents.add_reagent("????", 2)
	reagents.reaction(H, INGEST)
	reagents.trans_to(H, 2)
	visible_message("<span class='bname'>[H]</span> drinks from \the [src]!</span>")
	H.bladder += rand(1,3) //For peeing
	H.hidratacao += 10
	playsound(M.loc, 'sound/items/drink.ogg', rand(10, 50), 1)
	return

/obj/structure/water/attack_hand(mob/M as mob)
	if(isrobot(M) || isAI(M))
		return

	if(!Adjacent(M))
		return

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.job == "Jester")
			H.say("Pipipipipipipipi...")
			playsound(M.loc, 'elchavo.ogg', rand(30, 50), 0)

/obj/structure/water/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/alicate))
		var/obj/item/weapon/alicate/A = W
		var/obj/item/weapon/ore/refined/lw/lw = safepick(A.contents)
		if(A.contents.len && lw.itemToBecome && lw.percentageToBecome >= MAX_SMITHING)
			for(var/i = 1, i <= lw.amountsDone, i++)
				var/obj/item/WE = new lw.itemToBecome(user.loc)
				WE.quality = lw.qualidadeBarra
				WE.New()
			A.contents.Cut()
			A.update_icon()
			var/sound_to_go = pick('sound/effects/quench_barrel1.ogg', 'sound/effects/quench_barrel2.ogg')
			src.quenched = TRUE
			playsound(src.loc, sound_to_go, 50, 0)
	if (istype(W, /obj/item/weapon/reagent_containers))
		var/obj/item/weapon/reagent_containers/RG = W
		RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		if(quenched)
			RG.reagents.add_reagent("????", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("\blue [user] fills \the [RG] using \the [src].","\blue You fill \the [RG] using \the [src].")
		return

/obj/structure/forja
	name = "forge"
	desc = "A forge used to heat metals."
	icon = 'icons/obj/forja.dmi'
	icon_state = "forja0"
	density = 1
	anchored = 1
	var/onfire = 0
	var/mob/tableclimber
	hits = 30
	breakable = TRUE

/obj/structure/forja/proc/climb_table(mob/user)
	src.add_fingerprint(user)
	user.visible_message("<span class='warning'>[user] starts climbing onto [src].</span>", \
								"<span class='notice'>You start climbing onto [src]...</span>")
	var/climb_time = 1
	if(user.restrained()) //Table climbing takes twice as long when restrained.
		climb_time = 2
	var/mob/living/carbon/human/H = user
	var/list/rolled = roll3d6(user,SKILL_CLIMB,null)
	switch(rolled[GP_RESULT])
		if(GP_CRITFAIL)
			var/damage = 10
			visible_message("<span class='crithit'>CRITICAL FAILURE!</span> <span class='hitbold'><b>[H]</b></span><span class='hit'> fails to climb [src]!</span>")
			H.apply_damage(damage + rand(-3,15), BRUTE, "head")
			H.apply_damage(damage + rand(-3,15), BRUTE, "r_chest")
			H:weakened = max(H:weakened,4)
			recoil(H)
			H.adjustStaminaLoss(rand(10,20))
			playsound(H.loc, 'sound/weapons/bite.ogg', 70, 0)
			step_away(H,src,1)
			H.sound2()
			if(prob(80))
				H.apply_effect(5, PARALYZE)
				visible_message("<span class='combatglow'><b>[H]</b>< has been knocked unconscious!</span>")
				H.ear_damage += rand(0, 3)
				H.ear_deaf = max(H.ear_deaf,6)
			H.CU()
			return
		else
			tableclimber = user
			if(do_mob(user, user, climb_time))
				if(src.loc) //Checking if table has been destroyed
					user.pass_flags += PASSTABLE
					step(user,get_dir(user,src.loc))
					user.pass_flags -= PASSTABLE
					user.visible_message("<span class='bname'>[user]</span> climbs onto [src]")
					if(onfire)
						H.on_fire = 1
						H.bodytemperature = 1000
						H.update_fire()
						spawn(rand(4, 8))
							var/list/sound = list()
							sound = list('sound/voice/firescream_female1.ogg', 'sound/voice/firescream_female2.ogg')
							if(H.gender == "male")
								sound = list('sound/voice/firescream1.ogg', 'sound/voice/firescream2.ogg', 'sound/voice/firescream3.ogg')
							playsound(loc, pick(sound), 200, 1)
					playsound(user.loc, 'sound/effects/ontable.ogg', 100, 0)
					tableclimber = null
					return 1
			tableclimber = null
	return 0

/obj/structure/forja/MiddleClick(mob/living/user as mob)
    user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
    if(get_dist(src,user) <= 1)
        if(user.stat)
            return

        if(user.resting)
            return

        if(user.sleeping)
            return

        if(user.stunned)
            return

        if(user.canmove)
            climb_table(user)
            return
    return

/obj/structure/forja/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(src.density == 0) //Because broken racks -Agouri |TODO: SPRITE!|
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/structure/forja/process()
	if(onfire)
		playsound(src, 'sound/webbers/bigfireloop.ogg', 70, wait=1, repeat=0)

/obj/structure/forja/New()
	. = ..()
	processing_objects.Add(src)

/obj/structure/forja/update_icon()
	if(onfire)
		icon_state = "forja1"
		set_light(6, 3, "#fdcf58")
		playsound(src, 'sound/webbers/bigfireloop.ogg', 70, wait=1, repeat=0)
	else
		icon_state = "forja0"
		src.set_light(0)
		playsound(src, null, 70, 0, wait=1, repeat=0)

/obj/structure/forja/attack_hand(mob/user)
	if(onfire)
		playsound(src.loc, 'torch_snuff.ogg', 50, 0)
		onfire = 0
		update_icon()

/obj/structure/forja/attackby(obj/item/weapon/W as obj, mob/user as mob)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(W, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/F = W
		if(F.lit)
			onfire = 1
			playsound(src.loc, 'torch_light.ogg', 50, 0)
			user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>lights the [src]!</span>")
			update_icon()
		else	if(onfire)
			F.lit = 1
			F.update_icon()

	if(istype(W, /obj/item/weapon/alicate))
		var/obj/item/weapon/alicate/A = W
		var/obj/item/weapon/ore/refined/lw/lw = safepick(A.contents)
		if(A.contents.len && onfire)
			lw.temperatura += 10
			user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>heats the ingot in [src]!</span>")
			A.update_icon()

/obj/structure/anvil
	name = "anvil"
	desc = "an anvil used on blacksmithing."
	icon_state = "anvil"
	density = 1
	anchored = 1
	pixel_y = 6
	var/mob/tableclimber

/obj/structure/anvil/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1
	if(src.density == 0) //Because broken racks -Agouri |TODO: SPRITE!|
		return 1
	if(istype(mover) && mover.checkpass(PASSTABLE))
		return 1
	else
		return 0

/obj/structure/anvil/proc/climb_table(mob/user)
	src.add_fingerprint(user)
	user.visible_message("<span class='warning'>[user] starts climbing onto [src].</span>", \
								"<span class='notice'>You start climbing onto [src]...</span>")
	var/climb_time = 1
	if(user.restrained()) //Table climbing takes twice as long when restrained.
		climb_time = 2
	var/mob/living/carbon/human/H = user
	var/list/rolled = roll3d6(user,SKILL_CLIMB,null)
	switch(rolled[GP_RESULT])
		if(GP_CRITFAIL)
			var/damage = 10
			visible_message("<span class='crithit'>CRITICAL FAILURE!</span> <span class='hitbold'><b>[H]</b></span><span class='hit'> fails to climb [src]!</span>")
			H.apply_damage(damage + rand(-3,15), BRUTE, "head")
			H.apply_damage(damage + rand(-3,15), BRUTE, "r_chest")
			H:weakened = max(H:weakened,4)
			recoil(H)
			H.adjustStaminaLoss(rand(10,20))
			playsound(H.loc, 'sound/weapons/bite.ogg', 70, 0)
			step_away(H,src,1)
			H.sound2()
			if(prob(80))
				H.apply_effect(5, PARALYZE)
				visible_message("<span class='combatglow'><b>[H]</b>< has been knocked unconscious!</span>")
				H.ear_damage += rand(0, 3)
				H.ear_deaf = max(H.ear_deaf,6)
			H.CU()
			return
		else
			tableclimber = user
			if(do_mob(user, user, climb_time))
				if(src.loc) //Checking if table has been destroyed
					user.pass_flags += PASSTABLE
					step(user,get_dir(user,src.loc))
					user.pass_flags -= PASSTABLE
					user.visible_message("<span class='bname'>[user]</span> climbs onto [src]")
					playsound(user.loc, 'sound/effects/ontable.ogg', 100, 0)
					tableclimber = null
					return 1
			tableclimber = null
	return 0

/obj/structure/anvil/MiddleClick(mob/living/user as mob)
    user.setClickCooldown(DEFAULT_SLOW_COOLDOWN)
    if(get_dist(src,user) <= 1)
        if(user.stat)
            return

        if(user.resting)
            return

        if(user.sleeping)
            return

        if(user.stunned)
            return

        if(user.canmove)
            climb_table(user)
            return
    return

/obj/structure/anvil/New()
	processing_objects.Add(src)
	..()

/obj/structure/anvil/Destroy()
	processing_objects.Remove(src)
	..()

/obj/structure/anvil/process()
	update_icon()

/obj/structure/anvil/attackby(obj/item/weapon/W, mob/living/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(istype(W, /obj/item/weapon/alicate))
		var/obj/item/weapon/alicate/A = W
		var/obj/structure/anvil/L = src
		var/obj/item/weapon/ore/refined/lw/lw = safepick(A.contents)
		if(length(A.contents))
			//comicao por favor para de botar o return na mesma linha do if
			//pfv fica muito feio pelo amor
			//pfv nao usa .len usa length() menos chance de causar runtimes
			if(length(L.contents))
				return
			if(lw.temperatura <= 0)
				to_chat(user, "<span class='combatbold'>The ingot is too cold.</span>")
				return
			else
				L.contents |= A.contents

				A.update_icon()
				L.update_icon()

		else if(length(L.contents))
			if(length(A.contents))
				return

			A.contents |= L.contents
			A.update_icon()
			L.update_icon()

	if(istype(W, /obj/item/weapon/carverhammer))
		var/obj/item/weapon/carverhammer/S = W
		var/obj/structure/anvil/L = src
		var/obj/item/weapon/ore/refined/lw/lw = safepick(L.contents)
		var/mob/living/carbon/human/H = user
		var/smithingModifier
		if(length(L.contents) && istype(contents, subtypesof(/obj/item/weapon/ore/refined/lw)))
			if(!lw.itemToBecome)
				var/list/inputlist = list()
				var/list/tobecomelist = list()
				for(var/i = 1, i <= lw.coisas_possiveis.len, i++)
					var/coisas = lw.coisas_possiveis[i]
					var/nome = coisas["name"]
					var/tobecome = coisas["path"]

					tobecomelist += tobecome
					inputlist += nome
				if(length(medal_nominated) && length(lw.medals))
					for(var/i = 1, i <= lw.medals.len, i++)
						var/coisas = lw.medals[i]
						var/nome = coisas["name"]
						var/tobecome = coisas["path"]

						tobecomelist += tobecome
						inputlist += nome
				var/inputch = input("What do you wish to forge?", "Choose an object") as null|anything in inputlist
				if(inputch)
					var/list/items_smithing = lw.coisas_possiveis
					if(length(medal_nominated) && length(lw.medals))
						items_smithing += lw.medals
					for(var/i = 1, i <= items_smithing.len, i++)
						var/coisas = lw.coisas_possiveis[i]
						var/nome = coisas["name"]
						var/tobecome = coisas["path"]
						var/amountstobecome = coisas["amount"]
						if(inputch == nome)
							lw.itemToBecome = tobecome
							lw.amountsDone = amountstobecome
							return
			if(lw.itemToBecome)
				var/randomphrasis = pick("smiths", "forges", "shapes", "molds" )
				if(lw.percentageToBecome <= MAX_SMITHING)
					if(lw.temperatura <= 0)
						to_chat(user, "<span class='combatbold'>The ingot is too cold.</span>")
						return
					var/sSkill = H?.my_skills?.GET_SKILL(SKILL_SMITH)
					playsound(src.loc, pick('sound/lfwbsounds/bsmith1.ogg', 'sound/lfwbsounds/bsmith2.ogg', 'sound/lfwbsounds/bsmith3.ogg' ,'sound/lfwbsounds/bsmith4.ogg'), 100, 1)
					user.adjustStaminaLoss(4)
					if(sSkill <= 2)
						if(prob(21))
							user.visible_message("<span class='combatbold'>[user] BREAKS!</span> <span class='combat'>the bar!</span>")
							L.contents.Cut()
							L.update_icon()
							return
						user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>[randomphrasis] the ingot!</span>")
					else
						user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>[randomphrasis] the ingot!</span>")
					if(S.wielded == TRUE)
						smithingModifier += 3
					lw.percentageToBecome += sSkill + RNG_SMITH + smithingModifier
					H.learn_skill("smithing", null, lw.qualidadeBarra)
				else if(lw.percentageToBecome >= MAX_SMITHING)
					if(lw.percentageToUpgrade >= 1 && lw.temperatura > 0)
						var/sSkill = H?.my_skills?.GET_SKILL(SKILL_SMITH)
						lw.percentageToUpgrade += sSkill + RNG_SMITH + smithingModifier
						if(prob((lw.qualidadeBarra+4)-(sSkill-2)))
							user.visible_message("<span class='combatbold'>[user] BREAKS!</span> <span class='combat'>the bar!</span>")
							user.adjustStaminaLoss(6)
							L.contents.Cut()
							L.update_icon()
							return
						else
							if(prob((lw.qualidadeBarra+11)-(sSkill-1)))
								user.visible_message("<span class='combatbold'>[user]</span> <span class='combat'>[randomphrasis] the ingot!</span>")
								lw.damage += 1
							else
								user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>[randomphrasis] the ingot!</span>")

							playsound(src.loc, pick('sound/lfwbsounds/bsmith1.ogg', 'sound/lfwbsounds/bsmith2.ogg', 'sound/lfwbsounds/bsmith3.ogg' ,'sound/lfwbsounds/bsmith4.ogg'), 100, 1)
							user.adjustStaminaLoss(4)
							if(lw.percentageToUpgrade >= MAX_SMITHING && lw.qualidadeBarra <= 4)
								lw.qualidadeBarra += 1
								lw.percentageToUpgrade = 0
								user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>improves the ingot!</span>")
							H.learn_skill("smithing", null, lw.qualidadeBarra)
					else if(lw.percentageToUpgrade >= 1 && lw.temperatura <= 0)
						to_chat(user, "<span class='passive'>The ingot is too cold.</span>")
					else
						to_chat(user, "<span class='passivebold'>I already finished it.</span> <span class='passive'>I should quench it in a barrel or in water.</span>")



/obj/structure/anvil/RightClick(mob/living/carbon/human/user)
	if(istype(user.get_active_hand(), /obj/item/weapon/carverhammer))
		var/obj/structure/anvil/L = src
		var/obj/item/weapon/ore/refined/lw/lw = safepick(L.contents)
		if(lw.percentageToUpgrade <= 0 && lw.percentageToBecome >= 100 && lw.temperatura > 0 && lw.qualidadeBarra <= 6)
			user.visible_message("<span class='passivebold'>[user]</span> <span class='passive'>begins to improve the ingot!</span>")
			lw.percentageToUpgrade += 1


/obj/structure/anvil/update_icon()
	if(contents.len && istype(contents, subtypesof(/obj/item/weapon/ore/refined/lw)))
		var/obj/item/weapon/ore/refined/lw/lw = safepick(contents)
		if(lw.temperatura)
			icon_state = "anvil1"
		if(!lw.temperatura)
			icon_state = "anvil2"
	else
		icon_state = "anvil"


/obj/item/weapon/storage/forge
	name = "Smelter"
	desc = "A smelter used to forge ores"
	icon = 'icons/obj/structures.dmi'
	icon_state = "smelter"
	density = 0
	anchored = 1
	var/on = 0
	var/tocomplete = 0
	storage_slots = 2

	attack_hand(mob/user as mob)
		if(!on)
			for(var/obj/item/A in src.contents)
				A.loc = src.loc
		else return

/obj/item/weapon/storage/forge/update_icon()
	if(on)
		icon_state = "smelter1"
	else
		icon_state = "smelter"


/obj/item/weapon/storage/forge/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(on)
		return

	if(istype(W, /obj/item/weapon) && !(src.contents.len >= storage_slots))
		var/obj/item/weapon/L = W
		user.drop_item(sound = 0)
		src.contents += L

	if(istype(W, /obj/item/weapon/flame) && src.contents.len == src.storage_slots)
		var/COAL = 0
		on = 1
		update_icon()
		for(var/obj/item/weapon/ore/lw/L in src.contents)
			if(istype(L, /obj/item/weapon/ore/lw/coal))
				COAL += 1
		while(on && COAL ==1 )
			sleep(10)
			tocomplete += 10
			playsound(src.loc, 'sound/effects/smelter_sound.ogg', 50, 1)
			if(tocomplete >= 160)
				for(var/i = 1, i <= src.contents.len, i++)
					var/contentes = src.contents[i] //Isso é proposital
					if(!istype(contentes, /obj/item/weapon/ore/lw/coal) && istype(contentes, /obj/item/weapon/ore/lw))
						var/obj/item/weapon/ore/lw/A = contentes
						new A.refined_type(src.loc)
						src.contents.Cut()
						A.loc = src.contents
					else if(istype(contentes, /obj/item))
						var/obj/item/I = contentes
						if(I.can_be_smelted_to)
							new I.can_be_smelted_to(src.loc)
							src.contents.Cut()
				on = 0
				tocomplete = 0
				playsound(src.loc, 'sound/lfwbsounds/smelter_fin.ogg', 50, 1)
				update_icon()
				break