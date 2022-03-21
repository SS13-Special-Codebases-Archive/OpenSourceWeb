/obj/item/weapon/storage/touchable //Made to ignore depth in some procs (code\_onclick\item_attack.dm) proc/storage_depth(atom/container)
	name = "touchable"
	max_w_class = 3

/obj/item/weapon/storage/touchable/organ
	name = "organ storage"
	var/mob/living/carbon/human/owner

/obj/item/weapon/storage/touchable/organ/New()
	..()
	if(ishuman(loc))
		owner = loc

/obj/item/weapon/storage/touchable/organ/Destroy()
	owner.organ_storage = null
	owner = null
	qdel(boxes)
	qdel(closer)
	for(var/obj/item/I in src.contents)
		src.contents -= I
		qdel(I)
	loc = null
	return ..()

/obj/item/weapon/storage/touchable/crate
	storage_slots = 10
	max_w_class = 10
	max_combined_w_class = 1000

/obj/item/weapon/storage/touchable/crate/Destroy()
	qdel(boxes)
	qdel(closer)
	for(var/obj/item/I in src.contents)
		src.contents -= I
		qdel(I)
	loc = null
	return ..()
