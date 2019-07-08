-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/DefendStructure.lua#11 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/DefendStructure.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Steve_Copeland $
--
--            $Change: 35401 $
--
--          $DateTime: 2005/12/15 23:59:42 $
--
--          $Revision: #11 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

ScriptPoolCount = 16

function Definitions()
	
	Category = "Defend_Structure"
	AllowEngagedUnits = true
	MinContrastScale = 1.2
	MaxContrastScale = 1.8
	TaskForce = {
	{
		"MainForce"					
		,"DenyHeroAttach"
		,"EscortForce"		-- This should force a good RPS match for the enemies in our target's zone
		,"Infantry = 0,20"
		,"Vehicle | Air = 0,20"
		,"LandHero = 0,3"
	}
	}
	RequiredCategories = {"Infantry | Vehicle | Air"}

	structure = nil
	kill_target = nil
	
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())

	-- form up any spread out infantry
	MainForce.Activate_Ability("SPREAD_OUT", false)

	structure = AITarget.Get_Game_Object()
	DebugMessage("%s -- Found structure: %s.", tostring(Script), tostring(structure))
	if TestValid(structure) then
		kill_target = FindDeadlyEnemy(structure)
		DebugMessage("%s -- Found deadly enemy: %s.", tostring(Script), tostring(kill_target))
		if TestValid(kill_target) and (kill_target.Get_Distance(AITarget) < 500) then
			BlockOnCommand(MainForce.Attack_Target(kill_target, MainForce.Get_Self_Threat_Sum()))
		end
	
		BlockOnCommand(MainForce.Attack_Move(AITarget))
		BlockOnCommand(MainForce.Guard_Target(AITarget))
	end
end 


-- Make sure that units don't sit idle at the end of their move order, waiting for others
function MainForce_Unit_Move_Finished(tf, unit)

	DebugMessage("%s -- Unit move finished: %s.", tostring(Script), tostring(unit))

	-- As each unit arrives, guard the structure
	unit.Guard_Target(AITarget)
end
