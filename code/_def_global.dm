//See controllers/globals.dm
#define GLOBAL_MANAGED(X, InitValue)\
/datum/controller/global_vars/proc/InitGlobal##X(){\
	##X = ##InitValue;\
	gvars_datum_init_order += #X;\
}
#define GLOBAL_UNMANAGED(X, InitValue) /datum/controller/global_vars/proc/InitGlobal##X()

#ifndef TESTING
#define GLOBAL_PROTECT(X)\
/datum/controller/global_vars/InitGlobal##X(){\
	..();\
	gvars_datum_protected_varlist += #X;\
}
#else
#define GLOBAL_PROTECT(X)
#endif

#define GLOBAL_REAL_VAR(X) var/global/##X
#define GLOBAL_REAL(X, Typepath) var/global##Typepath/##X

#define GLOBAL_RAW(X) /datum/controller/global_vars/var/global##X

#define GLOBAL_VAR_INIT(X, InitValue) GLOBAL_RAW(/##X); GLOBAL_MANAGED(X, InitValue)

#define GLOBAL_VAR_CONST(X, InitValue) GLOBAL_RAW(/const/##X) = InitValue; GLOBAL_UNMANAGED(X, InitValue)

#define GLOBAL_LIST_INIT(X, InitValue) GLOBAL_RAW(/list/##X); GLOBAL_MANAGED(X, InitValue)

#define GLOBAL_LIST_EMPTY(X) GLOBAL_LIST_INIT(X, list())

#define GLOBAL_DATUM_INIT(X, Typepath, InitValue) GLOBAL_RAW(Typepath/##X); GLOBAL_MANAGED(X, InitValue)

#define GLOBAL_VAR(X) GLOBAL_RAW(/##X); GLOBAL_MANAGED(X, null)

#define GLOBAL_LIST(X) GLOBAL_RAW(/list/##X); GLOBAL_MANAGED(X, null)

#define GLOBAL_DATUM(X, Typepath) GLOBAL_RAW(Typepath/##X); GLOBAL_MANAGED(X, null)

#define GLOBAL_PROC "some_magic_bullshit"

#define INVOKE_ASYNC world.ImmediateInvokeAsync

//defines that give qdel hints. these can be given as a return in destory() or by calling

#define QDEL_HINT_QUEUE 		0 //qdel should queue the object for deletion.
#define QDEL_HINT_LETMELIVE		1 //qdel should let the object live after calling destory.
#define QDEL_HINT_IWILLGC		2 //functionally the same as the above. qdel should assume the object will gc on its own, and not check it.
#define QDEL_HINT_HARDDEL_NOW	4 //qdel should assume this object won't gc, and hard del it post haste.
#define QDEL_HINT_PUTINPOOL		5 //qdel will put this object in the atom pool.
#define QDEL_HINT_FINDREFERENCE	6 //functionally identical to QDEL_HINT_QUEUE if TESTING is not enabled in _compiler_options.dm.
								  //if TESTING is enabled, qdel will call this object's find_references() verb.

/world/proc/ImmediateInvokeAsync(thingtocall, proctocall, ...)
	set waitfor = FALSE

	if (!thingtocall)
		return

	var/list/calling_arguments = length(args) > 2 ? args.Copy(3) : null

	if (thingtocall == GLOBAL_PROC)
		call(proctocall)(arglist(calling_arguments))
	else
		call(thingtocall, proctocall)(arglist(calling_arguments))

#define isvirtualmob(A) istype(A, /mob/observer/virtual)
#define listequal(A, B) (A.len == B.len && !length(A^B))

/proc/trange(rad = 0, turf/centre = null) //alternative to range (ONLY processes turfs and thus less intensive)
	if(!centre)
		return

	var/turf/x1y1 = locate(((centre.x-rad)<1 ? 1 : centre.x-rad),((centre.y-rad)<1 ? 1 : centre.y-rad),centre.z)
	var/turf/x2y2 = locate(((centre.x+rad)>world.maxx ? world.maxx : centre.x+rad),((centre.y+rad)>world.maxy ? world.maxy : centre.y+rad),centre.z)
	return block(x1y1,x2y2)

#define TimeOfGame (get_game_time())
#define TimeOfTick (world.tick_usage*0.01*world.tick_lag)
/proc/get_game_time()
	var/global/time_offset = 0
	var/global/last_time = 0
	var/global/last_usage = 0

	var/wtime = world.time
	var/wusage = world.tick_usage * 0.01

	if(last_time < wtime && last_usage > 1)
		time_offset += last_usage - 1

	last_time = wtime
	last_usage = wusage

	return wtime + (time_offset + wusage) * world.tick_lag

/datum/stack
	var/list/stack
	var/max_elements = 0

/datum/stack/New(list/elements, max)
	..()
	stack = elements ? elements.Copy() : list()
	if(max)
		max_elements = max

/datum/stack/Destroy()
	Clear()
	. = ..()

/datum/stack/proc/Pop()
	if(is_empty())
		return null
	. = stack[stack.len]
	stack.Cut(stack.len,0)

/datum/stack/proc/Push(element)
	if(max_elements && (stack.len+1 > max_elements))
		return null
	stack += element

/datum/stack/proc/Top()
	if(is_empty())
		return null
	. = stack[stack.len]

/datum/stack/proc/Remove(element)
	stack -= element

/datum/stack/proc/is_empty()
	. = stack.len ? 0 : 1

//Rotate entire stack left with the leftmost looping around to the right
/datum/stack/proc/RotateLeft()
	if(is_empty())
		return 0
	. = stack[1]
	stack.Cut(1,2)
	Push(.)

//Rotate entire stack to the right with the rightmost looping around to the left
/datum/stack/proc/RotateRight()
	if(is_empty())
		return 0
	. = stack[stack.len]
	stack.Cut(stack.len,0)
	stack.Insert(1,.)


/datum/stack/proc/Copy()
	var/datum/stack/S=new()
	S.stack = stack.Copy()
	S.max_elements = max_elements
	return S

/datum/stack/proc/Clear()
	stack.Cut()

/datum/stack/proc/QdelClear()
	for(var/entry in stack)
		qdel(entry)
	stack.Cut()

// Process status defines
#define PROCESS_STATUS_IDLE 1
#define PROCESS_STATUS_QUEUED 2
#define PROCESS_STATUS_RUNNING 3
#define PROCESS_STATUS_MAYBE_HUNG 4
#define PROCESS_STATUS_PROBABLY_HUNG 5
#define PROCESS_STATUS_HUNG 6

// Process time thresholds
#define PROCESS_DEFAULT_HANG_WARNING_TIME 	300 // 30 seconds
#define PROCESS_DEFAULT_HANG_ALERT_TIME 	600 // 60 seconds
#define PROCESS_DEFAULT_HANG_RESTART_TIME 	900 // 90 seconds
#define PROCESS_DEFAULT_SCHEDULE_INTERVAL 	50  // 50 ticks
#define PROCESS_DEFAULT_SLEEP_INTERVAL		2	// 2 ticks
#define PROCESS_DEFAULT_CPU_THRESHOLD		90  // 90%

// SCHECK macros
// This references src directly to work around a weird bug with try/catch
#define SCHECK_EVERY(this_many_calls) if(++src.calls_since_last_scheck >= this_many_calls) sleepCheck()
#define SCHECK SCHECK_EVERY(50)