/datum/controller/process/pooler/setup()
	name = "pooler"
	schedule_interval = 1 // pooler needs to run each tick
	start_delay = 1 // it should not be delayed either -- i'm setting this to 1 in the hopes that it gets fixed, if it doesn't, i'll just have to remove the process and call DoWork from somewhere else
	if(!Pooler)
		Pooler = new

/datum/controller/process/pooler/doWork()
	Pooler.DoWork()