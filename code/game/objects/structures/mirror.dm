/obj/structure/mirror
	name = "mirror"
	desc = "Mirror mirror on the wall, who's the most robust of them all?"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mirror"
	density = 0
	anchored = 1
	var/shattered = 0
	var/obj/reflection/refracao = null
	vis_flags = VIS_HIDE
	plane = 21

/obj/structure/mirror/New()
    ..()
    refracao = new(loc)
    refracao.setup_visuals(src)

/obj/reflection
    name = "reflection"
    appearance_flags = KEEP_TOGETHER|TILE_BOUND|PIXEL_SCALE
    layer = 20
    var/alpha_icon = 'icons/obj/watercloset.dmi'
    var/alpha_icon_state = "mirror_mask"
    var/obj/structure/mirror/mirror
    vis_flags = VIS_HIDE
    mouse_opacity = 0
    plane = 21

/obj/reflection/proc/setup_visuals(target)
    mirror = target
    if(mirror.pixel_x > 0)
        dir = WEST
    else if (mirror.pixel_x < 0)
        dir = EAST
    if(mirror.pixel_y > 0)
        dir = SOUTH
    else if (mirror.pixel_y < 0)
        dir = NORTH
    pixel_x = mirror.pixel_x
    pixel_y = mirror.pixel_y
    spawn(10)
        update_mirror_filters()

/obj/reflection/proc/update_mirror_filters()
    filters = null
    vis_contents = null
    if(!mirror)
        return
    var/matrix/M = matrix()
    var/y_offset = 0
    if(dir == WEST || dir == EAST)
        M.Scale(-1, 1)
    else if(dir == SOUTH|| dir == NORTH)
        M.Scale(1, -1)
        y_offset = 0
        mirror.dir = NORTH
    color = list(1,0,0,0,
                 0,1,0,0,
                 0,0,1,0,
                 0,0,0,1,
                 0.3125,0.3125,0.3125,0)
    transform = M
    alpha = 192
    filters += filter("type" = "alpha", "icon" = icon(alpha_icon, alpha_icon_state), "x" = 0, "y" = y_offset)
    vis_contents += mirror.loc

/obj/structure/mirror/south
	pixel_y = -32

/obj/structure/mirror/north
	pixel_y = 32

/obj/structure/mirror/east
	pixel_x = 32

/obj/structure/mirror/west
	pixel_x = -32

/obj/structure/mirror/examine(mob/living/carbon/human/user)
	if(is_dreamer(user))
		var/frase = null
		frase = "You realize that the face reflecting in the mirror is not yours. Who are you?"
		to_chat(usr, "<div class='firstdivexamine'><div class='box'><span class='statustext'>This is a [src.blood_DNA ? "bloody " : ""][icon2html(src, usr)]</span> <span class='uppertext'>[src.name].</span>\n<span class='statustext'>[frase]</span>\n<hr class='linexd'></div></div>")

/obj/structure/mirror/attack_hand(mob/user as mob)
	if(shattered)	return

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.a_intent == "hurt")
			if(shattered)
				playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
				return
			if(prob(30) || H.species.can_shred(H))
				user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
				shatter()
			else
				user.visible_message("<span class='danger'>[user] hits [src] and bounces off!</span>")
			return
		else
			to_chat(H, "You look like you've been dead for a week.")


/obj/structure/mirror/proc/shatter()
	if(shattered)	return
	shattered = 1
	icon_state = "mirror_broke"
	playsound(src, "shatter", 70, 1)
	desc = "Oh no, seven years of bad luck!"
	refracao.icon_state = "mirror_maskbroken"
	refracao.update_mirror_filters()

/obj/structure/mirror/bullet_act(var/obj/item/projectile/Proj)
	if(prob(Proj.damage * 2))
		if(!shattered)
			shatter()
		else
			playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
	..()


/obj/structure/mirror/attackby(obj/item/I as obj, mob/user as mob)
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return

	if(prob(I.force * 2))
		visible_message("<span class='warning'>[user] smashes [src] with [I]!</span>")
		shatter()
	else
		visible_message("<span class='warning'>[user] hits [src] with [I]!</span>")
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 70, 1)

/obj/structure/mirror/attack_animal(mob/user as mob)
	if(!isanimal(user)) return
	var/mob/living/simple_animal/M = user
	if(M.melee_damage_upper <= 0) return
	if(shattered)
		playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, 1)
		return
	user.visible_message("<span class='danger'>[user] smashes [src]!</span>")
	shatter()