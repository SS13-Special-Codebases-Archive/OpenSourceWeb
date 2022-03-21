/mob/living/carbon/human/MiddleClick(mob/living/carbon/human/user as mob)
	if(user.middle_click_intent == null)
		if(user.get_active_hand())
			if(istype(user.get_active_hand(), /obj/item/weapon))
				var/obj/item/weapon/W = user.get_active_hand()
				var/datum/organ/external/affected = get_organ(user.zone_sel.selecting)
				if(src.stat == 0) return
				if(W.sharp)
					visible_message("<span class='combatbold'>[user]</span><span class='combat'> is trying to operate [src] with [W]!</span>")
					if(do_after(user, rand(20,30)))
						if(ismonster(src))
							gib()
							if(istype(src, /mob/living/carbon/human/monster/arellit))
								new /obj/item/stack/sheet/leather(src.loc)
								new /obj/item/stack/sheet/leather(src.loc)
								new /obj/item/stack/sheet/leather(src.loc)
								new /obj/item/stack/sheet/leather(src.loc)
								new /obj/item/stack/sheet/leather(src.loc)
								new /obj/item/weapon/reagent_containers/food/snacks/meat(src.loc)
								new /obj/item/weapon/reagent_containers/food/snacks/meat(src.loc)
								new /obj/item/weapon/reagent_containers/food/snacks/meat(src.loc)
								new /obj/item/weapon/bone(src.loc)
							else
								new /obj/item/stack/sheet/leather(src.loc)
								new /obj/item/weapon/reagent_containers/food/snacks/meat(src.loc)
								new /obj/item/weapon/bone(src.loc)
						else
							if(affected.name == "chest" || affected.name == "groin" || affected.name == "vitals")
								if(statcheck(user.my_stats.st, 10, 0))
									if(affected.open == 0)
										if(istype(src) && !(src.species.flags & NO_BLOOD))
											affected.status |= ORGAN_BLEEDING
										affected.createwound(CUT, 20)
										affected.open = 1
										src.update_surgery(1)
										visible_message("<span class='combatbold'>[user]</span><span class='combat'> makes an incision on [src].</span>")
										return

								else if(skillcheck(user.my_skills.GET_SKILL(SKILL_SURG), 75, 0, user))
									if(affected.open == 0)
										if(istype(src) && !(src.species.flags & NO_BLOOD))
											affected.status |= ORGAN_BLEEDING
										affected.createwound(CUT, 20)
										affected.open = 1
										src.update_surgery(1)
										visible_message("<span class='combatbold'>[user]</span><span class='combat'> makes an incision on [src].</span>")
										return

								if(statcheck(user.my_stats.st, 10, 0))
									if(affected.open == 1)
										if(istype(src) && !(src.species.flags & NO_BLOOD))
											affected.status |= ORGAN_BLEEDING
										affected.createwound(CUT, 40)
										affected.dissected = 1
										src.update_surgery(1)
										visible_message("<span class='combatbold'>[user]</span><span class='combat'> dissects [src].</span>")
										return

								else if(skillcheck(user.my_skills.GET_SKILL(SKILL_SURG), 75, 0, user))
									if(affected.open == 1)
										if(istype(src) && !(src.species.flags & NO_BLOOD))
											affected.status |= ORGAN_BLEEDING
										affected.createwound(CUT, 40)
										affected.dissected = 1
										src.update_surgery(1)
										visible_message("<span class='combatbold'>[user]</span><span class='combat'> dissects [src].</span>")
										return
							else
								if(statcheck(user.my_stats.st, 10, 0) && skillcheck(user.my_skills.GET_SKILL(SKILL_SURG), 50, 0, user))
									visible_message("<span class='combatbold'>[user]</span><span class='combat'> cuts [src]!</span>")
									affected.droplimb(1,1,0)
								else if(skillcheck(user.my_skills.GET_SKILL(SKILL_SURG), 75, 0, user))
									visible_message("<span class='combatbold'>[user]</span><span class='combat'> cuts [src]!</span>")
									affected.droplimb(1,1,0)
	else
		middle_click_intent_check(user)