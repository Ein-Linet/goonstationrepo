/client/proc/spelltemp(newtemp as num)
	set category = "Spells"
	set name = "Change Temperature"
	set desc="Change Temperature"
	if(usr.stat >= 2)
		usr << "Not when you're dead!"
		return
	if(!istype(usr:wear_suit, /obj/item/weapon/clothing/suit/wizrobe))
		usr << "I don't feel strong enough without my robe."
		return
	if(!istype(usr:shoes, /obj/item/weapon/clothing/shoes/sandal))
		usr << "I don't feel strong enough without my sandals."
		return
	if(!istype(usr:head, 	/obj/item/weapon/clothing/head/wizhat))
		usr << "I don't feel strong enough without my hat."
		return
	if(!istype(usr.equipped(), /obj/item/weapon/staff))
		usr << "I don't feel strong enough without my staff."
		return
	usr.verbs -= /client/proc/spelltemp
	spawn(1200)
		usr.verbs += /client/proc/spelltemp
	if(usr == killer)
		var/mob/human/M = usr
		M.say("TUT KAHMUN JE NUMAN")
	for(var/turf/T in view())
		if(!T.updatecell)	continue
		T.temp = newtemp
//		world.log_admin("[src.key] set [T]'s temp to [newtemp]")
		sleep(60)
		newtemp = T.temp
	return