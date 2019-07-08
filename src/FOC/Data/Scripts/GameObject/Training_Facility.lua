-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Training_Facility.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Training_Facility.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Andre_Arsenault $
--
--            $Change: 37816 $
--
--          $DateTime: 2006/02/15 15:33:33 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

--require("PGStateMachine")
require("PGStoryMode")

function Definitions()
	flag_structure_alive = true
	facility_list = Find_All_Objects_Of_Type("Secondary_Training_Facility_R")
	--MessageBox("Object spawned and script running!")
	rebel = Find_Player("Rebel")
	empire = Find_Player("Empire")
	
	upgrade_R = Find_Object_Type("RL_Combat_Armor_L1_Upgrade_Negative")
	upgrade_E = Find_Object_Type("EL_Combat_Armor_L1_Upgrade_Negative")
end

function Story_Mode_Service()
	if flag_structure_alive then
		for i,facility in pairs(facility_list) do
			if not TestValid(facility) then		
				flag_structure_alive = false
				--MessageBox("Structure Dead, time to apply upgrade")
				Create_Generic_Object (upgrade_E, facility_loc, empire)
				Create_Generic_Object (upgrade_R, facility_loc, rebel)
			end	
		end	
	end
end