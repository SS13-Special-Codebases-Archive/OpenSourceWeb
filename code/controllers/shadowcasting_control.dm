//This subsystem only exists for the initial setup of shadowcasting overlays, and quite literally nothing else
var/datum/controller/shadowcasting/shadowcasting_controller = new()
/datum/controller/shadowcasting
    name = "shadowcasting controller"
    var/initialized = FALSE
