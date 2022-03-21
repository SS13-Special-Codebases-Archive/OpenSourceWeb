var/const/VIRTUAL_ABILITY_NONE = 0
var/const/VIRTUAL_ABILITY_HEAR = 1
var/const/VIRTUAL_ABILITY_SEE  = 2
var/const/VIRTUAL_ABILITY_ALL  = (~VIRTUAL_ABILITY_NONE)

#define DEBUG
// Turf-only flags.
#define NOJAUNT 1 // This is used in literally one place, turf.dm, to block ethereal jaunt.

#define TRANSITIONEDGE 7 // Distance from edge to move to another z-level.

// Invisibility constants.
#define INVISIBILITY_LIGHTING    20
#define INVISIBILITY_LEVEL_ONE   35
#define INVISIBILITY_LEVEL_TWO   45
#define INVISIBILITY_OBSERVER    60
#define INVISIBILITY_EYE         61
#define INVISIBILITY_SYSTEM      99

#define SEE_INVISIBLE_LIVING     25
#define SEE_INVISIBLE_NOLIGHTING 15
#define SEE_INVISIBLE_LEVEL_ONE  INVISIBILITY_LEVEL_ONE
#define SEE_INVISIBLE_LEVEL_TWO  INVISIBILITY_LEVEL_TWO
#define SEE_INVISIBLE_CULT       INVISIBILITY_OBSERVER
#define SEE_INVISIBLE_OBSERVER   INVISIBILITY_EYE
#define SEE_INVISIBLE_SYSTEM     INVISIBILITY_SYSTEM

#define SEE_IN_DARK_DEFAULT 8

#define SEE_INVISIBLE_MINIMUM 5
#define INVISIBILITY_MAXIMUM 100

/datum/proc/get_client()
	return null

/client/proc/get_client()
	return src

/mob/get_client()
	return client

/mob/observer/virtual/get_client()
	return host.get_client()

/atom/movable/proc/recursive_move(var/atom/movable/am, var/old_loc, var/new_loc)
	moved_event.raise_event(src, old_loc, new_loc)

/atom/movable/proc/move_to_turf(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(T && T != loc)
		forceMove(T)

// Similar to above but we also follow into nullspace
/atom/movable/proc/move_to_turf_or_null(var/atom/movable/am, var/old_loc, var/new_loc)
	var/turf/T = get_turf(new_loc)
	if(T != loc)
		forceMove(T)

/atom/proc/recursive_dir_set(var/atom/a, var/old_dir, var/new_dir)
	set_dir(new_dir)

// Sometimes you just want to end yourself
/datum/proc/qdel_self()
	qdel(src)

/proc/register_all_movement(var/event_source, var/listener)
	moved_event.register(event_source, listener, /atom/movable/proc/recursive_move)
	dir_set_event.register(event_source, listener, /atom/proc/recursive_dir_set)

/proc/unregister_all_movement(var/event_source, var/listener)
	moved_event.unregister(event_source, listener, /atom/movable/proc/recursive_move)
	dir_set_event.unregister(event_source, listener, /atom/proc/recursive_dir_set)

//	Observer Pattern Implementation: Moved
//		Registration type: /atom/movable
//
//		Raised when: An /atom/movable instance has moved using Move() or forceMove().
//
//		Arguments that the called proc should expect:
//			/atom/movable/moving_instance: The instance that moved
//			/atom/old_loc: The loc before the move.
//			/atom/new_loc: The loc after the move.

var/decl/observ/moved/moved_event = new()

/decl/observ/moved
	name = "Moved"
	expected_type = /atom/movable

/decl/observ/moved/register(var/atom/movable/mover, var/datum/listener, var/proc_call)
	. = ..()

	// Listen to the parent if possible.
	if(. && istype(mover.loc, expected_type))
		register(mover.loc, mover, /atom/movable/proc/recursive_move)

/********************
* Movement Handling *
********************/

/atom/Entered(var/atom/movable/am, var/atom/old_loc)
	. = ..()
	if(am && old_loc)
		moved_event.raise_event(am, old_loc, am.loc)

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	. = ..()
	if(moved_event.has_listeners(am))
		moved_event.register(src, am, /atom/movable/proc/recursive_move)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	. = ..()
	moved_event.unregister(src, am, /atom/movable/proc/recursive_move)

// Entered() typically lifts the moved event, but in the case of null-space we'll have to handle it.
/atom/movable/Move()
	var/old_loc = loc
	. = ..()
	if(. && !loc)
		moved_event.raise_event(src, old_loc, null)

/atom/movable/forceMove(atom/destination)
	var/old_loc = loc
	. = ..()
	if(. && !loc)
		moved_event.raise_event(src, old_loc, null)

//	Observer Pattern Implementation: Direction Set
//		Registration type: /atom
//
//		Raised when: An /atom changes dir using the set_dir() proc.
//
//		Arguments that the called proc should expect:
//			/atom/dir_changer: The instance that changed direction
//			/old_dir: The dir before the change.
//			/new_dir: The dir after the change.

var/decl/observ/dir_set/dir_set_event = new()

/decl/observ/dir_set
	name = "Direction Set"
	expected_type = /atom

/decl/observ/dir_set/register(var/atom/dir_changer, var/datum/listener, var/proc_call)
	. = ..()

	// Listen to the parent if possible.
	if(. && istype(dir_changer.loc, /atom/movable))	// We don't care about registering to turfs.
		register(dir_changer.loc, dir_changer, /atom/proc/recursive_dir_set)

/*********************
* Direction Handling *
*********************/

/atom/set_dir()
	var/old_dir = dir
	. = ..()
	if(old_dir != dir)
		dir_set_event.raise_event(src, old_dir, dir)

/atom/movable/Entered(var/atom/movable/am, atom/old_loc)
	. = ..()
	if(dir_set_event.has_listeners(am))
		dir_set_event.register(src, am, /atom/proc/recursive_dir_set)

/atom/movable/Exited(var/atom/movable/am, atom/old_loc)
	. = ..()
	dir_set_event.unregister(src, am, /atom/proc/recursive_dir_set)

//	Observer Pattern Implementation: Sight Set
//		Registration type: /mob
//
//		Raised when: A mob's sight value changes.
//
//		Arguments that the called proc should expect:
//			/mob/sightee:  The mob that had its sight set
//			/old_sight: sight before the change
//			/new_sight: sight after the change
var/decl/observ/sight_set/sight_set_event = new()

/decl/observ/sight_set
	name = "Sight Set"
	expected_type = /mob

/*********************
* Sight Set Handling *
*********************/

/mob/proc/set_sight(var/new_sight)
	var/old_sight = sight
	if(old_sight != new_sight)
		sight = new_sight
		sight_set_event.raise_event(src, old_sight, new_sight)

//	Observer Pattern Implementation: See Invisible Set
//		Registration type: /mob
//
//		Raised when: A mob's see_invisible value changes.
//
//		Arguments that the called proc should expect:
//			/mob/sightee:  The mob that had its sight set
//			/old_see_invisible: see_invisible before the change
//			/new_see_invisible: see_invisible after the change
var/decl/observ/see_invisible_set/see_invisible_set_event = new()

/decl/observ/see_invisible_set
	name = "See Invisible Set"
	expected_type = /mob

/*****************************
* See Invisible Set Handling *
*****************************/

/mob/proc/set_see_invisible(var/new_see_invisible)
	var/old_see_invisible = see_invisible
	if(old_see_invisible != new_see_invisible)
		see_invisible = new_see_invisible
		see_invisible_set_event.raise_event(src, old_see_invisible, new_see_invisible)

//	Observer Pattern Implementation: See In Dark Set
//		Registration type: /mob
//
//		Raised when: A mob's see_in_dark value changes.
//
//		Arguments that the called proc should expect:
//			/mob/sightee:  The mob that had its see_in_dark set
//			/old_see_in_dark: see_in_dark before the change
//			/new_see_in_dark: see_in_dark after the change
var/decl/observ/see_in_dark_set/see_in_dark_set_event = new()

/decl/observ/see_in_dark_set
	name = "See In Dark Set"
	expected_type = /mob

/***************************
* See In Dark Set Handling *
***************************/

/mob/proc/set_see_in_dark(var/new_see_in_dark)
	var/old_see_in_dark = sight
	if(old_see_in_dark != new_see_in_dark)
		see_in_dark  = new_see_in_dark
		see_in_dark_set_event.raise_event(src, old_see_in_dark, new_see_in_dark)

//	Observer Pattern Implementation: Destroyed
//		Registration type: /datum
//
//		Raised when: A /datum instance is destroyed.
//
//		Arguments that the called proc should expect:
//			/datum/destroyed_instance: The instance that was destroyed.
var/decl/observ/destroyed/destroyed_event = new()

/decl/observ/destroyed
	name = "Destroyed"

/datum/Destroy()
	destroyed_event.raise_event(src)
	. = ..()
	cleanup_events(src)

/*
* Informs a given owner about objects entering relevant turfs.
* How to use:
* Supply:
*	* holder           - The atom which wish to be informed of entered turfs
*	* on_turf_entered  - The proc to call when a turf has been entered. The object which entered the turf is supplied.
*		NOTE: The holder itself will call this proc if its turf changes, even if it enters a turf that isn't seen.
*	* on_turfs_changed - The proc to call if the turfs being listened to have changed. The previous and new list of seen turfs is supplied.
*	* range            - The effective range of the proximity detector. Small values strongly recommended. Can be changed later by calling set_range()
*	* proximity_flags  - Various minor special cases, see the PROXIMITY_* flags below.
*	* proc_owner       - Optional. holder used if unset. The owner instance of the procs supplied above.
*
* Call register_turfs() to begin listening to relevant turfs.
* Call unregister_turfs() to stop listening. No argument is required.
*/

var/const/PROXIMITY_EXCLUDE_HOLDER_TURF = 1 // When acquiring turfs to monitor, excludes the turf the holder itself is currently in.

/datum/proximity_trigger
	var/atom/holder

	var/proc_owner
	var/on_turf_entered
	var/on_turfs_changed

	var/range_

	var/list/turfs_in_range
	var/list/seen_turfs_

	var/proximity_flags = 0

	var/decl/turf_selection/turf_selection

/datum/proximity_trigger/line
	turf_selection = /decl/turf_selection/line

/datum/proximity_trigger/square
	turf_selection = /decl/turf_selection/square

/datum/proximity_trigger/New(var/holder, var/on_turf_entered, var/on_turfs_changed, var/range = 2, var/proximity_flags = 0, var/proc_owner)
	..()

	if(!ispath(turf_selection, /decl/turf_selection))
		CRASH("Invalid turf selection type set: [turf_selection]")
	turf_selection = decls_repository.get_decl(turf_selection)

	src.holder = holder
	src.on_turf_entered = on_turf_entered
	src.on_turfs_changed = on_turfs_changed
	range_ = range
	src.proximity_flags = proximity_flags
	src.proc_owner = proc_owner || holder

	turfs_in_range = list()
	seen_turfs_ = list()

/datum/proximity_trigger/Destroy()
	unregister_turfs()

	on_turfs_changed = null
	on_turf_entered = null
	holder = null
	. = ..()

/datum/proximity_trigger/proc/is_active()
	return turfs_in_range.len

/datum/proximity_trigger/proc/set_range(var/new_range)
	if(range_ == new_range)
		return
	range_ = new_range
	if(is_active())
		register_turfs()

/datum/proximity_trigger/proc/register_turfs()
	if(ismovable(holder))
		moved_event.register(holder, src, /datum/proximity_trigger/proc/on_holder_moved)
	dir_set_event.register(holder, src, /datum/proximity_trigger/proc/register_turfs) // Changing direction might alter the relevant turfs

	var/list/new_turfs = acquire_relevant_turfs()
	if(listequal(turfs_in_range, new_turfs))
		return

	for(var/t in (turfs_in_range - new_turfs))
		opacity_set_event.unregister(t, src, /datum/proximity_trigger/proc/on_turf_visibility_changed)
	for(var/t in (new_turfs - turfs_in_range))
		opacity_set_event.register(t, src, /datum/proximity_trigger/proc/on_turf_visibility_changed)

	turfs_in_range = new_turfs
	on_turf_visibility_changed()

/datum/proximity_trigger/proc/unregister_turfs()
	if(ismovable(holder))
		moved_event.unregister(holder, src, /datum/proximity_trigger/proc/on_holder_moved)
	dir_set_event.unregister(holder, src, /datum/proximity_trigger/proc/register_turfs)

	for(var/t in turfs_in_range)
		opacity_set_event.unregister(t, src, /datum/proximity_trigger/proc/on_turf_visibility_changed)
	for(var/t in seen_turfs_)
		entered_event.unregister(t, src, /datum/proximity_trigger/proc/on_turf_entered)

	call(proc_owner, on_turfs_changed)(seen_turfs_.Copy(), list())

	turfs_in_range.Cut()
	seen_turfs_.Cut()

/datum/proximity_trigger/proc/on_turf_visibility_changed()
	var/list/new_seen_turfs_ = get_seen_turfs()
	if(listequal(seen_turfs_, new_seen_turfs_))
		return

	call(proc_owner, on_turfs_changed)(seen_turfs_.Copy(), new_seen_turfs_.Copy())

	for(var/t in (seen_turfs_ - new_seen_turfs_))
		entered_event.unregister(t, src, /datum/proximity_trigger/proc/on_turf_entered)
	for(var/t in (new_seen_turfs_ - seen_turfs_))
		entered_event.register(t, src, /datum/proximity_trigger/proc/on_turf_entered)

	seen_turfs_ = new_seen_turfs_

/datum/proximity_trigger/proc/on_holder_moved(var/holder, var/old_loc, var/new_loc)
	var/old_turf = get_turf(old_loc)
	var/new_turf = get_turf(new_loc)
	if(old_turf == new_turf)
		return
	call(proc_owner, on_turf_entered)(holder)
	register_turfs()

/datum/proximity_trigger/proc/on_turf_entered(var/turf/T, var/atom/enterer)
	if(enterer == holder) // We have an explicit call for holder, in case it moved somewhere we're not listening to.
		return
	if(enterer.opacity)
		on_turf_visibility_changed()
	call(proc_owner, on_turf_entered)(enterer)

/datum/proximity_trigger/proc/get_seen_turfs()
	. = list()
	var/turf/center = get_turf(holder)
	if(!center)
		return

	for(var/T in dview(range_, center))
		if(T in turfs_in_range)
			. += T

/datum/proximity_trigger/proc/acquire_relevant_turfs()
	. = turf_selection.get_turfs(holder, range_)
	if(proximity_flags & PROXIMITY_EXCLUDE_HOLDER_TURF)
		. -= get_turf(holder)


/obj/item/proxy_debug
	var/image/overlay
	var/proxy_type

/obj/item/proxy_debug/line
	proxy_type = /datum/proximity_trigger/line

/obj/item/proxy_debug/square
	proxy_type = /datum/proximity_trigger/square

/obj/item/proxy_debug/New()
	..()
	overlay = image('icons/misc/mark.dmi', icon_state = "x3")
	var/datum/proximity_trigger/a = new proxy_type(src, /obj/item/proxy_debug/proc/turf_entered, /obj/item/proxy_debug/proc/update_turfs)
	a.register_turfs()

/obj/item/proxy_debug/proc/turf_entered(var/atom/A)
	visible_message("[A] entered my range!")

/obj/item/proxy_debug/proc/update_turfs(var/list/old_turfs, var/list/new_turfs)
	for(var/turf/T in old_turfs)
		T.overlays -= overlay
	for(var/turf/T in new_turfs)
		T.overlays += overlay

/decl/turf_selection/proc/get_turfs(var/atom/origin, var/range)
	return list()

/decl/turf_selection/line/get_turfs(var/atom/origin, var/range)
	. = list()
	var/center = get_turf(origin)
	if(!center)
		return
	for(var/i = 0 to range)
		center = get_step(center, origin.dir)
		if(!center) // Reached the end of the world most likely
			return
		. += center

/decl/turf_selection/square/get_turfs(var/atom/origin, var/range)
	. = list()
	var/center = get_turf(origin)
	if(!center)
		return
	for(var/turf/T in trange(range, center))
		. += T

//	Observer Pattern Implementation: Entered
//		Registration type: /atom
//
//		Raised when: An /atom/movable instance has entered an atom.
//
//		Arguments that the called proc should expect:
//			/atom/entered: The atom that was entered
//			/atom/movable/enterer: The instance that entered the atom
//			/atom/old_loc: The atom the enterer came from
//

var/decl/observ/entered/entered_event = new()

/decl/observ/entered
	name = "Entered"
	expected_type = /atom

/*******************
* Entered Handling *
*******************/

/atom/Entered(atom/movable/enterer, atom/old_loc)
	..()
	entered_event.raise_event(src, enterer, old_loc)

var/list/global_listen_count = list()
var/list/event_sources_count = list()
var/list/event_listen_count = list()

/proc/cleanup_events(var/source)
	if(global_listen_count[source])
		cleanup_global_listener(source, global_listen_count[source])
	if(event_sources_count[source])
		cleanup_source_listeners(source, event_sources_count[source])
	if(event_listen_count[source])
		cleanup_event_listener(source, event_listen_count[source])

/decl/observ/register(var/datum/event_source, var/datum/listener, var/proc_call)
	. = ..()
	if(.)
		event_sources_count[event_source] += 1
		event_listen_count[listener] += 1

/decl/observ/unregister(var/datum/event_source, var/datum/listener, var/proc_call)
	. = ..()
	if(.)
		event_sources_count[event_source] -= 1
		event_listen_count[listener] -= 1

		if(event_sources_count[event_source] <= 0)
			event_sources_count -= event_source
		if(event_listen_count[listener] <= 0)
			event_listen_count -= listener

/decl/observ/register_global(var/datum/listener, var/proc_call)
	. = ..()
	if(.)
		global_listen_count[listener] += 1

/decl/observ/unregister_global(var/datum/listener, var/proc_call)
	. = ..()
	if(.)
		global_listen_count[listener] -= 1
		if(global_listen_count[listener] <= 0)
			global_listen_count -= listener

/proc/cleanup_global_listener(listener, listen_count)
	global_listen_count -= listener
	for(var/entry in all_observable_events.events)
		var/decl/observ/event = entry
		if(event.unregister_global(listener))
			log_debug("[event] - [listener] was deleted while still registered to global events.")
			if(!(--listen_count))
				return

/proc/cleanup_source_listeners(event_source, source_listener_count)
	event_sources_count -= event_source
	for(var/entry in all_observable_events.events)
		var/decl/observ/event = entry
		var/proc_owners = event.event_sources[event_source]
		if(proc_owners)
			for(var/proc_owner in proc_owners)
				if(event.unregister(event_source, proc_owner))
					log_debug("[event] - [event_source] was deleted while still being listened to by [proc_owner].")
					if(!(--source_listener_count))
						return

/proc/cleanup_event_listener(listener, listener_count)
	event_listen_count -= listener
	for(var/entry in all_observable_events.events)
		var/decl/observ/event = entry
		for(var/event_source in event.event_sources)
			if(event.unregister(event_source, listener))
				log_debug("[event] - [listener] was deleted while still listening to [event_source].")
				if(!(--listener_count))
					return

/var/repository/decls/decls_repository = new()

/repository/decls
	var/list/fetched_decls
	var/list/fetched_decl_types
	var/list/fetched_decl_subtypes

/repository/decls/New()
	..()
	fetched_decls = list()
	fetched_decl_types = list()
	fetched_decl_subtypes = list()

/repository/decls/proc/decls_of_type(var/decl_prototype)
	. = fetched_decl_types[decl_prototype]
	if(!.)
		. = get_decls(typesof(decl_prototype))
		fetched_decl_types[decl_prototype] = .

/repository/decls/proc/decls_of_subtype(var/decl_prototype)
	. = fetched_decl_subtypes[decl_prototype]
	if(!.)
		. = get_decls(subtypesof(decl_prototype))
		fetched_decl_subtypes[decl_prototype] = .

/repository/decls/proc/get_decl(var/decl_type)
	. = fetched_decls[decl_type]
	if(!.)
		. = new decl_type()
		fetched_decls[decl_type] = .

/repository/decls/proc/get_decls(var/list/decl_types)
	. = list()
	for(var/decl_type in decl_types)
		.[decl_type] =  get_decl(decl_type)

/decls/Destroy()
	crash_with("Prevented attempt to delete a decl instance: [(src)]")
	return QDEL_HINT_LETMELIVE // Prevents Decl destruction


var/repository/unique/uniqueness_repository = new()

/repository/unique
	var/list/generators

/repository/unique/New()
	..()
	generators = list()

/repository/unique/proc/Generate()
	var/generator_type = args[1]
	var/datum/uniqueness_generator/generator = generators[generator_type]
	if(!generator)
		generator = new generator_type()
		generators[generator_type] = generator
	var/list/generator_args = args.Copy() // Cannot cut args directly, BYOND complains about it being readonly.
	generator_args -= generator_type
	return generator.Generate(arglist(generator_args))

/datum/uniqueness_generator/proc/Generate()
	return

/datum/uniqueness_generator/id_sequential
	var/list/ids_by_key

/datum/uniqueness_generator/id_sequential/New()
	..()
	ids_by_key = list()

/datum/uniqueness_generator/id_sequential/Generate(var/key, var/default_id = 100)
	var/id = ids_by_key[key]
	if(id)
		id++
	else
		id = default_id

	ids_by_key[key] = id
	. = id

/datum/uniqueness_generator/id_random
	var/list/ids_by_key

/datum/uniqueness_generator/id_random/New()
	..()
	ids_by_key = list()

/datum/uniqueness_generator/id_random/Generate(var/key, var/min, var/max)
	var/list/ids = ids_by_key[key]
	if(!ids)
		ids = list()
		ids_by_key[key] = ids

	if(ids.len >= (max - min) + 1)
		error("Random ID limit reached for key [key].")
		ids.Cut()

	if(ids.len >= 0.6 * ((max-min) + 1)) // if more than 60% of possible ids used
		. = list()
		for(var/i = min to max)
			if(i in ids)
				continue
			. += i
		var/id = pick(.)
		ids += id
		return id
	else
		do
			. = rand(min, max)
		while(. in ids)
		ids += .
