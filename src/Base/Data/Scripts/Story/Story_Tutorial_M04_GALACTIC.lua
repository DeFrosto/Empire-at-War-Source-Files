-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Story/Story_Tutorial_M04_GALACTIC.lua#1 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Story/Story_Tutorial_M04_GALACTIC.lua $
--
--    Original Author: Eric_Yiskis
--
--            $Author: Eric_Yiskis $
--
--            $Change: 27240 $
--
--          $DateTime: 2005/09/15 11:24:38 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStoryMode")


------------------------------------------------------------------------------------------------------------------------
-- Definitions -- This function is called once when the script is first created.
------------------------------------------------------------------------------------------------------------------------

function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	StoryModeEvents = 
	{
		Tutorial_IV_Begin = State_Tutorial_IV_Begin
	}
	
	unit_list = {}
	
end

------------------------------------------------------------------------------------------------------------------------
-- State_Tutorial_IV_Begin -- Activate the Smuggler
------------------------------------------------------------------------------------------------------------------------

function State_Tutorial_IV_Begin(message)
	if message == OnEnter then
	
		--MessageBox("Tutorial_IV.Lua is attempting smuggler activation")
		
		unit_list = Find_All_Objects_Of_Type("GENERIC_SMUGGLER_R_TUTORIAL")
		if table.getn(unit_list) == 0 then
			MessageBox("Galactic Lua script couldn't find smuggler!")
			return
		end
		
		smuggler = unit_list[1]
		smuggler_transport = smuggler.Get_Parent_Object()
		smuggler_transport.Activate_Ability()
		
	end
end

------------------------------------------------------------------------------------------------------------------------
