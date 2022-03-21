/mob/living/carbon/human/proc/buckle_victim(var/mob/victim)
	victim.buckled = src
	victim.loc = loc
	buckled_mob = victim

/mob/living/carbon/human/proc/unbuckle_someone()
	if(!buckled_mob) return

	buckled_mob.buckled = null
	buckled_mob.update_canmove()
	buckled_mob = null