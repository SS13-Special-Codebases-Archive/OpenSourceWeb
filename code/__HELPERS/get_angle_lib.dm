proc
	get_dir_angle(atom/a,atom/b)
		var/d
		var/n=get_angle(a,b)
		if(n>=337.5 || n<=22.5) d=EAST
		if(n>=22.5 && n<=67.5) d=SOUTHEAST
		if(n>=67.5 && n<=112.5) d=SOUTH
		if(n>=112.5 && n<=157.5) d=SOUTHWEST
		if(n>=157.5 && n<=202.5) d=WEST
		if(n>=202.5 && n<=247.5) d=NORTHWEST
		if(n>=247.5 && n<=292.5) d=NORTH
		if(n>=292.5 && n<337.5) d=NORTHEAST
		return d

	get_dir_angle4(atom/a,atom/b)
		var/d
		var/n=get_angle(a,b)
		if(n>=315 || n<=45) d=EAST
		if(n>=45 && n<=135) d=SOUTH
		if(n>=135 && n<=225) d=WEST
		if(n>=225 && n<=315) d=NORTH
		return d

	get_angle(a,b,c,d)
		if(!a && !b && !c && !d) CRASH("No arguments given or arguments are null")
		if(isnum(a) && isnum(c)) return get_angle_nums(a,b,c,d)
		if(!isnum(a))
			if(!isnum(b))
				var/list/a_pos=get_pix_pos(a)
				var/list/b_pos=get_pix_pos(b)
				return get_angle_nums(a_pos[1],a_pos[2],b_pos[1],b_pos[2])
			else
				var/list/a_pos=get_pix_pos(a)
				return get_angle_nums(a_pos[1],a_pos[2],b,c)
		else if(!isnum(c))
			var/list/c_pos=get_pix_pos(c)
			return get_angle_nums(a,b,c_pos[1],c_pos[2])

	get_angle_nums(ax,ay,bx,by)
		var/val = sqrt((bx - ax) * (bx - ax) + (by - ay) * (by - ay))
		if(!val) return 0
		var/ar = arccos((bx - ax) / val)
		var/deg = round(360 - (by - ay >= 0 ? ar : -ar), 1)
		while(deg > 360) deg -= 360
		while(deg < 0) deg += 360
		return deg

	get_pix_pos(atom/a)
		var/xstep=0
		var/ystep=0
		if(ismob(a))
			var/mob/m=a
			xstep=m.step_x
			ystep=m.step_y
		return list(a.x*world.icon_size+xstep,a.y*world.icon_size+ystep)
