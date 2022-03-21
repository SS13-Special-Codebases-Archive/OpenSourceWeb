//This can probably just go in living.dm
/mob/living/proc/handle_hud_vision()
	if (stat != DEAD)
		if (blind)
			blind.alpha = blinded ? 255 : 0

	if (disabilities & NEARSIGHTED)
		client.screen += global_hud.vimpaired

	if (eye_blurry >= 10)
		client.screen += global_hud.blurry

	if (druggy)
		client.screen += global_hud.druggy

	else
		reset_hud_vision()

/mob/living/proc/reset_hud_vision()
	if (blind)
		blind.alpha = 0