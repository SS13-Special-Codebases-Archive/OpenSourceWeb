var/global/energyInvestimento = 0
var/global/list/medal_nominated = list()

/obj/structure/stool/bed/chair/ThroneMid
	name = "Baron's Throne"
	desc = "A magnificent throne."
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "center"
	anchored = 1
	flammable = 0
	var/captured = FALSE

/obj/structure/stool/bed/chair/ThroneMid/proc/baron_ui(var/mob/user as mob)
	var/dat = {"<META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'><TITLE>The Dragon Throne</TITLE></META>
<style type='text/css'>
body {font-family: PTSANS; cursor: url('pointer.cur'), auto;padding:20px;
background-color: #060606;overflow:hidden;
}

.thronelink
{font-size:110%;font-family: 'Cond';
background:transparent;color:#666;
}
.thronelink.second
{
color:#898;
}
.thronelinks
{text-decoration:none;
text-decoration:none;outline: none;border: none;
}
.thronelink:hover
{
text-decoration:none;
text-shadow: 0px 0px 25px #ffffff;color:#ffffff;
background:transparent;
line-height:120%;
}
#thronecom
{
width: 100%;
height: 100%;
text-align:center;
background-color: #0e0e0e;
}
</style>
<body background ext=#533333 alink=#777777 vlink=#777777 link=#777777>

<style type='text/css'>
	@font-face {font-family: Gothic;src: url(gothic.ttf);}
	@font-face {font-family: Book;src: url(book.ttf);}
	@font-face {font-family: Hando;src: url(hando.ttf);}

	@font-face {font-family: Eris;src: url(eris.otf);}
	@font-face {font-family: Brandon;src: url(brandon.otf);}
	@font-face {font-family: VRN;src: url(vrn.otf);}
	@font-face {font-family: NEOM;src: url(neom.otf);}
	@font-face {font-family: PTSANS;src: url(PTSANS.ttf);}
	@font-face {font-family: Type;src: url(type.ttf);}
	@font-face {font-family: Enlightment;src: url(enlightment.ttf);}
	@font-face {font-family: Arabic;src: url(arabic.ttf);}
	@font-face {font-family: Digital;src: url(digital.ttf);}
	@font-face {font-family: Cond;src: url(cond2.ttf);}
	@font-face {font-family: Semi;src: url(semi.ttf);}
	@font-face {font-family: Droser;src: url(Droser.ttf);}
	.goth {font-family: Gothic, Verdana, sans-serif;}
	.book {font-family: Book, serif;}
	.hando {font-family: Hando, Verdana, sans-serif;}
	.typewriter {font-family: Type, Verdana, sans-serif;}
	.arabic {font-family: Arabic, serif; font-size:180%;}
	.droser {font-family: Droser, Verdana, sans-serif;}
</style>
<DIV id='thronecom'><BR><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=declareemergency'><span class='thronelink'>Declare Emergency</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=gathermeeting'><span class='thronelink second'>Gather a Meeting</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=decree'><span class='thronelink'>Make a Decree</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=capture'><span class='thronelink second'>Capture</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=execute'><span class='thronelink'>Execute</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=settaxes'><span class='thronelink second'>Set the Taxes</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=riotreal'><span class='thronelink'>Riot!</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=appointhand'><span class='thronelink second'>Appoint a Hand</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=battlealarm'><span class='thronelink'>Battle Alarm!</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=firearmlaw'><span class='thronelink second'>Firearms Trade Law</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=drugslaw'><span class='thronelink'>Drugs Trade Law</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=expandchurch'><span class='thronelink second'>Expand Church Powers</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=reassign'><span class='thronelink'>Reassign</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=playsong'><span class='thronelink second'>Play Songs</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=migburnlaw'><span class='thronelink'>Migrants Burn Law</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=openpit'><span class='thronelink second'>Open the Pit!</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=callformigrants'><span class='thronelink'>Call For Migrants</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=craftmedal'><span class='thronelink second'>Craft a Medal</span></A><BR><A class='thronelinks' href='byond://?src=\ref[src];usecrown=energylaw'><span class='thronelink'>Energy Law</span></A><BR><BR></DIV>
"}
	user << browse(dat, "window=id_com;size=300x700")

var/global/isEmergency = 0
var/global/isMeeting = 0
var/list/riot_essential = list("Baron", "Baroness Bodyguard", "Incarn", "Squire", "Marduk", "Tiamat", "Hand", "Heir", "Successor", "Baroness", "Guest", "Meister", "Treasurer", "Inquisitor", "Bishop", "Practicus", "Sheriff")

/obj/structure/stool/bed/chair/ThroneMid/Topic(href, href_list)
	if(src.buckled_mob)
		src.buckled_mob = usr
		var/list/allowedjobs = list("Baron","Hand","Count","Baroness","Heir","Successor")
		var/mob/living/carbon/human/H = src.buckled_mob
		if(H.job == "Jester" && H.special == "jesterdecree")
			switch(href_list["usecrown"])
				if("decree")
					var/input = sanitize(input(usr, "Type your decree.", "Firethorn Decree", "") as message|null, list("\t"="#","ÿ"="&#255;"))
					if(!input)
						return
					if(findtext(input, "http"))
						return
					if(get_dist(src, H) > 1)
						return
					if(H.stat)
						return
					to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
					to_chat(world, "<span class='excomm'>New Baron's decree!</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<span class='decree'>[input]</span>")
					to_chat(world, "<br>")
					for(var/obj/machinery/information_terminal/T in vending_list)
						if(T.hacked) continue
						if(T.screenbroken) continue
						T.announces += input

		if(H.job == "Marduk")
			switch(href_list["usecrown"])
				if("riotreal")
					if(riotreal == 0 && riot != 1)
						to_chat(world, "<br>")
						to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
						to_chat(world, "<span class='excomm'>¤Riot Declared! Tiamathi must gear up in the small armory, those caught outside their residence shall be executed!¤</span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<br>")
						to_chat(world, "<span class='decree'>New [H.job]'s decree!</span>")
						to_chat(world, "<br>")
						world << sound('RiotAlarm.ogg', repeat = 1, wait = 0, volume = 100, channel = 6)
						riotreal = 1
						for(var/obj/machinery/door/poddoor/shutters/B in world)
							if(B.alert == "baronriot")
								B.open()
					else
						if(riotreal == 1 && riot == 0)
							to_chat(world, "<br>")
							to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
							to_chat(world, "<span class='excomm'><b>¤Riot state inactive. Fortress residents may now return to their duties.¤</b></span>")
							world << sound('sound/AI/bell_toll.ogg')
							to_chat(world, "<br>")
							to_chat(world, "<span class='decree'>New [H.job]'s decree!</span>")
							to_chat(world, "<br>")
							world << sound('RiotAlarm.ogg', repeat = 0, wait = 0, volume = 0, channel = 6)
							riotreal = 0
							for(var/obj/machinery/door/poddoor/shutters/B in world)
								if(B.alert == "baronriot")
									B.close()
						if(riot == 1)
							to_chat(usr, "<span class='combat'>[pick(nao_consigoen)] I need to turn off the Battle Alarm first!</span>")

		if(allowedjobs.Find(H.job) && H.head && istype(H.head, /obj/item/clothing/head/caphat))
			switch(href_list["usecrown"])
				if("declareemergency")
					if(!isEmergency)
						to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
						to_chat(world, "<span class='excomm'>New [src.buckled_mob.job]'s decree!</span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<span class='decree'>Our glorious [src.buckled_mob.job] declares state of EMERGENCY!</span>")
						to_chat(world, "<br>")
						isEmergency = 1
						for(var/obj/machinery/emergency_room/E in emergency_rooms)
							if(!E.activearea.alarm_toggled)
								E.icon_state = E.active_state
								E.activearea.alarm_toggled = TRUE
								playsound(E.loc, 'danger_alarm.ogg',80,0, 30, 30)
								E.active = TRUE
								spawn(20)
									processing_objects.Add(E)
					else
						to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
						to_chat(world, "<span class='excomm'>New [src.buckled_mob.job]'s decree!</span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<span class='decree'>Our glorious [src.buckled_mob.job] undeclares state of emergency!</span>")
						to_chat(world, "<br>")
						isEmergency = 0
						for(var/obj/machinery/emergency_room/E in emergency_rooms)
							if(E.activearea.alarm_toggled)
								E.icon_state = initial(E.icon_state)
								E.activearea.alarm_toggled = FALSE
								E.active = FALSE
								spawn(20)
									processing_objects.Remove(E)

				if("gathermeeting")
					if(!isMeeting)
						to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
						to_chat(world, "<span class='excomm'>New [src.buckled_mob.job]'s decree!</span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<span class='decree'>Our glorious [src.buckled_mob.job] calls for a MEETING IN THE THRONE ROOM!</span>")
						to_chat(world, "<br>")
						isMeeting = 1
					else
						to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
						to_chat(world, "<span class='excomm'>New [src.buckled_mob.job]'s decree!</span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<span class='decree'>Our glorious [src.buckled_mob.job] finishes the meeting!</span>")
						to_chat(world, "<span class='decree'>Go away!</span>")
						to_chat(world, "<br>")
						isMeeting = 0

				if("decree")
					var/input = sanitize(input(usr, "Type your decree.", "Firethorn Decree", "") as message|null, list("\t"="#","ÿ"="&#255;"))
					if(!input)
						return
					if(findtext(input, "http"))
						return
					if(get_dist(src, H) > 1)
						return
					if(H.stat)
						return
					to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
					to_chat(world, "<span class='excomm'>New [src.buckled_mob.job]'s decree!</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<span class='decree'>[input]</span>")
					to_chat(world, "<br>")
					for(var/obj/machinery/information_terminal/T in vending_list)
						if(T.hacked) continue
						if(T.screenbroken) continue
						T.announces += input

				if("capture")
					var/input = sanitize(input(usr, "Type your capture.", "Firethorn Decree", "") as message|null)
					if(!input)
						return
					if(findtext(input, "http"))
						return
					to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
					to_chat(world, "<span class='excomm'>New [src.buckled_mob.job]'s decree!</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<span class='decree'>[input] must be CAPTURED alive!</span>")
					to_chat(world, "<br>")

				if("execute")
					var/input = sanitize(input(usr, "Type your execution.", "Firethorn Decree", "") as message|null)
					if(!input)
						return
					if(findtext(input, "http"))
						return
					to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
					to_chat(world, "<span class='excomm'>New [src.buckled_mob.job]'s decree!</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<span class='decree'>[input] must be EXECUTED!</span>")
					to_chat(world, "<br>")

				if("settaxes")
					var/input = sanitize_uni(input(usr, "Choose between 0 and 100 percent.", "Firethorn Decree", "") as num)
					if(input > 100 || input < 1 || input % 1)
						return
					to_chat(world, "<br>")
					to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
					to_chat(world,"<span class='excomm'>¤The new taxes are <i>[input]%</i>!¤</span>")
					taxes = input
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<br>")
					to_chat(world, "<span class='decree'>New [src.buckled_mob.job]'s decree!</span>")
					to_chat(world, "<br>")

				if("opensmall")
					var/obj/item/device/radio/headset/bracelet/a = new /obj/item/device/radio/headset/bracelet(null)
					a.autosay("Alert: The small armory has been opent!", "Emergency")
					for(var/obj/machinery/door/poddoor/shutters/B in world)
						if(B.alert == "smallarmory")
							B.open()
					return

				if("appointhand")
					if(fortHand)
						return
					var/input = sanitize(input(usr, "Choose your hand, must be their full name.", "Firethorn Decree", "") as message|null)
					if(!input)
						return
					for(var/mob/living/carbon/human/HH in mob_list)
						if(input == H.real_name)
							fortHand = HH
							HH.job = "Hand"
					if(!fortHand)
						return
					to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
					to_chat(world, "<span class='excomm'>New [H.job]'s decree!</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<span class='decree'>[input] is now [H.real_name]'s Hand!</span>")
					to_chat(world, "<br>")

				if("battlealarm")
					if(riot == 0 && riotreal == 0)
						to_chat(world, "<br>")
						to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
						to_chat(world, "<span class='excomm'>¤BATTLE ALARM! Everyone must head to the Armory and prepare for combat!¤</span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<br>")
						to_chat(world, "<span class='decree'>New [H.job]'s decree!</span>")
						to_chat(world, "<br>")
						world << sound('mantrap.ogg', repeat = 1, wait = 0, volume = 50, channel = 6)
						riot = 1
						for(var/obj/machinery/door/poddoor/shutters/B in world)
							if(B.alert == "baronalert")
								B.open()
					else
						if(riot == 1 && riotreal == 0)
							to_chat(world, "<br>")
							to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
							to_chat(world, "<span class='excomm'><b>¤The alert has been terminated.¤</b></span>")
							world << sound('sound/AI/bell_toll.ogg')
							to_chat(world, "<br>")
							to_chat(world, "<span class='decree'>New [H.job]'s decree!</span>")
							to_chat(world, "<br>")
							world << sound('mantrap.ogg', repeat = 0, wait = 0, volume = 0, channel = 6)
							riot = 0
							for(var/obj/machinery/door/poddoor/shutters/B in world)
								if(B.alert == "baronalert")
									B.close()
						if(riotreal == 1)
							to_chat(usr, "<span class='combat'>[pick(nao_consigoen)] I need to turn off the Riot Alarm first!</span>")

				if("riotreal")
					if(riotreal == 0 && riot != 1)
						to_chat(world, "<br>")
						to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
						to_chat(world, "<span class='excomm'>¤Riot Declared! Tiamathi must gear up in the small armory, those caught outside their residence shall be executed!¤</span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<br>")
						to_chat(world, "<span class='decree'>New [H.job]'s decree!</span>")
						to_chat(world, "<br>")
						world << sound('RiotAlarm.ogg', repeat = 1, wait = 0, volume = 100, channel = 6)
						riotreal = 1
						for(var/obj/machinery/door/poddoor/shutters/B in world)
							if(B.alert == "baronriot")
								B.open()
					else
						if(riotreal == 1 && riot == 0)
							to_chat(world, "<br>")
							to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
							to_chat(world, "<span class='excomm'><b>¤Riot state inactive. Fortress residents may now return to their duties.¤</b></span>")
							world << sound('sound/AI/bell_toll.ogg')
							to_chat(world, "<br>")
							to_chat(world, "<span class='decree'>New [H.job]'s decree!</span>")
							to_chat(world, "<br>")
							world << sound('RiotAlarm.ogg', repeat = 0, wait = 0, volume = 0, channel = 6)
							riotreal = 0
							for(var/obj/machinery/door/poddoor/shutters/B in world)
								if(B.alert == "baronriot")
									B.close()
						if(riot == 1)
							to_chat(usr, "<span class='combat'>[pick(nao_consigoen)] I need to turn off the Battle Alarm first!</span>")

				if("firearmlaw")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<br>")
					to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
					if(!gunban)
						to_chat(world, "<span class='excomm'>¤The sale and exchange of firearms is now Banned in the fortress.¤</span>")
						gunban = 1
					else
						to_chat(world, "<span class='excomm'>¤The sale and exchange of firearms is now Allowed in the fortress.¤</span>")
						gunban = 0
					to_chat(world, "<br>")
					to_chat(world, "<span class='decree'>New [H.job]'s decree!</span>")
					to_chat(world, "<br>")
				if("drugslaw")
					to_chat(world, "<br>")
					to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
					if(!drugban)
						to_chat(world, "<span class='excomm'>¤The sale and exchange of drugs is now Banned in the fortress.¤</span>")
						drugban = 1
					else
						to_chat(world, "<span class='excomm'>¤The sale and exchange of drugs is now Allowed in the fortress.¤</span>")
						drugban = 0
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<br>")
					to_chat(world, "<span class='decree'>New [H.job]'s decree!</span>")
					to_chat(world, "<br>")
				if("expandchurch")
					switch(alert("Are you SURE you want to expand church powers? This is irreversible.", "Expand Church Powers", "Yes", "No"))
						if("Yes")
							if(!churchexpanded)
								to_chat(world, "<br>")
								to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
								to_chat(world, "<span class='excomm'>The [H.job] expanded church powers, praise the lord!</span>")
								world << sound('sound/AI/bell_toll.ogg')
								to_chat(world, "<br>")
								to_chat(world, "<span class='decree'>New [H.job]'s decree!</span>")
								to_chat(world, "<br>")
								churchexpanded = 1
								Inquisitor_Points += rand(6,11)

								for(var/mob/living/carbon/human/ChurchMen in mob_list)
									if(ChurchMen.wear_id)
										if(ChurchMen.job == "Inquisitor" || ChurchMen.job == "Practicus" || ChurchMen.job == "Bishop" || ChurchMen.job == "Sniffer")
											var/obj/item/weapon/card/id/R = ChurchMen.wear_id
											R.access = list(church, access_morgue, access_chapel_office, access_maint_tunnels, meistery,smith,treasury,esculap,sanctuary,innkeep,merchant,garrison,keep,baronquarter,hump,courtroom,soilery,lifeweb,geschef, marduk, hand_access)

							else
								return
				if("reassign")
					var/turf/T = locate(H.x, H.y-1, H.z)
					var/job = input("What job?", "Dragon Throne") in list("Judge", "Meister", "Baroness", "Heir", "Successor", "Jester",\
					"Butler", "Sitzfrau", "Maid", "Servant", "Marduk", "Tiamat", "Incarn", "Squire", "Sheriff", "Baroness Bodyguard",\
					"Esculap", "Serpent", "Metalsmith", "Weaponsmith", "Armorsmith", "Pusher",\
					"Amuser", "Book Making Agent", "Homeless", "Hump", "Mortician", "Misero",\
					"Grayhound", "Soiler", "Treasurer", "Innkeeper", "Innkeeper Wife")
					for(var/mob/living/carbon/human/M in T)
						M.job = job
						if(M.wear_id)
							var/obj/item/weapon/card/id/R = M.wear_id
							R.registered_name = M.real_name
							R.rank = job
							R.assignment = job
							R.name = "[R.registered_name]'s Ring"
							switch(job)
								if("Judge") R.access = list(keep,courtroom)
								if("Meister") R.access = list(keep,meistery,treasury)
								if("Baroness") R.access = list(treasury,meistery,keep,baronquarter)
								if("Baroness Bodyguard") R.access = list(garrison,keep)
								if("Heir") R.access = list(keep,baronquarter)
								if("Successor") R.access = list(keep,baronquarter)
								if("Jester") R.access = list(keep)
								if("Butler") R.access = list(keep)
								if("Sitzfrau") R.access = list(keep)
								if("Maid") R.access = list(keep)
								if("Servant") R.access = list(keep)
								if("Marduk") R.access = list(meistery,sanctuary,garrison,keep,hump,courtroom,soilery,lifeweb, baronquarter, marduk, innkeep)
								if("Tiamat") R.access = list(garrison,keep,courtroom)
								if("Sheriff") R.access = list(garrison,keep,courtroom)
								if("Incarn") R.access = list(garrison,keep,courtroom)
								if("Squire") R.access = list(garrison,keep)
								if("Esculap") R.access = list(sanctuary,keep,esculap)
								if("Serpent") R.access = list(sanctuary)
								if("Metalsmith") R.access = list(smith)
								if("Weaponsmith") R.access = list(smith)
								if("Armorsmith") R.access = list(smith)
								if("Pusher") R.access = list(brothel, amuser)
								if("Amuser") R.access = list(amuser)
								if("Book Making Agent") R.access = list(keep,courtroom)
								if("Homeless") R.access = list()
								if("Hump") R.access = list(keep,hump)
								if("Mortician") R.access = list(lifeweb)
								if("Misero") R.access = list(lifeweb)
								if("Grayhound") R.access = list(merchant)
								if("Soiler") R.access = list(soilery)
								if("Treasurer") R.access = list(keep,meistery,treasury)
								if("Innkeeper") R.access = list(innkeep)
								if("Innkeeper Wife") R.access = list(innkeep)
						to_chat(world, "<br>")
						to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
						to_chat(world,"<span class='excomm'>¤[M.real_name] is now a [job]!¤</span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<br>")
						to_chat(world, "<span class='decree'>New [src.buckled_mob.job]'s decree!</span>")
						to_chat(world, "<br>")


				if("playsong")
					var/song = input("What song?", "Dragon Throne") in list("Unknown (1)", "Unknown (2)", "Unknown (3)")
					if(!song) return
					if(song == "Unknown (1)")
						chosenSong = 'sound/music/csrio.ogg'
					else if(song == "Unknown (2)")
						chosenSong = 'sound/music/soufoda.ogg'
					else
						chosenSong = 'sound/music/rapdasarmas.ogg'
					for(var/obj/machinery/loud_speaker/L in loud_speakers)
						L.playsom()

				if("migburnlaw")
					to_chat(world, "<br>")
					to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
					world << sound('sound/AI/bell_toll.ogg')
					if(!migban)
						to_chat(world, "<span class='excomm'>¤The entrance of new migrants into the fortress is now prohibited. The Incarn is now allowed to throw them into the magma.¤</span>")
						migban = 1
					else
						to_chat(world, "<span class='excomm'>¤Migrants are allowed inside the fortress.¤</span>")
						migban = 0
					to_chat(world, "<br>")
					to_chat(world, "<span class='decree'>New [H.job]'s decree!</span>")
					to_chat(world, "<br>")

				if("openpit")
					for(var/obj/machinery/door/airlock/orbital/gates/magma/trap_door/T in world)
						T.toggle()

				if("callformigrants")
					to_chat(world, "<br>")
					to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
					to_chat(world,"<span class='excomm'>¤The Lord asks for migrants!¤</span>")
					world << sound('sound/AI/bell_toll.ogg')
					to_chat(world, "<br>")
					to_chat(world, "<span class='decree'>New [src.buckled_mob.job]'s decree!</span>")
					to_chat(world, "<br>")

				if("craftmedal")
					var/mob/living/carbon/human/already_nominated
					var/input = sanitize(input(usr, "Choose someone to recieve the medal.", "Firethorn Decree", "") as text|null)
					if(!input)
						return
					if(H.real_name == input)
						to_chat(H, "<span class='combat'>I feel stupid...</span>")
						return
					if(length(medal_nominated))
						for(var/mob/living/carbon/human/HU in medal_nominated)
							if(HU.real_name == input)
								already_nominated = HU
								break
					to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
					to_chat(world, "<span class='excomm'>New [H.job]'s decree!</span>")
					world << sound('sound/AI/bell_toll.ogg')
					if(already_nominated)
						to_chat(world, "<span class='decree'>[H.job] don't want any medal for [input]!</span>")
						to_chat(world, "<br>")
						medal_nominated.Remove(already_nominated)
						return
					to_chat(world, "<span class='decree'>[input] has been rewarded! The smiths shall craft a medal for him!</span>")
					to_chat(world, "<br>")
					for(var/mob/living/carbon/human/HH in mob_list)
						if(HH.real_name == input)
							medal_nominated[HH] = H

				if("energylaw")
					if((treasuryworth.get_money()) > 199 && energyInvestimento == 0)
						to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
						to_chat(world, "<span class='excomm'>New [H.job]'s decree!</span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<span class='decree'>Our glorious [H.job] has decided to spend money on energy!</span>")
						to_chat(world, "<br>")
						energyInvestimento = 1
					else if((treasuryworth.get_money()) > 199 && energyInvestimento == 1)
						to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
						to_chat(world, "<span class='excomm'>New [H.job]'s decree!</span>")
						world << sound('sound/AI/bell_toll.ogg')
						to_chat(world, "<span class='decree'>Our glorious [H.job] has stopped spending money on energy!</span>")
						to_chat(world, "<br>")
						energyInvestimento = 0
					else
						to_chat(usr, "Not enough money on the treasury.")
					return

/obj/structure/stool/bed/chair/ThroneBaroness
	name = "Throne"
	desc = "A magnificent throne."
	icon = 'icons/obj/throne.dmi'
	icon_state = "throne2"
	anchored = 1

var/global/taxes = 13
var/roundendready = FALSE

/obj/structure/stool/bed/chair/ThroneMid/buckle_mob(mob/M as mob, mob/user as mob)
	if (!ticker)
		user << "You can't buckle anyone in before the game starts."
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || user.lying || user.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	unbuckle()

	if (M == usr)
		M.visible_message("<span class='passivebold'>[M.name]</span> <span class='passive'>sits majestically on [src]!</span>")
	else
		M.visible_message("<span class='passivebold'>[M.name]</span> <span class='passive'>sits majestically on [src]!</span>")

	M.pixel_y = 5

	baron_ui(M)

	M.buckled = src
	M.loc = src.loc
	M.dir = src.dir
	M.update_canmove()
	src.buckled_mob = M
	src.add_fingerprint(user)
	var/mob/living/carbon/human/H = usr
	var/list/allowedjobs = list("Baron","Hand","Count","Baroness","Heir","Successor")
	if(allowedjobs.Find(H.job) && H.head && istype(H.head, /obj/item/clothing/head/caphat))
		H.verbs += /mob/living/carbon/human/verb/BaronRiot
		H.verbs += /mob/living/carbon/human/verb/BaronAnnounce
		H.verbs += /mob/living/carbon/human/verb/BaronRiotReal
		H.verbs += /mob/living/carbon/human/verb/DrugBan
		H.verbs += /mob/living/carbon/human/verb/WeaponBan
		H.verbs += /mob/living/carbon/human/verb/Migrants
		H.verbs += /mob/living/carbon/human/verb/SetTaxes
		H.verbs += /mob/living/carbon/human/verb/ChurchExpand
		H.verbs += /mob/living/carbon/human/verb/OpenTraps
		H.verbs += /mob/living/carbon/human/verb/SetHand

	if(H.job == "Jester" && H.special == "jesterdecree")
		H.verbs += /mob/living/carbon/human/verb/BaronAnnounce
	M.updatePig()

	if(H.job == "Marduk")
		H.verbs += /mob/living/carbon/human/verb/BaronRiotReal
	M.updatePig()

/obj/structure/stool/bed/chair/ThroneMid/unbuckle(mob/M as mob, mob/user as mob)
	if(buckled_mob)
		if(buckled_mob.buckled == src)	//this is probably unneccesary, but it doesn't hurt
			buckled_mob.buckled = null
			buckled_mob.anchored = initial(buckled_mob.anchored)
			buckled_mob.update_canmove()
			buckled_mob = null
	var/mob/living/carbon/human/H = usr
	H.pixel_y = initial(H.pixel_y)
	src << output(list2params(list()), "outputwindow.browser:removeAntagTab")
	src << output(list2params(list()), "outputwindow.browser:initial")
	H.verbs -= /mob/living/carbon/human/verb/BaronRiot
	H.verbs -= /mob/living/carbon/human/verb/BaronAnnounce
	H.verbs -= /mob/living/carbon/human/verb/BaronRiotReal
	H.verbs -= /mob/living/carbon/human/verb/DrugBan
	H.verbs -= /mob/living/carbon/human/verb/WeaponBan
	H.verbs -= /mob/living/carbon/human/verb/Migrants
	H.verbs -= /mob/living/carbon/human/verb/SetTaxes
	H.verbs -= /mob/living/carbon/human/verb/ChurchExpand
	H.verbs -= /mob/living/carbon/human/verb/OpenTraps
	H.verbs -= /mob/living/carbon/human/verb/SetHand
	if(H.job == "Jester" && H.special == "jesterdecree")
		H.verbs -= /mob/living/carbon/human/verb/BaronAnnounce
	H.updatePig()

	if(H.job == "Marduk")
		H.verbs -= /mob/living/carbon/human/verb/BaronRiotReal
	H.updatePig()

/mob/living/carbon/human/New()
	. = ..()
	src.verbs -= /mob/living/carbon/human/verb/BaronRiot
	src.verbs -= /mob/living/carbon/human/verb/BaronAnnounce
	src.verbs -= /mob/living/carbon/human/verb/BaronRiotReal
	src.verbs -= /mob/living/carbon/human/verb/DrugBan
	src.verbs -= /mob/living/carbon/human/verb/WeaponBan
	src.verbs -= /mob/living/carbon/human/verb/Migrants
	src.verbs -= /mob/living/carbon/human/verb/SetTaxes
	src.verbs -= /mob/living/carbon/human/verb/ChurchExpand
	src.verbs -= /mob/living/carbon/human/verb/OpenTraps
	src.verbs -= /mob/living/carbon/human/verb/SetHand

/mob/living/carbon/human/verb/BaronAnnounce()
	set hidden = 0
	set category = "Baron"
	set name = "Decretodobarao"
	set desc="Decretar algo."
	var/input = sanitize(input(usr, "Type your decree.", "Firethorn Decree", "") as message|null, list("\t"="#","ÿ"="&#255;"))
	if(!input)
		return
	if(findtext(input, "http"))
		return
	to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
	to_chat(world, "<span class='excomm'>New [src.job]'s decree!</span>")
	world << sound('sound/AI/bell_toll.ogg')
	to_chat(world, "<span class='decree'>[input]</span>")
	to_chat(world, "<br>")
	for(var/obj/machinery/information_terminal/T in vending_list)
		if(T.hacked) continue
		if(T.screenbroken) continue
		T.announces += input
	log_admin("[key_name(src)] has made a decree")
	message_admins("[key_name_admin(src)] has made a decree", 1)


/mob/living/carbon/human/verb/SetHand()
	set hidden = 0
	set category = "Baron"
	set name = "SetHands"
	set desc="Decretar algo."
	if(fortHand)
		return
	var/input = sanitize(input(usr, "Choose your hand, must be their full name.", "Firethorn Decree", "") as message|null)
	if(!input)
		return
	for(var/mob/living/carbon/human/H in mob_list)
		if(input == H.real_name)
			fortHand = H
			H.job = "Hand"
	if(!fortHand)
		return
	to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
	to_chat(world, "<span class='excomm'>New [src.job]'s decree!</span>")
	world << sound('sound/AI/bell_toll.ogg')
	to_chat(world, "<span class='decree'>[input] is now [src.real_name]'s Hand!</span>")
	to_chat(world, "<br>")

/mob/living/carbon/human/verb/OpenTraps()
	set hidden = 0
	set category = "Baron"
	set name = "Abrirtrapdoors"
	set desc="abre trap doors."

	for(var/obj/machinery/door/airlock/orbital/gates/magma/trap_door/T in world)
		T.toggle()

/mob/living/carbon/human/verb/SetTaxes()
	set hidden = 0
	set category = "Baron"
	set name = "ColocarTaxas"
	set desc="Coloca taxas."
	var/input = sanitize_uni(input(usr, "Choose between 0 and 100 percent.", "Firethorn Decree", "") as num)
	if(input > 100 || input < 1)
		return
	to_chat(world, "<br>")
	to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
	to_chat(world,"<span class='excomm'>¤The new taxes are <i>[input]%</i>!¤</span>")
	taxes = input
	world << sound('sound/AI/bell_toll.ogg')
	to_chat(world, "<br>")
	to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
	to_chat(world, "<br>")

	log_admin("[key_name(src)] has made a decree")
	message_admins("[key_name_admin(src)] has made a decree", 1)

/mob/living/carbon/human/verb/BaronRiot()
	set hidden = 0
	set category = "Baron"
	set name = "Declararalerta"
	set desc="Abre a armory e declara alerta."
	if(riot == 0 && riotreal == 0)
		to_chat(world, "<br>")
		to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
		to_chat(world, "<span class='excomm'>¤BATTLE ALARM! Everyone must head to the Armory and prepare for combat!¤</span>")
		world << sound('sound/AI/bell_toll.ogg')
		to_chat(world, "<br>")
		to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
		to_chat(world, "<br>")
		world << sound('mantrap.ogg', repeat = 1, wait = 0, volume = 50, channel = 6)
		riot = 1
		for(var/obj/machinery/door/poddoor/shutters/B in world)
			if(B.alert == "baronalert")
				B.open()
	else
		if(riot == 1 && riotreal == 0)
			to_chat(world, "<br>")
			to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
			to_chat(world, "<span class='excomm'><b>¤The alert has been terminated.¤</b></span>")
			world << sound('sound/AI/bell_toll.ogg')
			to_chat(world, "<br>")
			to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
			to_chat(world, "<br>")
			world << sound('mantrap.ogg', repeat = 0, wait = 0, volume = 0, channel = 6)
			riot = 0
			for(var/obj/machinery/door/poddoor/shutters/B in world)
				if(B.alert == "baronalert")
					B.close()
		if(riotreal == 1)
			to_chat(usr, "<span class='combat'>[pick(nao_consigoen)] I need to turn off the Riot Alarm first!</span>")

		log_admin("[key_name(src)] has turned on the battle alarm")
		message_admins("[key_name_admin(src)] has turned on the battle alarm", 1)

/mob/living/carbon/human/verb/BaronRiotReal()
	set hidden = 0
	set category = "Baron"
	set name = "Riot Alarm"
	set desc="Declare a riot."
	if(riotreal == 0 && riot == 0)
		to_chat(world, "<br>")
		to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
		to_chat(world, "<span class='excomm'>¤Riot Declared! Tiamathi must gear up in the small armory, those caught outside their residence shall be executed!¤</span>")
		world << sound('sound/AI/bell_toll.ogg')
		to_chat(world, "<br>")
		to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
		to_chat(world, "<br>")
		world << sound('RiotAlarm.ogg', repeat = 1, wait = 0, volume = 100, channel = 6)
		riotreal = 1
		for(var/obj/machinery/door/poddoor/shutters/B in world)
			if(B.alert == "baronriot")
				B.open()
	else
		if(riotreal == 1 && riot == 0)
			to_chat(world, "<br>")
			to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
			to_chat(world, "<span class='excomm'><b>¤Riot state inactive. Fortress residents may now return to their duties.¤</b></span>")
			world << sound('sound/AI/bell_toll.ogg')
			to_chat(world, "<br>")
			to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
			to_chat(world, "<br>")
			world << sound('RiotAlarm.ogg', repeat = 0, wait = 0, volume = 0, channel = 6)
			riotreal = 0
			for(var/obj/machinery/door/poddoor/shutters/B in world)
				if(B.alert == "baronriot")
					B.close()
		if(riot == 1)
			to_chat(usr, "<span class='combat'>[pick(nao_consigoen)] I need to turn off the Battle Alarm first!</span>")

			log_admin("[key_name(src)] has declared riot")
			message_admins("[key_name_admin(src)] has declared riot", 1)
		if(riot == 1)
			to_chat(usr, "<span class='combat'>[pick(nao_consigoen)] I need to turn off the Battle Alarm first!</span>")

/mob/living/carbon/human/verb/DrugBan()
	set hidden = 0
	set category = "Baron"
	set name = "VendadeDrogas"
	set desc="Proibe ou permite venda de drogas."

	to_chat(world, "<br>")
	to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
	if(!drugban)
		to_chat(world, "<span class='excomm'>¤The sale and exchange of drugs is now Banned in the fortress.¤</span>")
		drugban = 1
	else
		to_chat(world, "<span class='excomm'>¤The sale and exchange of drugs is now Allowed in the fortress.¤</span>")
		drugban = 0
	world << sound('sound/AI/bell_toll.ogg')
	to_chat(world, "<br>")
	to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
	to_chat(world, "<br>")

/mob/living/carbon/human/verb/WeaponBan()
	set hidden = 0
	set category = "Baron"
	set name = "VendadeArmas"
	set desc="Proibe ou permite venda de armas."

	world << sound('sound/AI/bell_toll.ogg')
	to_chat(world, "<br>")
	to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
	if(!gunban)
		to_chat(world, "<span class='excomm'>¤The sale and exchange of firearms is now Banned in the fortress.¤</span>")
		gunban = 1
	else
		to_chat(world, "<span class='excomm'>¤The sale and exchange of firearms is now Allowed in the fortress.¤</span>")
		gunban = 0
	to_chat(world, "<br>")
	to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
	to_chat(world, "<br>")

/mob/living/carbon/human/verb/ChurchExpand()
	set hidden = 0
	set category = "Baron"
	set name = "Expandirpoderesdaigreja"
	set desc="Expande o poder da igreja."
	switch(alert("Are you SURE you want to expand church powers? This is irreversible.", "Expand Church Powers", "Yes", "No"))
		if("Yes")
			if(!churchexpanded)
				to_chat(world, "<br>")
				to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
				to_chat(world, "<span class='excomm'>The [src.job] expanded church powers, praise the lord!</span>")
				world << sound('sound/AI/bell_toll.ogg')
				to_chat(world, "<br>")
				to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
				to_chat(world, "<br>")
				churchexpanded = 1
				Inquisitor_Points += 10
			else
				return

/mob/living/carbon/human/verb/Migrants()
	set hidden = 0
	set category = "Baron"
	set name = "TrafegodeMigrantes"
	set desc="Proibe ou permite a entrada de migrantes."

	to_chat(world, "<br>")
	to_chat(world, "<span class='ravenheartfortress'>Firethorn Fortress</span>")
	world << sound('sound/AI/bell_toll.ogg')
	if(!migban)
		to_chat(world, "<span class='excomm'>¤The entrance of new migrants into the fortress is now prohibited. The Incarn is now allowed to throw them into the magma.¤</span>")
		migban = 1
	else
		to_chat(world, "<span class='excomm'>¤Migrants are allowed inside the fortress.¤</span>")
		migban = 0
	to_chat(world, "<br>")
	to_chat(world, "<span class='decree'>New [src.job]'s decree!</span>")
	to_chat(world, "<br>")

/obj/structure/stool/bed/chair/ThroneSides
	name = "Baron's Throne"
	desc = "A magnificent throne."
	icon = 'icons/obj/throne.dmi'
	icon_state = "thronecenter"
	anchored = 1
	flammable = 0

/obj/structure/stool/bed/chair/ThroneSides/right
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "baseright"

/obj/structure/stool/bed/chair/ThroneSides/left
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "baseleft"

/obj/structure/stool/bed/chair/ThroneSides/wingright
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "wingright"
	plane = 21

/obj/structure/stool/bed/chair/ThroneSides/wingleft
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "wingleft"
	plane = 21

/obj/structure/stool/bed/chair/ThroneSides/top
	icon = 'icons/obj/throne_new.dmi'
	icon_state = "top"
	plane = 21

/obj/structure/stool/bed/chair/ThroneSides/buckle_mob()
	return 0

/obj/structure/stool/bed/chair/ThroneSides2
	name = "Throne"
	desc = "A magnificent throne."
	icon = 'icons/obj/throne.dmi'
	icon_state = "thronecenter2"
	anchored = 1

/obj/structure/stool/bed/chair/ThroneSides/buckle_mob()
	return 0