/datum/controller/process/lighting/setup()
	name = "lighting"
	schedule_interval = 5 // every second
	start_delay = 22

/datum/controller/process/lighting/doWork()
	lighting_controller.process()