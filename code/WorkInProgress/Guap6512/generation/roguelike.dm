//#define DEBUG

var/list/mobs = list()
proc
	mapGen()
		for(var/atom/A in world)
			if(A.z == 7)
				if(istype(A,/turf))
					var/turf/T = A
					T.ChangeTurf(/turf/simulated/wall)
				else
					qdel(A)
		var/turf/simulated/wall/D = locate(rand(6,world.maxx-5),rand(6,world.maxy-5),7)
		new /structure/hallway( D, 0, rand(8,20), 25 ) //Start the map generation.
		new /obj/multiz/ladder(D) //Place the stairs.
		new /node(D) //So the stairs aren't always at the end of a hallway.
		return 1


	//sblock is a proc that I use instead of block when I'm not sure which turf is
	//the bottom-left and which one is the top-right, which is required for block.
	sblock(turf/A,turf/B,turf/C,turf/D)
		var/turf/Y
		var/turf/Z
		if(!A || !B)
			return null
		if(!C || !D)
			Y = BL(A,B)
			Z = TR(A,B)
		else
			Y = BL(A,B,C,D)
			Z = TR(A,B,C,D)
		return block(Y,Z)

	//Self-explanatory.
	get_steps(var/atom/loc,var/dir,var/num)
		if(num == 0) return loc
		return get_steps( get_step(loc,dir), dir, num-1)

	//Same as get_steps, but returns a location datum, instead of a turf location.
	get_stepsloc(var/atom/loc,var/dir,var/num)
		var/location/L = new(turf=loc)
		L.shift(dir,num)
		return L

	//Same as get_steps, only takes a location datum as an argument, and not an atom.
	get_stepsFromLoc(var/location/L,var/dir,var/num)
		var/location/A = new(L.x,L.y,L.z)
		A.shift(dir,num)
		return A

	//Bottom left corner of 4 corners of a rectangle, or the rectangle formed by 2
	//corners, if only 2 are provided.
	BL(var/turf/A,var/turf/B,var/turf/C,var/turf/D)
		var/turf/T
		if(!C || !D)
			T = locate(min(A.x,B.x),min(A.y,B.y),min(A.z,B.z))
		else
			T = locate(min(A.x,B.x,C.x,D.x),min(A.y,B.y,C.y,D.y),min(A.z,B.z,C.z,D.z))
		return T

	//Same as BL, but returns the top-right corner, not the bottom-left.
	TR(var/turf/A,var/turf/B,var/turf/C,var/turf/D)
		var/turf/T
		if(!C || !D)
			T = locate(max(A.x,B.x),max(A.y,B.y),max(A.z,B.z))
		else
			T = locate(max(A.x,B.x,C.x,D.x),max(A.y,B.y,C.y,D.y),max(A.z,B.z,C.z,D.z))
		return T

	//Returns a list of turfs that are the border of a rectangle formed by the two turfs.
	bord(var/turf/A,var/turf/B)
		var/list/turfs = list()
		for(var/x = A.x, x <= B.x, x++)
			turfs += locate(x,A.y,A.z)
			turfs += locate(x,B.y,A.z)
		for(var/y = A.y, y <= B.y, y++)
			turfs += locate(A.x,y,A.z)
			turfs += locate(B.x,y,A.z)
		return turfs

	//Creates a list of certain types from another list.
	typesInList(var/T,var/list/L)
		var/list/N = list()
		for(var/V in L)
			if(istype(V,T))
				N += V
		return N

	//Cardinal orange.  The turfs to the NORTH, SOUTH, EAST, and WEST.
	corange(var/atom/A,var/N)
		var/list/L = list()
		for(var/i in list(NORTH,SOUTH,EAST,WEST))
			for(var/X = 1, X <= N, X++)
				L += get_steps(A,i,X)
		return L
/*
turf
	floor
		text = " "
		upStairs
			text = "<"
		downStairs
			text = ">"
		//Stairs are a subtype of floor so that they won't be paved over by rooms/hallways.
	wall
		density = 1
		opacity = 1
		text = "#"
	door
		opacity = 1
		text = "+"

obj
	locobj //For testing purposes only.
		text = "O"

mob
	Player
		text = "@"
		Login()
			world << "<b>[src] logs in.</b>"
			sleep(5)
			loc = locate(/obj/multiz/ladder)
			mobs += src
			Map()
		Logout()
			world << "<b>[src] logs out.</b>"
			mobs -= src
			qdel(src)
		verb
			Map()
				var/text = "<TT><font face=Terminal size=1>"
				for(var/Y = world.maxy, Y >= 1, Y--)
					for(var/X = 1, X <= world.maxx, X++)
						var/turf/T = locate(X,Y,src.z)
						if(T.text == " ")
							text += "&nbsp"
						else
							text += T.text
					text += "<BR>"
				text += "</font></TT>"
				src << browse(text)
			say(msg as text)
				world << "<B>[usr]:</B> [html_encode(copytext(msg,1,500))]"
*/
structure
	hallway
		New(var/turf/loc,var/dir,var/length,var/prob)
			. = ..()
			var/iters = 1
			if(dir == 0) //If 0 is passed as the dir argument, pick one randomly.  Otherwise, use the provided dir.
				dir = 1
				iters = 4
			var/initdir = dir //Keep the initial dir value.
			var/list/poss[][] = new() //a list of the lists of possible turfs.
			var/list/turfs = list()
			for(var/i = 0, i < iters, i++)
				dir = initdir << i
				var/turf/end = get_steps(loc,dir,length)
				if(!end)
					continue
				turfs = sblock(loc,end) //Using sblock, because it's so much cooler.
				var/list/Z = sblock( get_step( turfs[2],turn(dir,90) ), get_step( turfs[turfs.len], turn(dir,-45) ) )
				//Weird stuff... the above is simply creating a block of turfs to check for intersections with other
				//floor tiles, in which case there hallway can't be placed there.  This excludes the first tile
				//(turfs[1]), and the tiles next to / behind it, so it doesn't get caught up on the node it was
				//created from.
				if(Z)
					if(!locate(/turf/simulated/floor/plating) in Z)
						poss += list(turfs)
			var/list/nodes = list()
			//Creates a list of turfs to place nodes on, so that the hallway can complete it's creation before other
			//hallways/rooms crowd it in.
			if(poss.len)
				var/list/L = pick(poss) //Picks the list of turfs for the hallway.
				for(var/i = 2, i < L.len, i++)
					var/turf/simulated/floor/plating/F = new(L[i])
					if(prob(prob))
						nodes += F
				var/turf/end = new /turf/simulated/floor/plating(L[L.len])
				if(istype(loc,/turf/simulated/wall))
					loc = new /turf/simulated/floor/plating(loc)
					new /obj/machinery/door/unpowered/shuttle/(loc)
				if(prob > -1)
					new /node(end,src) //Create a node at the end of it (unless if prob is -1, in which case no nodes
					//are to be created on the hallway at all, as opposed to being limited to only the node at the end,
					//as it would be if 0 was passed in.
				for(var/turf/T in nodes)
					new /node(T)
			else
				qdel(src)

	rectroom
		New(var/turf/A,var/dim1,var/dim2,var/prob)
			. = ..()
			var/list/Possible = list()
			var/list/possDoors = list()
			for(var/D in list(NORTH,SOUTH,EAST,WEST))
				var/turf/B
				if(istype(A,/turf/simulated/floor/plating))
					B = get_step(A,D)
				else
					B = A

				if( istype( get_step(B,D), /turf/simulated/floor/plating ) ) continue //Since 1 in 4 directions will have the turf it was
				//created from on it, and sometimes more when in a congested area, it pays to make this quick check.

				var/location/M1 = get_stepsloc(B, turn( D, -90 ), 1)
				var/location/M2 = get_stepsloc(B, turn( D, 90 ), dim1)
				var/location/M3 = get_stepsFromLoc(M1, D, dim2+1)
				var/location/M4 = get_stepsFromLoc(M2, D, dim2+1)
				//These four location datums are the 4 corners of the rectroom in it's initial position.  The location
				//datum is used as they must be shifted reliably, even if they are off the map.
				while(M2.loc() != B)
					if(M1.valid && M2.valid && M3.valid && M4.valid) //Checks to make sure they aren't off the map.
						var/floor = 0
						for(var/turf/T in sblock( M1.loc() , M2.loc() , M3.loc() , M4.loc() ) )
							if(istype(T,/turf/simulated/floor/plating))
								floor = 1
								break
						//Loop checks for floor tiles in the possible area.
						if(!floor)
							Possible += new /rect( BL( M1.loc() , M2.loc() , M3.loc() , M4.loc() ), TR( M1.loc() , M2.loc() , M3.loc() , M4.loc() ) )
							possDoors += B
					M1.shift( turn( D, -90 ), 1 )
					M2.shift( turn( D, -90 ), 1 )
					M3.shift( turn( D, -90 ), 1 )
					M4.shift( turn( D, -90 ), 1 )
					//Shift all the locations one tile.
			if(!Possible.len)
				qdel(src)
				//If there's no way it can fit, oh well, we tried.  It would be possible to simply try again with a
				//new size, but that would severely affect the speed of the map generation.
			var/Z = rand(1, Possible.len)
			var/rect/R = Possible[Z]
			var/list/walls = bord(R.BL,R.TR)
			//Picks a random workable positioning, and creates a list of walls for placing nodes on.
			for(var/turf/T in block(R.BL,R.TR)-walls)
				T = new /turf/simulated/floor/plating(T)
			//new /turf/door(possDoors[Z])
			new /turf/simulated/floor/plating(possDoors[Z])
			new /obj/machinery/door/unpowered/shuttle/(possDoors[Z])
			var/list/possWalls = list()
			for(var/turf/V in walls)
				var/list/T = typesInList(/turf/simulated/floor/plating,corange(V,1))
				if(T.len == 1)
					possWalls += V
				else if(T.len == 2)
					if(prob(prob))
						new /turf/simulated/floor/plating(possDoors[Z])
						new /obj/machinery/door/unpowered/shuttle/(possDoors[Z])
			//The above loop creates a list of possible node locations.  If there is a door possibility
			//(floors bordering on two sides), there is a chance a door will be placed instead.
			if(possWalls.len)
				for(var/turf/F in possWalls)
					if(prob(prob))
						new /node(F,src)
			//Then, finally, create the nodes.


node
	var/structure/owner
	var/turf/loc
	New(var/L, var/O)
		. = ..()
		loc = L
		owner = O
		switch(rand(1,2))
			if(1)
				var/structure/S = new /structure/rectroom(loc, roll("2d6") , roll("2d6"), 10)
				if(!S)
					S = new /structure/hallway(loc, 0, rand(8,20), 10)
					if(!S)
						if(prob(50))
							new /structure/hallway(loc, 0, rand(8,20), 10)
			if(2)
				var/structure/S = new /structure/hallway(loc, 0, rand(8,20), 10)
				if(!S)
					S = new /structure/hallway(loc, 0, rand(8,20), 10)
					if(!S)
						if(prob(50))
							new /structure/rectroom(loc, roll("2d6") , roll("2d6"), 10)
		//The switch basically chooses between a hallway and a rectroom.  If either fails, they will
		//be null, and thus there is a 50% chance of the other type being created instead.

//The rect object is simply a handy way for me to access the turfs inside / around a rectangle.
rect
	var/turf/BL
	var/turf/TR
	New(var/turf/A,var/turf/B)
		BL = A
		TR = B
	proc/inRect()
		return block(BL,TR)-bord(BL,TR)
	proc/Rect()
		return block(BL,TR)
	proc/Border()
		return bord(BL,TR)

//The location object is a handy little object that aids me in the rectroom creation.  Basically,
//it's a locate() value that I can shift around and stuff, even when it's off the map, which makes
//it ideal for situations where I need to shift it around, even when it's off the map.
location
	var/valid = 0
	var/x
	var/y
	var/z
	New(X,Y,Z,var/turf/turf)
		if(turf)
			x = turf.x
			y = turf.y
			z = turf.z
		else if(X != null && Y != null && Z != null)
			x = X
			y = Y
			z = Z
		if(!x || !y || !z)
			valid = 0
	proc
		loc()
			return locate(x,y,z)
		shift(var/D,var/N)
			switch(D)
				if(NORTH)
					y += N
				if(SOUTH)
					y -= N
				if(EAST)
					x += N
				if(WEST)
					x -= N
				//I don't know if there was a better way to do this.  I don't care.
			setValid()
		setValid() //Proc that will set the valid variable to the right value.
			valid = 1
			if(x < 1 || y < 1 || z < 1 || x > world.maxx || y > world.maxy || z > world.maxz)
				valid = 0

//There.  I'd hope you enjoyed reading that more than I enjoyed running teeth-first into a table
//on a bike when I was a kid, but I don't want to disappoint myself.