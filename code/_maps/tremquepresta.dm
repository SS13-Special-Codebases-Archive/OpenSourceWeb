var/list/trainparts = list()
var/list/inquisitrainparts = list()

/area/dunwell/train
    name = "trainbody"
    forced_ambience = list('sound/lfwbambimusic/atrementous-city.ogg', 'sound/lfwbambimusic/curvedblade.ogg', 'sound/lfwbambimusic/dustareallherbeauties.ogg', 'sound/fwambi/ravenheart7.ogg', 'sound/fwambi/happy_temple.ogg', 'sound/fwambi/many_torches.ogg')


/area/dunwell/trainpath
    name = "trainpath"
    forced_ambience = list('sound/lfwbambimusic/atrementous-city.ogg', 'sound/lfwbambimusic/curvedblade.ogg', 'sound/lfwbambimusic/dustareallherbeauties.ogg', 'sound/fwambi/ravenheart7.ogg', 'sound/fwambi/happy_temple.ogg', 'sound/fwambi/many_torches.ogg')


/area/dunwell/trainpathInquisition
    name = "trainpathInquisition"
    forced_ambience = list('sound/lfwbambimusic/atrementous-city.ogg', 'sound/lfwbambimusic/curvedblade.ogg', 'sound/lfwbambimusic/dustareallherbeauties.ogg', 'sound/fwambi/ravenheart7.ogg', 'sound/fwambi/happy_temple.ogg', 'sound/fwambi/many_torches.ogg')

/turf/simulated/train/rail
    icon = 'train.dmi'
    icon_state = "1,3"

/obj/structure/grille/reinforced/bars/notreact
    name = "barras de metal"
    desc = "Um monte de pedaços de ferro presos ao chão."
    icon_state = "bars"
    icon_destroyed = "barsbroken"
    throwpass = 1
    layer = MOB_LAYER+1
    dire = SOUTH

/obj/train
    name = "train"
    icon = 'icons/turf/train.dmi'
    icon_state = "floor"
    density = 0
    opacity = 0
    layer = 2
    anchored = 1

/obj/train/New()
	..()
	var/turf/T = get_turf(src)
	var/area/A = get_area(T)
	if(istype(A, /area/dunwell/trainpathInquisition))
		inquisitrainparts += src
	else
		trainparts += src

/obj/train/Destroy()
	trainparts -= src
	inquisitrainparts -= src
	return ..()

/obj/train/floorlifeweb
	icon = 'icons/life/floorsold.dmi'

/obj/train/wall/charon
	icon = 'icons/turf/walls.dmi'

/obj/train/wall
    icon_state = "1"
    density = 1
    opacity = 1
    layer = 2

/obj/train/wall/b
    icon_state = "2"
/obj/train/wall/c
    icon_state = "3"

/obj/proc/trainMove(var/dirr = 5, var/shouldPlay = 0)
    var/turf/T = get_step(src, dirr)
    if(!T)
        return

    if(T?.density)
        qdel(src)
        return
    if(density)
        for(var/mob/M in T.contents)
            var/turf/Turfe = get_step(M, dirr)
            var/protegido = 0
            for(var/obj/O in Turfe.contents)
                if(istype(O, /obj/train))
                    protegido = 1
                    break
            if(!protegido)
                M.gib()
    var/list/atomList = list()
    for(var/atom/movable/M in loc?.contents)
        if(istype(M,/obj/train))
            continue
        if(istype(M, /atom/movable/lighting_overlay) || M.type == /atom/movable/overlay)
            continue
        atomList += M

    x = T.x
    z = T.z
    y = T.y

    spawn(0)
        for(var/atom/movable/M in atomList)
            M.x = T.x
            M.y = T.y
            M.z = T.z
            M.update_light()
            M.glide_size = 0
            if(ismob(M))
                var/mob/MOB = M
                if(shouldPlay == 1)
                    MOB << sound('sound/lfwbsounds/train_loop.ogg', repeat=1, wait=1, channel=18, volume=70)
                if(shouldPlay == 2)
                    MOB << sound(null, channel=18, volume=0)