-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/SpaceMode/RetreatPlan.lua#3 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/SpaceMode/RetreatPlan.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Steve_Copeland $
--
--            $Change: 25425 $
--
--          $DateTime: 2005/08/30 19:33:22 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	Category = "Space_Retreat | Land_Retreat"
	TaskForce = {
	{
		"MainForce",
		"TaskForceRequired"					
	}
	}
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()

	if not MainForce.Withdraw_Units() then
		DebugMessage("%s -- unable to retreat", tostring(Script))
		ScriptExit()
	end

	Purge_Goals(PlayerObject)
	MainForce.Block_Goal_Proposal()
	MainForce.Collect_All_Free_Units()
	MainForce.Set_As_Goal_System_Removable(false)
	
	while true do
		Sleep(1)
	end

	ScriptExit()
	
end
