// Pooler subsystem. This is the process we will use to pool async jobs for completion and call a proc when they do eventually complete.

// I suck at program design and thus this should be considered rudimentary at best -- whatever /tg/ had in 2014 is still better than this.
#define poll json_decode(call("ByondSharpNE", "PollJobs")())["Data"]
#define get_async_result(options) json_decode(call("ByondSharpNE", "GetResult")(options))["Data"]

var/global/datum/controller/Pooler/Pooler = new


/datum/controller/Pooler
	var/list/job_ids
	var/list/procs_to_fire
	var/callback

/datum/controller/Pooler/New()
	job_ids = list()
	procs_to_fire = list()

/datum/controller/Pooler/proc/DoWork()
	for(var/id in job_ids) // iterate through all the pending async jobs
		if(job_ids[id][1] in params2list(poll)) // if we catch a finished job
			if(job_ids[id][2]) // if there's a proc owner
				call(job_ids[id][2], id)(get_async_result(job_ids[id][1])) // make the callback with the result
				job_ids -= id // remove the job from the pending jobs list
			else // if not, call the proc as if it was a global
				call(id)(get_async_result(job_ids[id][1]))
				job_ids -= id
	for(var/procs in procs_to_fire) // iterate through all the pending async procs whose result we don't give a shit about
		call("ByondSharpNE", procs)(procs_to_fire[procs]) // call the proc, don't bother storing the job ids for pooling
		procs_to_fire -= procs // we have called it, get rid of it so we don't call it again

/datum/controller/Pooler/proc/Enqueue(var/proc/callback, var/async_proc as text, var/arguments, var/proc_owner)
	var/id = json_decode(call("ByondSharpNE", async_proc)(arguments))["Data"]
	job_ids[callback] = list(id, proc_owner) // lists inside lists make my head hurt but god i don't think theres a better solution for it

/proc/async_call(var/callback, var/async_proc, var/list/arguments, var/proc_owner, var/ff) // global proc to make async calls. don't use for synchronous calls
	if(arguments.len > 1)
		if(!ff)
			Pooler.Enqueue(callback, async_proc, list2params(arguments), proc_owner)
		else
			Pooler.FireAndForget(async_proc, list2params(arguments))
	else
		if(!ff)
			Pooler.Enqueue(callback, async_proc, arguments[1], proc_owner)
		else
			Pooler.FireAndForget(async_proc, arguments[1])

/datum/controller/Pooler/proc/FireAndForget(var/async_proc, var/arguments)  //for when we don't care about the result
	procs_to_fire[async_proc] = arguments