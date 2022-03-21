/datum/organ/external/mouth
	name = "mouth"
	icon_name = "mouth"
	display_name = "mouth"
	display_namebr = "boca"
	max_damage = 100
	min_broken_damage = 75
	body_part = MOUTH
	encased = "skull"
	var/list/teeth_list = list()
	var/max_teeth = 32
	var/teethRemaining = 32
	iconsdamage = "head"
	head_icon_needed = 1
	mask_color = "#ffffff"

/datum/organ/external/mouth/proc/get_teeth() //returns collective amount of teeth
	var/amt = 0
	if(!teeth_list) teeth_list = list()
	for(var/obj/item/stack/teeth in teeth_list)
		amt += teeth.amount
	return amt

/datum/organ/external/mouth/proc/knock_out_teeth(throw_dir, num=32) //Won't support knocking teeth out of a dismembered head or anything like that yet.
	num = Clamp(num, 1, 32)
	var/done = 0
	if(teeth_list && teeth_list.len) //We still have teeth
		var/stacks = rand(1,3)

		var/list/L = list()
		for(var/turf/T in range(1))
			L += T
		var/turf/TUR = pick(L)
		for(var/curr = 1 to stacks) //Random amount of teeth stacks
			var/obj/item/stack/teeth/teeth = pick(teeth_list)
			if(!teeth || teeth.zero_amount()) return //No teeth left, abort!
			var/drop = round(min(teeth.amount, num)/stacks) //Calculate the amount of teeth in the stack
			var/obj/item/stack/teeth/T = new teeth.type(owner.loc, drop)
			teeth.use(drop)
			T.add_blood(owner)
			playsound(owner, "trauma", 75, 0)
			T.throw_at(TUR)
			owner.loc:add_blood(owner)

			teeth.zero_amount() //Try to delete the teeth
			done = 1
			dentesperdidos += drop
	return done
