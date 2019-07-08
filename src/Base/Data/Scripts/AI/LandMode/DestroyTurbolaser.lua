-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/DestroyTurbolaser.lua#2 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/DestroyTurbolaser.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Steve_Copeland $
--
--            $Change: 35401 $
--
--          $DateTime: 2005/12/15 23:59:42 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

ScriptPoolCount = 16

function Definitions()
	
	Category = "Destroy_Turbolaser"
	TaskForce = {
	{
		"MainForce"						
		,"DenyHeroAttach"
		,"Infantry | Air | LandHero = 3,10"
	},
	{
		"GuardForce"
		,"EscortForce"
		,"Squad_Rebel_Trooper | Squad_Stormtrooper = 0,2"
	}
	}
	
	start_loc = nil
	
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	QuickReinforce(PlayerObject, AITarget, MainForce, GuardForce)
	
	Try_Ability(MainForce, "ROCKET_ATTACK")

	-- Try to get under the min attack range, then attack
	BlockOnCommand(MainForce.Move_To(AITarget, MainForce.Get_Self_Threat_Sum()))
	BlockOnCommand(MainForce.Attack_Target(AITarget))	

	ScriptExit()
end

function GuardForce_Thread()
	BlockOnCommand(GuardForce.Produce_Force())

	QuickReinforce(PlayerObject, AITarget, GuardForce, MainForce)
	
	-- Give an initial order to put the escorts in a state that the Escort function expects
	GuardForce.Guard_Target(MainForce)

	-- Make sure these guys will shoot at structures autonomously
	GuardForce.Set_Targeting_Priorities("Infantry_Attack_Move")

	while true do
		Escort(GuardForce, MainForce)
	end
end

