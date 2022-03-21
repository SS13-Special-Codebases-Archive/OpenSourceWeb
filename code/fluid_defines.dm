#define MINIMUM_VALUE_TO_PROCCESS 5
#define ENOUGH_DEPTH 10
#define WATER_COLOR "#d4f1f9"
#define BLOOD_COLOR "#c80000"
#define FLUID_UPDATE_DELAY_ATOMS 15
//#define MAPTEXTDEBUG 1

/turf/simulated
	var/obj/reagent/liquid = null
/atom/movable
	var/last_water_state = null

var/list/ReagentsToUpdate = list()