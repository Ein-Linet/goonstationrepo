/obj/machinery/computer/prison_shuttle/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/x in src.verbs)
					src.verbs -= x
				src.icon_state = "broken"
		if(3.0)
			if (prob(25))
				for(var/x in src.verbs)
					src.verbs -= x
				src.icon_state = "broken"
		else
	return


/obj/machinery/computer/prison_shuttle/verb/take_off()
	set src in oview(1)

	if (usr.stat || usr.restrained())
		return

	src.add_fingerprint(usr)
	if(!src.allowedtocall)
		usr << "\red The console seems irreparably damaged!"
		return
	if(src.z == 3)
		usr << "\red Already in transit! Please wait!"
		return

	var/A = locate(/area/shuttle_prison)
	for(var/mob/M in A)
		M.show_message("\red Launch sequence initiated!")
		spawn(0)	shake_camera(M, 10, 1)
	sleep(10)

	if(src.z == 2)	//This is the laziest proc ever
		for(var/atom/movable/AM as mob|obj in A)
			AM.z = 3
			AM.Move()
		for(var/turf/T as turf in A)
			T.buildlinks()
		sleep(rand(600,1800))
		for(var/atom/movable/AM as mob|obj in A)
			AM.z = 1
			AM.Move()
		for(var/turf/T as turf in A)
			T.buildlinks()
	else
		for(var/atom/movable/AM as mob|obj in A)
			AM.z = 3
			AM.Move()
		for(var/turf/T as turf in A)
			T.buildlinks()
		sleep(rand(600,1800))
		for(var/atom/movable/AM as mob|obj in A)
			AM.z = 2
			AM.Move()
		for(var/turf/T as turf in A)
			T.buildlinks()
	for(var/mob/M in A)
		M.show_message("\red Prison shuttle has arrived at destination!")
		spawn(0)	shake_camera(M, 2, 1)
	return

/obj/machinery/computer/prison_shuttle/verb/restabalize()
	set src in oview(1)

	src.add_fingerprint(usr)

	var/A = locate(/area/shuttle_prison)
	for(var/mob/M in A)
		M.show_message("\red <B>Restabilizing prison shuttle atmosphere!</B>")

	for(var/obj/move/T in A)
		T.firelevel = 0
		T.oxygen = O2STANDARD
		T.oldoxy = O2STANDARD
		T.tmpoxy = O2STANDARD
		T.poison = 0
		T.oldpoison = 0
		T.tmppoison = 0
		T.co2 = 0
		T.oldco2 = 0
		T.tmpco2 = 0
		T.sl_gas = 0
		T.osl_gas = 0
		T.tsl_gas = 0
		T.n2 = N2STANDARD
		T.on2 = N2STANDARD
		T.tn2 = N2STANDARD
		T.temp = T20C
		T.otemp = T20C
		T.ttemp = T20C
		sleep(1)
	for(var/mob/M in A)
		M.show_message("\red <B>Prison shuttle atmosphere restabilized!</B>")
	return

/obj/machinery/computer/shuttle/ex_act(severity)
	switch(severity)
		if(1.0)
			//SN src = null
			del(src)
			return
		if(2.0)
			if (prob(50))
				for(var/x in src.verbs)
					src.verbs -= x
				src.icon_state = "broken"
		if(3.0)
			if (prob(25))
				for(var/x in src.verbs)
					src.verbs -= x
				src.icon_state = "broken"
		else
	return

/obj/machinery/computer/shuttle/verb/restabalize()
	set src in oview(1)

	world << "\red <B>Restabalizing shuttle atmosphere!</B>"
	var/A = locate(/area/shuttle)
	for(var/obj/move/T in A)
		T.firelevel = 0
		T.oxygen = O2STANDARD
		T.oldoxy = O2STANDARD
		T.tmpoxy = O2STANDARD
		T.poison = 0
		T.oldpoison = 0
		T.tmppoison = 0
		T.co2 = 0
		T.oldco2 = 0
		T.tmpco2 = 0
		T.sl_gas = 0
		T.osl_gas = 0
		T.tsl_gas = 0
		T.n2 = N2STANDARD
		T.on2 = N2STANDARD
		T.tn2 = N2STANDARD
		T.temp = T20C
		T.otemp = T20C
		T.ttemp = T20C
		//Foreach goto(35)
	world << "\red <B>Shuttle Restabalized!</B>"
	src.add_fingerprint(usr)
	return

/obj/machinery/computer/shuttle/attackby(var/obj/item/weapon/card/id/W as obj, var/mob/user as mob)
	if(stat & (BROKEN|NOPOWER))
		return
	if ((!( istype(W, /obj/item/weapon/card/id) ) || !( ticker ) || ticker.shuttle_location == shuttle_z || !( user )))
		return
	if (!W.access) //no access
		user << "The access level of [W.registered]\'s card is not high enough. "
		return
	var/list/cardaccess = W.access
	if(!istype(cardaccess, /list) || !cardaccess.len) //no access
		user << "The access level of [W.registered]\'s card is not high enough. "
		return
	var/choice = alert(user, text("Would you like to (un)authorize a shortened launch time? [] authorization\s are still needed. Use abort to cancel all authorizations.", src.auth_need - src.authorized.len), "Shuttle Launch", "Authorize", "Repeal", "Abort")
	switch(choice)
		if("Authorize")
			src.authorized -= W.registered
			src.authorized += W.registered
			if (src.auth_need - src.authorized.len > 0)
				world << text("\blue <B>Alert: [] authorizations needed until shuttle is launched early</B>", src.auth_need - src.authorized.len)
			else
				world << "\blue <B>Alert: Shuttle launch time shortened to 10 seconds!</B>"
				ticker.timeleft = 100
				//src.authorized = null
				del(src.authorized)
				src.authorized = list(  )
		if("Repeal")
			src.authorized -= W.registered
			world << text("\blue <B>Alert: [] authorizations needed until shuttle is launched early</B>", src.auth_need - src.authorized.len)
		if("Abort")
			world << "\blue <B>All authorizations to shorting time for shuttle launch have been revoked!</B>"
			src.authorized.len = 0
			src.authorized = list(  )
		else
	return

/obj/shut_controller/proc/rotate(direct)

	var/SE_X = 1
	var/SE_Y = 1
	var/SW_X = 1
	var/SW_Y = 1
	var/NE_X = 1
	var/NE_Y = 1
	var/NW_X = 1
	var/NW_Y = 1
	for(var/obj/move/M in src.parts)
		if (M.x < SW_X)
			SW_X = M.x
		if (M.x > SE_X)
			SE_X = M.x
		if (M.y < SW_Y)
			SW_Y = M.y
		if (M.y > NW_Y)
			NW_Y = M.y
		if (M.y > NE_Y)
			NE_Y = M.y
		if (M.y < SE_Y)
			SE_Y = M.y
		if (M.x > NE_X)
			NE_X = M.x
		if (M.x < NW_X)
			NW_X = M.y
	var/length = abs(NE_X - NW_X)
	var/width = abs(NE_Y - SE_Y)
	var/obj/random = pick(src.parts)
	var/s_direct = null
	switch(s_direct)
		if(1.0)
			switch(direct)
				if(90.0)
					var/tx = SE_X
					var/ty = SE_Y
					var/t_z = random.z
					for(var/obj/move/M in src.parts)
						M.ty =  -M.x - tx
						M.tx =  -M.y - ty
						var/T = locate(M.x, M.y, 11)
						M.relocate(T)
						M.ty =  -M.ty
						M.tx += length
						//Foreach goto(374)
					for(var/obj/move/M in src.parts)
						M.tx += tx
						M.ty += ty
						var/T = locate(M.tx, M.ty, t_z)
						M.relocate(T, 90)
						//Foreach goto(468)
				if(-90.0)
					var/tx = SE_X
					var/ty = SE_Y
					var/t_z = random.z
					for(var/obj/move/M in src.parts)
						M.ty = M.x - tx
						M.tx = M.y - ty
						var/T = locate(M.x, M.y, 11)
						M.relocate(T)
						M.ty =  -M.ty
						M.ty += width
						//Foreach goto(571)
					for(var/obj/move/M in src.parts)
						M.tx += tx
						M.ty += ty
						var/T = locate(M.tx, M.ty, t_z)
						M.relocate(T, -90.0)
						//Foreach goto(663)
				else
		else
	return