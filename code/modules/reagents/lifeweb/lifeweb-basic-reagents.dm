/datum/reagent/gallium // Ga
	name = "Gallium"
	id = "gallium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#AA7DCE"

/datum/reagent/cesium
	name = "Cesium"
	id = "cesium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#95d975"

/datum/reagent/thorium
	name = "Thorium"
	id = "thorium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#aabaa2"

/datum/reagent/californium
	name = "Californium"
	id = "californium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#8ce2ff"

/datum/reagent/rellurium
	name = "Rellurium"
	id = "rellurium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#0b3645"

/datum/reagent/tantalum
	name = "Tantalum"
	id = "tantalum"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#3b0b45"

/datum/reagent/lithium
	name = "Lithium"
	id = "lithium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#6e4324"

/datum/reagent/morphite
	name = "Morphite"
	id = "morphite"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#807b4e"

/datum/reagent/iridium
	name = "iridium"
	id = "iridium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#45755a"

/datum/reagent/thaesium
	name = "thaesium"
	id = "thaesium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#455975"

/datum/reagent/selenium
	name = "Selenium"
	id = "selenium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#754557"

/datum/reagent/europium
	name = "Europium"
	id = "europium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#e3af74"

/datum/reagent/hassium
	name = "Hassium"
	id = "hassium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#3d3232"

/datum/reagent/lutetium
	name = "Lutetium"
	id = "lutetium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#FFC0CB"

/datum/reagent/lutetium/on_mob_life(var/mob/living/M as mob, var/alien)
	..()
	if(!istype(M))
		return
	if(!istype(M, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = M
	if(H.lust)
		H.lust -= 1

/datum/reagent/barium
	name = "Barium"
	id = "barium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#548c82"

/datum/reagent/technetium
	name = "Technetium"
	id = "technetium"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#2c5191"

/datum/reagent/technetium/on_mob_life(var/mob/living/M as mob, var/alien)
	..()
	if(!istype(M))
		return
	if(!istype(M, /mob/living/carbon/human))
		return
	var/mob/living/carbon/human/H = M

	if(H.reagents.has_reagent("dob"))
		holder.remove_reagent("dob", 1)

/datum/reagent/molybdenum
	name = "Molybdenum"
	id = "molybdenum"
	reagent_state = LIQUID
	metabolization_rate = 0.01
	color = "#2e174a"