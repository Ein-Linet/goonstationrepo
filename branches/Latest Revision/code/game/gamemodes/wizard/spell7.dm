/client/proc/smokecloud()

	set category = "Spells"
	set name = "Smoke"
	set desc = "Creates a cloud of smoke"
	if(usr.stat >= 2)
		usr << "Not when you're dead!"
		return
	if(!istype(usr:wear_suit, /obj/item/weapon/clothing/suit/wizrobe))
		usr << "I don't feel strong enough to use this spell"
		return
	if(!istype(usr:shoes, /obj/item/weapon/clothing/shoes/sandal))
		usr << "I don't feel strong enough to use this spell"
		return
	if(!istype(usr:head, 	/obj/item/weapon/clothing/head/wizhat))
		usr << "I don't feel strong enough to use this spell"
		return
	usr.verbs -= /client/proc/smokecloud
	spawn(120)
		usr.verbs += /client/proc/smokecloud
	var/obj/effects/badsmoke/O = new /obj/effects/badsmoke( usr.loc )
	O.dir = pick(NORTH, SOUTH, EAST, WEST)
	spawn( 0 )
		O.Life()

