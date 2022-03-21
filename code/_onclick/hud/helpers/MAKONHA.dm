#define UNSETEMPTY(L) if (L && !length(L)) L = null
/mob/living/carbon/human/var
	enmaconhado = 0

/proc/loop_conha(var/obj/A, var/intensity = 30, var/_x = 1.35)
	set waitfor = 0
	for(var/x = 0, x <= intensity, x++)
		screen_loop_conha(A, _x)
		sleep(27)

/proc/screen_loop_conha(var/obj/A, var/_x = 1.35)
	set waitfor = 0
	var/matrix/M = matrix()
	var/matrix/M2 = matrix()
	animate(A, transform = M.Turn(0.6), time = 9)
	sleep(9)
	animate(A, transform = M2.Turn(-0.6), time = 9)
	sleep(9)
	animate(A, transform = null, time = 9)
	sleep(9)

/proc/screen_loop_maconha(var/filter, var/_x = 1.35, var/mob/MOB)
	set waitfor = 0
	if(!filter) return
	for(var/i;i<=67;i++)
		animate(filter, size=2.5, time=10)
		sleep(10)
		animate(filter, size=1, time=2)
		sleep(2)
		if(i == 68)
			for(var/obj/ripple_controller/R in MOB?.client?.screen)
				var/filterA = R.get_filter("negors")
				animate(filterA, size=0, time=10)
				del(R) //just to be ssure it will disappear

/obj/ripple_controller
	appearance_flags = PLANE_MASTER
	plane = 10
	screen_loc = "CENTER"
	render_source = "all"
	mouse_opacity = 0

/mob/living/carbon/human/proc/MAKONHA_DOIDO_DOIDO_DOIDO_DOIDO_DOIDO_MAKONHA()
	set waitfor = 0

	src << 'sound/music/hishmaliin.ogg'


	for(var/obj/I in client?.usingPlanes)
		loop_conha(I)

	for(var/obj/I in client?.usingPlanes)
		var/obj/ripple_controller/R = new
		client.screen.Add(R)
		R.plane = I.plane+11
		R.render_source = I.render_target
		R.add_filter("negors", 1, list("type"="angular_blur"))
		var/filter = R.get_filter("negors")
		screen_loop_maconha(filter, MOB = src)
/proc/cmp_filter_data_priority(list/A, list/B)
	return A["priority"] - B["priority"]

/atom/proc/add_filter(name,priority,list/params)
	LAZYINITLIST(filter_data)
	var/list/p = params.Copy()
	p["priority"] = priority
	filter_data[name] = p
	update_filters()

/atom/proc/remove_filter(name_or_names)
	if(!filter_data)
		return

	var/list/names = islist(name_or_names) ? name_or_names : list(name_or_names)

	for(var/name in names)
		if(filter_data[name])
			filter_data -= name
	update_filters()

/atom/proc/update_filters()
	filters = null
	filter_data = sortTim(filter_data, /proc/cmp_filter_data_priority, TRUE)
	for(var/f in filter_data)
		var/list/data = filter_data[f]
		var/list/arguments = data.Copy()
		arguments -= "priority"
		filters += filter(arglist(arguments))
	UNSETEMPTY(filter_data)

/atom/proc/get_filter(name)
	if(filter_data && filter_data[name])
		return filters[filter_data.Find(name)]