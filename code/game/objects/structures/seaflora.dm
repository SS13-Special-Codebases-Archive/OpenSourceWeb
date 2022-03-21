/obj/structure/lifeweb/mushroom/hydra
	name = "hydra"
	icon_state = "hydra"

/obj/structure/lifeweb/mushroom/hydraempty
	name = "hydra"
	icon_state = "hydra_empty"

/obj/structure/rack/lwtable/stone/searock5
	icon_state = "searock5"

/obj/structure/rack/lwtable/stone/searock
	icon_state = "searock"

/obj/structure/rack/lwtable/stone/searock2
	icon_state = "searock2"
/obj/structure/rack/lwtable/stone/searock3
	icon_state = "searock3"

/obj/structure/lifeweb/grass/algae
	name = "algae"
	icon_state = "algae"
	icon = 'icons/mining.dmi'

/obj/structure/lifeweb/grass/algae/New()
	..()
	icon_state = "algae[rand(1,2)]"