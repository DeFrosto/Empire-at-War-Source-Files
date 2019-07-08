-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Story/Story_Rebel_Prologue_M02_SPACE.lua#7 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Story/Story_Rebel_Prologue_M02_SPACE.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Brian_Hayes $
--
--            $Change: 22566 $
--
--          $DateTime: 2005/07/28 14:58:29 $
--
--          $Revision: #7 $
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
		Rebel_M02_SPACE_00 = State_Rebel_M02_SPACE_00
		,Rebel_M02_SPACE_03 = State_Rebel_M02_SPACE_03

	}
       
	reinforce_type_list = { 
		"Z95_Headhunter_Rebel_Squadron"
		,"Z95_Headhunter_Rebel_Squadron"
		,"Nebulon_B_Frigate"
	}
	
	empire_list = {
		"TIE_Scout_Squadron"
		,"TIE_Scout_Squadron"
		,"TIE_Scout_Squadron"
		,"Tartan_Patrol_Cruiser_Easy"
		,"Tartan_Patrol_Cruiser_Easy"
	}
	
	empire_player = nil
	empire_units = nil
end


function State_Rebel_M02_SPACE_00(message)
	if message == OnEnter then

		empire_spawn_marker = Find_Hint("GENERIC_MARKER_SPACE", "spawn")
		if not empire_spawn_marker then
			MessageBox("couldn't find marker")
			return
		end
		
		empire_player = empire_spawn_marker.Get_Owner()
		empire_units = SpawnList(empire_list, empire_spawn_marker, empire_player, false, true)
		for k, unit in pairs(empire_units) do
			unit.Attack_Target(Find_Nearest(unit, "Fighter", empire_player, false))
		end	
		
		Register_Timer(Timer_Release_Units_To_AI, 30)
	
	end
end

function Timer_Release_Units_To_AI()

	MessageBox("Releasing Units to the AI")
	for k, unit in pairs(empire_units) do
		if TestValid(unit) then
			unit.Prevent_AI_Usage(false)
		end
	end
end

function State_Rebel_M02_SPACE_03(message)

	if message == OnEnter then
		--MessageBox("entering State_Rebel_M02_SPACE_03")

		entry_marker = Find_Hint("ATTACKER ENTRY POSITION")
		if not TestValid(entry_marker) then
			MessageBox("didn't find entry_marker")
			return
		end
		
		ReinforceList(reinforce_type_list, entry_marker, entry_marker.Get_Owner())

	elseif message == OnUpdate then
		
	elseif message == OnExit then
	end

end
