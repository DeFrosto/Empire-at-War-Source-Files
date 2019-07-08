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
--            $Author: Rich_Donnelly $
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
		Tutorial_M06_Begin									= State_Tutorial_M06_Begin,
		Tutorial_M06_Light_Vehicle_Factory_Highlight = State_Tutorial_M06_Light_Vehicle_Factory_Highlight,
		Tutorial_M06_Scroll_To_Command_Center			= State_Tutorial_M06_Scroll_To_Command_Center,
		Tutorial_M06_Scroll_To_Mining_Facility			= State_Tutorial_M06_Scroll_To_Mining_Facility,
		Tutorial_M06_Scroll_To_Resource_Pad				= State_Tutorial_M06_Scroll_To_Resource_Pad,
		Tutorial_M06_Scroll_To_Reinforcement_Point	= State_Tutorial_M06_Scroll_To_Reinforcement_Point
	}
	
	unit_list = {}
	
	fog_id = nil
	fog_id2 = nil
	fog_id3 = nil
	
end

-----------------------------------------------------------------------------------------------------------------------

function State_Tutorial_M06_Begin(message)
	if message == OnEnter then

		-- MessageBox("]]]] LUA: State_Tutorial_M06_Begin")
	
		-- Get Empire & Rebel Owners		
		rebel_player = Find_Player("Rebel")
		empire_player = Find_Player("Empire")	
		
		Lock_Controls(1)										  

		-- Get the Markers
		--marker1 = Find_Hint("GENERIC_MARKER_LAND", "marker1")
		--marker2 = Find_Hint("GENERIC_MARKER_LAND", "marker2")
		--if not marker1 or not marker2 then
		--	MessageBox("]]]] LUA: One of the markers was not found!")
		--else
		--	MessageBox("]]]] LUA: All Markers Found!")
		--end
		
		---- Start of the tutorial sequence ----
		--Sleep(5)
		--Scroll_Camera_To(marker1)
		--Sleep(5)
		--Scroll_Camera_To(marker2)
		--Sleep(5)

		--MessageBox("]]]] LUA: End")
		
	end
end


-----------------------------------------------------------------------------------------------------------------------

function State_Tutorial_M06_Light_Vehicle_Factory_Highlight(message)
	if message == OnEnter then

	-- Select the light vehicle factory
	rebel_player.Select_Object(Find_First_Object("R_Ground_Light_Vehicle_Factory"))
	
	end
end

-----------------------------------------------------------------------------------------------------------------------

function State_Tutorial_M06_Scroll_To_Command_Center(message)
	if message == OnEnter then

		unit = Find_First_Object("Rebel_Command_Center")
		Scroll_Camera_To(unit)
		rebel_player.Select_Object(unit)
			
	end
end

-----------------------------------------------------------------------------------------------------------------------

function State_Tutorial_M06_Scroll_To_Mining_Facility(message)
	if message == OnEnter then

		--unit = Find_First_Object("N_Ground_Mining_Facility_Build_Pad")
		unit_list = Find_All_Objects_With_Hint("mining")
		unit = unit_list[1]
		fog_id = FogOfWar.Reveal(rebel_player,unit.Get_Position(),200,200)
		Scroll_Camera_To(unit)
		rebel_player.Select_Object(unit)
			
	end
end

-----------------------------------------------------------------------------------------------------------------------

function State_Tutorial_M06_Scroll_To_Resource_Pad(message)
	if message == OnEnter then

		--unit = Find_First_Object("Skirmish_Mineral_Processor_Pad")
		unit_list = Find_All_Objects_With_Hint("processor")
		unit = unit_list[1]
		fog_id2 = FogOfWar.Reveal(rebel_player,unit.Get_Position(),200,200)
		Scroll_Camera_To(unit)
		rebel_player.Select_Object(unit)
			
	end
end

-----------------------------------------------------------------------------------------------------------------------

function State_Tutorial_M06_Scroll_To_Reinforcement_Point(message)
	if message == OnEnter then

		unit = Find_First_Object("Reinforcement_Point")
		fog_id3 = FogOfWar.Reveal(rebel_player,unit.Get_Position(),200,200)
		Scroll_Camera_To(unit)
		rebel_player.Select_Object(unit)
			
	end
end

-----------------------------------------------------------------------------------------------------------------------

