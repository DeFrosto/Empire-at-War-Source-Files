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
		Tutorial_M03_Begin = State_Tutorial_M03_Begin,
		Follow_Through_Asteroids = State_Follow_Through_Asteroids,
		Follow_To_Frigate = State_Follow_To_Frigate,
		Tutorial_M03_Eliminate_Fighters_06 = State_Tutorial_M03_Eliminate_Fighters_06,
		Tutorial_M03_Deploy_Reinforcements_05_Objective = State_Tutorial_M03_Deploy_Reinforcements_05_Objective,
		Tutorial_M03_Follow_To_Starbase = State_Tutorial_M03_Follow_To_Starbase
		
	}
	
	unit_list = {}
	ambush_units = {}
	nebulon_escorts = {}
	
	init_done = false
	
	-- Synchronization with the narrative
	follow_through_asteroids = false
	follow_to_frigate = false
	player_at_waypoint0 = false
	reported_frigate_destroyed = false
	
	fog_id = nil
	
	flag_must_follow_leader = false
	flag_okay_to_attack_space_station = false
	flag_okay_to_attack_frigate = false
	
end


-----------------------------------------------------------------------------------------------------------------------
-- Function for Event: Tutorial_M03_Begin
-----------------------------------------------------------------------------------------------------------------------


function State_Tutorial_M03_Begin(message)
	if message == OnEnter then

		--MessageBox("]]]] LUA: State_Tutorial_M03_Begin")
	
		-- Get Empire & Rebel Owners		
		rebel_player = Find_Player("Rebel")
		empire_player = Find_Player("Empire")											  
	
		-- Get the Markers
		waypoint0_marker = Find_Hint("GENERIC_MARKER_SPACE", "waypoint0")
		waypoint1_marker = Find_Hint("GENERIC_MARKER_SPACE", "waypoint1")
		waypoint2_marker = Find_Hint("GENERIC_MARKER_SPACE", "waypoint2")
		waypoint3_marker = Find_Hint("GENERIC_MARKER_SPACE", "waypoint3")
		waypoint4_marker = Find_Hint("GENERIC_MARKER_SPACE", "waypoint4")
		acclamator_marker = Find_Hint("GENERIC_MARKER_SPACE", "acclamator")
		nebulon_station_marker = Find_Hint("GENERIC_MARKER_SPACE", "nebulonspot")
		ion_marker = Find_Hint("GENERIC_MARKER_SPACE", "ion")
		
		space_station = Find_Hint("REBEL_STAR_BASE_TUTORIAL", "space-station")
		space_station_health_prime = space_station.Get_Hull()
		
		-- Get the Rebel Frigate
		unit_list = Find_All_Objects_Of_Type("Nebulon_B_Frigate")
		nebulon_frigate = unit_list[1]
		
		-- Escort the frigate
		nebulon_escorts = Find_All_Objects_With_Hint("nebulon")
		for i,unit in pairs(nebulon_escorts) do
			unit.Guard_Target(nebulon_frigate)
		end
		nebulon_bombers = Find_All_Objects_With_Hint("nebulonbomber")
		--for i,unit in pairs(nebulon_bombers) do
		--	unit.Guard_Target(nebulon_frigate)
		--end
				
		-- Launch the frigate's thread
		Create_Thread("Control_Frigate")
		
		-- Launch the commander's thread
		unit_list = Find_All_Objects_With_Hint("commander")
		if table.getn(unit_list) == 0 then
			MessageBox("Couldn't Find Commander!")
		end
		commander = unit_list[1]
		Create_Thread("Control_Commander")
		commander.Make_Invulnerable(true) -- can't be killed
		commander.Prevent_All_Fire(true) -- can't shoot
		commander.Set_Selectable(false) -- can't be controlled by player

		-- Have Rebel fighters show up at the first waypoint when the commander gets near
		ambush_units = Find_All_Objects_With_Hint("ambushunits");
		ambush_trigger_range = 300
		Register_Prox(waypoint1_marker,Send_Ambush,ambush_trigger_range,empire_player)
		Register_Prox(commander,Eliminate_Fighters,600,rebel_player)
		
		-- Get the starbase
		unit_list = Find_All_Objects_Of_Type("Rebel_Star_Base_Tutorial")
		rebel_star_base = unit_list[1]
		if not TestValid(rebel_star_base) then
			MessageBox("Couldn't find the Rebel Starbase")
		end
		
		-- Setup proximity detector for ion nebulas
		ion_trigger_range = 200
		Register_Prox(ion_marker,Ion_Trigger,ion_trigger_range,empire_player)
		
		-- Setup waypoint 0 proximity
		waypoint0_trigger_range = 300
		Register_Prox(waypoint0_marker,Prox_Waypoint0,waypoint0_trigger_range,empire_player)
		
		init_done = true
		
	end
end

-----------------------------------------------------------------------------------------------------------------------

function Prox_Waypoint0(prox_obj, trigger_obj)
	if trigger_obj.Get_Type().Get_Name() == "TARTAN_PATROL_CRUISER" then
		player_at_waypoint0 = true
	end
end

-----------------------------------------------------------------------------------------------------------------------

function Control_Frigate()
	while TestValid(nebulon_frigate) do
		BlockOnCommand(nebulon_frigate.Move_To(nebulon_station_marker))
		Sleep(5)
	end
end

-----------------------------------------------------------------------------------------------------------------------

function Ion_Trigger(prox_obj, trigger_obj)
	prox_obj.Cancel_Event_Object_In_Range(Ion_Trigger)
	Story_Event("NEAR_ION_FIELD")
end
	
-----------------------------------------------------------------------------------------------------------------------

function Eliminate_Fighters(prox_obj, trigger_obj)
	prox_obj.Cancel_Event_Object_In_Range(Eliminate_Fighters)
	Story_Event("ELIMINATE_FIGHTERS")
	
	-- Select the tartan patrol cruisers so we have a better chance of highlighting their special ability in the XML script
	--unit_list = Find_All_Objects_Of_Type("TARTAN_PATROL_CRUISER")
	--for i,unit in pairs(unit_list) do
	--	empire_player.Select_Object(unit)
	--end
end

-----------------------------------------------------------------------------------------------------------------------

-- Send ambush on it's way

function Send_Ambush(prox_obj, trigger_obj)

	-- Note: we actually need multiple calls to this because sometimes a single call fails!
	
	for i,unit in pairs(ambush_units) do
		if TestValid(unit) then
			if unit.Get_Parent_Object() ~= nil then
				unit.Get_Parent_Object().Attack_Move(commander)
			end
			unit.Attack_Move(commander)
		end
	end
	
end

-----------------------------------------------------------------------------------------------------------------------

-- This is a bit of a hack, the original script doesn't really account for such long dialog, so I had to add some
-- synchronization. -Eric_Y

function State_Follow_Through_Asteroids(message)
	if message == OnEnter then
		--MessageBox("]]]] State_Follow_Through_Asteroids")
		follow_through_asteroids = true
		flag_must_follow_leader = true
	end
end

function State_Follow_To_Frigate(message)
	if message == OnEnter then
		--MessageBox("]]]] State_Follow_To_Frigate")
		follow_to_frigate = true
		flag_okay_to_attack_frigate = true
	end
end

function State_Tutorial_M03_Follow_To_Starbase(message)
	if message == OnEnter then
		--MessageBox("now okay to attack starbase")
		flag_okay_to_attack_space_station = true
	end
end


-----------------------------------------------------------------------------------------------------------------------

function Control_Commander()

	-- Wait for the level letterbox effects to finish up.
	--Sleep(14)
	Sleep(5)
	
	-- Give intro text to the player
	Story_Event("FOLLOW_COMMANDER")
	
	-- Let all the dialog finish
	while not follow_through_asteroids do
		Sleep(3)
	end
	
	-- Fly to waypoint 0
	Sleep(1)
	Story_Event("LETS_GO")
	BlockOnCommand(commander.Move_To(waypoint0_marker))
	commander.Stop()
	--MessageBox("Arrived at waypoint 0")

	
	-- Continue on to encounter the fighters
	Sleep(1)
	while not player_at_waypoint0 do
		Sleep(2)
	end
	Story_Event("PLAYER_FOLLOWING")
	--MessageBox("Player Following")
	
	
	BlockOnCommand(commander.Move_To(waypoint1_marker))
	commander.Stop()
	--MessageBox("Arrived at waypoint 1")
	--Sleep(1)
	Story_Event("ELIMINATE_FIGHTERS")
	
	
	-- Stop to take out the fighters
	fighters_destroyed = false
	while not fighters_destroyed do
		fighters_destroyed = true
		for i,unit in pairs(ambush_units) do
			if TestValid(unit) then
				fighters_destroyed = false
				commander.Attack_Move(unit)
				break
			end
		end
		Sleep(1)
	end

	--Sleep(1)
	Story_Event("FIGHTERS_ELIMINATED")
	
	-- Let all the dialog finish
	while not follow_to_frigate do
		Sleep(3)
	end

	-- Head over to the Nebulon B Frigate and its escort
	BlockOnCommand(commander.Move_To(waypoint2_marker))
	commander.Stop()
	--MessageBox("Arrived at waypoint 2")
	
	-- Send in the Y-Wings
	unit_list = Find_All_Objects_Of_Type("Y-WING")
	if table.getn(unit_list) > 0 then
		for i,unit in pairs(unit_list) do
			if unit and unit.Get_Parent_Object() then
				unit.Get_Parent_Object().Attack_Move(commander)
			end
		end
	end
	
	-- Destroy the bombers first
	Sleep(1)
	Story_Event("ELIMINATE_BOMBERS")
	--bombers_destroyed = false
	--while not bombers_destroyed do
		--bombers_destroyed = true
		--for i,unit in pairs(nebulon_bombers) do
			--if TestValid(unit) then 
				--bombers_destroyed = false
				--commander.Attack_Move(unit)
				--break
			--end
		--end
		--Sleep(3)
	--end

		
	-- Destroy the frigate
	if TestValid(nebulon_frigate) then
		commander.Attack_Move(nebulon_frigate)
	end
	Sleep(1)
	Story_Event("DESTROY_FRIGATE")
	while TestValid(nebulon_frigate) do	
	
		-- if all but one of the cruisers gets destroyed, kill the nebulon-B
		unit_list = Find_All_Objects_Of_Type("Tartan_Patrol_Cruiser")
		if table.getn(unit_list) == 1 then
			nebulon_frigate.Take_Damage(10000)
		end
		
		Sleep(1)
	end

	-- Call in the Reinforcements
	Sleep(2)
	Story_Event("DEPLOY_REINFORCEMENTS")
	--NOTE: adding ships to reinforce pool moved to State_Tutorial_M03_Deploy_Reinforcements_05_Objective for better synchronization with XML
	--ref_type = Find_Object_Type("Acclamator_Assault_Ship")
	--Add_Reinforcement(ref_type,empire_player)
	
	-- Wait for reinforcement acclamator to arrive
	while true do
		unit_list = Find_All_Objects_Of_Type("Acclamator_Assault_Ship")
		if table.getn(unit_list) > 1 then
			break
		end
		Sleep(2)
	end
	Sleep(2)
		
	-- Fly over to the starbase
	Sleep(1)
	Story_Event("FOLLOW_TO_STARBASE")
	fog_id = FogOfWar.Temporary_Reveal(rebel_player,rebel_star_base)
	BlockOnCommand(commander.Move_To(waypoint3_marker))
	--MessageBox("Arrived at waypoint 3")
	BlockOnCommand(commander.Move_To(waypoint4_marker))
	commander.Stop()
	--MessageBox("Arrived at waypoint 4")
		
	-- Attack the rebel starbase
	Sleep(1)
	Story_Event("DESTROY_STARBASE")
	commander.Attack_Move(rebel_star_base)
	
end

-----------------------------------------------------------------------------------------------------------------------

function State_Tutorial_M03_Deploy_Reinforcements_05_Objective(message)
	if message == OnEnter then
	
		ref_type = Find_Object_Type("Acclamator_Assault_Ship")
		Add_Reinforcement(ref_type,empire_player)
		Add_Reinforcement(ref_type,empire_player)

	end
end

-----------------------------------------------------------------------------------------------------------------------

function State_Tutorial_M03_Eliminate_Fighters_06(message)
	if message == OnEnter then
	
		-- Select the tartan patrol cruisers so we have a better chance of highlighting their special ability in the XML script
		unit_list = Find_All_Objects_Of_Type("TARTAN_PATROL_CRUISER")
		for i,unit in pairs(unit_list) do
			empire_player.Select_Object(unit)
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
	
	unit_list = Find_All_Objects_Of_Type("Tartan_Patrol_Cruiser")
	if table.getn(unit_list) == 0 then
		unit_list = Find_All_Objects_Of_Type("Acclamator_Assault_Ship")
		if table.getn(unit_list) == 0 then 
			Story_Event("CRUISERS_DESTROYED")
		end
	end
	
	if not flag_okay_to_attack_frigate and (nebulon_frigate.Get_Shield() < 0.9) then
		--force lose...player is not supposed to be here yet.
		Story_Event("PLAYER_NOT_FOLLOWING_LEADER")
	end
	
	if not flag_okay_to_attack_space_station and (space_station.Get_Shield() < 0.9) then
		--force lose...player is not supposed to be here yet.
		Story_Event("PLAYER_NOT_FOLLOWING_LEADER")
	end
	
	if flag_must_follow_leader == true then
		--calculate distances here
		player_unit_list = Find_All_Objects_Of_Type("Tartan_Patrol_Cruiser")
		for i,player_unit in pairs(player_unit_list) do
			if TestValid(player_unit) then
				if (player_unit.Get_Distance(commander) > 2500) then
					--MessageBox("PLAYER NOT FOLLOWING -- LOSE!!")
					Story_Event("PLAYER_NOT_FOLLOWING_LEADER")
					flag_must_follow_leader = false
				end
			end
		end
	end

	if not reported_frigate_destroyed and not TestValid(nebulon_frigate) then
		Story_Event("FRIGATE_DESTROYED")
		reported_frigate_destroyed = true
	end
	
end

-----------------------------------------------------------------------------------------------------------------------
