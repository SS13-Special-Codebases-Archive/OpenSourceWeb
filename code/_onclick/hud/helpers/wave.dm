mob/proc/water(var/wavecount=1, var/intensity=0.5, var/delay=100, var/effectDrug=0)
	if(src.client)
		if(effectDrug)
			filters = filter(type="color",color=list(1,0,0, 0,1.2,0, 0,0,1, 0,0,0),space=FILTER_COLOR_HSL)

		for(var/obj/i in client?.usingPlanes)
			i.WaterEffect(wavecount, intensity)
		sleep(delay)
		for(var/obj/i in client?.usingPlanes)
			i.remove_filter("AS1")
		filters = null

atom/proc/WaterEffect(var/wavecount, var/intensity)

    var/X,Y,rsq,i,f
    for(i=1, i<=wavecount, ++i)
        // choose a wave with a random direction and a period between 10 and 30 pixels
        do
            X = 60*rand() - 30
            Y = 60*rand() - 30
            rsq = X*X + Y*Y
        while(rsq<100 || rsq>900)   // keep trying if we don't like the numbers
        // keep distortion (size) small, from 0.5 to 3 pixels
        // choose a random phase (offset)
        filters += filter(type="wave", x=X, y=Y, size=intensity, offset=rand())
        add_filter("AS1", 1, list("type" = "wave", x=X, y=Y, size=intensity, offset=rand()))
    for(i=1, i<=wavecount, ++i)
        // animate phase of each wave from its original phase to phase-1 and then reset;
        // this moves the wave forward in the X,Y direction
        var/phi = get_filter("AS1")
        animate(phi, offset=f:offset, time=0, loop=-1, flags=ANIMATION_PARALLEL)
        animate(offset=f:offset-1, time=rand()*20+10)