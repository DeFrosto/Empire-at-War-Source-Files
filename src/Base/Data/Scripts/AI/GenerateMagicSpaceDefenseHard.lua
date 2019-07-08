-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/GenerateMagicSpaceDefenseHard.lua#2 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/GenerateMagicSpaceDefenseHard.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 36287 $
--
--          $DateTime: 2006/01/12 11:12:55 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()	
	Category = "Generate_Magic_Space_Defense_Hard"
	IgnoreTarget = true
	
	TaskForce = {
	{
		"ReserveForce"
		,"DenyHeroAttach"
		,"Fighter | Bomber = 5"
		,"Corvette | Frigate | Capital = 3"
	}
	}
	AllowFreeStoreUnits = false
	MagicPlan = true
	MagicPlanStealing = false
end

function ReserveForce_Thread()		
	ReserveForce.Set_As_Goal_System_Removable(false)
	BlockOnCommand(ReserveForce.Produce_Force(Target))
	ReserveForce.Set_Plan_Result(true)	
	Sleep(20)
	--Use the Normal version of Needs_Magic_Space_Defense (just in case the units we spawned don't pull us past the
	--Hard threshold)
	while EvaluatePerception("Needs_Magic_Space_Defense", PlayerObject, Target) == 0.0 do
		Sleep(1)
	end
	ScriptExit()
end