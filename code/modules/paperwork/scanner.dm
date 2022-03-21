/obj/machinery/scanner
	name = "Scanner"
	icon = 'computer.dmi'
	icon_state = "aiupload"
	density = 1
	anchored = 1
	var/lastuser = null

/obj/machinery/scanner/attack_hand(mob/living/carbon/human/user)
	if(!ishuman(user) || lastuser == user.real_name)
		return
	lastuser = user.real_name
	var/mname = user.real_name
	var/dna = user.dna.unique_enzymes
	var/age = user.age
	var/bloodtype = user.b_type
	var/fingerprint = md5(user.dna.uni_identity)
	var/mgender = user.gender
	var/list/marks = list()
//	var/DBQuery/cquery = dbcon.NewQuery("SELECT * from jobban WHERE ckey='[user.ckey]'")
//	if(!cquery.Execute()) return
//	else
//		while(cquery.NextRow())
//			var/list/row = cquery.GetRowData()
//			marks += row["rank"]

	if(user.real_name == "Atarabashi Nihondzin") //EASTER EGG
		mgender = "unknown"

	var/text = {"
	<center>Report</center><br>
	Name: [mname]<br>
	Sex: [mgender]<br>
	Age: [age]<br>
	Blood Type: [bloodtype]<br>
	Fingerprint: [fingerprint]<br>
	DNA: [dna]<br>

	Black Marks<br> "}
	for(var/A in marks)
		text += "\red[A]<br>"
	user << "You feel a tiny prick!"
	var/obj/item/weapon/paper/scan/print = new/obj/item/weapon/paper/scan(src.loc)
	print.name = "[mname] Report"
	print.info = text
	print.mname = mname
	print.mgender = mgender
	print.age = age
	print.bloodtype = bloodtype
	print.fingerprint = fingerprint
	print.dna = dna