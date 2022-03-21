///////////////////////////
/// THUX LOCKPICKINGTM ////
//PAU NO CU DA FORJA !!!!//
///FAZ MELHOR PODRICAO1 ///
///////////////////////////

//SOM
var/list/lockpicking_sounds = list('ui_lockpicking_pickmovement_01.ogg','ui_lockpicking_pickmovement_02.ogg','ui_lockpicking_pickmovement_03.ogg','ui_lockpicking_pickmovement_04.ogg')
var/lockpick_break_sound = 'lockpick_break.ogg'
//INTERFACE
/obj/screen/lockpicking
	icon = 'icons/misc/lockpicking.dmi'
	icon_state = ""
	screen_loc = "CENTER,CENTER"
	plane = 30
	mouse_opacity = 0

/obj/screen/lockpicking/base
	icon_state = "lock"
	var/obj/screen/left = null
	var/obj/screen/right = null
	var/obj/screen/forceit = null
	var/obj/screen/push = null
	var/obj/screen/pin = null
	var/obj/item/weapon/lockpick = null
	var/obj/structure/lockpickable = null
	var/mob/living/M = null
	New()
		var/obj/screen/lockpicking/interact/left/L = new ()
		var/obj/screen/lockpicking/interact/right/R = new ()
		var/obj/screen/lockpicking/interact/force/F = new ()
		var/obj/screen/lockpicking/interact/push/P = new ()
		var/obj/screen/lockpicking/pin/PIN = new ()
		L.base = src
		R.base = src
		F.base = src
		P.base = src
		L.pin = PIN
		R.pin = PIN
		F.pin = PIN
		P.pin = PIN
		PIN.base = src
		left = L
		right = R
		forceit = F
		push = P
		pin = PIN

/obj/screen/lockpicking/base/Destroy()
	if(left && right && forceit && push && pin && M && lockpick && lockpickable)
		M.client.screen -= src
		M.client.screen -= left
		M.client.screen -= right
		M.client.screen -= forceit
		M.client.screen -= push
		M.client.screen -= pin
		qdel(left)
		qdel(right)
		qdel(forceit)
		qdel(push)
		qdel(pin)
		lockpickable.lockpicking = FALSE
		qdel(lockpick)
		qdel(src)
		return
	else
		return


/obj/screen/lockpicking/base/proc/DestroyFAKE()
	if(left && right && forceit && push && pin && M && lockpick && lockpickable)
		M.client.screen -= src
		M.client.screen -= left
		M.client.screen -= right
		M.client.screen -= forceit
		M.client.screen -= push
		M.client.screen -= pin
		qdel(left)
		qdel(right)
		qdel(forceit)
		qdel(push)
		qdel(pin)
		lockpickable.lockpicking = FALSE
		qdel(src)
		return
	else
		return


/obj/screen/lockpicking/pin
	name = "Pin"
	mouse_opacity = 1
	icon_state = "pick"
	var/obj/screen/base = null
	var/correct_dir

/obj/screen/lockpicking/pin/New()
	correct_dir = pick(NORTH, NORTHEAST, EAST, SOUTHEAST, SOUTH,  SOUTHWEST, WEST)

/obj/screen/lockpicking/interact
	name = "INTERACT"
	mouse_opacity = 1
	icon_state = ""
	var/obj/screen/base = null
	var/obj/screen/lockpicking/pin/pin = null

/obj/screen/lockpicking/interact/left
	name = "Turn Left"
	icon_state = "left"

/obj/screen/lockpicking/interact/left/Click()
	if(prob(50))
		usr.visible_message("<span class='passive'><b>[usr]</b> tries to lockpick.")
		playsound(usr.loc, pick(lockpicking_sounds), 50, 0, 1)
	pin.dir = turn(pin.dir, -45)

/obj/screen/lockpicking/interact/right
	name = "Turn Right"
	icon_state = "right"

/obj/screen/lockpicking/interact/right/Click()
	if(prob(50))
		usr.visible_message("<span class='passive'><b>[usr]</b> tries to lockpick.")
		playsound(usr.loc, pick(lockpicking_sounds), 50, 0, 1)
	pin.dir = turn(pin.dir, 45)


/obj/screen/lockpicking/interact/force
	name = "Force it Open"
	icon_state = "force"

/obj/screen/lockpicking/interact/force/Click()
	playsound(usr.loc, pick(lockpicking_sounds), 70, 0, 1)
	to_chat(usr, "<span class='jogtowalk'><i>You push the lockpick in the keyhole.</i></span>")
	var/succ_chance = 0
	var/mob/living/carbon/human/H = usr
	if(H.my_skills.GET_SKILL(SKILL_LOCK) < 1)
		succ_chance = (H.my_stats.pr+H.my_stats.it) + rand(0,5)
	else
		succ_chance = (((H.my_stats.pr+H.my_stats.it) * H.my_skills.GET_SKILL(SKILL_LOCK)) / 2) + 5
	succ_chance += H.my_stats.dx / 2
	// PR + IT * Lockpicking skill dividido por 2, bonus extra de DX dividida por 2
	if(pin.dir == pin.correct_dir && prob(succ_chance))
		to_chat(usr, "<span class='jogtowalk'><i>The lock makes a little click noise...</span>")
		if(do_after(usr, 10))
			to_chat(usr, "<span class='passive'>You managed to lockpick.</span>")
	else
		to_chat(usr, "<span class='combat'>You broke the lockpick!</span>")
		playsound(usr.loc, lockpick_break_sound, 75, 0, 1)
		H.lockpickingObj.LockBASEs.Destroy()

/obj/screen/lockpicking/interact/push
	name = "Push the lockpick"
	icon_state = "push"


/obj/screen/lockpicking/interact/push/Click()
	playsound(usr.loc, pick(lockpicking_sounds), 70, 0, 1)
	to_chat(usr, "<span class='jogtowalk'><i>You weakly push the lockpick in the keyhole.</i></span>")
	var/succ_chance = 0
	var/failchance = 75
	var/mob/living/carbon/human/H = usr
	if(H.my_skills.GET_SKILL(SKILL_LOCK) < 1)
		succ_chance = (H.my_stats.pr+H.my_stats.it) + rand(0,5)
	else
		succ_chance = (((H.my_stats.pr+H.my_stats.it) * H.my_skills.GET_SKILL(SKILL_LOCK)) / 2) + 5
	succ_chance += H.my_stats.dx / 2
	failchance -= succ_chance
	// PR + IT * Lockpicking skill dividido por 2, bonus extra de DX dividida por 2
	if(pin.dir == pin.correct_dir)
		to_chat(usr, "<span class='jogtowalk'><i>The lock makes a little click noise.</i> [succ_chance]% chance of success.</span>")
	else
		if(prob(failchance))
			to_chat(usr, "<span class='combat'>You broke the lockpick!</span>")
			playsound(usr.loc, lockpick_break_sound, 75, 0, 1)
			H.lockpickingObj.LockBASEs.Destroy()


///////////
///ITEMS///
///////////

/obj/item/weapon/lockpick
	name = "lockpick"
	icon = 'icons/obj/items.dmi'
	icon_state = "lockpick"
	flags = FPRINT | TABLEPASS| CONDUCT
	force = 7.0
	w_class = 1.0
	throwforce = 5.0
	throw_speed = 3
	throw_range = 5

///////////
///OBJS////
///////////
/obj/structure/var/lockpicking = FALSE
/obj/structure/var/obj/screen/lockpicking/base/LockBASEs = null

/obj/structure/closet/crate/lockpickable
	name = "chest"
	desc = "A rectangular wooden chest."
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
	var/locked = 1


/obj/structure/closet/crate/lockpickable/can_open()
	if(!locked)
		return 1
	else
		return 0


/obj/structure/closet/crate/lockpickable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/lockpick) && !lockpicking)
		do_lockpicking(user, W)
	else
		..()

/obj/structure/closet/crate/lockpickable/proc/do_lockpicking(var/mob/living/carbon/human/H, var/obj/item/weapon/lockpick/W)
	lockpicking = TRUE
	to_chat(H, "<span class='jogtowalk'><i>You attempt to lockpick \the [src].</i></span>")
	var/obj/screen/lockpicking/base/BASE = new ()
	if(!H.client.screen.Find(BASE))
		H.client.screen += BASE
		H.client.screen += BASE.left
		H.client.screen += BASE.right
		H.client.screen += BASE.forceit
		H.client.screen += BASE.push
		H.client.screen += BASE.pin
		BASE.lockpickable = src
		BASE.lockpick = W
		BASE.M = H
		H.lockpickingObj = src
		LockBASEs = BASE

///////////
///MOBS////
///////////
/mob/living/carbon/human/var/obj/structure/lockpickingObj = null