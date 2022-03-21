/datum/controller/process/ticker/setup()
	name = "ticker"
	schedule_interval = 20 // every 2 seconds
	start_delay = 24

/datum/controller/process/ticker/doWork()
	ticker.process()