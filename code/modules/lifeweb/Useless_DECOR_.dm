/*******************************
*****BASICAMENTE ISSO AQUI******
*****SERVE PRA PORRA NENHUMA****
********************************
*********************************/

/obj/machinery/lifeweb
	flammable = 0

/obj/machinery/lifeweb/pillar
	name = "lifeweb machinery"
	icon = 'icons/obj/LW2Pillar.dmi'
	icon_state = "1"
	desc = ""
	density = 1
	anchored = 1

/obj/machinery/lifeweb/pillar/left
	name = "left pillar"

/obj/machinery/lifeweb/pillar/right
	name = "right pillar"

/obj/machinery/lifeweb/decor
	name = "lifeweb machinery"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "decor"
	desc = ""
	density = 1
	anchored = 1

/obj/machinery/lifeweb/ladder
	name = "lifeweb stairs"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "ladder"
	desc = ""
	density = 0
	anchored = 1

/obj/machinery/lifeweb/bath
	name = "lifeweb blood pool"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "lifeweb-bath"
	desc = ""
	density = 1
	anchored = 1

/obj/machinery/lifeweb/altarR
	name = "lifeweb altar"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "altarR"
	desc = ""
	density = 1
	anchored = 1

/obj/machinery/lifeweb/altarL
	name = "lifeweb altar"
	icon = 'icons/obj/LW2.dmi'
	icon_state = "altarL"
	desc = ""
	density = 1
	anchored = 1

/*******************************
LUZ E OUTRAS MERDA TIPO OS VARIOS ICONES DA WEB
*********************************/


/obj/machinery/lifeweb/altarR/New()
	set_light(2, 2, 2.8, 1, "#eb0515")
	..()

/obj/machinery/lifeweb/decor/New()
	..()

/obj/machinery/lifeweb/altarL/New()
	set_light(2, 2, 2.8, 1, "#eb0515")
	..()