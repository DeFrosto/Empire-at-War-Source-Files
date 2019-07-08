-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Story/Story_Rebel_Prologue_M00_LAND.lua#4 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Story/Story_Rebel_Prologue_M00_LAND.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Steve_Copeland $
--
--            $Change: 20907 $
--
--          $DateTime: 2005/06/29 16:34:49 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStoryMode")

--
-- Definitions -- This function is called once when the script is first created.
-- 
function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	StoryModeEvents = 
	{
		Rebel_M00_Begin = State_Rebel_M00_Begin
		,Rebel_M00_LAND_07 = State_Rebel_M00_PLEX_GO -- triggers once several civillians are killed
        ,Rebel_M00_LAND_10 = State_Rebel_M00_TROOP_GO -- triggers once the two tanks are destroyed
	}
       
        rebel_plex_squad = {
                "Rebel_Tank_Buster_Squad"
        }
        
        rebel_inf_squad = {
                "Rebel_Infantry_Squad"
        }       
        
        rebel_mini_squad = {
                "Rebel_Mini_Infantry_Squad"
        }

		commander_company = {
				"Field_Com_Empire_Team"
		}

        rebel_player = nil
		rebspawn = nil
		commander_company_list = nil
		commander = nil
		fled1 = false
		fled2 = false
end

function State_Rebel_M00_Begin(message)
	if message == OnEnter then
	
		-- check for the markers to spawn at
		plex_marker1 = Find_Marker("GENERIC_MARKER_LAND", "plex1")
		plex_marker2 = Find_Marker("GENERIC_MARKER_LAND", "plex2")
		boss_marker_spawn = Find_Marker("GENERIC_MARKER_LAND", "commanderspawn")
		boss_marker_flee1 = Find_Marker("GENERIC_MARKER_LAND", "commanderflee1")
		boss_marker_flee2 = Find_Marker("GENERIC_MARKER_LAND", "commanderflee2")
		
		if not plex_marker1 or not plex_marker2 or not boss_marker_spawn or not boss_marker_flee1 or not boss_marker_flee2 then
			MessageBox("didn't find all needed markers")
			return
		end
		
        rebel_player = plex_marker1.Get_Owner()

		-- Spawn the Empire commander company and release him to the AI.	
		commander_company_list = SpawnList(commander_company, boss_marker_spawn, rebel_player.Get_Enemy(), true, true)
		
		-- Find the commander himself
		commander_type = Find_Object_Type("Generic_Field_Commander_Empire")
		for k, unit in pairs(commander_company_list) do
			if unit.Get_Type() == commander_type then
				commander = unit
				break
			end
		end
        if not TestValid(commander) then
			MessageBox("Couldn't find the commander.")
			return
		end

	end
end

function State_Rebel_M00_PLEX_GO(message)
        -- when the trigger for plex troopers fires off...
        
	if message == OnEnter then
                
		-- Spawn human player controlled units at the correct locations and give them an initial order.
		Spawn_Troops(rebel_plex_squad, plex_marker1, rebel_player, "Vehicle")
		Spawn_Troops(rebel_plex_squad, plex_marker2, rebel_player, "Vehicle")
		
	elseif message == OnUpdate then
		
	elseif message == OnExit then
	end

end

function State_Rebel_M00_TROOP_GO(message)
        -- When the trigger for the infantry spawning fires off...
	if message == OnEnter then
		-- MessageBox("rebel troops go")

		inf_marker1 = Find_Marker("GENERIC_MARKER_LAND", "inf1")
                inf_marker2 = Find_Marker("GENERIC_MARKER_LAND", "inf2")
                inf_marker3 = Find_Marker("GENERIC_MARKER_LAND", "inf3")

		if not TestValid(inf_marker1) or not TestValid(inf_marker2) or not TestValid(inf_marker3) then
			MessageBox("didn't find markers inf1 thru 3!")
			return
		end

                rebel_player = inf_marker1.Get_Owner()

		Spawn_Troops(rebel_inf_squad, inf_marker1, rebel_player, "Infantry")
		Spawn_Troops(rebel_inf_squad, inf_marker2, rebel_player, "Infantry")

		-- These are smaller groups of troopers, spawned over time.
		Spawn_Troops(rebel_mini_squad, inf_marker3, rebel_player, "Infantry")
		Register_Timer(Timer_Group2_Go, 2)

	elseif message == OnUpdate then
		
	elseif message == OnExit then
	end

end

-- function to spawn the troop type specified at a marker with a target to attack loaded

function Spawn_Troops(Utype, Umark, Ufact, Utarg)
	rebspawn = SpawnList(Utype, Umark, Ufact)
	for k, unit in pairs(rebspawn) do
		unit.Attack_Target(Find_Nearest(unit, Utarg, Ufact, false))
	end
end

function Timer_Group2_Go()
	inf_marker4 = Find_Marker("GENERIC_MARKER_LAND", "inf4")
	if not TestValid(inf_marker4) then
		MessageBox("didn't find marker inf4!")
	end
	rebel_side = inf_marker4.Get_Owner()
	Spawn_Troops(rebel_mini_squad, inf_marker4, rebel_player, "Infantry")
	Register_Timer(Timer_Group3_Go, 2)
end

function Timer_Group3_Go()
	inf_marker5 = Find_Marker("GENERIC_MARKER_LAND", "inf5")
	if not TestValid(inf_marker5) then
		MessageBox("didn't find marker inf5!")
	end
	rebel_side = inf_marker5.Get_Owner()
	Spawn_Troops(rebel_mini_squad, inf_marker5, rebel_player, "Infantry")
	Register_Timer(Timer_Group4_Go, 2)
end

function Timer_Group4_Go()
	inf_marker6 = Find_Marker("GENERIC_MARKER_LAND", "inf6")
	if not TestValid(inf_marker6) then
		MessageBox("didn't find marker inf6!")
	end
	rebel_side = inf_marker6.Get_Owner()
	Spawn_Troops(rebel_mini_squad, inf_marker6, rebel_player, "Infantry")
	Register_Timer(Timer_Group5_Go, 2)
end

function Timer_Group5_Go()
	inf_marker7 = Find_Marker("GENERIC_MARKER_LAND", "inf7")
	if not TestValid(inf_marker7) then
		MessageBox("didn't find marker inf7!")
	end
	rebel_side = inf_marker7.Get_Owner()
	Spawn_Troops(rebel_mini_squad, inf_marker7, rebel_player, "Infantry")
end

function Story_Mode_Service()

	-- Move the commander to various markers as his health goes down
	if TestValid(commander) then
		if not fled1 and (commander.Get_Hull() < 0.9) then
			MessageBox("trying to move commander to point A")
			fled1 = true
			commander.Move_To(boss_marker_flee1)
			-- commander.Lock_Current_Orders() Can't lock this because the second move might occur early
			Story_Event("COMMANDER_MOVING_TO_1")
		end
		if not fled2 and (commander.Get_Hull() < 0.6) then
			MessageBox("trying to move commander to point B")
			fled2 = true
			commander.Move_To(boss_marker_flee2)
			commander.Lock_Current_Orders()
			Story_Event("COMMANDER_MOVING_TO_2")
		end
	end
end
