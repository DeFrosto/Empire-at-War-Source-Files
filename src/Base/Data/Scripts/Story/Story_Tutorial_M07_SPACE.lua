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
		Tutorial_M07_Begin							= State_Tutorial_M07_Begin,
		Tutorial_M07_Select_Space_Station		= State_Select_Space_Station,
		Tutorial_M07_Scroll_To_Mining_Facility	= State_Scroll_To_Mining_Facility
	}
	
	unit_list = {}
	
	fog_id = nil
	fog_id2 = nil

end

-----------------------------------------------------------------------------------------------------------------------

function State_Tutorial_M07_Begin(message)
	if message == OnEnter then

		--MessageBox("]]]] LUA: State_Tutorial_M07_Begin")
	
		-- Get Empire & Rebel Owners		
		rebel_player = Find_Player("Rebel")
		empire_player = Find_Player("Empire")											  

		unit_list = Find_All_Objects_Of_Type("Skirmish_Rebel_Star_Base_1")
		if table.getn(unit_list) == 0 then
			MessageBox("Couldn't find rebel star base!")
			return
		else
			starbase = unit_list[1]
		end

		unit_list = Find_All_Objects_With_Hint("mining")
		if table.getn(unit_list) == 0 then
			MessageBox("Couldn't find asteroid mining facility!")
			return
		else
			mining_facility = unit_list[1]
		end


		-- Scroll over to star base and zoom out
		--Scroll_Camera_To(starbase)
		Point_Camera_At(starbase)
		Zoom_Camera(0.7,0)
		fog_id = FogOfWar.Reveal(rebel_player,starbase.Get_Position(),200,200)
				
	end
end

-----------------------------------------------------------------------------------------------------------------------

function State_Select_Space_Station(message) 
	if message == OnEnter then

		--MessageBox("]]]] LUA: Select space station")
		rebel_player.Select_Object(starbase)
		
	end
end

-----------------------------------------------------------------------------------------------------------------------

function State_Scroll_To_Mining_Facility(message)
	if message == OnEnter then

		--MessageBox("]]]] LUA: Scroll to mining facility")
		fog_id2 = FogOfWar.Reveal(rebel_player,mining_facility.Get_Position(),200,200)
		Scroll_Camera_To(mining_facility)
		rebel_player.Select_Object(mining_facility)
		
	end
end

-----------------------------------------------------------------------------------------------------------------------
