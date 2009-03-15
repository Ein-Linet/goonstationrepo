/obj/mopbucket/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/mop))
		if (src.water >= 2)
			src.water -= 2
			W:wet = 2
			W:suffix = text("[][]", (user.equipped() == src ? "equipped " : ""), W:wet)
			user << "\blue You wet the mop"
		if (src.water < 1)
			user << "\blue Out of water!"
	else if (istype(W, /obj/item/weapon/bucket))
		if ((W:water == 20))
			src.water = 20
			W:water -=20
			W:suffix = text("[][]", (user.equipped() == src ? "equipped " : ""), W:water)
			user << "\blue You pour the water into the mop bucket"
	return

/obj/item/weapon/cleaner/attack(mob/human/M as mob, mob/user as mob)
	return

/obj/item/weapon/cleaner/afterattack(atom/A as mob|obj, mob/user as mob)
	if (src.water < 1)
		user << "\blue Add more water!"
		return
	if (istype(A, /mob/human))
		var/mob/human/M = A
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []'s hands</B>", user, M), 1)
			sleep(40)
			src.water -= 1
			if (M.gloves)
				M.gloves.clean_blood()
			else
				M.clean_blood()
	else if (istype(A, /obj/item/weapon))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []</B>", user, A), 1)
			sleep(40)
			src.water -= 1
			A.clean_blood()
	return

/obj/item/weapon/cleaner/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of water left!", src, src.name, src.water)
	..()
	return

/obj/mopbucket/examine()
	set src in usr

	usr << text("\icon[] [] contains [] units of water left!", src, src.name, src.water)
	..()
	return

/obj/item/weapon/mop/attack(mob/human/M as mob, mob/user as mob)
	..()
	if (usr.clumsy && prob(50))
		usr << "\red The mop slips out of your hand and hits your head."
		usr.bruteloss += 10
		usr.paralysis += 20
		return
	if (M.stat < 2 && prob(15))
		var/mob/H = M
		// ******* Check
		if ((istype(H, /mob/human) && istype(H, /obj/item/weapon/clothing/head) && H.flags & 8 && prob(80)))
			M << "\red The helmet protects you from being hit hard in the head!"
			return
		var/time = rand(5, 60)
		if (prob(75))
			if (M.paralysis < time && (!M.ishulk))
				M.paralysis = time
		else
			if (M.stunned < time && (!M.ishulk))
				M.stunned = time
		if(M.stat != 2)	M.stat = 1
		for(var/mob/O in viewers(M, null))
			O.show_message(text("\red <B>[] has been knocked unconscious!</B>", M), 1, "\red You hear someone fall.", 2)
	else
		M << text("\red [] tried to knock you unconcious!",user)
		M.eye_blurry += 3
		//M.show_message(text("\red <B>This was a []% hit. Roleplay it! (personality/memory change if the hit was severe enough)</B>", time * 100 / 120))
	return

/obj/item/weapon/mop/afterattack(atom/A as turf|area, mob/user as mob)
	if (src.wet < 1)
		user << "\blue Your mop is dry!"
		return
	if (istype(A, /turf/station))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []</B>", user, A), 1)
		var/turf/T = user.loc
		sleep(40)
		if ((user.loc == T && user.equipped() == src && !( user.stat )))
			src.wet -= 1
			A:wet = 1
			spawn(800)
				A:wet = 0
			A.clean_blood()
	else if (istype(A, /obj/bloodtemplate))
		for(var/mob/O in viewers(user, null))
			O.show_message(text("\red <B>[] begins to clean []</B>", user, A), 1)
		var/turf/T = user.loc
		var/turf/U = A.loc
		sleep(40)
		if ((user.loc == T && user.equipped() == src && !( user.stat )))
			src.wet -= 1
			U:wet = 1
			spawn(800)
				U:wet = 0
			del(A)
	return