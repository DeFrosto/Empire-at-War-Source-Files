-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/PreDefendStructure.lua#9 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/PreDefendStructure.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 36065 $
--
--          $DateTime: 2006/01/06 15:57:55 $
--
--          $Revision: #9 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////


-- This plan serves to head off the main attacking force by placing an RPS appropriate forces
-- in the vicinity of the main base structure that will receive the enemy first.


require("pgevents")

ScriptPoolCount = 5

function Definitions()
	
	Category = "PreDefend_Structure"
	AllowEngagedUnits = true
	MinContrastScale = 0.5
	MaxContrastScale = 1.2
	TaskForce = {
	{
		"MainForce"			
		,"DenyHeroAttach"
		,"Infantry = 0,10"
		,"Vehicle | Air = 0,10"
		,"LandHero = 0,3"
	},
	{
		"GuardForce"
		,"EscortForce"		-- This should force a good RPS match for the enemies in our target's zone
		,"Infantry = 0,10"
		,"Vehicle | Air = 0,10"
		,"LandHero = 0,3"
	}
	}
	RequiredCategories = {"Infantry | Vehicle | Air"}

	structure = nil
end

function MainForce_Thread()

	-- We don't actually want the forces for contrast to AITarget, this plan
	-- is only concerned with the forces surrounding the AITarget.  We have
	-- to produce and release them to get them back on the freestore, however.
	BlockOnCommand(MainForce.Produce_Force())
	--MainForce.Release_Forces(1.0)

	QuickReinforce(PlayerObject, AITarget, MainForce, GuardForce)
	
	-- TODO: remove everything after release forces once this no longer kills a script	

	-- Find our structure nearest the enemy
	structure = Find_Nearest(AITarget, "Structure", PlayerObject, true)

	DebugMessage("%s -- PreDefending structure: %s.", tostring(Script), tostring(structure))
	if TestValid(structure) then
		BlockOnCommand(MainForce.Attack_Move(structure), 20)
	end
	
	ScriptExit()
end 

-- TODO: remove once the above commented block is removed
-- Make sure that units don't sit idle at the end of their move order, waiting for others
function MainForce_Unit_Move_Finished(tf, unit)

	DebugMessage("%s -- Unit move finished: %s.", tostring(Script), tostring(unit))

	-- As each unit arrives, guard the structure
	if TestValid(structure) then
		unit.Guard_Target(structure)
	end
end



function GuardForce_Thread()
	BlockOnCommand(GuardForce.Produce_Force())

	QuickReinforce(PlayerObject, AITarget, GuardForce, MainForce)

	Try_Ability(MainForce, "ROCKET_ATTACK")

	-- Find our structure nearest the enemy
	structure = Find_Nearest(AITarget, "Structure", PlayerObject, true)

	DebugMessage("%s -- PreDefending structure: %s.", tostring(Script), tostring(structure))
	if TestValid(structure) then
		BlockOnCommand(GuardForce.Attack_Move(structure), 20)
	end

	ScriptExit()
end 


-- Make sure that units don't sit idle at the end of their move order, waiting for others
function GuardForce_Unit_Move_Finished(tf, unit)

	DebugMessage("%s -- Unit move finished: %s.", tostring(Script), tostring(unit))

	-- As each unit arrives, guard the structure
	if TestValid(structure) then
		unit.Guard_Target(structure)
	end
end

