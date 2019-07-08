-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Story/Story_Rebel_Prologue_M07_SPACE.lua#3 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Story/Story_Rebel_Prologue_M07_SPACE.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Brian_Hayes $
--
--            $Change: 22566 $
--
--          $DateTime: 2005/07/28 14:58:29 $
--
--          $Revision: #3 $
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
		Rebel_M07_Begin = State_Rebel_M07_Begin

	}
       
	z951_type_list = { 
		"Z95_Headhunter_Squadron"
	}

	z952_type_list = { 
		"Z95_Headhunter_Squadron"
		,"Z95_Headhunter_Squadron"
	}
end

function State_Rebel_M07_Begin(message)

	if message == OnEnter then
		MessageBox("entering State_Rebel_M02_SPACE_01")

		defense_marker1 = Find_Hint("GENERIC_MARKER_SPACE", "1")
		defense_marker2 = Find_Hint("GENERIC_MARKER_SPACE", "2")
		defense_marker3 = Find_Hint("GENERIC_MARKER_SPACE", "3")
		defense_marker4 = Find_Hint("GENERIC_MARKER_SPACE", "4")
		if not defense_marker1 or not defense_marker2 or not defense_marker3 or not defense_marker4 then
			MessageBox("couldn't find needed markers")
			return
		end

		pirates = defense_marker1.Get_Owner()
		
		for k, unit in pairs(SpawnList(z951_type_list, defense_marker1, pirates, false, true)) do
			unit.Guard_Target(defense_marker1)
		end	

		for k, unit in pairs(SpawnList(z951_type_list, defense_marker2, pirates, false, true)) do
			unit.Guard_Target(defense_marker2)
		end	

		for k, unit in pairs(SpawnList(z952_type_list, defense_marker3, pirates, false, true)) do
			unit.Guard_Target(defense_marker3)
		end	

		for k, unit in pairs(SpawnList(z952_type_list, defense_marker4, pirates, false, true)) do
			unit.Guard_Target(defense_marker4)
		end	


	elseif message == OnUpdate then
		
	elseif message == OnExit then
	end

end

