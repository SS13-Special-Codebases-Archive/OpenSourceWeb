/obj/item/weapon
	name = "weapon"
	icon = 'icons/obj/weapons.dmi'
	var/poop_covering = 0
	var/drawsound = null // quando tu pega a arma
	var/reloadsound = null // quando tu recarrega a arma
	var/unloadsound = null //quando tu descarrega a arma

	var/sheathicon = null //se tem sheathicon da pra dar sheat entao deixa null seu negro // P RA ESPADA

	var/sheathiconknife = null // :antagonist:

	var/sheathicondagger = null // :antagonist:
	var/embedicon =  null // POOPENSHARDEN, ARMA PRESA
	var/embed = FALSE
	var/weapon_type = null
	can_improv = TRUE
	hitsound = "hitsound"

/obj/item
	var/swing_sound = "swing"

/obj/item/weapon/Bump(mob/M as mob)
	spawn(0)
		..()
	return

/obj/item/weapon/pickup(mob/user, var/togglesound)
	user.setClickCooldown(DEFAULT_QUICK_COOLDOWN)
	if(togglesound)
		drawsound(user)

/obj/item/weapon/proc/drawsound(mob/user)
	if(drawsound)
		user.visible_message("<span class='combatbold'>[user]</span> <span class='combat'>grabs a weapon.</span>")
		playsound(user, drawsound, 50, 1)

/obj/item/weapon/Destroy()
	. = ..()