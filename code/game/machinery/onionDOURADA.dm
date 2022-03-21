/obj/machinery/lwvend/onion/gold
    name = "G-ONION"
    var/locked = 0

/obj/machinery/lwvend/onion/gold/New()
    obols = rand(210, 350)

/obj/machinery/lwvend/onion/gold/attack_hand(mob/living/carbon/human/user as mob)
	playsound(src.loc, pick('sound/effects/public1.ogg','sound/effects/public2.ogg','sound/effects/public3.ogg'), 30, 0)
	var/illiterate = FALSE
	var/count = 0
	if(user.check_perk(/datum/perk/illiterate))
		illiterate = TRUE
	var/dat
	dat += {"<META http-equiv='X-UA-Compatible' content='IE=edge' charset='UTF-8'> <style type='text/css'> @font-face {font-family: Gothic;src: url(gothic.ttf);} @font-face {font-family: Book;src: url(book.ttf);} @font-face {font-family: Hando;src: url(hando.ttf);} @font-face {font-family: Eris;src: url(eris.otf);} @font-face {font-family: Brandon;src: url(brandon.otf);} @font-face {font-family: VRN;src: url(vrn.otf);} @font-face {font-family: NEOM;src: url(neom.otf);} @font-face {font-family: PTSANS;src: url(PTSANS.ttf);} @font-face {font-family: Type;src: url(type.ttf);} @font-face {font-family: Enlightment;src: url(enlightment.ttf);} @font-face {font-family: Arabic;src: url(arabic.ttf);} @font-face {font-family: Digital;src: url(digital.ttf);} @font-face {font-family: Cond;src: url(cond2.ttf);} @font-face {font-family: Semi;src: url(semi.ttf);} @font-face {font-family: Droser;src: url(Droser.ttf);} .goth {font-family: Gothic, Verdana, sans-serif;} .book {font-family: Book, serif;} .hando {font-family: Hando, Verdana, sans-serif;} .typewriter {font-family: Type, Verdana, sans-serif;} .arabic {font-family: Arabic, serif; font-size:180%;} .droser {font-family: Droser, Verdana, sans-serif;} </style> <style type='text/css'> @charset 'utf-8'; body {font-family: PTSANS;cursor: url('pointer.cur'), auto;} tr{
                background-color: #34125c;
            }
            table{
                border: 1px solid gold;
            }
            .header{
                color: white;
            }
			 tr{
                background-color: #34125c;
            }
            big{
                color:#cc9119;
            }

            tt{
                color: #a1844c;
                font-weight: lighter;
            }

            center{
                font-size: 160%;
            }
            .start{
                background-color: #010123;
            }
            .even{
                background-color: #423850;
            }a {
                text-decoration: none;
                outline: none;
                border: none;
                margin-left: 5px;
                margin-right: 5px;
            }
            a:focus {
                outline: none;
            }
            a:hover {
                color: whitesmoke;
                font-weight: bold;
                background: gray;
                outline: none;
                border: none;
			}
			a.active {
                text-decoration: none;
                color: #533333;
            }
            a.inactive:hover {
                color: #0d0d0d;
                background: #bb0000;
            }
            a.active:hover {
                color: #bb0000;
                background: #0f0f0f;
            }
            a.inactive:hover {
                text-decoration: none;
                color: #0d0d0d;
                background: #bb0000;
            }</style>
	<body background bgColor=#0d0d0d text=#533333 alink=#777777 vlink=#777777 link=#777777>
	<TT><CENTER><b>[src.name]</b></CENTER></TT><br>
	"}
	dat += "<TABLE width=100%><TR class='start'><TD><TT class='header'><B>Item:</B></TT></TD> <TD><TT class='header'><B>Price:</B></TT></TD><TD></TR>"
	for(var/list/L in products)
		count++
		var/class = ""
		var/ProductPrice =  L["price"]
		var/ProductName = L["name"]
		var/path = L["path"]
		var/code = L["code"]

		if(count % 2)
			class = "even"

		var/atom/A = new path()
		//dat += "<A href='?src=\ref[src];[code]=1'>[ProductName]</A><BR><span class='materials'>[recipeContents]</span><BR><BR>"
		if(illiterate)
			dat += "<TR class='[class]'><TD><TT><FONT Color = '836363'><B><BIG>[icon2html(A, user)] [Illiterate(ProductName,100)]</BIG></B></TT></TD> <TD><TT>[ProductPrice]</TT></TD></font></TT></TD> "
		else
			dat += "<TR class='[class]'><TD><TT><FONT Color = '836363'><B><BIG>[icon2html(A, user)] [ProductName]</BIG></B></TT></TD> <TD><TT>[ProductPrice]</TT></TD></font></TT></TD> "
		if(ProductPrice > obols)
			if(illiterate)
				dat += "<TD><TT><font Color = 'red'>[Illiterate("NOT ENOUGH MONEY",100)]</font></TD></TT></TR>"
			else
				dat += "<TD><TT><font Color = 'red'>NOT ENOUGH MONEY</font></TD></TT></TR>"
		else
			if(illiterate)
				dat += "<TD><TT><A href='?src=\ref[src];[code]=1'>[Illiterate("Purchase",100)]</A></TT></TR>"
			else
				dat += "<TD><TT><A href='?src=\ref[src];[code]=1'>Purchase</A></TT></TR>"
		qdel(A)
	if(illiterate)
		dat += "</TABLE><br><TT><b>[Illiterate("Obols Loaded",100)]: [obols]</b><br></TT><BR><TT><A href='?src=\ref[src];change=1'>[Illiterate("Change",100)]</A></TT>"
	else
		dat += "</TABLE><br><TT><b>Obols Loaded: [obols]</b><br></TT><BR><TT><A href='?src=\ref[src];change=1'>Change</A></TT>"

	user << browse(dat, "window=vending;size=575x450")


/obj/machinery/lwvend/onion/gold/RightClick(var/mob/living/carbon/human/H)
    if(H.job != "Pusher")
        return
    locked = !locked
    playsound(src.loc, 'sound/airlock_boltswitch.ogg', 100, 1)

/obj/machinery/lwvend/onion/gold/attack_hand(mob/living/carbon/human/user)
    if(locked)
        return
    return ..()