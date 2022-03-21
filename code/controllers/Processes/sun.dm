/datum/controller/process/sun/setup()
	name = "sun"
	schedule_interval = 20 // every second
	start_delay = 22
	sun = new

/datum/controller/process/sun/doWork()
	sun.calc_position()
