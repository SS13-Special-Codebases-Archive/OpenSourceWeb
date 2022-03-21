/obj/item/weapon/reagent_containers/food/proc/foodloc(var/mob/M, var/obj/item/O)
	if(O.loc == M) return M.loc
	else return O.loc

///////////////////////////////////////////////////////
//                                                   //
//                   Raw reagents                    //
//                                                   //
///////////////////////////////////////////////////////


/obj/item/weapon/reagent_containers/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Maybe you should cook it first?"
	icon_state = "rawsticks"

/obj/item/weapon/reagent_containers/food/snacks/dough
	name = "dough"
	desc = "A dough."
	icon_state = "dough"


/obj/item/weapon/reagent_containers/food/snacks/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon_state = "flat dough"



/obj/item/weapon/reagent_containers/food/snacks/doughslice
	name = "dough slice"
	desc = "Make your magic."
	icon_state = "doughslice"


/obj/item/weapon/reagent_containers/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of meat."
	icon_state = "rawcutlet"


/obj/item/weapon/reagent_containers/food/snacks/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon_state = "rawmeatball"




///////////////////////////////////////////////////////
//                                                   //
//                       Sauces                      //
//                                                   //
///////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/snacks/ketchup
	name = "ketchup"
	desc = "Goes well with meat."
	icon_state = "ketchup"


///////////////////////////////////////////////////////
//                                                   //
//                      Bakery                       //
//                                                   //
///////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/snacks/candycane
	name = "candy cane"
	desc = "Sweet and sticky."
	icon_state = "candycane"

	//heal_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/sweetapple
	name = "sweet apple"
	desc = "Warm, sweet and healthy!"
	icon_state = "sweetapple"

	//heal_amt = 2

/obj/item/weapon/reagent_containers/food/snacks/pattyapple
	name = "apple patty"
	desc = "Like grandma's."
	icon_state = "pattyapple"

	//heal_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon_state = "bun"

	//heal_amt = 1

/obj/item/weapon/reagent_containers/food/snacks/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon_state = "flatbread"

	//heal_amt = 1



///////////////////////////////////////////////////////
//                                                   //
//                    Cooked food                    //
//                                                   //
///////////////////////////////////////////////////////




/obj/item/weapon/reagent_containers/food/snacks/sbakedpotato
	name = "sauced potatoes"
	desc = "It smells and tastes great!"
	icon_state = "sbakedpotato"



/obj/item/weapon/reagent_containers/food/snacks/sspaghetti
	name = "sauced spaghetti"
	desc = "Long and tasty - 'Tomato Noodles'."
	icon_state = "sspaghetti"

/obj/item/weapon/reagent_containers/food/snacks/smeatspaghetti
	name = "sauced spaghetti with meatballs"
	desc = "A tasty dinner - 'Spaghetti Terror'."
	icon_state = "smeatspaghetti"


/obj/item/weapon/reagent_containers/food/snacks/somelette
	name = "sauced omelette"
	desc = "A saucy dish - 'Bloody Alien'."
	icon_state = "somelette"

	//heal_amt = 3


/obj/item/weapon/reagent_containers/food/snacks/ssteak
	name = "sauced steak"
	desc = "A sauced meat steak."
	icon_state = "meatstake"

	//heal_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice - 'Bacon'."
	icon_state = "cutlet"

	//heal_amt = 2

/obj/item/weapon/reagent_containers/food/snacks/sausage
	name = "sausage"
	desc = "A sausage."
	icon_state = "sausage"

	//heal_amt = 2


///////////////////////////////////////////////////////
//                                                   //
//                    Burgers                        //
//                                                   //
///////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/snacks/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs."
	icon_state = "hotdog"

	//heal_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/shotdog
	name = "sauced hotdog"
	desc = "Unrelated to dogs - 'Royal Hotdog'."
	icon_state = "shotdog"


/obj/item/weapon/reagent_containers/food/snacks/sburger
	name = "sauced burger"
	desc = "A fast way to become fat - 'Space Burger'."
	icon_state = "sburger"

	//heal_amt = 4

/obj/item/weapon/reagent_containers/food/snacks/hamburger
	name = "hamburger"
	desc = "A fast way to become fat."
	icon_state = "hamburger"

	//heal_amt = 3

/obj/item/weapon/reagent_containers/food/snacks/shamburger
	name = "sauced hamburger"
	desc = "A fast way to become fat - 'Star Hamburger'."
	icon_state = "shamburger"

	//heal_amt = 4


/obj/item/weapon/reagent_containers/food/snacks/scheeseburger
	name = "saused cheeseburger"
	desc = "The cheese adds a good flavor - 'Space Cheeseburger'."
	icon_state = "scheeseburger"

	//heal_amt = 4

/obj/item/weapon/reagent_containers/food/snacks/taco
	name = "taco"
	desc = "Take a bite!"
	icon_state = "taco"



///////////////////////////////////////////////////////
//           Cutting other food items .              //
///////////////////////////////////////////////////////

// Flat dough into dough slices (x3)
/obj/item/weapon/reagent_containers/food/snacks/flatdough/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/utensil/knife))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/doughslice(spawnloc)
		new /obj/item/weapon/reagent_containers/food/snacks/doughslice(spawnloc)
		new /obj/item/weapon/reagent_containers/food/snacks/doughslice(spawnloc)
		user << "You cut the flat dough into slices."
		qdel(src)

// Potato in potato sticks
/obj/item/weapon/reagent_containers/food/snacks/potato/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/utensil/knife))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/rawsticks(spawnloc)
		user << "You cut the potato."
		qdel(src)


// Meat into raw cutlets (x3)
/obj/item/weapon/reagent_containers/food/snacks/meat/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/utensil/knife))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/rawcutlet(spawnloc)
		new /obj/item/weapon/reagent_containers/food/snacks/rawcutlet(spawnloc)
		new /obj/item/weapon/reagent_containers/food/snacks/rawcutlet(spawnloc)
		user << "You cut the meat into slices."
		qdel(src)

// Steak into cutlets (x3)
/obj/item/weapon/reagent_containers/food/snacks/steak/attackby(obj/item/weapon/kitchen/utensil/knife/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/cutlet(spawnloc)
		new /obj/item/weapon/reagent_containers/food/snacks/cutlet(spawnloc)
		new /obj/item/weapon/reagent_containers/food/snacks/cutlet(spawnloc)
		user << "You cut the steak into slices."
		qdel(src)
		return
	..()

// Sauced steak into cutlets (x3)
/obj/item/weapon/reagent_containers/food/snacks/ssteak/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/utensil/knife))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/cutlet(spawnloc)
		new /obj/item/weapon/reagent_containers/food/snacks/cutlet(spawnloc)
		new /obj/item/weapon/reagent_containers/food/snacks/cutlet(spawnloc)
		user << "You cut the steak into slices."
		qdel(src)

///////////////////////////////////////////////////////
//                                                   //
//                  Combining foods                  //
//                                                   //
///////////////////////////////////////////////////////

// Bread slice + butter = bread and butter
/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/bread/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/butter))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/butterbread(spawnloc)
		user << "You place butter on the bread."
		qdel(W)
		qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/butterbread/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/turf/spawnloc = foodloc(user, src)

	// Bread and butter + cheese slice = cheese sandwich
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/cheese))
		new /obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/chsandwich(spawnloc)
		user << "You make a cheese sandwich."
		qdel(W)
		qdel(src)

	// Bread and butter + cutlet = meat sandwich
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/cutlet))
		new /obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/msandwich(spawnloc)
		user << "You make a meat sandwich."
		qdel(W)
		qdel(src)

	else if(istype(W, /obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/salami))
		new /obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/salsandwich(spawnloc)
		user << "You make a salami sandwich."
		qdel(W)
		qdel(src)


// Cheese sandwich + meat sandwich = sammich
/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/chsandwich/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/msandwich))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/sammich(spawnloc)
		user << "You make a sammich,"
		qdel(W)
		qdel(src)

// Meat sandwich + cheese sandwich = sammich
/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/msandwich/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/chsandwich))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/sammich(spawnloc)
		user << "You make a sammich,"
		qdel(W)
		qdel(src)

// Flour + egg = dough
/obj/item/weapon/reagent_containers/food/snacks/flour/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/egg))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/dough(spawnloc)
		user << "You make a dough."
		qdel(W)
		qdel(src)

// Dough + rolling pin = flat dough
/obj/item/weapon/reagent_containers/food/snacks/dough/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/rollingpin))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/flatdough(spawnloc)
		user << "You flatten the dough."
		qdel(src)


/obj/item/weapon/reagent_containers/food/snacks/bun/attackby(obj/item/weapon/W as obj, mob/user as mob)
	// Bun + meatball = burger
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/faggot))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/burger(spawnloc)
		user << "You make a burger."
		qdel(W)
		qdel(src)

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/cutlet))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/hamburger(spawnloc)
		user << "You make a hamburger."
		qdel(W)
		qdel(src)

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/sausage))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/hotdog(spawnloc)
		user << "You make a hotdog."
		qdel(W)
		qdel(src)

// Burger + cheese slice = cheeseburger
/obj/item/weapon/reagent_containers/food/snacks/burger/attackby(obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/cheese/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/cheeseburger(spawnloc)
		user << "You make a cheeseburger."
		qdel(W)
		qdel(src)
		return
	..()

// Hamburger + cheese slice = cheeseburger
/obj/item/weapon/reagent_containers/food/snacks/hamburger/attackby(obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/cheese/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/cheeseburger(spawnloc)
		user << "You make a cheeseburger."
		qdel(W)
		qdel(src)
		return
	..()

// Sauced burger + cheese slice = sauced cheeseburger
/obj/item/weapon/reagent_containers/food/snacks/sburger/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/cheese))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/scheeseburger(spawnloc)
		user << "You make a sauced cheeseburger."
		qdel(W)
		qdel(src)

// Sauced hamburger + cheese slice = sauced cheeseburger
/obj/item/weapon/reagent_containers/food/snacks/shamburger/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/cheese))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/scheeseburger(spawnloc)
		user << "You make a sauced cheeseburger."
		qdel(W)
		qdel(src)



// Sauced spaghetti + meatball = sauced spaghetti with meatballs
/obj/item/weapon/reagent_containers/food/snacks/sspaghetti/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/faggot))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/smeatspaghetti(spawnloc)
		user << "You add meatballs to sauced spaghetti."
		qdel(W)
		qdel(src)

///////////////////////////////////////////////////////
//                                                   //
//                     Adding sauce.                 //
//                                                   //
///////////////////////////////////////////////////////


// Steak + ketchup
/obj/item/weapon/reagent_containers/food/snacks/steak/attackby(obj/item/weapon/reagent_containers/food/snacks/ketchup/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/ssteak(spawnloc)
		user << "You put ketchup on the steak."
		qdel(src)
		return
	..()

// Baked potato + ketchup
/obj/item/weapon/reagent_containers/food/snacks/bakedpotato/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/ketchup))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/sbakedpotato(spawnloc)
		user << "You add ketchup to baked potato."
		qdel(src)

// Spaghetti + ketchup
/obj/item/weapon/reagent_containers/food/snacks/spaghetti/attackby(obj/item/weapon/reagent_containers/food/snacks/ketchup/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/sspaghetti(spawnloc)
		user << "You put ketchup in spaghetti."
		qdel(src)
		return
	..()

// Meatballs & spaghetti + ketchup
/obj/item/weapon/reagent_containers/food/snacks/meatspaghetti/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/ketchup))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/smeatspaghetti(spawnloc)
		user << "You put ketchup in meat spaghetti."
		qdel(src)

// Burger + ketchup
/obj/item/weapon/reagent_containers/food/snacks/burger/attackby(obj/item/weapon/reagent_containers/food/snacks/ketchup/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/sburger(spawnloc)
		user << "You add ketchup to the burger."
		qdel(src)
		return
	..()

// Hamburger + ketchup
/obj/item/weapon/reagent_containers/food/snacks/hamburger/attackby(obj/item/weapon/reagent_containers/food/snacks/ketchup/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/shamburger(spawnloc)
		user << "You add ketchup to the hamburger."
		qdel(src)
		return
	..()

// Hotdog + ketchup
/obj/item/weapon/reagent_containers/food/snacks/hotdog/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/ketchup))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/shotdog(spawnloc)
		user << "You add ketchup to the hotdog."
		qdel(src)

// Burger + omelette
/obj/item/weapon/reagent_containers/food/snacks/omelette/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/ketchup))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/somelette(spawnloc)
		user << "You add ketchup to the omelette."
		qdel(src)

///////////////////////////////////////////////////////
//                                                   //
//           Bread and sandwich system.              //
//           Stuff goes on top of bread slices!      //
//                                                   //
///////////////////////////////////////////////////////

// *** At first, containers which require a knife to get something from then ***

// the loaf
/obj/item/weapon/reagent_containers/food/snacks/breadsys/
	icon_state = null



// the loaf
/obj/item/weapon/reagent_containers/food/snacks/breadsys/loaf
	name = "loaf of bread"
	desc = "A fine loaf of bread"
	icon_state = "loaf4"
	//heal_amt = 2


// the butterpack
/obj/item/weapon/reagent_containers/food/snacks/breadsys/butterpack
	name = "Butter pack"
	desc = "A big pack of goodness."
	icon_state = "butterpack"


// the stick of salami
/obj/item/weapon/reagent_containers/food/snacks/breadsys/salamistick
	name = "salami stick"
	desc = "Don't choke on this, find a knife."
	icon_state = "salamistick3"

// the head of cheese
/obj/item/weapon/reagent_containers/food/snacks/breadsys/bigcheese
	name = "cut of cheese"
	desc = "Cut it with a knife."
	icon = 'food.dmi'
	icon_state = "bigcheese"
	//heal_amt = 3


// *** Now icons for the stuff which goes on top of the bread slice ***

/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop
	var/stateontop = "salami3" //state when ontop a sandvich

// a slice of bread loaf
/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/bread
	name = "bread slice"
	desc = "A well-made bread slice."
	icon_state = "bread3"
	stateontop = "bread1"
	//heal_amt = 1

// a slice of salami
/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/salami
	name = "salami"
	desc = "A preserved meat."
	icon_state = "salami"
	stateontop = "salami3"
	//heal_amt = 1

// a slice of cheese
/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/cheese
	name = "cheese slice"
	desc = "Small enough to fit on a bread slice."
	icon_state = "cheese"
	stateontop = "cheese3"
	//heal_amt = 1

// a slice of butter
/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/butter
	name = "butter"
	desc = "You need a butter to make sandwiches, right?"
	icon_state = "butter"
	stateontop = "butter3"
	//heal_amt = 0

// bread and butter
/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/butterbread
	name = "bread and butter"
	desc = "A base for a sandwich."
	icon_state = "breadbutter"
	//heal_amt = 1


// a cheese sandwich
/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/chsandwich
	name = "cheese sandwich"
	desc = "Cheese and butter. Nice."
	icon_state = "chsandwich"

	//heal_amt = 2

// a meat sandwich
/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/msandwich
	name = "meat sandwich"
	desc = "Fat but filling."
	icon_state = "msandwich"

	//heal_amt = 2

// a salami sandwich
/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/salsandwich
	name = "salami sandwich"
	desc = "This is a salami sandwich.. Really, that's all... No strange spices mixed in."
	icon_state = "salsandwich"

	//heal_amt = 2

// a sammich
/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/sammich
	name = "sammiich"
	desc = "A great sandwich!"
	icon_state = "sammich"
	//heal_amt = 4

// *** Cutting sandwich-system containers into pieces ***

//	 Loaf code
/obj/item/weapon/reagent_containers/food/snacks/breadsys/loaf/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/utensil/knife))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/bread(spawnloc)
		user << "You slice a piece of bread"
		amount--
		if(amount <= 5)
			icon_state = "loaf3"
		if(amount <= 4)
			icon_state = "loaf2"
		if(amount <= 2)
			icon_state = "loaf1"
		if(amount <= 1)
			new /obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/bread(spawnloc)
			qdel(src)


//	 Salami code
/obj/item/weapon/reagent_containers/food/snacks/breadsys/salamistick/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/utensil/knife))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/salami(spawnloc)
		user << "You slice a piece of salami"
		amount--
		if(amount <= 4)
			icon_state = "salamistick2"
		if(amount <= 3)
			icon_state = "salamistick1"
		if(amount <= 2)
			icon_state = "salamistick0"
		if(amount <= 1)
			new /obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/salami(spawnloc)
			qdel(src)


//	 Butterpack code
/obj/item/weapon/reagent_containers/food/snacks/breadsys/butterpack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/utensil/knife))
		var/turf/spawnloc = foodloc(user, src)
		if(amount >= 1)
			new /obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/butter(spawnloc)
			user << "You cut some butter"
			amount--
		if(amount < 1)
			qdel(src)

// *** Sandwich assembling code. Watch the overloading on bread/attackby ***

/obj/item/weapon/reagent_containers/food/snacks/breadsys/bread/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop))
		var/state = W:stateontop
		if(!state)
			return
		if(src.name != "sandwich")
			src.name = "sandwich"
		overlays += image(W.icon,icon_state = state)
		user.drop_item(W)
		W.loc = src
		user << "You put a [W] ontop of the [src]"
		src.heal_amt++
	else if(W.type == /obj/item/weapon/reagent_containers/food/snacks/breadsys/bread/)
		user.drop_item(W)
		W.loc = src
		if(src.name != "sandwich")
			src.name = "sandwich"
		overlays += image(W.icon,icon_state = W.icon_state)
		user << "You put [W] ontop of the [src]"
		src.heal_amt++
	update_icon()


/obj/item/weapon/reagent_containers/food/snacks/breadsys/bread/update_icon()
	src.overlays = null
	var/num = amount
	for(var/obj/item/weapon/reagent_containers/food/snacks/breadsys/ontop/X in src)
		var/iconx = "[X.stateontop][num]"
		overlays += image(X.icon,iconx)

///////////////////////////////////////////////////////
//        End of sandwich-related stuff              //
///////////////////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Man, that looks good. I bet it's got nougat."
	icon_state = "candy"
	//heal_amt = 1
	//nutmod = 0.1

/obj/item/weapon/reagent_containers/food/snacks/candy/MouseDrop(mob/user as mob)
	return src.attack(user, user)

/obj/item/weapon/reagent_containers/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps"
	icon_state = "chips"
	//heal_amt = 2
	//nutmod = 0.1

/obj/item/weapon/reagent_containers/food/snacks/chips/MouseDrop(mob/user as mob)
	return src.attack(user, user)





/obj/item/weapon/reagent_containers/food/snacks/waffles/MouseDrop(mob/user as mob)
	return src.attack(user, user)

