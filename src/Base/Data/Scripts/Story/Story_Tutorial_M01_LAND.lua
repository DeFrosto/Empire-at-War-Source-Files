--/////////////////////////////////////////////////////////////////////////////////////////////////
--
-- (C) Petroglyph Games, Inc.
--
--
--  *****           **                          *                   *
--  *   **          *                           *                   *
--  *    *          *                           *                   *
--  *    *          *     *                 *   *          *        *
--  *   *     *** ******  * **  ****      ***   * *      * *****    * ***
--  *  **    *  *   *     **   *   **   **  *   *  *    * **   **   **   *
--  ***     *****   *     *   *     *  *    *   *  *   **  *    *   *    *
--  *       *       *     *   *     *  *    *   *   *  *   *    *   *    *
--  *       *       *     *   *     *  *    *   *   * **   *   *    *    *
--  *       **       *    *   **   *   **   *   *    **    *  *     *   *
-- **        ****     **  *    ****     *****   *    **    ***      *   *
--                                          *        *     *
--                                          *        *     *
--                                          *       *      *
--                                      *  *        *      *
--                                      ****       *       *
--
--/////////////////////////////////////////////////////////////////////////////////////////////////
-- C O N F I D E N T I A L   S O U R C E   C O D E -- D O   N O T   D I S T R I B U T E
--/////////////////////////////////////////////////////////////////////////////////////////////////
--
--              $File: 
--
--            $Author: Joseph_Gernert $
--
--            $Change: 
--
--          $DateTime: 
--
--          $Revision: 
--
--/////////////////////////////////////////////////////////////////////////////////////////////////


require("PGStoryMode")

-----------------------------------------------------------------------------------------------------------------------
-- Definitions -- This function is called once when the script is first created.
-----------------------------------------------------------------------------------------------------------------------
function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	StoryModeEvents = 
	{
		Tutorial_M01_Begin = State_Tutorial_M01_Begin,
		Tutorial_M01_Give_Clearance_For_Imperial_Attack = State_Tutorial_M01_Construct_Done,
		Tutorial_M01_Construct_01 = State_Tutorial_M01_Construct_01,
		Tutorial_M01_Intro_07 = State_Tutorial_M01_Intro_07,
		Tutorial_M01_Task_Two_04d = State_Highlight_On_Comm_Jammer,
		Tutorial_M01_Task_Four_02a = State_Highlight_On_Turrets,
		Tutorial_M01_Construct_Highlight_Off = State_Highlight_Off_AITurret,
		
		Tutorial_M01_Intro_02 = State_First_Intro_Dialog_Done,
		Tutorial_M01_Intro_04 = State_Second_Intro_Dialog_Done,
		Tutorial_M01_Task_Five_02 = State_Remove_Base_Walls,
		Tutorial_M01_Give_Hint_62 = State_Land_Troops_at_First_RP,
		Tutorial_M01_Patrol_SpreadOut_Hint = State_Tutorial_M01_Patrol_SpreadOut_Hint
	
	}
	
	rebel_squad = {
		"REBEL_MINI_INFANTRY_SQUAD"
	}
	
	rebel_base_squad = {
		"REBEL_MINI_INFANTRY_SQUAD"
		,"REBEL_TANK_BUSTER_SQUAD"
	}
		
	imperial_squad = {
		"IMPERIAL_MEDIUM_STORMTROOPER_SQUAD"
	}
			
	spawn_range = 150
	unit_list = {}
	base_list = {}
	
	imperial_assault_in_progress = false
	init_done = false
	comm_jammer_deleted = false
	skipped_building = false
	
	-- Keep track of how many reinforce points have been captured
	rps_captured = 0
	rp1_captured = false
	rp2_captured = false
	wookie_speed = 1
	flag_wookie_clearing_breached = false
	flag_wookie_clearing2_breached = false
	flag_okay_SkipBuild_Mission = true
	flag_given_HIGHLIGHT_OFF_03 = false
	flag_rebel_wall_is_down = false
end


-----------------------------------------------------------------------------------------------------------------------
-- Function for Event: Tutorial_M01_Begin
-----------------------------------------------------------------------------------------------------------------------


function State_Tutorial_M01_Begin(message)

	if message == OnEnter then

		--MessageBox("]]]] LUA: State_Tutorial_M01_Begin")
	
		-- Get Empire & Rebel Owners		
		rebel_player = Find_Player("Rebel")
		empire_player = Find_Player("Empire")
		neutral_player = Find_Player("Neutral")

		-- Get the Markers
		squad1_marker = Find_Hint("GENERIC_MARKER_LAND", "squad1")
		rebel_base_marker = Find_Hint("GENERIC_MARKER_LAND", "rebelbase")
		rebel_base_marker2 = Find_Hint("GENERIC_MARKER_LAND", "basespawn")
		
		unit_list = Find_All_Objects_With_Hint("reinforce1");
		reinforce_point1 = unit_list[1]
		unit_list = Find_All_Objects_With_Hint("reinforce2");
		reinforce_point2 = unit_list[1]
		--skip_build_list = Find_All_Objects_With_Hint("skip-mission")
		--skip_build_marker = skip_build_list[1]
		skip_build_marker = Find_Hint("REINFORCEMENT_POINT_PLUS5_CAP","reinforce1")
		
		-- Get the rebel base
		base_list = Find_All_Objects_Of_Type("R_GROUND_BARRACKS")
		rebel_base = base_list[1]
		--rebel_base.Change_Owner(neutral_player)
		base_list = Find_All_Objects_Of_Type("COMMUNICATIONS_ARRAY_R")
		rebel_comm_array = base_list[1]
		--rebel_comm_array.Change_Owner(neutral_player)
		
		turret_01 = Find_Hint("REBEL_BUILD_PAD_BACTA","turret01")
		turret_02 = Find_Hint("REBEL_BUILD_PAD_AITURRET","turret02")
		
		reinforcement_point01 = Find_Hint("REINFORCEMENT_POINT_PLUS5_CAP","reinforce1")
		
		if not reinforcement_point01 then
			MessageBox("missing reinforcement_point01!!")
		end
		
		-- Set up first proximity triggers
		Register_Prox(squad1_marker, Spawn_Squad_1, spawn_range, rebel_player)
		Register_Prox(rebel_base_marker, Prox_Base, 200, rebel_player)
		Register_Prox(skip_build_marker, Prox_SkipBuildMission, 150, rebel_player)
		
		
		prox_reinforce01 = Find_Hint("GENERIC_MARKER_LAND","prox-reinforce01")
		--Register_Prox(prox_reinforce01, Prox_Reinforcement_Hint, 150, rebel_player)
		
		-- Trigger first marker
		--Story_Event("HIGHLIGHT_ZONE_ONE")
		
		init_done = true
		
		--markers and stuff for cinematic
		player_squad_list = Find_All_Objects_With_Hint("playersquad")
		player_squad = player_squad_list[1]
		
		
		wookiie_clearing_wookiie_01 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing-wok1")
		wookiie_clearing_wookiie_02 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing-wok2")
		wookiie_clearing_wookiie_03 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing-wok3")
		wookiie_clearing_wookiie_04 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing-wok4")
		wookiie_clearing_wookiie_05 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing-wok5")
		wookiie_clearing_wookiie_06 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing-wok6")
		wookiie_clearing_wookiie_07 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing-wok7")
		wookiie_clearing_wookiie_08 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing-wok8")
		wookiie_clearing_wookiie_09 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing-wok9")
		
		wookiie_clearing02_wookiie_01 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing2-wok1")
		wookiie_clearing02_wookiie_02 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing2-wok2")
		wookiie_clearing02_wookiie_03 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing2-wok3")
		wookiie_clearing02_wookiie_04 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing2-wok4")
		wookiie_clearing02_wookiie_05 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wokclearing2-wok5")
		
		wookiie_clearing_proxflag = Find_Hint("GENERIC_MARKER_LAND","wokclearing-proxflag")
		wookiie_tree03= Find_Hint("GENERIC_MARKER_LAND","woktree-03")
		
		wookiie_clearing2_proxflag = Find_Hint("GENERIC_MARKER_LAND","wokclearing2-proxflag")
		wookiie_tree04= Find_Hint("GENERIC_MARKER_LAND","woktree-04")
		
		mauler_01 = Find_Hint("TIE_CRAWLER","mauler01")
		mauler_02 = Find_Hint("TIE_CRAWLER","mauler02")
		
		mauler_01_goto = Find_Hint("GENERIC_MARKER_LAND","mauler01-goto")
		mauler_02_goto = Find_Hint("GENERIC_MARKER_LAND","mauler02-goto")
		
		if not (mauler_01 or mauler_02) then
			MessageBox("cannot find maulers")
		end
		
		if not (mauler_01_goto or mauler_02_goto) then
			MessageBox("cannot find maulers goto spots")
		end
		
		rebel_base_enemy_prox = Find_Hint("GENERIC_MARKER_LAND","prox-imperials-nearby")
		
		Register_Prox(wookiie_tree03, Enter_Wookie_Tree, 10, neutral_player)
		Register_Prox(wookiie_tree04, Enter_Wookie_Tree, 10, neutral_player)
		Register_Prox(wookiie_clearing_proxflag, Clearing_Wookies_Retreat, 50, rebel_player)
		Register_Prox(wookiie_clearing2_proxflag, Clearing2_Wookies_Retreat, 50, rebel_player)
		
		--Register_Prox(rebel_base_enemy_prox, Empire_Attacking, 100, empire_player)
		
		Create_Thread("Intro_Cinematic")
	end
	
end

-----------------------------------------------------------------------------------------------------------------------
-- JDG OPENING CINEMATIC STUFF HERE
-----------------------------------------------------------------------------------------------------------------------
function Intro_Cinematic()

	-- intro cine function
	cine_start = Find_Hint("GENERIC_MARKER_LAND","empire-landing-cine")
	Point_Camera_At(cine_start)
	Start_Cinematic_Camera()
	Resume_Mode_Based_Music()
	
	walker_01 = Find_Hint("AT_ST_WALKER","walker01")
	walker_02 = Find_Hint("AT_ST_WALKER","walker02")
	
	walker_01_goto = Find_Hint("GENERIC_MARKER_LAND","walker01-goto")
	walker_02_face = Find_Hint("GENERIC_MARKER_LAND","walker02-face")
	
	walker_01.Move_To(walker_01_goto)
	
	
	
	Sleep(1)
	Fade_Screen_In(1)
	
	-- Set_Cinematic_Camera_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	Set_Cinematic_Camera_Key(cine_start, 500, 20, 350, 1, 0, 0, 0)
	-- Set_Cinematic_Camera_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	Set_Cinematic_Target_Key(cine_start, 0, 0, 0, 0, 0, 0, 0) 
	-- Transition_Cinematic_Camera_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
	Transition_Cinematic_Camera_Key(cine_start, 8, 400, 30, 350, 1, 0, 0, 0)
	
	--imperial_squad
	
	ReinforceList(imperial_squad, cine_start.Get_Position(), empire_player, false, true)
	
	
	
	Story_Event("CUE_FIRST_INTRO_DIALOG")
	--Hint: Imperial forces have detected the Rebel presence here on the surface of Kashyyyk.  
	--You will need to gather your troops and defend the Alliance base on this planet.
	Sleep(1.5)
	walker_02.Turn_To_Face(walker_02_face)
	Sleep(2)
	cine_start.Play_SFX_Event("Unit_Shuttle_Landing_3")
	Sleep(2)
	walker_02.Turn_To_Face(walker_01)
	
	
	
end

function State_First_Intro_Dialog_Done(message)
	if message == OnEnter then
		Sleep(2)
		Fade_Screen_Out(1)
		
		
		Create_Thread("Cine_Patrol_PatrolAway")
		
		Sleep(1)
		
		Story_Event("CUE_SECOND_INTRO_DIALOG")
		Fade_Screen_In(1)
		
		Set_Cinematic_Camera_Key(player_squad, 250, 12, 30, 1, player_squad, 1, 0)
		-- Set_Cinematic_Target_Key(target_pos, x_dist, y_pitch, z_yaw, euler, pobj, use_object_rotation, cinematic_animation)
		Set_Cinematic_Target_Key(player_squad, 0, 0, 0, 0, player_squad, 1, 0)
		
		Create_Thread("Cine_Wookies_Run_Away")
	end
end

function State_Second_Intro_Dialog_Done(message)
	if message == OnEnter then
	
		Point_Camera_At(player_squad)
		
		End_Cinematic_Camera()
		Letter_Box_Out(.5)	
		Lock_Controls(0)
		Suspend_AI(0)
	end
end

function Cine_Patrol_PatrolAway()
	patrol_goto1 = Find_Hint("GENERIC_MARKER_LAND","patrol-goto1")
	patrol_goto2 = Find_Hint("GENERIC_MARKER_LAND","patrol-goto2")
	--patrol_goto3 = Find_Hint("GENERIC_MARKER_LAND","patrol-goto3")
	patrol_finalface = Find_Hint("GENERIC_MARKER_LAND","patrol-finalfacespot")
	--player_squad.Move_To(patrol_goto1)
	--player_squad.Move_To(patrol_goto2)
	--player_squad.Move_To(patrol_goto3)
	Formation_Move(player_squad, patrol_goto1)
	Formation_Move(player_squad, patrol_goto2)
	--Formation_Move(player_squad, patrol_goto3)
	
	player_squad.Turn_To_Face(patrol_finalface)
end

function Cine_Wookies_Run_Away()
	--MessageBox("Cine_Wookies_Run_Away hit!!")
	wookie_01 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wok1")
	wookie_02 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wok2")
	wookie_03 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wok3")
	wookie_04 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wok4")
	wookie_05 = Find_Hint("WOOKIE_WARRIOR_UNARMED_SOLO","wok5")
	
	wookie_01.Override_Max_Speed(wookie_speed)
	wookie_02.Override_Max_Speed(wookie_speed)
	wookie_03.Override_Max_Speed(wookie_speed)
	wookie_04.Override_Max_Speed(wookie_speed)
	wookie_05.Override_Max_Speed(wookie_speed)
	
	wookie_tree_01 = Find_Hint("GENERIC_MARKER_LAND","woktree-01")
	wookie_tree_02 = Find_Hint("GENERIC_MARKER_LAND","woktree-02")
	
	Register_Prox(wookie_tree_01, Enter_Wookie_Tree, 10, neutral_player)
	Register_Prox(wookie_tree_02, Enter_Wookie_Tree, 10, neutral_player)
	
	Sleep(3)
	wookie_01.Move_To(wookie_tree_01)
	Sleep(.25)
	wookie_02.Move_To(wookie_tree_01)
	Sleep(.25)
	wookie_03.Move_To(wookie_tree_01)
	Sleep(1)
	wookie_04.Move_To(wookie_tree_02)
	Sleep(.25)
	wookie_05.Move_To(wookie_tree_02)
end



function Enter_Wookie_Tree(prox_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "WOOKIE_WARRIOR_UNARMED_SOLO" then
		--MessageBox("deleting wookie?")
		trigger_obj.Despawn()
	end
end

function Clearing_Wookies_Retreat(prox_obj, trigger_obj)
	
	if not flag_wookie_clearing_breached then
		flag_wookie_clearing_breached = true
		--MessageBox("Wookie clearing prox breached!!")
		Create_Thread("Clearing_Wookies_Run_Away")
	end
end

function Clearing_Wookies_Run_Away()
	--MessageBox("Cine_Wookies_Run_Away hit!!")
	
	wookiie_clearing_wookiie_01.Override_Max_Speed(wookie_speed)
	wookiie_clearing_wookiie_02.Override_Max_Speed(wookie_speed)
	wookiie_clearing_wookiie_03.Override_Max_Speed(wookie_speed)
	wookiie_clearing_wookiie_04.Override_Max_Speed(wookie_speed)
	wookiie_clearing_wookiie_05.Override_Max_Speed(wookie_speed)
	wookiie_clearing_wookiie_06.Override_Max_Speed(wookie_speed)
	wookiie_clearing_wookiie_07.Override_Max_Speed(wookie_speed)
	wookiie_clearing_wookiie_08.Override_Max_Speed(wookie_speed)
	wookiie_clearing_wookiie_09.Override_Max_Speed(wookie_speed)
	
	--Sleep(1)
	wookiie_clearing_wookiie_01.Move_To(wookiie_tree03)
	Sleep(.05)
	wookiie_clearing_wookiie_02.Move_To(wookiie_tree03)
	Sleep(.25)
	wookiie_clearing_wookiie_03.Move_To(wookiie_tree03)
	Sleep(.05)
	wookiie_clearing_wookiie_04.Move_To(wookiie_tree03)
	Sleep(.25)
	wookiie_clearing_wookiie_05.Move_To(wookiie_tree03)
	Sleep(.05)
	wookiie_clearing_wookiie_06.Move_To(wookiie_tree03)
	Sleep(.05)
	wookiie_clearing_wookiie_07.Move_To(wookiie_tree03)
	Sleep(.25)
	wookiie_clearing_wookiie_08.Move_To(wookiie_tree03)
	Sleep(.05)
	wookiie_clearing_wookiie_09.Move_To(wookiie_tree03)
	Sleep(.25)

end

function Clearing2_Wookies_Retreat(prox_obj, trigger_obj)
	
	if not flag_wookie_clearing2_breached then
		flag_wookie_clearing2_breached = true
		--MessageBox("Wookie clearing2 prox breached!!")
		Create_Thread("Clearing2_Wookies_Run_Away")
	end
end 

function Clearing2_Wookies_Run_Away()
	--MessageBox("Clearing2_Wookies_Retreat hit!!")
	
	wookiie_clearing02_wookiie_01.Override_Max_Speed(wookie_speed)
	wookiie_clearing02_wookiie_02.Override_Max_Speed(wookie_speed)
	wookiie_clearing02_wookiie_03.Override_Max_Speed(wookie_speed)
	wookiie_clearing02_wookiie_04.Override_Max_Speed(wookie_speed)
	wookiie_clearing02_wookiie_05.Override_Max_Speed(wookie_speed)

	
	--Sleep(1)
	wookiie_clearing02_wookiie_01.Move_To(wookiie_tree04)
	Sleep(.05)
	wookiie_clearing02_wookiie_02.Move_To(wookiie_tree04)
	Sleep(.25)
	wookiie_clearing02_wookiie_03.Move_To(wookiie_tree04)
	Sleep(.05)
	wookiie_clearing02_wookiie_04.Move_To(wookiie_tree04)
	Sleep(.25)
	wookiie_clearing02_wookiie_05.Move_To(wookiie_tree04)


end



-----------------------------------------------------------------------------------------------------------------------
--jdg misc highlighting events (small arrows)
function State_Highlight_On_Comm_Jammer(message)
	if message == OnEnter then
		comm_jammer = Find_Hint("GENERIC_MARKER_LAND","comm-jammer")
		if TestValid(comm_jammer) then
			Add_Radar_Blip(comm_jammer, "comm_jammer_blip")
			comm_jammer.Highlight_Small(true, -50)
		end
	end
end

function State_Highlight_On_Turrets(message)
	if message == OnEnter then
		turret_01_flag = Find_Hint("GENERIC_MARKER_LAND","bactatank")
		if TestValid(turret_01_flag) then -- bacta tank
			Add_Radar_Blip(turret_01_flag, "turret_01_blip")
			turret_01_flag.Highlight_Small(true, -100)
		end
		
		turret_02_flag = Find_Hint("GENERIC_MARKER_LAND","ai-turret")
		if TestValid(turret_02_flag) then -- anti-infantry turret
			Add_Radar_Blip(turret_02_flag, "turret_02_blip")
			turret_02_flag.Highlight_Small(true, -100)
		end
	end
end

function State_Highlight_Off_AITurret(message)
	if message == OnEnter then
		 -- anti-infantry turret
		 --MessageBox("remove flag from ai turret")
		Remove_Radar_Blip("turret_02_blip")
		turret_02_flag.Highlight_Small(false)
		
	end
end

------------------------------------------------------------------------------------------------------------
--jdg this destroys the walls at the rebel base that prevent getting too far ahead
function State_Remove_Base_Walls(message)
	if message == OnEnter then
		Create_Thread("Mauler01_Attack_Wall")
		Create_Thread("Mauler02_Attack_Wall")
		
		--make all rebels invulnerable for a few seconds
		player_unit_list = Find_All_Objects_Of_Type(rebel_player)
		
		for i, player_unit in pairs(player_unit_list) do
			if TestValid(player_unit) then
				--MessageBox("player_unit.Make_Invulnerable(true)")
				player_unit.Make_Invulnerable(true)
			end
		end
	
	
	
	
	
		
	end
end

function Mauler01_Attack_Wall()
	mauler_01.Prevent_All_Fire(true)
	mauler_01.Prevent_Opportunity_Fire(true)
	--Formation_Move(mauler_01, mauler_01_goto)
	--BlockOnCommand(mauler_01.Move_To(mauler_01_goto))
	
	mauler_01.Move_To(mauler_01_goto)
	Sleep(3)
	mauler_01.Stop()
	mauler_01.Activate_Ability("SELF_DESTRUCT", true)
end

function Mauler02_Attack_Wall()
	mauler_02.Prevent_All_Fire(true)
	mauler_02.Prevent_Opportunity_Fire(true)
	--Formation_Move(mauler_02, mauler_02_goto)
	--BlockOnCommand(mauler_02.Move_To(mauler_02_goto))
	mauler_02.Move_To(mauler_02_goto)
	Sleep(3)
	mauler_02.Stop()
	
	mauler_02.Activate_Ability("SELF_DESTRUCT", true)
end

function State_Tutorial_M01_Patrol_SpreadOut_Hint(message)
	if message == OnEnter then
			
		unit_list = Find_All_Objects_Of_Type("SQUAD_REBEL_TROOPER")
		if table.getn(unit_list) == 0 then
			MessageBox("Couldn't find the Rebel Troopers!")
		else
			for i,unit in pairs(unit_list) do
				rebel_player.Select_Object(unit)
			end
		end
		
	end
end


------------------------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------------------------
function Spawn_Squad_1(prox_obj, trigger_obj)

	-- Ignore transports which aparently have a HUGE bound
	if trigger_obj.Get_Type().Get_Name() == "GALLOFREE_TRANSPORT_LANDING" then
		return
	end
	
	-- Turn off the prox trigger otherwise we are going to have a whole lot 'o rebels running around
	prox_obj.Cancel_Event_Object_In_Range(Spawn_Squad_1)
	
	-- Spawn the first squad, and let the story script know 
	--MessageBox("]]]] Spawning Squad 1: triggering object = %s",trigger_obj.Get_Type().Get_Name())
	unit_list = SpawnList(rebel_squad, squad1_marker, rebel_player, false, true)
	Story_Event("SQUAD_ONE")

	-- Set up next step
	Story_Event("HIGHLIGHT_ZONE_TWO")
	comm_jammer_list = Find_All_Objects_Of_Type("COMM_JAMMER")
	if table.getn(comm_jammer_list) == 0 then
		MessageBox("Couldn't find the Comm_Jammer object! Aborting.")
		return
	end
	comm_jammer_obj = comm_jammer_list[1]
	Register_Death_Event(comm_jammer_obj,Comm_Jammer_Destroyed)
	Register_Prox(comm_jammer_obj, Prox_Jammer, 150, rebel_player)
	
end

-----------------------------------------------------------------------------------------------------------------------

function Comm_Jammer_Destroyed()
	Story_Event("HIGHLIGHT_ZONE_THREE")
	Remove_Radar_Blip("comm_jammer_blip")
	comm_jammer.Highlight_Small(false)
	
	if not comm_jammer_deleted then
		Story_Event("JAMMER_VICTORY")
	end
end

-----------------------------------------------------------------------------------------------------------------------

function Prox_SkipBuildMission(prox_obj, trigger_obj)
	if flag_okay_SkipBuild_Mission == true then
		prox_obj.Cancel_Event_Object_In_Range(Prox_SkipBuildMission)
		Story_Event("HIGHLIGHT_ZONE_FOUR")
		Story_Event("HINT_OVERRIDE")
		skipped_building = true
	end
end

-----------------------------------------------------------------------------------------------------------------------

function Prox_Base(prox_obj, trigger_obj)

	if TestValid(trigger_obj) and trigger_obj.Get_Type() == Find_Object_Type("SQUAD_REBEL_TROOPER") then

		-- turn off the trigger
		prox_obj.Cancel_Event_Object_In_Range(Prox_Base)

		comm_jammer_deleted = true
		if TestValid(comm_jammer_obj) then
			comm_jammer_obj.Take_Damage(10000)
		end

		turret_01.Change_Owner(rebel_player)
		turret_02.Change_Owner(rebel_player)
		rebel_comm_array.Change_Owner(rebel_player)
		rebel_base.Change_Owner(rebel_player)
		rebel_base.Set_Garrison_Spawn(true)

		unit_list = SpawnList(rebel_base_squad, rebel_base_marker, rebel_player, false, true)
		unit_list = SpawnList(rebel_base_squad, rebel_base_marker2, rebel_player, false, true)
			
		--if not flag_given_HIGHLIGHT_OFF_03 then
			--flag_given_HIGHLIGHT_OFF_03 = true
			Story_Event("HIGHLIGHT_OFF_03")
		--end
		
	end
	
end

-----------------------------------------------------------------------------------------------------------------------

function Prox_Jammer(prox_obj, trigger_obj)
	prox_obj.Cancel_Event_Object_In_Range(Prox_Jammer)
	Story_Event("JAMMER_SPOTTED")
end

-----------------------------------------------------------------------------------------------------------------------

function State_Tutorial_M01_Construct_Done(message)

	if message == OnEnter then
		if not skipped_building then
			--MessageBox("State_Tutorial_M01_Construct_Done HIT!!")												  
			time_until_assault = 1
			Register_Timer(Start_Imperial_Assault,time_until_assault)
		end
	end
end


-----------------------------------------------------------------------------------------------------------------------

function Start_Imperial_Assault()
	--jdg causing a crash....commenting out for now
	--skip_build_marker.Cancel_Event_Object_In_Range(Prox_SkipBuildMission)
	flag_okay_SkipBuild_Mission = false
	
	-- Send the imperials to the base
	unit_list = Find_All_Objects_Of_Type("STORMTROOPER_TEAM")
	for i,unit in pairs(unit_list) do
		unit.Attack_Move(rebel_base)
	end
	
	--MessageBox("Starting assault")	
	Sleep(3)					
	Story_Event("IMPERIAL_ASSAULT")
	Story_Event("HINT_OVERRIDE")
	--Register_Timer(Send_Scouts,40) -- The imperial light scouts are next in line, but they are fast!
    Register_Timer(Send_ATSTs,15)
	
	imperial_assault_in_progress = true
end


function Send_ATSTs()
	--MessageBox("Sending AT-ST's")
	unit_list = Find_All_Objects_Of_Type("AT_ST_WALKER")
	for i,unit in pairs(unit_list) do
		unit.Attack_Move(rebel_base)
	end
	Story_Event("HINT_OVERRIDE")
	Story_Event("ATST_ASSAULT")
end

--function Send_Scouts() 
	--MessageBox("Sending Scouts")
	--unit_list = Find_All_Objects_Of_Type("SCOUT_TROOPER")
	--for i,unit in pairs(unit_list) do
		--unit.Attack_Move(rebel_base)
	--end
	--Story_Event("HINT_OVERRIDE")
	--Story_Event("SCOUT_ASSAULT")
--end

function Player_Back_To_Vulnerable()
	Sleep(1)
	
	--remove rebels invulnerable status
	player_unit_list = Find_All_Objects_Of_Type(rebel_player)
	
	for i, player_unit in pairs(player_unit_list) do
		if TestValid(player_unit) then
			--MessageBox("Player_Back_To_Vulnerable")
			player_unit.Make_Invulnerable(false)
		end
	end
	
end

-----------------------------------------------------------------------------------------------------------------------
-- Story_Mode_Service() - Processes each frame.
-----------------------------------------------------------------------------------------------------------------------

function Story_Mode_Service()

	if not init_done then
		return
	end
	
	-- If all the infantry are killed, rebels lose
	unit_list = Find_All_Objects_Of_Type("REBEL_TROOPER_TEAM")
	plex_list = Find_All_Objects_Of_Type("PLEX_SOLDIER_TEAM")
	if (table.getn(unit_list) == 0) and (table.getn(plex_list) == 0) then
		Story_Event("REBELS_LOSE")
	end
	
	
	if not flag_rebel_wall_is_down and not
	(TestValid(mauler_01) or TestValid(mauler_02))then
		flag_rebel_wall_is_down = true
		
		
		
		wall_list = Find_All_Objects_With_Hint("tempwall")
		for i,wall in pairs(wall_list) do
			if TestValid(wall) then
				--MessageBox("walls invulnerable == false")
				wall.Make_Invulnerable(false)
				--wall.Despawn()
				wall.Take_Damage(10000)
			end
		end
		
		Create_Thread("Player_Back_To_Vulnerable")
		
		
	
	end
	
	if imperial_assault_in_progress then
		unit_list = Find_All_Objects_Of_Type("STORMTROOPER_TEAM")
		if table.getn(unit_list) > 0 then
			--DebugMessage("]]]] still stormtroopers alive")
			return
		end
		unit_list = Find_All_Objects_Of_Type("AT_ST_WALKER")
		if table.getn(unit_list) > 0 then
			--DebugMessage("]]]] still AT-ST's alive")
			return
		end
		unit_list = Find_All_Objects_Of_Type("SCOUT_TROOPER")
		if table.getn(unit_list) > 0 then
			--DebugMessage("]]]] still scouts alive")
			return
		end
		
		--MessageBox("Imperial Assault was repelled")
		imperial_assault_in_progress = false
		Story_Event("HINT_OVERRIDE")
		Story_Event("HIGHLIGHT_ZONE_FOUR")
		--Register_Prox(reinforce_point1, Spawn_Troopers_01, 200, rebel_player)
		Register_Prox(reinforce_point2, Spawn_Troopers_02, 200, rebel_player)
	end
	
	if not rp1_captured and reinforce_point1.Get_Owner() == rebel_player then
		Story_Event("HINT_OVERRIDE")
		Story_Event("STOP_HIGHLIGHT_RP1")
		rp1_captured = true
		rps_captured = rps_captured + 1
		if rps_captured == 1 then
			Story_Event("FIRST_REINFORCE_CAPTURED")
		else
			Story_Event("MISSION_COMPLETE")
		end				
	end
	
	if not rp2_captured and reinforce_point2.Get_Owner() == rebel_player then
		Story_Event("HINT_OVERRIDE")
		Story_Event("STOP_HIGHLIGHT_RP2")
		rp2_captured = true
		rps_captured = rps_captured + 1
		if rps_captured == 1 then
			Story_Event("FIRST_REINFORCE_CAPTURED")
		else
			Story_Event("MISSION_COMPLETE")
		end				
	end

end

-----------------------------------------------------------------------------------------------------------------------

function Spawn_Troopers_01 (prox_obj, trigger_obj)
	--MessageBox("TROOP_TRANSPORT_1")
	--Story_Event("TROOP_TRANSPORT_1")
	prox_obj.Cancel_Event_Object_In_Range(Spawn_Troopers_01)
	
end




function State_Land_Troops_at_First_RP(message)
	if message == OnEnter then
		ReinforceList(imperial_squad, reinforce_point1.Get_Position(), empire_player, false, true)
	end
end

function Spawn_Troopers_02 (prox_obj, trigger_obj)
	--MessageBox("TROOP_TRANSPORT_2")
	Story_Event("TROOP_TRANSPORT_2")
	prox_obj.Cancel_Event_Object_In_Range(Spawn_Troopers_02)
	ReinforceList(imperial_squad, reinforce_point2.Get_Position(), empire_player, false, true)
end

function State_Tutorial_M01_Construct_01(message)
	if message == OnEnter then
		Story_Event("HINT_OVERRIDE")
		
		--MessageBox("remove flag from bacta tank")
		Remove_Radar_Blip("turret_01_blip")
		turret_01_flag.Highlight_Small(false)
	end
end

-----------------------------------------------------------------------------------------------------------------------

function State_Tutorial_M01_Intro_07(message)
	if message == OnEnter then

		--SQUAD_REBEL_TROOPER
		unit_list = Find_All_Objects_Of_Type("SQUAD_REBEL_TROOPER")
		if table.getn(unit_list) == 0 then
			MessageBox("Couldn't find the Rebel Troopers!")
		else
			for i,unit in pairs(unit_list) do
				rebel_player.Select_Object(unit)
			end
		end
		
	end
end

-----------------------------------------------------------------------------------------------------------------------

