-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/SpaceMode/EscortPlan.lua#9 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/SpaceMode/EscortPlan.lua $
--
--    Original Author: Brian Hayes
--
--            $Author: Steve_Copeland $
--
--            $Change: 34279 $
--
--          $DateTime: 2005/12/05 16:46:43 $
--
--          $Revision: #9 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

--
-- Space Mode Escort
--

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	AllowEngagedUnits = false
	Category = "Space_Escort_Goal"
	IgnoreTarget = true
	TaskForce = {
	-- First Task Force
	{
		"MainForce"
		,"Fighter = 1,4"
		,"Interdictor_Cruiser = 0,1"
	}
	}
end

function MainForce_Thread()
	DebugMessage("%s -- In MainForce_Thread.", tostring(Script))
	BlockOnCommand(MainForce.Produce_Force());

	QuickReinforce(PlayerObject, AITarget, MainForce)

	DebugMessage("MainForce constructed at stage area!")

	Sleep(1)
	DebugMessage("Taskforce %s (of var type: %s) following object %s.", tostring(MainForce), type(MainForce), tostring(Target))
	--BlockOnCommand(MainForce.Follow_Target(AITarget))
	
	-- Give an initial order to put the escorts in a state that the Escort function expects
	MainForce.Guard_Target(AITarget)

	while true do
		Escort(MainForce, AITarget)
	end
		
	DebugMessage("%s -- MainForce Done!  Exiting Script!", tostring(Script))
	ScriptExit()
end
