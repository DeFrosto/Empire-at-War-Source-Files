-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/SiphonCreditsPlan.lua#9 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/SiphonCreditsPlan.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Pat_Pannullo $
--
--            $Change: 15724 $
--
--          $DateTime: 2005/04/07 18:28:54 $
--
--          $Revision: #9 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	IgnoreTarget = true;
	Category = "Weaken_Planet"
	TaskForce = {
	{
		"SmugglerForce",						
		"DenyHeroAttach",
		"Smuggler_Team_E | Smuggler_Team_R = 1"
	}
	}
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function SmugglerForce_Thread()
	DebugMessage("%s -- In SmugglerForce_Thread.", tostring(Script))
	
	if EvaluatePerception("Suitable_Smuggler_Target", PlayerObject, Target) < 0.5 then
		ScriptExit()
	end
	
	Sleep(1)

	AssembleForce(SmugglerForce)
	Sleep(1)
	BlockOnCommand(SmugglerForce.Move_To(Target))

	-- Landing a hero deploys it, removing it from the game and killing the script.  So,
	-- we have to indicate success before we land the unit, even though she hasn't deployed.
	-- If a hero killer gets her before she deploys, the plan should die before setting itself successful.	
	SmugglerForce.Set_Plan_Result(true)	
	LandUnits(SmugglerForce)
	
	DebugMessage("%s -- SmugglerForce Done!  Exiting Script!", tostring(Script))
	ScriptExit()
end

function SmugglerForce_No_Units_Remaining()
	ScriptExit()
end