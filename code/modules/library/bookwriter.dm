/obj/structure/writersdesk
	name = "Typewriter"
	desc = "A desk with various tools to write a book"
	icon = 'structures.dmi'
	icon_state = "writers"
	density = 1
	anchored = 1
	layer = 2.8

/obj/structure/writersdesk/attack_hand(mob/user)
	switch(alert("Would you like to write a book?",,"Yes","No"))
		if("No")
			return
	var/cat = "Fiction"
	var/t = input(user,"Write a book!","Booker","Note: This is all logged abuseing this system will get you banned.") as message
	var/text = copytext(t,1,0)
	var/title = input(user,"Give a title to your book!","Bookia","Title here") as text
	var/author = input(user,"What's your name?","Namey",user.name) as text
	var/catname = input(user,"What catagory is this book in?","Fiction") in list("Fiction", "Adult", "Religion", "Learn")
	switch(catname)
		if("Fiction")
			cat = "Fiction"
		if("Adult")
			cat = "Adult"
		if("Religion")
			cat = "Religion"
		if("Learn")
			cat = "Learn"

	switch(alert("Are you sure you want to save the book?",,"Yes","No"))
		if("No")
			return
	if(title == "Title here"|| text == "Note: This is all logged abuseing this system will get you banned.")
		to_chat(user, "Dude. what the hell?")
		return

	var/sqltitle = sanitizeSQL(title)
	var/sqlauthor = sanitizeSQL(author)
	var/sqlcontent = sanitizeSQL(text)
	var/sqlcategory = sanitizeSQL(cat)


	establish_db_connection()
	if(!dbcon.IsConnected())
		to_chat(user, "<span class='combatbold'>[pick(nao_consigoen)]</span> Bookcases are not working properly, contact your local god-king!</font>")
		return

	var/DBQuery/x_query = dbcon.NewQuery("INSERT INTO `erro_library` (`sqltitle`, `sqlauthor`, `sqlcontent`,`sqlcategory`) VALUES ([dbcon.Quote(sqltitle)], [dbcon.Quote(sqlauthor)],[dbcon.Quote(sqlcontent)],'[sqlcategory]')")
	if(!x_query.Execute())
		world.log << "Failed-[x_query.ErrorMsg()]"
		to_chat(user, "Sadly something went wrong..")
		user << browse(text,"window=derp")
