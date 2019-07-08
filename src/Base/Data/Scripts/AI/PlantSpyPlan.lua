-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/PlantSpyPlan.lua#7 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/PlantSpyPlan.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 24353 $
--
--          $DateTime: 2005/08/19 17:54:05 $
--
--          $Revision: #7 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	IgnoreTarget = true;
	Category = "Scout_Planet"
	TaskForce = {
	{
		"SpyForce",						
		"DenyHeroAttach",
		"Probe_Droid_Team = 1"
	}
	}
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function SpyForce_Thread()
	DebugMessage("%s -- In SpyForce_Thread.", tostring(Script))
	Sleep(1)

	AssembleForce(SpyForce)
	Sleep(1)
	BlockOnCommand(SpyForce.Move_To(Target))
	LandUnits(SpyForce)
	SpyForce.Set_Plan_Result(true)	
	
	DebugMessage("%s -- SpyForce Done!  Exiting Script!", tostring(Script))
	ScriptExit()
end

function SpyForce_Production_Failed(tf, failed_object_type)
	DebugMessage("%s -- Abandonning plan owing to production failure.", tostring(Script))
	ScriptExit()
end

function SpyForce_No_Units_Remaining()
	DebugMessage("%s -- All units dead or non-buildable.  Abandonning plan.", tostring(Script))
	ScriptExit()
end