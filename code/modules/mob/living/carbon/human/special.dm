/datum/special/var
	name = "Special"
	limitations = "Nenhuma"
	description = "Descrição"
	reward = "Nenhuma"
	limitationsen = "None"
	descriptionen = "Description"
	rewarden = "None"
	specialitem = null

/datum/special/proc/pick_special()
	var/specials = pick(subtypesof(/datum/special))
	if (specials)
		var/special = new specials
		return special
	else
		warning("erro no vice de alguem ai")

/datum/special/notafraid
	name = "notafraid"
	description = "Você não tem medo de cair porquê você sabe como aterrisar."
	descriptionen = "You're not afraid to fall because you know how to land right."

/datum/special/weed
	name = "weedstrong"
	description = "Maconha te deixa mais forte e mais inteligente."
	descriptionen = "Weed makes your stronger, faster and smarter."

/datum/special/squireheir
	name = "squireheir"
	limitations = "Heir."
	limitationsen = "Heir."
	description = "Você pretende ser o futuro Marduk."
	descriptionen = "You pretend to become the future Marduk."

/datum/special/allah
	name = "Allah"
	description = "أنت من أتباع الله الواحد"
	descriptionen = "أنت من أتباع الله الواحد"

/datum/special/comicsans
	name = "comicsans"
	description = "Você tem uma voz desagradável."
	descriptionen = "You have an unpleasant voice."

/datum/special/mayartist
	name = "mayartist"
	descriptionen = "Today is your lucky night. You spent a few days training your painting skills and tonight you might achieve great success."

/datum/special/afraidmed
	name = "afraidmed"
	description = "It's better to die than to be healed like this. You're afraid of doctors and medicine."
	descriptionen = "It's better to die than to be healed like this. You're afraid of doctors and medicine."

/datum/special/bouncer
	name = "bouncer"
	limitations = "Tiamat. If Pusher is present."
	limitationsen = "Tiamat. If Pusher is present."
	description = "You're a Bouncer. You despise the law, but love to bring order. You also love your boss-bro Pusher, and you'll crush everyone who dares to disrespect him or his place."
	descriptionen = "You're a Bouncer. You despise the law, but love to bring order. You also love your boss-bro Pusher, and you'll crush everyone who dares to disrespect him or his place."

/datum/special/succubus
	name = "succubus"
	limitations = "Mulheres."
	limitationsen = "Grown-up Females."
	description = "You're a succubus, able to enslave men through your bedroom tricks."
	descriptionen = "You're a succubus, able to enslave men through your bedroom tricks."

/datum/special/gigantism
	name = "gigantism"
	description = "You suffer of Gigantism."
	descriptionen = "You suffer of Gigantism."

/datum/special/weirdgait
	name = "weirdgait"
	description = "You have a weird gait."
	descriptionen = "You have a weird gait."

/datum/special/hardconcentrate
	name = "hardconcentrate"
	description = "Sometimes it's hard for you to concentrate."
	descriptionen = "Sometimes it's hard for you to concentrate."

/datum/special/camodevice
	name = "camodevice"
	description = "Você escondeu um dispositivo de camuflagem."
	descriptionen = "You've hidden a camouflage device."
	specialitem = /obj/item/weapon/cloaking_device

/datum/special/childworker
	limitations = "Adultos"
	limitationsen = "Grown-up Males"
	description = "Você passou sua infância trabalhando como um construtor numa obra."
	descriptionen = "You've spent your entire childhood as a worker on a construction site."

/datum/special/michaelshepard
	name = "michaelshepard"
	limitations = "Bums"
	limitationsen = "Bums"
	description = "Michael Shepard"
	descriptionen = "Michael Shepard."

/datum/special/proficientkicker
	description = "Você chuta muito bem."
	descriptionen = "You're a proficient kicker."

/datum/special/hygiene
	name = "hygiene"
	description = "Você é bem fedido."
	descriptionen = "You smell terrible and unable to do anything about it."

/datum/special/blueblood
	name = "blueblood"
	description = "Você vem de uma família nobre no norte, você é de sangue nobre."
	descriptionen = "You come from a noble family from the north, you're noble blood."

/datum/special/silverobols
	name = "silverobol"
	description = "Você escondeu obols de prata em algum lugar para as noites difíceis."
	specialitem = /obj/item/weapon/spacecash/silver/c20
	descriptionen = "You've hidden some silver obols in the safest place - just for rainy day."

/datum/special/naturalgenius
	name = "naturalgenius"
	description = "Você é um gênio não reconhecido."
	descriptionen = "You're an unrecognized genius."

/datum/special/naturalwarrior
	name = "naturalwarrior"
	description = "Você é um guerreiro nato."
	descriptionen = "You're a natural born warrior."

/datum/special/goodheart
	name = "goodheart"
	description = " You have a healthy heart."
	descriptionen = "You have a healthy heart."

/datum/special/doublewp
	name = "doublewp"
	description = "Noone could ever stop you. You gain double bonuses with Willpower."
	descriptionen = "Noone could ever stop you. You gain double bonuses with Willpower."

/datum/special/hiddengun
	name = "hiddengun"
	description = "Você tem uma arma escondida em algum lugar."
	descriptionen = "You've hidden a gun somewhere."
	specialitem = /obj/item/weapon/gun/projectile/newRevolver/duelista/neoclassic

/datum/special/weirdregurgi
	name = "weirdregurgi"
	description = "Você é obscecado por um sonho estranho em que você é engulido por um regurgitator."
	descriptionen = "You are obsessed with a weird dream where you're caught by a regurgitator."

/*/datum/special/missingrightarm
	name = "missingrightarm"
	description = "Você tinha perdido seu braço direito por uns anos, agora ambas suas mãos são igualmente ágeis."
	descriptionen = "You were missing your right arm for a couple of years. Now both your hands are equally agile."*/

/datum/special/deathweb
	name = "deathweb"
	description = "You are deathly afraid of the lifeweb. Being put into it would have catastrophic results."
	descriptionen = "You are deathly afraid of the lifeweb. Being put into it would have catastrophic results."

/datum/special/bulletdodger
	name = "bulletdodger"
	description = "Eles te chamam de Bullet Dodger, é difícil de você levar um tiro."
	descriptionen = "They call you the Bullet Dodger. It's harder for you to get shot."

/datum/special/gunnorth
	name = "gunnorth"
	description = "Eles te chamam de pistoleiro mais ágil do sul."
	descriptionen = "They call you the fastest gun in the South."

/datum/special/merchunt
	name = "merchunt"
	description = "Você cometeu uns erros, mercenários vão te caçar."
	descriptionen = "You've made some mistakes. Mercenaries will hunt you down."

/datum/special/oathsilence
	name = "oathsilence"
	limitations = "Pós-Cristão"
	description = "Você fez um voto de silêncio."
	descriptionen = "You gave an oath of silence."

/datum/special/alcoholicsober
	name = "alcoholicsober"
	description = "Você não é um alcoolatra, mas as coisas vão mal quando você está sóbrio."
	descriptionen = "You're not an alcoholic, but work doesn't go well when you're sober.."

/datum/special/looksmart
	name = "looksmart"
	description = "Você não parece inteligente."
	descriptionen = "You don't look smart."

/datum/special/semiteblood
	name = "semiteblood"
	description = "O sangue semita antigo fala em você, permitindo estimar o valor de um item à vontade."
	descriptionen = "Ancient semite blood speaks in you, allowing to estimate an item's value at ease. "

/datum/special/dst
	name = "dst"
	limitations = "Vadias Mulheres."
	limitationsen = "Female Whore."
	description = "Você tem uma DST mortal, transmita para 6 homens, sobreviva."
	descriptionen = "You carry a deadly STD. Give it to 6 lucky men. Survive."
	reward = "10 Cromossomos"
	rewarden = "10 Chromosomes"

/datum/special/unmarriedwoman
	name = "unmarriedwoman"
	limitations = "Mulheres Solteiras"
	limitationsen = "Unmarried women"
	description = "Procure um marido. Escape na Charon ou compre uma passagem para Vinfort."
	descriptionen = "Find a husband. Escape on the Babylon shuttle or have a ticket to Vinfort."
	reward = "5 Cromossomos"
	rewarden = "5 Chromosomes"

/datum/special/orphanbum
	name = "orphanbum"
	limitations = "Mendigo"
	limitationsen = "Bum"
	description = "Você é agente dos Órfãos, uma organização proscrita. A sociedade pensa que você é um mal puro, que você é pior do que os hereges. Mas você tem apenas boas intenções e no caminho certo para encontrar a verdade - todas as mentiras contra você apenas confirmam isso. Complete sua missão e escape na Charon ou compre uma passagem para Vinfort."
	descriptionen = "You're an Agent of the Orphans, a proscribed organisation. The society thinks that you are a pure evil, that you're worse than heretics. But you have only good intentions and on the right way to finding the truth - all the lies against you just confirm this. Complete your mission, and escape on the Babylon shuttle or have a ticket to Vinfort."
	reward = "5 Cromossomos"
	rewarden = "5 Chromosomes"

/datum/special/baronsurvive
	name = "baronsurvive"
	limitations = "Tiamat"
	limitationsen = "Tiamat"
	description = "Make sure the Baron survives. Survive."
	descriptionen = "Make sure the Baron survives. Survive."
	reward = "2 Cromossomos"
	rewarden = "2 Chromosomes"

/datum/special/amusermany
	name = "amusermany"
	limitations = "Amuser"
	limitationsen = "Amuser"
	description = "Being a new traveller on this path, you should gather experience and good reputation. Survive, and you'll get +1 CHR for every client you serve tonight."
	descriptionen = "Being a new traveller on this path, you should gather experience and good reputation. Survive, and you'll get +1 CHR for every client you serve tonight."
	reward = ""
	rewarden = ""

/datum/special/gloves
	name = "gloves"
	description = "Você tem alguns planos vis. Você teve que comprar luvas para evitar deixar impressões digitais."
	descriptionen = "You have some vile plans. You had to buy gloves to avoid leaving fingerprints."

/datum/special/screamerimmunity
	name = "screamerimmunity"
	description = "You were once badly bitten by a screamer, but you never became one of them."
	descriptionen = "You were once badly bitten by a screamer, but you never became one of them."

/datum/special/screamercurse
	name = "screamercurse"
	description = "A witch has cast a terrible spell on you - When you die, you will surely become a screamer."
	descriptionen = "A witch has cast a terrible spell on you - When you die, you will surely become a screamer."

/datum/special/robusta
	name = "robusta"
	limitations = "Apenas mulheres."
	limitationsen = "Only females."
	description = "Anos de Lutas intensas e treinamento para suportar seu ego obsessivo te deixaram incrivelmente melhor no combate."
	descriptionen = "Years of intense fighting and training to feed your obsessive ego have left you incredibly better in combat."

/datum/special/squireadult
	name = "squireadult"
	limitations = "Squires"
	limitationsen = "Squires"
	description = "What a disgrace! You're a grown up man and still a squire."
	descriptionen = "What a disgrace! You're a grown up man and still a squire."

/datum/special/jesterdecree
	name = "jesterdecree"
	limitations = "Bobo da Corte."
	limitationsen = "Jester."
	description = "Quando o barão não está presente, você faz decretos por ele."
	descriptionen = "When the baron is away, you make decrees for him."

/*/datum/special/bloodchildcollect
	name = "bloodchildcollect"
	limitations = "Crianças."
	limitationsen = "Children."
	description = "Grown-ups always tell you that God is good and important, and you always should help Him. You've agreed to collect blood for the recently arrived Inquisition squad."
	descriptionen = "Grown-ups always tell you that God is good and important, and you always should help Him. You've agreed to collect blood for the recently arrived Inquisition squad."*/

/datum/special/censormagnum
	name = "censormagnum"
	limitations = "Marduk."
	limitationsen = "Marduk."
	description = "Até um homem forte como você precisa de um ajudante. Você está sendo assistido por uma pistola Magnum 66."
	descriptionen = "Even a strongman like you require a helper. You are being assisted by a Magnum 66 pistol."
/*
/datum/special/succubus
	name = "succubus"
	limitations = "Grown Females."
	limitationsen = "Grown Females."
	description = "You're a succubus, able to enslave men through your bedroom tricks."
	descriptionen = "You're a succubus, able to enslave men through your bedroom tricks."
*/
/datum/special/archmortus
	name = "archmortus"
	limitations = "Mortus."
	limitationsen = "Mortus."
	description = "Você é o Archmortus. Forte, legal e respeitável, você conseguiu forçar a nobreza a ascender você a este título inexistente."
	descriptionen = "You're the Archmortus. Strong, cool and respectable, you've managed to force the nobility to ascend you to this non-existing title."

/datum/special/novice
	name = "novice"
	description = "A autodisciplina e a cautela fizeram com que você evitasse muitos erros. Você não tem vícios."
	descriptionen = "Self-discipline and caution have made you stay from many mistakes. You have no vices."

/datum/special/grandma
	name = "grandma"
	description = "During your childhood you had to treat your ill grandma. You've learned a lot about medicine and surgery, but your grandma died in terrible pain."
	descriptionen = "During your childhood you had to treat your ill grandma. You've learned a lot about medicine and surgery, but your grandma died in terrible pain."

/datum/special/fragile
	name = "fragile"
	description = "Você é uma coisinha frágil."
	descriptionen = "You are a fragile thing."

/datum/special/scaredark
	name = "scaredark"
	description = "You know what kind of things can lure in the shadows. You cannot stand to be in the dark."
	descriptionen = "You know what kind of things can lure in the shadows. You cannot stand to be in the dark."

/datum/special/youlooksick
	name = "youlooksick"
	description = "You look sick."
	descriptionen = "You look sick."

/datum/special/needhurry
	name = "needhurry"
	description = "No need to hurry. You walk slowly but you don't get tired that much."
	descriptionen = "No need to hurry. You walk slowly but you don't get tired that much."

/datum/special/sailor
	name = "sailor"
	description = "During your childhood, you've met a sailor. He promised to take you on a cruise around the subterranean waters of evergreen. But then he got drunk and pushed you into a toilet pit. Since then, you are deadly afraid of drowning."
	descriptionen = "During your childhood, you've met a sailor. He promised to take you on a cruise around the subterranean waters of evergreen. But then he got drunk and pushed you into a toilet pit. Since then, you are deadly afraid of drowning."

/datum/special/paingain
	name = "paingain"
	description = "Pain has finally transformed into gain. You're in a good physical shape."
	descriptionen = "Pain has finally transformed into gain. You're in a good physical shape."

/datum/special/piercinggaze
	name = "piercinggaze"
	description = "Você viu coisas em que as pessoas não acreditariam. Como resultado, seu olhar penetrante coloca terror em sua alma."
	descriptionen = "You've seen things they people wouldn't believe. As a result, your piercing gaze puts terror into their soul."

/datum/special/perception
	name = "perception"
	description = "You are able to notice little things fast."
	descriptionen = "You are able to notice little things fast."

/datum/special/avantgarde
	name = "avantgarde"
	description = "Your grandfather has enjoyed his experiments with avantgarde perfume. You don't notice the stink anymore."
	descriptionen = "Your grandfather has enjoyed his experiments with avantgarde perfume. You don't notice the stink anymore."

/datum/special/interestingperson
	name = "interestingperson"
	description = "You're an interesting person. -2 and +2 to stats."
	descriptionen = "You're an interesting person. -2 and +2 to stats."

/datum/special/badshape
	name = "badshape"
	description = "You should have been paying more attention to yourself. You're in a bad physical shape."
	descriptionen = "You should have been paying more attention to yourself. You're in a bad physical shape."

/datum/special/wormcrawl
	name = "wormcrawl"
	description = "You are scared of worms and you hate them. No one in the world could make you crawl."
	descriptionen = "You are scared of worms and you hate them. No one in the world could make you crawl."

/datum/special/robustmeister
	name = "robustmeister"
	limitations = "Meister"
	limitationsen = "Meister"
	description = "You're robust enough for a Meister."
	descriptionen = "You're robust enough for a Meister."

/datum/special/maleamuser
	name = "maleamuser"
	limitations = "Amuser."
	limitationsen = "Amuser."
	description = "Thanks to your pretty face and playful character, you've achieved the rank of an Amuser."
	descriptionen = "Thanks to your pretty face and playful character, you've achieved the rank of an Amuser."

/datum/special/little_sherif
	name = "littlesheriff"
	limitations = "Sheriff."
	limitationsen = "Sheriff."
	description = "While you may be young, your just actions and love for the law have given you the opportunity to become Sheriff."
	descriptionen = "While you may be young, your just actions and love for the law have given you the opportunity to become Sheriff."

/datum/special/rich
	name = "rich"
	limitations = "Bookkeeper or Grayhound."
	limitationsen = "Bookkeeper or Grayhound."
	description = "You have a task this night, get 5000 obols on merchant's console, and make your dream come true!"
	descriptionen = "You have a task this night, get 5000 obols on merchant's console, and make your dream come true!"
	reward = "10 Cromossomos"
	rewarden = "10 Chromosomes"

/datum/special/rebelsuccessor
	name = "rebelsuccessor"
	limitations = "Adult Successor."
	limitationsen = "Adult Successor."
	description = "You are a rebellious successor. Screw noble customs."
	descriptionen = "You are a rebellious successor. Screw noble customs."

/datum/special/castrated
	name = "castrated"
	limitations = "Adult Males."
	limitationsen = "Adult Males."
	description = "You've lost your manhood."
	descriptionen = "You've lost your manhood."

/datum/special/circusfreak
	name = "circusfreak"
	limitations = "Adults."
	limitationsen = "Adults."
	description = "You were raised by itinerant performers and acrobats. Knife throwing, gymnastics, rope-walking."
	descriptionen = "You were raised by itinerant performers and acrobats. Knife throwing, gymnastics, and rope-walking."

/datum/special/doinked
	name = "doinked"
	limitations = "Females."
	limitationsen = "Females."
	description = "You have something extra."
	descriptionen = "You have something extra."

/mob/living/carbon/human/proc/special_load()
	if(special)
		switch(special)
/*			if("succubus")
				if(gender == FEMALE && age >= 18)
					isSuccubus = TRUE
					to_chat(src, "<span class='bname'>You're a succubus.</span>")
					to_chat(src, " Able to enslave men through your bedroom tricks, check the Spider tab to check on your powers.")
					src.verbs += /mob/living/carbon/human/proc/teleportSlaves
					src.updatePig()*/
			if("notafraid")
				//code aqui
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
			if("Allah")
				//code aqui
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.religion = "Allah"
			if("hygiene")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.hygiene = -400
			if("silverobols")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
			if("interestingperson")
				src.my_stats.st += rand(-2,2)
				src.my_stats.dx += rand(-2,2)
				src.my_stats.pr += rand(-2,2)
				src.my_stats.ht += rand(-2,2)
				src.my_stats.im += rand(-2,2)
				src.my_stats.it += rand(-2,2)
			if("badshape")
				src.my_stats.ht -= 2
				src.my_stats.st -= 2
			if("blueblood")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.add_event("nobleblood", /datum/happiness_event/noble_blood)
			if("naturalgenius")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.my_stats.it = rand(14, 18)
				if(check_perk(/datum/perk/illiterate))
					src.perks.Remove(locate(/datum/perk/illiterate) in src.perks)
				add_perk(/datum/perk/ref/teaching)
			if("naturalwarrior")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.my_stats.st += rand(1,1)
				src.my_stats.ht += rand(2,2)
				src.my_stats.dx += rand(2,2)
				src.my_skills.ADD_SKILL(SKILL_MELEE, 5)
				src.my_skills.ADD_SKILL(SKILL_RANGE, 5)
			if("screamerimmunity")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				add_perk(/datum/perk/screamerimmunity)
			if("comicsans")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.comic_sans = TRUE
			if("robustmeister")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				if(src.job == "Meister")
					src.my_stats.st += 2
					src.my_stats.ht += 3
					src.my_stats.dx += 4
					src.my_skills.ADD_SKILL(SKILL_MELEE, 6)
			if("squireheir")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				if(src.job == "Heir")
					src.my_skills.ADD_SKILL(SKILL_MELEE, 4)
					src.my_skills.ADD_SKILL(SKILL_RANGE, 4)
					src.my_stats.st += rand(2,3)
					equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/security/marduk_alt2(src), slot_wear_suit)
			if("michaelshepard")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				if(src.job == "Bum")
					real_name = "Michael Shepard"
					my_skills.ADD_SKILL(SKILL_MELEE, 6)
					my_stats.st += 6
					my_stats.ht += 6
					my_stats.dx += 6
					name = "Michael Shepard"
					gender = MALE
					job = "Bum"
					voice_name = "Michael Shepard"
					equip_to_slot_or_del(new /obj/item/clothing/suit/chickensuit(src), slot_wear_suit)
					equip_to_slot_or_del(new /obj/item/clothing/mask/chicken(src), slot_wear_mask)
					var/bumweapon = pick("knife","club","limb")
					switch(bumweapon)
						if("knife")
							if(prob(50))
								equip_to_slot_or_del(new /obj/item/weapon/kitchen/utensil/knife/dagger/copper(src), slot_r_hand)
							else
								equip_to_slot_or_del(new /obj/item/weapon/kitchen/utensil/knife(src), slot_r_hand)
						if("club")
							equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/woodenclub(src), slot_r_hand)
						if("limb")
							equip_to_slot_or_del(new /obj/item/weapon/organ/l_leg(src), slot_r_hand)
			if("perception")
				src.my_stats.pr = rand(16,20)
			if("paingain")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.my_stats.st += 3
				src.my_stats.ht += 2
			if("grandma")
				src.my_skills.ADD_SKILL(SKILL_SURG, 12)
				src.my_skills.ADD_SKILL(SKILL_MEDIC, 12)
			if("hiddengun")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.special_item = pick(/obj/item/weapon/gun/projectile/newRevolver/duelista/neoclassic,/obj/item/weapon/gun/projectile/automatic/pistol/ml23,/obj/item/weapon/gun/projectile/automatic/pistol/ml23/gold, /obj/item/weapon/gun/projectile/automatic/pistol/magnum66, /obj/item/weapon/gun/projectile/automatic/pistol/magnum66/screamer23, /obj/item/weapon/gun/projectile/automatic/pistol/magnum66/mother)
			if("weirdregurgi")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
			/*if("missingrightarm")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.my_stats.dx += 3*/
			if("bulletdodger")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.my_stats.dx += 3
				src.name = "[src.real_name] Bullet Dodger"
			if("gunnorth")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.my_skills.CHANGE_SKILL(SKILL_RANGE, 17)
			if("goodheart")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.my_stats.ht += rand(2,3)
			if("merchunt")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
			if("alcoholicsober")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.vice = "Alcoholic"
			if("oathsilence")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
			if("looksmart")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.my_stats.it = rand(3,5)
			if("semiteblood")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				//src.jewish = TRUE
				src.add_perk(/datum/perk/ref/value)
			/*if("bloodchildcollect")
				src.equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet/eng(src), slot_wrist_r)
				src.equip_to_slot_or_del(new /obj/item/weapon/reagent_containers/syringe/blood_snatcher, slot_r_hand)*/
			if("dst")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				if(src.job == "Amuser")
					src.contract_disease(new /datum/disease/aids,1,0)
			if("orphanbum")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				if(src.job == "Bum")
					src.my_stats.st = rand(11,13)
					src.my_stats.ht = rand(13,14)
					src.my_stats.dx = rand(13,14)
					src.my_skills.ADD_SKILL(SKILL_MELEE, rand(8,11))
					src.my_skills.ADD_SKILL(SKILL_RANGE, rand(8,11))
			if("gloves")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.equip_to_slot_or_del(new /obj/item/clothing/gloves/black(src), slot_gloves)
			if("robusta")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				if(src.gender == FEMALE)
					src.my_skills.ADD_SKILL(SKILL_MELEE, 2)
					src.my_stats.st += 3
					src.my_stats.ht += 1
					src.virgin = 0
			if("fragile")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.my_stats.ht -= 4
			if("doublewp")
				src.add_perk(/datum/perk/heroiceffort)
			if("bouncer")
				var/haspusher = FALSE
				for(var/mob/living/carbon/human/H in mob_list)
					if(H.job == "Pusher")
						haspusher = TRUE
				if(src.job == "Tiamat" && haspusher == TRUE)
					if(src.wear_suit)
						qdel(src.wear_suit)
					if(src.wrist_r)
						qdel(src.wrist_r)
					if(src.belt)
						qdel(src.belt)
					if(src.r_hand)
						qdel(src.r_hand)
					src.equip_to_slot_or_del(new /obj/item/clothing/suit/storage/redjacket(src), slot_wear_suit)
					src.equip_to_slot_or_del(new /obj/item/weapon/melee/classic_baton/woodenclub(src), slot_belt)
					src.equip_to_slot_or_del(new /obj/item/clothing/mask/cigarette/weed(src), slot_r_hand)
					equip_to_slot_or_del(new /obj/item/device/radio/headset/bracelet(src), slot_wrist_r)
					src.my_skills.CHANGE_SKILL(SKILL_SWING, rand(1,3))
					src.my_skills.CHANGE_SKILL(SKILL_UNARM, rand(1,3))
					src.assignment = "Bouncer"
					if(wear_id)
						var/obj/item/weapon/card/id/R = wear_id
						R.registered_name = real_name
						R.rank = job
						R.assignment = src.assignment
						R.name = "[R.registered_name]'s Ring"
						R.access = list(brothel, amuser)
						qdel(src.wear_id)
						src.equip_to_slot_or_del(R, slot_wear_id)
					for(var/obj/effect/landmark/start/S in landmarks_list)
						if(S.name == "Bouncer")
							src.forceMove(S.loc)
							break
			if("censormagnum")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				if(src.job == "Marduk")
					src.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/automatic/pistol/magnum66(src), slot_l_hand)
			if("novice")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.vice = ""
			if("childworker")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				src.my_skills.CHANGE_SKILL(SKILL_MASON, rand(12,14))
				src.my_skills.CHANGE_SKILL(SKILL_ENGINE, rand(12,14))
			if("succubus")
				if(src.gender == "female")
					src.make_succubi()
			if("gigantism")
				src.Altista()
			if("archmortus")
				warning("Special de: [ckey ? "CKEY: [ckey]" : "SEM CKEY"] carregou.")
				if(src.job == "Mortus")
					src.assignment = "Archmortus"
					src.equip_to_slot_or_del(new /obj/item/clothing/mask/plaguedoctor(src), slot_wear_mask)
					src.my_skills.ADD_SKILL(SKILL_MELEE, 2)
					src.my_stats.st += 2
					src.my_stats.ht += 1
					src.my_stats.dx += 1
					src.my_stats.it += 1

					src.my_stats.initst = src.my_stats.st
					src.my_stats.initht = src.my_stats.ht
					src.my_stats.initdx = src.my_stats.dx
					src.my_stats.initit = src.my_stats.it
					for(var/obj/effect/landmark/start/S in landmarks_list)
						if(S.name == "Archmortus")
							src.forceMove(S.loc)
							break
			if("squireadult")
				return
			if("maleamuser")
				if(src.job == "Amuser")
					src.set_species("Femboy")
			if("littlesheriff")
				if(src.job == "Sheriff")
					src.set_species("Child")
					if(src.wear_suit)
						qdel(src.wear_suit)
					if(src.shoes)
						qdel(src.shoes)
					if(src.w_uniform)
						qdel(src.w_uniform)
					if(src.head)
						qdel(src.head)
					if(src.belt)
						qdel(src.belt)
					src.equip_to_slot_or_del(new /obj/item/clothing/under/child_jumpsuit(src), slot_w_uniform)
					src.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/vest/squire(src), slot_wear_suit)
					src.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/child/shoes(src), slot_shoes)
					src.equip_to_slot_or_del(new /obj/item/weapon/gun/projectile/newRevolver/duelista/neoclassic(src), slot_belt)
					src.equip_to_slot_or_del(new /obj/item/ammo_magazine/box/c38(src), slot_r_store)

					src.my_stats.st = rand(8,9)
					src.my_stats.ht = rand(8,9)
					src.my_stats.dx = rand(12,13)
					src.my_stats.it = rand(8,11)
					src.my_stats.pr = rand(12,14)
			if("rebelsuccessor")
				if(src.job == "Successor" && src.age >= 18)
					if(src.wear_suit)
						qdel(src.wear_suit)
					if(src.shoes)
						qdel(src.shoes)
					if(src.w_uniform)
						qdel(src.w_uniform)
					if(src.amulet)
						qdel(src.amulet)
					src.equip_to_slot_or_del(new /obj/item/clothing/under/rebelsuccessor(src), slot_w_uniform)
					src.equip_to_slot_or_del(new /obj/item/clothing/head/amulet/collar(src), slot_amulet)
					src.equip_to_slot_or_del(new /obj/item/clothing/shoes/lw/stiletto_shoes(src), slot_shoes)
					src.equip_to_slot_or_del(new /obj/item/clothing/suit/rebelsuccessor(src), slot_wear_suit)
					src.my_skills.ADD_SKILL(SKILL_PARTY, rand(12,15))
					src.my_skills.ADD_SKILL(SKILL_MELEE, 6)
					src.my_stats.st += 3
			if("castrated")
				if(src.age >= 18 && src.gender == MALE)
					src.mutilated_genitals = 1
			if("circusfreak")
				if(src.age >= 18)
					src.my_skills.ADD_SKILL(SKILL_MUSIC, 13)
					src.my_skills.ADD_SKILL(SKILL_CLIMB, 13)
					src.my_skills.ADD_SKILL(SKILL_THROW, 15)
					src.my_stats.dx += rand(3)
					src.acrobat = 1
			if("doinked")
				if(src.gender == FEMALE)
					src.futa = TRUE


	else
		warning("Special de: [ckey ? "CKEY: [ckey]" : "ERROR"] não carregou.")
