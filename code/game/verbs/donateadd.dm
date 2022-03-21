/proc/add_seaspotter()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO seaspotter_merc (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    seaspotter_merc.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_squirea()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO squire_donor (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    adultsquire.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_mercenary()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO mercenary_donor (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    mercenary_donor.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_tribvet()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO tribvet_donor (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    tribunal_vet.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_urchin()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO urchin_donor (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    urchin_donor.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_reddawn()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO reddawn_merc (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    reddawn_merc.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_lord()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO lord (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    lord.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_crusader()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO crusader (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    crusader.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_tophat()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO tophat (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    tophat.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_monk()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO monk (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    monk.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_futa()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO futa (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    futa.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")


/proc/add_30cm()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO 30cm (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    thirtycm.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_trapapoc()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO trapapoc (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    trapapoc.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_outlaw()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO outlaw (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    outlaw.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_waterbottle()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO waterbottledonation (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    waterbottledonation.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_luxurydonation()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO luxurydonation (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    luxurydonation.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_pjack()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO pjack (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    pjack.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")

/proc/add_customooc()
    var/ckey = input("Enter the donator's ckey", "Farweb")
    if(length(ckey) <= 1 || length(ckey) > 30)
        to_chat(usr, "<span class='highlighttext'>This ckey is invalid.</span>")
        return
    var/DBQuery/queryInsert = dbcon.NewQuery("INSERT INTO customooccolorlist (ckey) VALUE (\"[ckey(ckey)]\")")
    if(!queryInsert.Execute())
        world.log << queryInsert.ErrorMsg()
        queryInsert.Close()
        return
    customooccolorlist.Add(ckey(ckey))
    to_chat(usr, "<span class='highlighttext'>[ckey] has been added to the donators list.</span>")