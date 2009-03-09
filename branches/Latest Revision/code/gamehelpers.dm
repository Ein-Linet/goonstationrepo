///////////////////////////////////////////////////////////////
//If you dont know what this stuff is, then you dont need it.//
///////////////////////////////////////////////////////////////

/proc/getleftblocks(input,blocknumber,blocksize)
	var/string
	string = copytext(input,1,((blocksize*blocknumber)-(blocksize-1)))
	if (blocknumber > 1)
		return string
	else
		return null

/proc/getrightblocks(input,blocknumber,blocksize)
	var/string
	string = copytext(input,blocksize*blocknumber+1,length(input)+1)
	if (blocknumber < (length(input)/blocksize))
		return string
	else
		return null

/proc/getblock(input,blocknumber,blocksize)
	var/result
	result = copytext(input ,(blocksize*blocknumber)-(blocksize-1),(blocksize*blocknumber)+1)
	return result

/proc/setblock(istring, blocknumber, replacement, blocksize)
	var/result
	result = getleftblocks(istring, blocknumber, blocksize) + replacement + getrightblocks(istring, blocknumber, blocksize)
	return result

/proc/add_zero2(t, u)
	var/temp1
	while (length(t) < u)
		t = "0[t]"
	temp1 = t
	if (length(t) > u)
		temp1 = copytext(t,2,u+1)
	return temp1

/proc/miniscramble(input,rs,rd)
	var/output
	output = null
	if (input == "C" || input == "D" || input == "E" || input == "F")
		output = pick(prob((rs*10));"4",prob((rs*10));"5",prob((rs*10));"6",prob((rs*10));"7",prob((rs*5)+(rd));"0",prob((rs*5)+(rd));"1",prob((rs*10)-(rd));"2",prob((rs*10)-(rd));"3")
	if (input == "8" || input == "9" || input == "A" || input == "B")
		output = pick(prob((rs*10));"4",prob((rs*10));"5",prob((rs*10));"A",prob((rs*10));"B",prob((rs*5)+(rd));"C",prob((rs*5)+(rd));"D",prob((rs*5)+(rd));"2",prob((rs*5)+(rd));"3")
	if (input == "4" || input == "5" || input == "6" || input == "7")
		output = pick(prob((rs*10));"4",prob((rs*10));"5",prob((rs*10));"A",prob((rs*10));"B",prob((rs*5)+(rd));"C",prob((rs*5)+(rd));"D",prob((rs*5)+(rd));"2",prob((rs*5)+(rd));"3")
	if (input == "0" || input == "1" || input == "2" || input == "3")
		output = pick(prob((rs*10));"8",prob((rs*10));"9",prob((rs*10));"A",prob((rs*10));"B",prob((rs*10)-(rd));"C",prob((rs*10)-(rd));"D",prob((rs*5)+(rd));"E",prob((rs*5)+(rd));"F")
	if (!output) output = "5"
	return output

/proc/isblockon(hnumber, bnumber)
	var/temp2
	temp2 = hex2num(hnumber)
/////////////////////////////
	if (bnumber == 2 || bnumber == 12)
		if (temp2 >= 3500)
			return 1
		else
			return 0
	if (bnumber == 8 || bnumber == 10)
		if (temp2 >= 3050)
			return 1
		else
			return 0
/////////////////////////////
	if (temp2 >= 2050)
		return 1
	else
		return 0

/proc/randmutb(mob/M as mob)
	var/num
	var/newdna
	num = pick(1,3,5,6,7,9,11,13)
	newdna = setblock(M.primarynew.struc_enzyme,num,toggledblock(getblock(M.primarynew.struc_enzyme,num,3)),3)
	M.primarynew.struc_enzyme = newdna
	return

/proc/randmutg(mob/M as mob)
	var/num
	var/newdna
	num = pick(2,4,8,10,12)
	newdna = setblock(M.primarynew.struc_enzyme,num,toggledblock(getblock(M.primarynew.struc_enzyme,num,3)),3)
	M.primarynew.struc_enzyme = newdna
	return

/proc/randmuti(mob/M as mob)
	var/num
	var/newdna
	num = pick(1,2,3,4,5,6,7,8,9,10,11,12,13)
	newdna = setblock(M.primarynew.uni_identity,num,add_zero2(num2hex(rand(1,4095),1),3),3)
	M.primarynew.uni_identity = newdna
	return

/proc/toggledblock(hnumber) //unused
	var/temp3
	var/chtemp
	temp3 = hex2num(hnumber)
	if (temp3 < 2050)
		chtemp = rand(2050,4095)
		return add_zero2(num2hex(chtemp,1),3)
	else
		chtemp = rand(1,2049)
		return add_zero2(num2hex(chtemp,1),3)

// LAWL PERSH HAI2U

/proc/updateappearance(mob/M as mob,structure)
	if(istype(M, /mob/human))
		var/mob/human/H = M
		H.r_hair = hex2num(getblock(structure,1,3))
		H.b_hair = hex2num(getblock(structure,2,3))
		H.g_hair = hex2num(getblock(structure,3,3))
		H.r_facial = hex2num(getblock(structure,4,3))
		H.b_facial = hex2num(getblock(structure,5,3))
		H.g_facial = hex2num(getblock(structure,6,3))
		H.s_tone = round(((hex2num(getblock(structure,7,3))/25)-125))
		H.r_eyes = hex2num(getblock(structure,8,3))
		H.g_eyes = hex2num(getblock(structure,9,3))
		H.b_eyes = hex2num(getblock(structure,10,3))
		if (isblockon(getblock(structure, 11,3),11))
			H.gender = "female"
		else
			H.gender = "male"
		///
		if (hex2num(getblock(structure,12,3)) >= 1 && hex2num(getblock(structure,12,3)) <= 350) H.f_style_r = "bald"
		if (hex2num(getblock(structure,12,3)) >= 351 && hex2num(getblock(structure,12,3)) <= 700) H.f_style_r = "facial_elvis"
		if (hex2num(getblock(structure,12,3)) >= 701 && hex2num(getblock(structure,12,3)) <= 1050) H.f_style_r = "facial_vandyke"
		if (hex2num(getblock(structure,12,3)) >= 1051 && hex2num(getblock(structure,12,3)) <= 1400) H.f_style_r = "facial_neckbeard"
		if (hex2num(getblock(structure,12,3)) >= 1401 && hex2num(getblock(structure,12,3)) <= 1750) H.f_style_r = "facial_chaplin"
		if (hex2num(getblock(structure,12,3)) >= 1751 && hex2num(getblock(structure,12,3)) <= 2100) H.f_style_r = "facial_watson"
		if (hex2num(getblock(structure,12,3)) >= 2101 && hex2num(getblock(structure,12,3)) <= 2450) H.f_style_r = "facial_abe"
		if (hex2num(getblock(structure,12,3)) >= 2451 && hex2num(getblock(structure,12,3)) <= 2800) H.f_style_r = "facial_chin"
		if (hex2num(getblock(structure,12,3)) >= 2801 && hex2num(getblock(structure,12,3)) <= 3150) H.f_style_r = "facial_hip"
		if (hex2num(getblock(structure,12,3)) >= 3151 && hex2num(getblock(structure,12,3)) <= 3500) H.f_style_r = "facial_gt"
		if (hex2num(getblock(structure,12,3)) >= 3501 && hex2num(getblock(structure,12,3)) <= 4095) H.f_style_r = "facial_hogan"//beard

		if (hex2num(getblock(structure,12,3)) >= 1 && hex2num(getblock(structure,12,3)) <= 350) H.f_style = "bald"
		if (hex2num(getblock(structure,12,3)) >= 351 && hex2num(getblock(structure,12,3)) <= 700) H.f_style = "facial_elvis"
		if (hex2num(getblock(structure,12,3)) >= 701 && hex2num(getblock(structure,12,3)) <= 1050) H.f_style = "facial_vandyke"
		if (hex2num(getblock(structure,12,3)) >= 1051 && hex2num(getblock(structure,12,3)) <= 1400) H.f_style = "facial_neckbeard"
		if (hex2num(getblock(structure,12,3)) >= 1401 && hex2num(getblock(structure,12,3)) <= 1750) H.f_style = "facial_chaplin"
		if (hex2num(getblock(structure,12,3)) >= 1751 && hex2num(getblock(structure,12,3)) <= 2100) H.f_style = "facial_watson"
		if (hex2num(getblock(structure,12,3)) >= 2101 && hex2num(getblock(structure,12,3)) <= 2450) H.f_style = "facial_abe"
		if (hex2num(getblock(structure,12,3)) >= 2451 && hex2num(getblock(structure,12,3)) <= 2800) H.f_style = "facial_chin"
		if (hex2num(getblock(structure,12,3)) >= 2801 && hex2num(getblock(structure,12,3)) <= 3150) H.f_style = "facial_hip"
		if (hex2num(getblock(structure,12,3)) >= 3151 && hex2num(getblock(structure,12,3)) <= 3500) H.f_style = "facial_gt"
		if (hex2num(getblock(structure,12,3)) >= 3501 && hex2num(getblock(structure,12,3)) <= 4095) H.f_style = "facial_hogan"//beard
		///
		if (hex2num(getblock(structure,13,3)) >= 1 && hex2num(getblock(structure,12,3)) <= 750) H.h_style_r = "bald"
		if (hex2num(getblock(structure,13,3)) >= 751 && hex2num(getblock(structure,12,3)) <= 1250) H.h_style_r = "hair_c"
		if (hex2num(getblock(structure,13,3)) >= 1251 && hex2num(getblock(structure,12,3)) <= 2000) H.h_style_r = "hair_b"
		if (hex2num(getblock(structure,13,3)) >= 2001 && hex2num(getblock(structure,12,3)) <= 2750) H.h_style_r = "hair_a"//hair
		if (hex2num(getblock(structure,13,3)) >= 2751 && hex2num(getblock(structure,12,3)) <= 3250) H.h_style_r = "hair_d"
		if (hex2num(getblock(structure,13,3)) >= 3251 && hex2num(getblock(structure,12,3)) <= 4000) H.h_style_r = "hair_e"
		if (hex2num(getblock(structure,13,3)) >= 4001 && hex2num(getblock(structure,12,3)) <= 4095) H.h_style_r = "hair_f"

		if (hex2num(getblock(structure,13,3)) >= 1 && hex2num(getblock(structure,12,3)) <= 750) H.h_style = "bald"
		if (hex2num(getblock(structure,13,3)) >= 751 && hex2num(getblock(structure,12,3)) <= 1250) H.h_style = "hair_c"
		if (hex2num(getblock(structure,13,3)) >= 1251 && hex2num(getblock(structure,12,3)) <= 2000) H.h_style = "hair_b"
		if (hex2num(getblock(structure,13,3)) >= 2001 && hex2num(getblock(structure,12,3)) <= 2750) H.h_style = "hair_a"//hair
		if (hex2num(getblock(structure,13,3)) >= 2751 && hex2num(getblock(structure,12,3)) <= 3250) H.h_style = "hair_d"
		if (hex2num(getblock(structure,13,3)) >= 3251 && hex2num(getblock(structure,12,3)) <= 4000) H.h_style = "hair_e"
		if (hex2num(getblock(structure,13,3)) >= 4001 && hex2num(getblock(structure,12,3)) <= 4095) H.h_style = "hair_f"


		//
		H.update_face()
		H.update_body()
		return 1
	else
		return 0

/proc/domutcheck(mob/M as mob, connected,inj) //this is a really ugly way of doing this, please dont hit me
	if (M.ishulk == 1)
		M.ishulk = 0
		M.anchored = 0
	M.isslime = 0
	M.telekinesis = 0
	M.firemut = 0
	M.sdisabilities = 0
	M.xray = 0
	M.clumsy = 0
	M.disabilities = 0 //turn off EVERYTHING - Yeah, lazy
	M.see_in_dark = 2
	M.see_invisible = 0
	if (isblockon(getblock(M.primarynew.struc_enzyme, 1,3),1))
		M.disabilities |= 1
		M << "\red Your eyes feel strange."
	if (isblockon(getblock(M.primarynew.struc_enzyme, 2,3),2))
		if(inj || prob(15))
			M << "\blue Your muscles hurt."
			M.ishulk = 1
			M.anchored = 1
	if (isblockon(getblock(M.primarynew.struc_enzyme, 3,3),3))
		M.disabilities |= 2
		M << "\red You get a headache."
	if (isblockon(getblock(M.primarynew.struc_enzyme, 4,3),4))
		M << "\red You feel strange."
	if (isblockon(getblock(M.primarynew.struc_enzyme, 5,3),5))
		M.disabilities |= 4
		M << "\red You start coughing."
	if (isblockon(getblock(M.primarynew.struc_enzyme, 6,3),6))
		M << "\red You feel lightheaded."
		M.clumsy = 1
	if (isblockon(getblock(M.primarynew.struc_enzyme, 7,3),7))
		M.disabilities |= 8
		M << "\red You twitch."
	if (isblockon(getblock(M.primarynew.struc_enzyme, 8,3),8))
		if(inj || prob(50))
			M << "\blue The walls suddenly disappear."
			M.sight |= (SEE_MOBS|SEE_OBJS|SEE_TURFS)
			M.see_in_dark = 8
			M.see_invisible = 4
			M.xray = 1
	if (isblockon(getblock(M.primarynew.struc_enzyme, 9,3),9))
		M.disabilities |= 16
		M << "\red You feel nervous."
	if (isblockon(getblock(M.primarynew.struc_enzyme, 10,3),10))
		if(inj || prob(30))
			M << "\blue Your body feels warm."
			M.firemut = 1
	if (isblockon(getblock(M.primarynew.struc_enzyme, 11,3),11))
		M.sdisabilities |= 1
		M << "\red You cant seem to see anything."
	if (isblockon(getblock(M.primarynew.struc_enzyme, 12,3),12))
		if(inj || prob(15))
			M << "\blue You feel smarter."
			M.telekinesis = 1
	if (isblockon(getblock(M.primarynew.struc_enzyme, 13,3),13))
		M.sdisabilities |= 4
		M.ear_deaf = 1
		M << "\red Its kinda quiet..."

//////////////////////////////////////////////////////////// Monkey Block
	if (isblockon(getblock(M.primarynew.struc_enzyme, 14,3),14) && istype(M, /mob/human))
	// human > monkey
		for(var/obj/item/weapon/W in M)
			M.u_equip(W)
			if (M.client)
				M.client.screen -= W
			if (W)
				W.loc = M.loc
				W.dropped(M)
				W.layer = initial(W.layer)

		if(!connected)
			M.UpdateClothing()
			M.monkeyizing = 1
			M.canmove = 0
			M.icon = null
			M.invisibility = 100
			var/atom/movable/overlay/animation = new /atom/movable/overlay( M.loc )
			animation.icon_state = "blank"
			animation.icon = 'mob.dmi'
			animation.master = src
			flick("h2monkey", animation)
			sleep(48)
			del(animation)

		var/mob/monkey/O = new /mob/monkey(src)
		if(ticker.killer == M)
			O.memory = M.memory
			ticker.killer = O
		O.start = 1
		O.primarynew = M.primarynew
		M.primarynew = null

		for(var/obj/T in M)
			del(T)
		for(var/R in M.organs)
			del(M.organs[text("[]", R)])

		O.loc = M.loc
		if (M.client)
			M.client.mob = O
		if (connected) //inside dna thing
			var/obj/machinery/dna_scannernew/C = connected
			O.loc = C
			C.occupant = O
			connected = null
		O.name = text("monkey ([])",copytext(md5(M.rname), 2, 6))
		del(M)
		return

	if (!isblockon(getblock(M.primarynew.struc_enzyme, 14,3),14) && !istype(M, /mob/human))
	// monkey > human
		for(var/obj/item/weapon/W in M)
			M.u_equip(W)
			if (M.client)
				M.client.screen -= W
			if (W)
				W.loc = M.loc
				W.dropped(M)
				W.layer = initial(W.layer)

		if(!connected)
			M.UpdateClothing()
			M.monkeyizing = 1
			M.canmove = 0
			M.icon = null
			M.invisibility = 100
			var/atom/movable/overlay/animation = new /atom/movable/overlay( M.loc )
			animation.icon_state = "blank"
			animation.icon = 'mob.dmi'
			animation.master = src
			flick("monkey2h", animation)
			sleep(48)
			del(animation)

		var/mob/human/O = new /mob/human( src )
		if(ticker.killer == M)
			O.memory = M.memory
			ticker.killer = O
		O.start = 1
		if (isblockon(getblock(M.primarynew.uni_identity, 11,3),11))
			O.gender = "female"
		else
			O.gender = "male"
		O.primarynew = M.primarynew
		M.primarynew = null

		for(var/obj/T in M)
			del(T)

		O.loc = M.loc
		if (M.client)
			M.client.mob = O
		if (connected) //inside dna thing
			var/obj/machinery/dna_scannernew/C = connected
			O.loc = C
			C.occupant = O
			connected = null

		var/i
		while (!i)
			var/randomname
			if (O.gender == "male")
				randomname = capitalize(pick(first_names_male) + " " + capitalize(pick(last_names)))
			else
				randomname = capitalize(pick(first_names_female) + " " + capitalize(pick(last_names)))
			if (findname(randomname))
				continue
			else
				O.rname = randomname
				i++
		updateappearance(O,O.primarynew.uni_identity)
		del(M)
		return
//////////////////////////////////////////////////////////// Monkey Block
	M.UpdateClothing()
	return null

/proc/dopage(src,target)
	var/href_list
	var/href
	href_list = params2list("src=\ref[src]&[target]=1")
	href = "src=\ref[src];[target]=1"
	src:temphtml = null
	src:Topic(href, href_list)
	return null
