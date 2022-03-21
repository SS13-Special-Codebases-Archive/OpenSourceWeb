/mob
	var/doubleVisioned = 0
	var/blurred = 0


/mob/proc/CU(var/firstVal = -15, var/secondVal = 15, var/firstSpeed = 14, var/secondSpeed = 14)
	set waitfor = 0
	if(!client) return
	if(doubleVisioned) return

	var/tmp/obj/render_controller/R1 = new
	R1.alpha = 128
	R1.render_source = "all"
	R1.plane = 4

	var/tmp/obj/render_controller/R2 = new
	R2.alpha = 65
	R2.render_source = "all"
	R2.plane = 5

	var/tmp/obj/render_controller/R3 = new
	R3.alpha = 78
	R3.render_source = "mob"
	R3.plane = 11

	var/tmp/obj/render_controller/R4 = new
	R4.alpha = 110
	R4.render_source = "mob"
	R4.plane = 12

	var/tmp/obj/render_controller/R5 = new
	R5.alpha = 90
	R5.render_source = "all2"
	R5.plane = 16

	var/tmp/obj/render_controller/R6 = new
	R6.alpha = 115
	R6.render_source = "all2"
	R6.plane = 17

	var/tmp/obj/render_controller/R7 = new
	R7.alpha = 90
	R7.render_source = "all3"
	R7.plane = 19

	var/tmp/obj/render_controller/R8 = new
	R8.alpha = 115
	R8.render_source = "all3"
	R8.plane = 20

	var/tmp/obj/render_controller/R9 = new
	R9.alpha = 90
	R9.render_source = "all4"
	R9.plane = 22

	var/tmp/obj/render_controller/R10 = new
	R10.alpha = 115
	R10.render_source = "all4"
	R10.plane = 23

	var/tmp/obj/render_controller/R11 = new
	R9.alpha = 90
	R9.render_source = "all5"
	R9.plane = 24

	var/tmp/obj/render_controller/R12 = new
	R10.alpha = 115
	R10.render_source = "all5"
	R10.plane = 25

	src.client.screen.Add(R1)
	src.client.screen.Add(R2)
	src.client.screen.Add(R3)
	src.client.screen.Add(R4)
	src.client.screen.Add(R5)
	src.client.screen.Add(R6)
	src.client.screen.Add(R7)
	src.client.screen.Add(R8)
	src.client.screen.Add(R9)
	src.client.screen.Add(R10)
	src.client.screen.Add(R11)
	src.client.screen.Add(R12)

	var/list/SCV = list(rand(firstVal, secondVal), rand(firstVal, secondVal))
	var/matrix/MR1 = matrix()
	var/matrix/MR2 = matrix()
	var/matrix/MR3 = matrix()
	var/matrix/MR4 = matrix()
	var/matrix/MR5 = matrix()
	var/matrix/MR6 = matrix()
	var/matrix/MR7 = matrix()
	var/matrix/MR8 = matrix()
	var/matrix/MR9 = matrix()
	var/matrix/MR10 = matrix()
	var/matrix/MR11 = matrix()
	var/matrix/MR12 = matrix()

	var/list/SClist = list(SCV[1], SCV[2])
	var/list/SC2list = list((-1 * SCV[1]), (-1 * SCV[2]))
	doubleVisioned = 1
	animate(R1, transform = MR1.Translate(SC2list[1], SC2list[2]), time = firstSpeed, easing = ELASTIC_EASING, flags = ANIMATION_PARALLEL)
	animate(R2, transform = MR2.Translate(SClist[1], SClist[2]), time = firstSpeed, easing = ELASTIC_EASING, flags = ANIMATION_PARALLEL)
	animate(R3, transform = MR3.Translate(SC2list[1], SC2list[2]), time = firstSpeed, easing = ELASTIC_EASING, flags = ANIMATION_PARALLEL)
	animate(R4, transform = MR4.Translate(SClist[1], SClist[2]), time = firstSpeed, easing = ELASTIC_EASING, flags = ANIMATION_PARALLEL)
	animate(R5, transform = MR5.Translate(SC2list[1], SC2list[2]), time = firstSpeed, easing = ELASTIC_EASING, flags = ANIMATION_PARALLEL)
	animate(R6, transform = MR6.Translate(SClist[1], SClist[2]), time = firstSpeed, easing = ELASTIC_EASING, flags = ANIMATION_PARALLEL)

	animate(R7, transform = MR7.Translate(SC2list[1], SC2list[2]), time = firstSpeed, easing = ELASTIC_EASING, flags = ANIMATION_PARALLEL)
	animate(R8, transform = MR8.Translate(SClist[1], SClist[2]), time = firstSpeed, easing = ELASTIC_EASING, flags = ANIMATION_PARALLEL)
	animate(R9, transform = MR9.Translate(SC2list[1], SC2list[2]), time = firstSpeed, easing = ELASTIC_EASING, flags = ANIMATION_PARALLEL)
	animate(R10, transform = MR10.Translate(SClist[1], SClist[2]), time = firstSpeed, easing = ELASTIC_EASING, flags = ANIMATION_PARALLEL)
	animate(R11, transform = MR11.Translate(SClist[1], SClist[2]), time = firstSpeed, easing = ELASTIC_EASING, flags = ANIMATION_PARALLEL)
	animate(R12, transform = MR12.Translate(SClist[1], SClist[2]), time = firstSpeed, easing = ELASTIC_EASING, flags = ANIMATION_PARALLEL)
	sleep(firstSpeed)
	animate(R1, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R2, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R3, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R4, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R5, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R6, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R7, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R8, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R9, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R10, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R11, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	animate(R12, transform = null, time = secondSpeed, easing = BACK_EASING, flags = ANIMATION_PARALLEL)
	sleep(secondSpeed)

    //remove
	client.screen.Remove(R1)
	client.screen.Remove(R2)
	client.screen.Remove(R3)
	client.screen.Remove(R4)
	client.screen.Remove(R5)
	client.screen.Remove(R6)
	client.screen.Remove(R7)
	client.screen.Remove(R8)
	client.screen.Remove(R9)
	client.screen.Remove(R10)
	client.screen.Remove(R11)
	client.screen.Remove(R12)
	doubleVisioned = 0
/*
/mob/proc/CU(var/firstVal = -15, var/secondVal = 15, var/firstSpeed = 14, var/secondSpeed = 14)
	//fazer ser obrigatorio???
	. = ..()

	if(!client) return

	//COISOS TO SCREEN
	blurred = 1
	var/tmp/obj/render_controller/SC2 = new
	src?.client?.screen.Add(SC2)
	SC2.alpha = 128

	var/tmp/obj/render_controller/SC3 = new
	client.screen.Add(SC3)
	SC3.alpha = 65
	SC3.plane = 12


	var/tmp/obj/render_controller/luz/L1 = new
	var/tmp/obj/render_controller/luz/L2 = new
	L1.alpha = 65
	L2.alpha = 128
	L2.plane = 17
	client.screen.Add(L1)
	client.screen.Add(L2)

	var/list/SCV = list(rand(firstVal, secondVal), rand(firstVal, secondVal))

    //efeito
	var/matrix/ML2 = matrix()
	var/matrix/M2 = matrix()
	var/matrix/M3 = matrix()

	var/list/SClist = list(SCV[1], SCV[2])
	var/list/SC2list = list((-1 * SCV[1]), (-1 * SCV[2]))

	animate(L2, transform = ML2.Translate(SC2list[1], SC2list[2]), time = firstSpeed, easing = QUAD_EASING, flags = ANIMATION_PARALLEL)
	animate(SC2, transform = M2.Translate(SClist[1], SClist[2]), time = firstSpeed, easing = QUAD_EASING, flags = ANIMATION_PARALLEL)
	animate(SC3, transform = M3.Translate(SC2list[1], SC2list[2]), time = firstSpeed, easing = QUAD_EASING, flags = ANIMATION_PARALLEL)
	sleep(firstSpeed)
	animate(L2, transform = null, time = secondSpeed, easing = QUAD_EASING, flags = ANIMATION_PARALLEL)
	animate(SC2, transform = null, time = secondSpeed, easing = QUAD_EASING, flags = ANIMATION_PARALLEL)
	animate(SC3, transform = null, time = secondSpeed, easing = QUAD_EASING, flags = ANIMATION_PARALLEL)
	sleep(secondSpeed)

    //remove
	client.screen.Remove(SC2)
	client.screen.Remove(SC3)
	client.screen.Remove(L1)
	client.screen.Remove(L2)
	blurred = 0
*/
/mob/proc/CU2(var/number = 10)
	if(!client) return
	for(var/x = 0, x <= number, x++)
		CU()