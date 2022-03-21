/datum/controller/process/machinery/setup()
	name = "machinery"
	schedule_interval = 20 // every 2 seconds
	start_delay = 12

/datum/controller/process/machinery/doWork()
	process_machines()

/var/global/machinery_sort_required = 0

/datum/controller/process/machinery/proc/process_machines()
	process_machines_sort()
	process_machines_process()
	process_machines_power()
	process_machines_rebuild()

/datum/controller/process/machinery/proc/process_machines_sort()
	if(machinery_sort_required)
		machinery_sort_required = 0
		machines = dd_sortedObjectList(machines)

/datum/controller/process/machinery/proc/process_machines_process()
	var/i = 1
	while(i<=machines.len)
		var/obj/machinery/Machine = machines[i]
		if(Machine)
			if(Machine.process() != PROCESS_KILL)
				if(Machine)
					i++
					continue
		machines.Cut(i,i+1)

/datum/controller/process/machinery/proc/process_machines_power()
	var/i=1
	while(i<=active_areas.len)
		var/area/A = active_areas[i]
		if(A.powerupdate && A.master == A)
			A.powerupdate -= 1
			A.clear_usage()
			for(var/j = 1; j <= A.related.len; j++)
				var/area/SubArea = A.related[j]
				for(var/obj/machinery/M in SubArea)
					if(M)
						//check if the area has power for M's channel
						//this will keep stat updated in case the machine is moved from one area to another.
						M.power_change(A)	//we've already made sure A is a master area, above.

						if(!(M.stat & NOPOWER) && M.use_power)
							M.auto_use_power()

		if(A.apc.len && A.master == A)
			i++
			continue

		A.powerupdate = 0
		active_areas.Cut(i,i+1)
/datum/controller/process/machinery/proc/process_machines_rebuild()
	if(controller_iteration % 150 == 0)	//Every 300 seconds we retest every area/machine
		for(var/area/A in all_areas)
			if(A == A.master)
				A.powerupdate += 1
				active_areas |= A