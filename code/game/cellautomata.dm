/obj/landmark/New()

	..()
	src.tag = text("landmark*[]", src.name)
	src.invisibility = 101

	if (name == "shuttle")
		shuttle_z = src.z
		del(src)

	if (name == "airtunnel_stop")
		airtunnel_stop = src.x

	if (name == "airtunnel_start")
		airtunnel_start = src.x

	if (name == "airtunnel_bottom")
		airtunnel_bottom = src.y

	if (name == "monkey")
		monkeystart += src.loc
		del(src)

	//prisoners
	if (name == "prisonwarp")
		prisonwarp += src.loc
		del(src)
	if (name == "mazewarp")
		mazewarp += src.loc
	if (name == "tdome1")
		tdome1	+= src.loc
	if (name == "tdome2")
		tdome2 += src.loc
	//not prisoners
	if (name == "prisonsecuritywarp")
		prisonsecuritywarp += src.loc
		del(src)

	if (name == "blobstart")
		blobstart += src.loc
		del(src)
	return

/obj/start/New()
	..()
	src.tag = "start*[src.name]"
	src.invisibility = 100
	return

/world/New()
	src.update_status()

	for (var/turf/T in world)
		T.updatelinks()

	makepipelines()
	makepowernets()

	sun = new /datum/sun()

	// ****stuff for presistent mode picking
	var/newmode = null

	var/modefile = file2text(persistent_file)

	if(modefile)			// stuff to fix trailing NL problems
		var/list/ML = dd_text2list(modefile, "\n")

		newmode = ML[1]

		//world << "Savefile: [SF] ([SF["newmode"]])"

		if(newmode)
			master_mode = newmode
			world.log << "Read default mode '[newmode]' from [persistent_file]"


	// *****
	var/motd = file2text("config/motd.txt")
	auth_motd = file2text("config/motd-auth.txt")
	no_auth_motd = file2text("config/motd-noauth.txt")
	if (motd)
		join_motd = motd


	var/ad_text = file2text("config/admins.txt")
	var/list/L = dd_text2list(ad_text, "\n")
	for(var/t in L)
		if (t)
			if (copytext(t, 1, 2) == ";")
				continue
			var/t1 = findtext(t, " - ", 1, null)
			if (t1)
				var/m_key = copytext(t, 1, t1)
				var/a_lev = copytext(t, t1 + 3, length(t) + 1)
				admins[m_key] = a_lev
				world.log << ("ADMIN: [m_key] = [a_lev]")

	config = new /datum/configuration()
	config.load("config/config.txt")
	// apply some settings from config..
	abandon_allowed = config.respawn

	src.update_status()

	vote = new /datum/vote()

	main_hud1 = new /obj/hud(  )
	main_hud2 = new /obj/hud/hud2(  )
	SS13_airtunnel = new /datum/air_tunnel/air_tunnel1(  )

	..()

	sleep(50)

	nuke_code = text("[]", rand(10000, 99999.0))
	for(var/obj/machinery/nuclearbomb/N in world)
		if (N.r_code == "ADMIN")
			N.r_code = nuke_code
	sleep(50)

	plmaster = new /obj/overlay(  )
	plmaster.icon = 'plasma.dmi'
	plmaster.icon_state = "onturf"
	plmaster.layer = FLY_LAYER

	slmaster = new /obj/overlay(  )
	slmaster.icon = 'plasma.dmi'
	slmaster.icon_state = "sl_gas"
	slmaster.layer = FLY_LAYER

	cellcontrol = new /datum/control/cellular()
	spawn (0)
		cellcontrol.process()
		return

	src.update_status()

	spawn (0)
		sleep(900)		//*****RM was 900
		Label_482:
		if (going && (!ticker))
			ticker = new /datum/control/gameticker(  )
			spawn( 0 )
				ticker.process()
				return
			data_core = new /obj/datacore(  )
		else
			sleep(100)
			goto Label_482
		return
	return

//Crispy fullban
/world/Del()
	for(var/mob/M in world)
		if(M.client)
			M << sound('sound/NewRound.ogg')
	sleep(10) // wait for sound to play
	..()

/atom/proc/check_eye(user as mob)
	if (istype(user, /mob/ai))
		return 1
	return

/atom/proc/Bumped(AM as mob|obj)
	return

/atom/movable/Bump(var/atom/A as mob|obj|turf|area, yes)
	spawn( 0 )
		if ((A && yes))
			A.Bumped(src)
		return
	..()
	return

// **** Note in 40.93.4, split into obj/mob/turf point verbs, no area

/atom/verb/point()
	set src in oview()

	if ((!( usr ) || !( isturf(usr.loc) )) || isarea(src))		// can't point to areas anymore
		return
	if (usr.stat == 0 && !usr.restrained())
		var/P = new /obj/point( (isturf(src) ? src : src.loc) )
		spawn(20)
			del(P)
			return
		for(var/mob/M in viewers(usr, null))
			M.show_message(text("<B>[]</B> points to []", usr, src), 1)
	return

/turf/proc/updatecell()
	return

/turf/proc/conduction()
	return

/turf/proc/cachecell()
	return

/datum/control/proc/process()
	return

/datum/control/gameticker/proc/meteor_process()
	do
		if (!( shuttle_frozen ))
			if (src.timing == 1)
				src.timeleft -= 10
			else
				if (src.timing == -1.0)
					src.timeleft += 10
					if (src.timeleft >= shuttle_time_to_arrive)
						src.timeleft = null
						src.timing = 0
		for(var/i = 0; i < 10; i++)
			spawn_meteors()
		if (src.timeleft <= 0 && src.timing)
			src.timeup()

		sleep(10)
	while(src.processing)
	return


/datum/control/gameticker/proc/extend_process()

	do
		if (!( shuttle_frozen ))
			if (src.timing == 1)
				src.timeleft -= 10
			else
				if (src.timing == -1.0)
					src.timeleft += 10
					if (src.timeleft >= shuttle_time_to_arrive)
						src.timeleft = null
						src.timing = 0
		if (prob(0.5))
			spawn_meteors()
		if (src.timeleft <= 0 && src.timing)
			src.timeup()

		sleep(10)
	while(src.processing)
	return

/datum/control/gameticker/proc/malfunction_process()
	do
		if(ticker.AItime == ticker.AIwin)
			return
		ticker.AItime += 10
		sleep(10)
		if (ticker.AItime == 6000)
			world << "<FONT size = 3><B>Cent. Com. Update</B> AI Malfunction Detected</FONT>"
			world << "\red It seems we have provided you with a malfunctioning AI. We're very sorry."
	while(src.processing)
	return

/datum/control/gameticker/proc/nuclear(z_level)
	if (src.mode != "nuclear emergency")
		return
	if (z_level != 1)
		return
	spawn( 0 )
		src.objective = "Success"
		world << "<B>The Syndicate Operatives have destroyed Space Station 13!</B>"
		for(var/mob/human/H in world)
			if ((H.client && findtext(H.rname, "Syndicate ", 1, null)))
				if (H.stat != 2)
					world << text("<B>[] was []</B>", H.key, H.rname)
				else
					world << text("[] was [] (Dead)", H.key, H.rname)
		src.timing = 0
		sleep(300)
		world.log_game("Syndicate success")
		world.Reboot()
		return
	return

/datum/control/gameticker/proc/timeup()


	var/area/A = locate(/area/shuttle)
	if (src.shuttle_location == shuttle_z)

		var/list/srcturfs = list()
		var/list/dstturfs = list()
		var/throwx = 0

		for(var/turf/T in A)
			if (T.z == shuttle_z)
				srcturfs += T
			else
				dstturfs += T
			if(T.x > throwx)
				throwx = T.x

		// hey you, get out of the way!
		for(var/turf/T in dstturfs)
			// find the turf to move things to
			var/turf/D = locate(throwx, T.y, 1)
			var/turf/E = get_step(D, EAST)
			for(var/atom/movable/AM as mob|obj in T)
				// east! the mobs go east!
				AM.Move(D)
				spawn(0)
					AM.throw_at(E, 1, 1)
					return
		for(var/turf/T in srcturfs)
			for(var/atom/movable/AM as mob|obj in T)
				// first of all, erase any non-space turfs in the zone in
				var/turf/U = locate(T.x, T.y, 1)
				if(!istype(U, /turf/space))
					var/turf/space/S = new /turf/space( locate(U.x, U.y, U.z) )
					A.contents -= S
					A.contents += S
				AM.z = 1
			var/turf/U = locate(T.x, T.y, shuttle_z)
			U.oxygen = T.oxygen
			U.oldoxy = T.oldoxy
			U.tmpoxy = T.tmpoxy
			U.poison = T.poison
			U.oldpoison = T.oldpoison
			U.tmppoison = T.tmppoison
			U.co2 = T.co2
			U.oldco2 = T.oldco2
			U.tmpco2 = T.tmpco2

			U.buildlinks()
			del(T)
		src.timeleft = shuttle_time_in_station
		src.shuttle_location = 1
		world << "<B>The emergency shuttle has docked with the station! You have [ticker.timeleft/600] minutes to board the shuttle.</B>"
	else //marker2
		world << "<B>The emergency shuttle is leaving!</B>"
		shuttlecomming = 0
		check_win()
	return.

/datum/control/gameticker/proc/check_win()
	if (!mode.check_win())
		return 0

	for (var/mob/ai/aiPlayer in world)
		if (aiPlayer.stat!=2)
			world << "<b>The AI's laws at the end of the game were:</b>"
		else
			world << "<b>The AI's laws when it was deactivated were:</b>"
		aiPlayer.showLaws(1)

	var/area/A = locate(/area/shuttle)
	if (src.shuttle_location != shuttle_z)
		for(var/turf/T in A)
			if (T.z == 1)
				for(var/atom/movable/AM as mob|obj in T)
					A\M.z = shuttle_z
				var/turf/U = locate(T.x, T.y, shuttle_z)
				U.oxygen = T.oxygen
				U.oldoxy = T.oldoxy
				U.tmpoxy = T.tmpoxy
				U.poison = T.poison
				U.oldpoison = T.oldpoison
				U.tmppoison = T.tmppoison
				U.co2 = T.co2
				U.oldco2 = T.oldco2
				U.tmpco2 = T.tmpco2

				U.buildlinks()
				//T = null
				del(T)
	sleep(300)
	world.log_game("Rebooting due to end of game")
	world.Reboot()
	return 1

/datum/control/gameticker/process()

	shuttle_location = shuttle_z

	world.update_status()
	world << "<B>Welcome to the Space Station 13!</B>\n\n"

	switch (master_mode)
		if("secret")
			src.mode = config.pick_random_mode()
			world << "<B>The current game mode is - Secret!</B>"
			world << "<B>The game will pick between meteor, traitor, blob, malfunction, nuclear, wizard and monkey mode!</B>"
		if("random")
			src.mode = config.pick_random_mode()
			world << "<B>The current game mode is - Random</B>"
			world << "<B>The game has picked mode: \red [src.mode.name]</B>"
		else
			src.mode = config.pick_mode(master_mode)
			src.mode.announce()

	src.mode.pre_setup()

	world << "<B>Now dispensing all identification cards.</B>"

	world.log_game("starting game of [src.mode.name]")

	DivideOccupations()

	for (var/obj/manifest/M in world)
		M.manifest()

	for (var/mob/human/H in world)
		if (H.start) //dnamarker1
			reg_dna[H.primary.uni_identity] = H.name

	data_core.manifest()

	src.mode.post_setup()

	for(var/obj/start/S in world)
		//Deleting Startpoints but we need the ai point to AIize people later
		if (S.name != "AI")
			del(S)

// *****
// MAIN LOOP OF PROGRAM
// *****

/datum/control/cellular/process()
	set invisibility = 0
	set background = 1

	Label_6:

	while(!( ticker ))
		for(var/mob/M in world)
			spawn( 0 )
				if(!M)
					return
				M.UpdateClothing()
				return
		sleep(10)

	time = (++time %10)

	sun.calc_position()

	if(time%3 == 0)
		spawn(-1)
			for(var/turf/space/space in world)
				if (!skipupdate)
					if (space.updatecell)
						space.updatecell()
			return
	skipupdate = !skipupdate

	for(var/turf/station/T in world)
		if (T.updatecell)
			T.updatecell()
			if(!time)
				T.conduction()

	sleep(3)
	for(var/mob/M in world)
		spawn( 0 )
			if(!M)
				return
			M.Life()
			return

	sleep(3)
	for(var/obj/move/S in world)
		S.process()
	sleep(2)

	for(var/obj/machinery/M in machines)
		M.process()

	for(var/obj/machinery/M in gasflowlist)
		M.gas_flow()

	for(var/datum/powernet/P in powernets)
		P.reset()


	src.var_swap = !( src.var_swap )
	if (src.processing)
		sleep(2)
		goto Label_6
	return
