-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/DestroyLandUnit.lua#17 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/DestroyLandUnit.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Steve_Copeland $
--
--            $Change: 35401 $
--
--          $DateTime: 2005/12/15 23:59:42 $
--
--          $Revision: #17 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

ScriptPoolCount = 5

function Definitions()
	
	Category = "Destroy_Land_Unit"
	TaskForce = {
	{
		"MainForce"		
		,"DenyHeroAttach"
		,"Vehicle | Air = 1,8"
		,"LandHero = 0,1"
	},
	{
		"GuardForce"
		,"EscortForce"
		,"Infantry = 0,4"
	}
	}

	start_loc = nil

end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	QuickReinforce(PlayerObject, AITarget, MainForce, GuardForce)
	
	--BlockOnCommand(MainForce.Move_To(MainForce.Get_Stage(), false)) -- true = wait for entire taskforce at intermediate zone points
	
	MainForce.Set_As_Goal_System_Removable(false)

	MainForce.Activate_Ability("ROCKET_ATTACK", false)

	--TODO: Assign appropriate targeting priorities here, once we get the ability to do this per unit type
	BlockOnCommand(MainForce.Attack_Move(AITarget, MainForce.Get_Self_Threat_Max()))		

	ScriptExit()
end

function GuardForce_Thread()
	BlockOnCommand(GuardForce.Produce_Force())
	QuickReinforce(PlayerObject, AITarget, GuardForce, MainForce)
	
	-- Give an initial order to put the escorts in a state that the Escort function expects
	GuardForce.Guard_Target(MainForce)

	while true do
		Escort(GuardForce, MainForce)
	end
end
