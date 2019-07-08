-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Story/Story_Rebel_Prologue_M08_SPACE.lua#5 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Story/Story_Rebel_Prologue_M08_SPACE.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Brian_Hayes $
--
--            $Change: 22566 $
--
--          $DateTime: 2005/07/28 14:58:29 $
--
--          $Revision: #5 $
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
		Rebel_M08_Space_Begin = State_Rebel_M08_Space_Begin

	}
       
	wave1_type_list = { 
		"Tartan_Patrol_Cruiser"
	}

	wave2_type_list = { 
		"Tartan_Patrol_Cruiser"
	}

	wave3_type_list = { 
		"Tartan_Patrol_Cruiser"
		,"Tartan_Patrol_Cruiser"
	}

	wave4_type_list = { 
		"Acclamator_Assault_Ship"
	}


end

function State_Rebel_M08_Space_Begin(message)

	if message == OnEnter then
		--MessageBox("entering State_Rebel_M08_Space_Begin")

		entry_marker = Find_Hint("GENERIC_MARKER_SPACE", "reinforce")
		if not TestValid(entry_marker) then
			MessageBox("didn't find entry_marker")
			return
		end
		
		empire = entry_marker.Get_Owner()
		--MessageBox("found owner: %s", empire.Get_Name())
		
		Register_Timer(Timer_Deploy_Wave1, 30)
		Register_Timer(Timer_Deploy_Wave2, 55)
		Register_Timer(Timer_Deploy_Wave3, 80)
		Register_Timer(Timer_Deploy_Wave4, 110)

	elseif message == OnUpdate then
		
	elseif message == OnExit then
	end

end

function Timer_Deploy_Wave1()
	--MessageBox("wave1")
	--type = Find_Object_Type("Acclamator_Assault_Ship")
	--BlockOnCommand(Reinforce_Unit(type, entry_marker, entry_marker.Get_Owner()))
	ReinforceList(wave1_type_list, entry_marker, empire, true, true)
end

function Timer_Deploy_Wave2()
	--MessageBox("wave2")
	ReinforceList(wave2_type_list, entry_marker, empire, true, true)
end

function Timer_Deploy_Wave3()
	--MessageBox("wave3")
	ReinforceList(wave3_type_list, entry_marker, empire, true, true)
end

function Timer_Deploy_Wave4()
	--MessageBox("wave4")
	ReinforceList(wave4_type_list, entry_marker, empire, true, true)
	Register_Timer(Timer_Deploy_Wave4, 50)
end

