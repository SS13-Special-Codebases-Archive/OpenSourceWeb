/datum/happiness_event
	var/description
	var/happiness = 0
	var/timeout = 0

///For descriptions, use the span classes bold info, info, none, warning and boldwarning in order from great to horrible.

/datum/happiness_event/noble_blood
	description = "<span class='goodmood'>• <span class='passivebold'>Noble blood flows through my veins!</span>\n"
	happiness = 2

//nutrition
/datum/happiness_event/nutrition/fat
	description = "<span class='badmood'>• I'm so fat..</span>\n" //muh fatshaming <---- QUEM FEZ ESSE COMMENT É UM GORDO DE MERDA <--- esse cara ta falando a verdade
	happiness = -4

/datum/happiness_event/nutrition/goodfood
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I've tasted a lavish meal recently!</span>\n"
	happiness = 3
	timeout = 1800

/datum/happiness_event/nutrition/wellfed
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I'm stuffed. It feels good.</span>\n"
	happiness = 4

/datum/happiness_event/nutrition/fed
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I have recently had some food.</span>\n"
	happiness = 2

/datum/happiness_event/nutrition/bithungry
	description = "<span class='badmood'>• I'm getting a bit hungry.</span>\n"
	happiness = -2

/datum/happiness_event/nutrition/hungry
	description = "<span class='badmood'>• I'm hungry.</span>\n"
	happiness = -4

/datum/happiness_event/nutrition/starving
	description = "<span class='badmood'>• I'm starving!</span>\n"
	happiness = -12

/datum/happiness_event/nutrition/humanflesh
	description = "<span class='badmood'>• I've ate human flesh!</span>\n"
	happiness = -4
	timeout = 3000

/datum/happiness_event/nutrition/badtaste
	description = "<span class='badmood'>• This tastes like shit!</span>\n"
	happiness = -1
	timeout = 1800


//Hygiene
/datum/happiness_event/hygiene/clean
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I feel so clean!</span>\n"
	happiness = 2

/datum/happiness_event/hygiene/smelly
	description = "<span class='ifeelsick'>• I smell like shit.</span>\n"
	happiness = -5

/datum/happiness_event/hygiene/vomitted
	description = "<span class='ifeelsick'>• Ugh, I've vomitted.</span>\n"
	happiness = -5
	timeout = 1800


/datum/happiness_event/misc/tired
	description = "<span class='badmood'><b>• I need some sleep.</span></b>\n"
	happiness = -20

/datum/happiness_event/misc/weed
	description = "<span class='goodmood'>•</span> <span class='passivebold'>That's some good weed.</span>\n"
	happiness = 15

/datum/happiness_event/misc/better
	description = "<span class='goodmood'>•</span> <span class='passivebold'>Feels better.</span>\n"
	happiness = 15
	timeout = 9000

/datum/happiness_event/misc/argh
	description = "<span class='goodmood'>•</span> <span class='passivebold'>O-a.</span>\n"
	happiness = 15
	timeout = 9000

/datum/happiness_event/misc/woo
	description = "<span class='goodmood'>•</span> <span class='passivebold'>WOO!</span>\n"
	happiness = 15
	timeout = 9000

/datum/happiness_event/misc/jestbad
	description = "<span class='badmood'><b>• Fuck you, you fucking jester copetti.</span></b>\n"
	happiness = -20

/datum/happiness_event/misc/jestgood
	description = "<span class='goodmood'>•</span> <span class='passivebold'>That's pretty. Thank comatic it didn't blow up!</span>\n"
	happiness = 15


/datum/happiness_event/misc/iwanttodie
	description = "<span class='badmood'><b>• I want to die.</span></b>\n"
	happiness = -1
	timeout = 600

/datum/happiness_event/misc/lost
	description = "<span class='badmood'>• I've lost!</span>\n"
	happiness = -2
	timeout = 3000

/datum/happiness_event/misc/realcup
	description = "<span class='badmood'><b>• I need my goblet.</span></b>\n"
	happiness = -1
	timeout = 600

/datum/happiness_event/misc/spoon
	description = "<span class='badmood'><b>• I... HATE Eating with smerd cutlery.</span></b>\n"
	happiness = -1
	timeout = 600

/datum/happiness_event/misc/ravenheart
	description = "<span class='badmood'><b>• I will miss Ravenheart.</span></b>\n"
	happiness = -2
	timeout = 4000


/datum/happiness_event/misc/ivefailed
	description = "<span class='badmood'><b>• I failed.</span></b>\n"
	happiness = -2
	timeout = 300

//Disgust
/datum/happiness_event/disgust/gross
	description = "<span class='ifeelsick'>• That was gross.</span>\n"
	happiness = -2
	timeout = 1800

/datum/happiness_event/disgust/verygross
	description = "<span class='ifeelsick'>• I think I'm going to puke...</span>\n"
	happiness = -4
	timeout = 1800

/datum/happiness_event/disgust/disgusted
	description = "<span class='ifeelsick'>• Oh god, that's disgusting...</span>\n"
	happiness = -6
	timeout = 1800

/datum/happiness_event/disgust/terriblethings
	description = "<span class='badmood'>• I saw terrible things.</span>\n"
	happiness = -4
	timeout = 1800

/datum/happiness_event/disgust/death
	description = "<span class='badmood'>• I saw someone die!</span>\n"
	happiness = -8
	timeout = 2400

//Generic events
/datum/happiness_event/favorite_food
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I really liked eating that.</span>\n"
	happiness = 3
	timeout = 2400

/datum/happiness_event/nice_shower
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I had a nice shower.</span>\n"
	happiness = 1
	timeout = 1800

/datum/happiness_event/handcuffed
	description = "<span class='badmood'>• I guess my antics finally caught up with me..</span>\n"
	happiness = -1

/datum/happiness_event/booze
	description = "<span class='goodmood'>•</span> <span class='passivebold'>Alcohol makes the universe lighter.</span>\n"
	happiness = 3
	timeout = 2400

/datum/happiness_event/relaxed//For nicotine.
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I feel relaxed.</span>\n"
	happiness = 1
	timeout = 1800

/datum/happiness_event/blessed
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I'm blessed!</span>\n"
	happiness = 2
	timeout = 65000

/datum/happiness_event/badblessed
	description = "<span class='badmood'>• I've been defiled by a bible!</span>\n"
	happiness = -6
	timeout = 800

/datum/happiness_event/martyr
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I am god's martyr!</span>\n"
	happiness = 6
	timeout = 800

/datum/happiness_event/mentallytired
	description = "<span class='badmood'>• I feel mentally tired! I must sleep.</span>\n"
	happiness = -4
	timeout = INFINITY

//Embarassment
/datum/happiness_event/hygiene/shit
	description = "<span class='ifeelsick'>• I shit myself. How embarassing.</span>\n"
	happiness = -12
	timeout = 1800

/datum/happiness_event/hygiene/pee
	description = "<span class='ifeelsick'>• I pissed myself. How embarassing.</span>\n"
	happiness = -12
	timeout = 1800

/datum/happiness_event/badsex
	description = "<span class='badmood'>• Ugh, that sex was horrible.</span>\n"
	happiness = -4
	timeout = 1800

/datum/happiness_event/learningfail
	description = "<span class='badmood'>• I couldn't learn anything, I feel so dumb!</span>\n"
	happiness = -4
	timeout = 300

/datum/happiness_event/damned
	description = "<span class='badmood'>• I've been damned for my whole life!</span>\n"
	happiness = -8
	timeout = 1900

/datum/happiness_event/excom
	description = "<span class='badmood'>• I've been excommunicated, I will never find salvation!</span>\n"
	happiness = -12
	timeout = INFINITY

/datum/happiness_event/excomthanati
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I've been excommunicated, thank you Tzchernobog!</span>\n"
	happiness = 4
	timeout = INFINITY

/datum/happiness_event/excomothers
	description = "<span class='badmood'>• I must kill the excommunicated!</span>\n" //replaced with their name at runtime.
	happiness = -1
	timeout = INFINITY

/datum/happiness_event/excomdead
	description = "<span class='goodmood'>•</span> <span class='passivebold'> The heretic is dead, <B>God be saved!</B></span>\n"
	happiness = 4
	timeout = 1800

/datum/happiness_event/thanati
	description = "<span class='goodmood'>•</span> <span class='passivebold'> Another one dies! <B>Praise the Overlord!</B></span>\n"
	happiness = 4
	timeout = 1800


/datum/happiness_event/imposter
	description = "<span class='goodmood'>•</span> <span class='passivebold'> Feels good being the traitor!</span>\n"
	happiness = 4
	timeout = INFINITY

/datum/happiness_event/imposterbad
	description = "<span class='badmood'>• We have been betrayed!</span>\n"
	happiness = -4
	timeout = INFINITY

/datum/happiness_event/whipchurch
	description = "<span class='goodmood'>•</span> <span class='passivebold'>God smiles at me.</span>\n"
	happiness = 4
	timeout = INFINITY

/datum/happiness_event/gmyza
	description = "<span class='badmood'>•Hey, I am not a gmyza!</span>\n"
	happiness = -1
	timeout = 800

/datum/happiness_event/copetti
	description = "<span class='badmood'>•Hey, I am not a copetti!</span>\n"
	happiness = -4
	timeout = 800

/datum/happiness_event/hug
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I have received a nice hug!</span>\n"
	happiness = 2
	timeout = 600

/datum/happiness_event/respect
	description = "<span class='goodmood'>•</span> <span class='passivebold'>Smerds give me the respect I deserve!</span>\n"
	happiness = 2
	timeout = 600

//Good sex here too because why not.
/datum/happiness_event/goodsex
	description = "<span class='goodmood'>•</span> <span class='passivebold'>That sex was really good!\n"
	happiness = 4
	timeout = 1800

/datum/happiness_event/regurgipleasure
	description = "<span class='goodmood'>•</span> <span class='passivebold'>That felt really good!\n"
	happiness = 4

/datum/happiness_event/magazinepleasure
	description = "<span class='goodmood'>•</span> <span class='passivebold'>That felt really good!\n"
	happiness = 4
	timeout = 1800

//Unused so far but I want to remember them to use them later.
/datum/happiness_event/disturbing
	description = "● I recently saw something disturbing</span>\n"
	happiness = -2

/datum/happiness_event/clown
	description = "● I recently saw a funny clown!</span>\n"
	happiness = 1

/datum/happiness_event/cloned_corpse
	description = "● I recently saw my own corpse...</span>\n"
	happiness = -6

/datum/happiness_event/surgery
	description = "<span class='badmood'>• HE'S CUTTING ME OPEN!!</span>\n"
	happiness = -8

//MISC

/datum/happiness_event/misc/sheriff
	description = "<span class='badmood'>• I hate this fortress! I can't wait to get out of here.</span>\n"
	happiness = -12

/datum/happiness_event/misc/barondead
	description = "<span class='badmood'>• Our baron is dead, what comes next?!</span>\n"
	happiness = -3

/datum/happiness_event/misc/shattereddreams
	description = "<span class='badmood'>• Poor Morgan James!</span>\n"
	happiness = -7

/datum/happiness_event/misc/lorddead
	description = "<span class='badmood'>• Our lord is dead, what comes next?!</span>\n"
	happiness = -7

/datum/happiness_event/misc/coronated
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I've been coronated.</span>\n"
	happiness = 12

/datum/happiness_event/misc/pregnantgood
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I'm probably pregnant!</span>\n"
	happiness = 5

/datum/happiness_event/misc/sheekos
	description = "<span class='goodmood'>•</span> <span class='passivebold'>Sheekos!</span>\n"
	happiness = 5

/datum/happiness_event/misc/godsave
	description = "<span class='goodmood'>•</span> <span class='passivebold'>God will save me.</span>\n"
	happiness = 5

/datum/happiness_event/misc/donate
	description = "<span class='goodmood'>•</span> <span class='passivebold'>I'm helping the lord.</span>\n"
	happiness = 5

/datum/happiness_event/misc/pregnantbad
	description = "<span class='badmood'>• I'm probably pregnant, oh no!</span>\n"
	happiness = -5

/datum/happiness_event/misc/needsex
	description = "<span class='badmood'>• I NEED SOMEONE TO FUCK!</span>\n"
	happiness = -30


//VICE
/datum/happiness_event/reflect
	description = "<span class='badmood'>• I need to reflect my experience.</span>\n"
	happiness = -3

/datum/happiness_event/vice/smoke
	description = "<span class='badmood'>• I need a smoke.</span>\n"
	happiness = -15

/datum/happiness_event/vice/weed
	description = "<span class='badmood'>• I need some weed..</span>\n"
	happiness = -15


/datum/happiness_event/vice/klepto
	description = "<span class='badmood'>• I need to steal from someone.</span>\n"
	happiness = -15


/datum/happiness_event/vice/photo
	description = "<span class='badmood'>• I need to take a picture of someone.</span>\n"
	happiness = -15

/datum/happiness_event/vice/kiss
	description = "<span class='badmood'>• I need a kiss from someone.</span>\n"
	happiness = -15


/datum/happiness_event/vice/necro
	description = "<span class='badmood'>• I need someone more rotten than me.</span>\n"
	happiness = -15

/datum/happiness_event/vice/pyromaniac
	description = "<span class='badmood'>• I need to see the world burn.</span>\n"
	happiness = -15

/datum/happiness_event/vice/sexo
	description = "<span class='badmood'>• I need someone to fuck.</span>\n"
	happiness = -15

/datum/happiness_event/vice/alco
	description = "<span class='badmood'>• I need a drink.</span>\n"
	happiness = -15

/datum/happiness_event/vice/ment
	description = "<span class='badmood'>• I need mentats.</span>\n"
	happiness = -15

/datum/happiness_event/vice/buff
	description = "<span class='badmood'>• I need buffout.</span>\n"
	happiness = -15

/datum/happiness_event/vice/heroin
	description = "<span class='badmood'>• I need to take a hit.</span>\n"
	happiness = -15

/datum/happiness_event/vice/stimulants
	description = "<span class='badmood'>• I need stimulants.</span>\n"
	happiness = -15

/datum/happiness_event/vice/maso
	description = "<span class='badmood'>• I need to feel pain.</span>\n"
	happiness = -15

/datum/happiness_event/vice/voyeur
	description = "<span class='badmood'>• I need to see someone do it.</span>\n"
	happiness = -15

/datum/happiness_event/wonder
	description = "<span class='badmood'>• I've seen something nightmarish. I'm afraid for my life.</span>\n"
	happiness = -18

//Song
/datum/happiness_event/song/perfect
	description = "<span class='goodmood'>•</span> <span class='passivebold'>This song is wonderful!</span>\n"
	happiness = 8
	timeout = 30 SECONDS

/datum/happiness_event/song/good
	description = "<span class='goodmood'>• This song is great!</span>\n"
	happiness = 4
	timeout = 30 SECONDS

/datum/happiness_event/song/bad
	description = "<span class='badmood'>• This song is awful!</span>\n"
	happiness = -4
	timeout = 30 SECONDS

//Help me
/datum/happiness_event/want_punch
	description = "<span class='badmood'>• I want to punch ...who?</span>\n"
	happiness = -4
	timeout = 600
	var/mob/living/carbon/human/pidor = null

/datum/happiness_event/epitemia
	description = "<span class='badmood'>• I need to... do what?</span>\n"
	happiness = -6
	var/epitemia_type = null

/datum/happiness_event/flag
	description = "<span class='badmood'>• The flag has fallen!</span>\n"
	happiness = -10

/mob/living/carbon/human/proc/add_epitemia(var/T)
	var/datum/happiness_event/epitemia/mood = new
	mood.epitemia_type = T
	mood.description = "<span class='badmood'>• I need [T] to redeem my sins!</span>\n"
	var/category = "epitemia"
	if(events[category])
		clear_event(category)
	events[category] = mood

/mob/living/carbon/human/proc/want_punch(var/mob/living/carbon/human/who)
	var/datum/happiness_event/want_punch/mood = new
	mood.pidor = who
	mood.description = "<span class='badmood'>• I want to punch [who.name]!</span>\n"
	var/category = "want_punch"
	if(events[category])
		clear_event(category)
	events[category] = mood
	spawn(mood.timeout)
		events -= category