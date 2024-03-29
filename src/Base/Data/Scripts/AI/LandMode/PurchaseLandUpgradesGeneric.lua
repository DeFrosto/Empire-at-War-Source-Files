-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/PurchaseLandUpgradesGeneric.lua#6 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/PurchaseLandUpgradesGeneric.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Steve_Copeland $
--
--            $Change: 34987 $
--
--          $DateTime: 2005/12/12 21:23:52 $
--
--          $Revision: #6 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Purchase_Land_Upgrades_Generic"
	IgnoreTarget = true
	TaskForce = {
	{
		"ReserveForce"
		,"DenySpecialWeaponAttach"
		,"DenyHeroAttach"
		
		-- Even though only one can be purchased, the 0,10 should increase the liklihood of items from these lists being chosen.
		,"EL_Increased_Mobility_Upgrade | EL_Stamina_Boost_Upgrade | EL_Light_Reflective_Armor_L1_Upgrade | EL_Light_Reflective_Armor_L2_Upgrade | EL_Enhanced_Reactors_L1_Upgrade | EL_Enhanced_Reactors_L2_Upgrade | EL_Heavy_Reflective_Armor_L1_Upgrade | EL_Heavy_Reflective_Armor_L2_Upgrade | EL_Improved_ATAT_Reactors_L1_Upgrade | EL_Improved_ATAT_Reactors_L2_Upgrade | EL_Increased_Production_L1_Upgrade | EL_Increased_Production_L2_Upgrade | EL_Bombing_Run_Use_Upgrade | EL_Reinforced_Structures_Upgrade | EL_Enhanced_Turret_Firepower_L1_Upgrade | EL_Enhanced_Turret_Firepower_L2_Upgrade | EL_Enhanced_Base_Shield_Upgrade | EL_More_Garrisons_L1_Upgrade | EL_Weatherproof_Upgrade | RL_Weatherproof_Upgrade = 0,10"
		,"EL_Increased_Mobility_Upgrade_NoPre | EL_Stamina_Boost_Upgrade_NoPre | EL_Enhanced_Reactors_L1_Upgrade_NoPre | EL_Enhanced_Reactors_L2_Upgrade_NoPre | EL_Heavy_Reflective_Armor_L1_Upgrade_NoPre | EL_Heavy_Reflective_Armor_L2_Upgrade_NoPre | RL_Combat_Armor_L1_Upgrade_NoPre | RL_Combat_Armor_L2_Upgrade_NoPre | RL_Enhanced_Repulsors_L1_Upgrade_NoPre | RL_Enhanced_Repulsors_L2_Upgrade_NoPre | RL_Improved_Treads_L1_Upgrade_NoPre | RL_Improved_Treads_L2_Upgrade_NoPre = 0,10"

		,"RL_Plex_Soldier_Research_Upgrade | RL_Infiltrator_Research_Upgrade | RL_T2B_Research_Upgrade | RL_Snowspeeder_Research_Upgrade | RL_T4B_Research_Upgrade | RL_MPTL_Research_Upgrade = 0,1"
		,"EL_Scout_Trooper_Research_Upgrade | EL_ATAA_Research_Upgrade | EL_ATST_Research_Upgrade | EL_M1_Tank_Research_Upgrade | EL_SPMAT_Research_Upgrade | EL_ATAT_Research_Upgrade = 0,1"
		,"RL_Combat_Armor_L1_Upgrade | RL_Combat_Armor_L2_Upgrade | RL_Light_Armor_L1_Upgrade | RL_Light_Armor_L2_Upgrade | RL_Enhanced_Repulsors_L1_Upgrade | RL_Enhanced_Repulsors_L2_Upgrade | RL_Heavy_Armor_L1_Upgrade | RL_Heavy_Armor_L2_Upgrade | RL_Improved_Treads_L1_Upgrade | RL_Improved_Treads_L2_Upgrade | RL_Improved_T4B_Damage_L1_Upgrade | RL_Improved_T4B_Damage_L2_Upgrade | RL_Increased_Production_L1_Upgrade | RL_Increased_Production_L2_Upgrade | RL_Bombing_Run_Use_Upgrade | RL_Reinforced_Structures_Upgrade | RL_Enhanced_Turret_Firepower_L1_Upgrade | RL_Enhanced_Turret_Firepower_L2_Upgrade | RL_Enhanced_Base_Shield_Upgrade | RL_More_Garrisons_L1_Upgrade = 0,1"
	}
	}
	 
	RequiredCategories = {"Upgrade"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)

	-- Give some time to accumulate money.
	tech_level = PlayerObject.Get_Tech_Level()
	min_credits = 1000
	if tech_level == 1 then
		min_credits = 2000
	elseif tech_level >= 2 then
		min_credits = 3000
	end
	
	max_sleep_seconds = 120
	current_sleep_seconds = 0
	while (PlayerObject.Get_Credits() < min_credits) and (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end
		
	ScriptExit()
end


