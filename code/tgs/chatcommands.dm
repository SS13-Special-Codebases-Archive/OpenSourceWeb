var/global/list/roundendping = list()

/datum/tgs_chat_command/pingme
    name = "pingme"
    help_text = "pingme <s1|s2|br|s3>"

/datum/tgs_chat_command/pingme/Run(datum/tgs_chat_user/sender, params)
    var/found = FALSE
    var/found_list
    var/list/allparams = splittext(params, " ")
    for(var/datum/tgs_chat_user/user in roundendping)
        if(user.id == sender.id)
            roundendping.Remove(user)
            return "You have been removed from the ping list."
    if(!sender.channel.is_private_channel)
        return "You may only use this command in private!"
    if(allparams.Find("S1") || allparams.Find("s1"))
        if(current_server == "S1")
            roundendping.Add(sender)
        found = TRUE
        found_list += " S1"
    if(allparams.Find("S2") || allparams.Find("s2"))
        if(current_server == "S2")
            roundendping.Add(sender)
        found = TRUE
        found_list += " S2"
    if(allparams.Find("BR") || allparams.Find("br"))
        if(current_server == "BRZ")
            roundendping.Add(sender)
        found = TRUE
        found_list += " BR"
    if(allparams.Find("S3") || allparams.Find("s3"))
        if(current_server == "S3")
            roundendping.Add(sender)
        found = TRUE
        found_list += " S3"
    if(found)
        return "You will be pinged when the selected servers ([trim(found_list)]) restart."
    else
        return "You didn't specify any valid servers!"

