-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/SpaceMode/PurchaseSpaceUpgradesGeneric.lua#4 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/SpaceMode/PurchaseSpaceUpgradesGeneric.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Steve_Copeland $
--
--            $Change: 34987 $
--
--          $DateTime: 2005/12/12 21:23:52 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Purchase_Space_Upgrades_Generic"
	IgnoreTarget = true
	TaskForce = {
	{
		"ReserveForce"
		,"DenySpecialWeaponAttach"
		,"DenyHeroAttach"
		,"RS_Enhanced_Shielding_L1_Upgrade | RS_Enhanced_Shielding_L2_Upgrade | RS_Enhanced_Shielding_L3_Upgrade | RS_Improved_Weapons_L1_Upgrade | RS_Improved_Weapons_L2_Upgrade | RS_Improved_Weapons_L3_Upgrade | RS_Increased_Supplies_L1_Upgrade | RS_Increased_Supplies_L2_Upgrade | RS_Ion_Cannon_Use_Upgrade | RS_Reinforced_Armor_L1_Upgrade | RS_Reinforced_Armor_L2_Upgrade | RS_Improved_Defenses_L1_Upgrade | RS_Improved_Defenses_L2_Upgrade | RS_Improved_Defenses_L3_Upgrade | RS_More_Garrisons_L1_Upgrade | ES_Enhanced_Reactors_L1_Upgrade | ES_Enhanced_Reactors_L2_Upgrade | ES_Enhanced_Reactors_L3_Upgrade | ES_Reinforced_Armor_L1_Upgrade | ES_Reinforced_Armor_L2_Upgrade | ES_Reinforced_Armor_L3_Upgrade | ES_Increased_Supplies_L1_Upgrade | ES_Increased_Supplies_L2_Upgrade | ES_Improved_Weapons_L1_Upgrade | ES_Improved_Weapons_L2_Upgrade | ES_Improved_Weapons_L3_Upgrade | ES_Hypervelocity_Gun_Use_Upgrade | ES_Improved_Defenses_L1_Upgrade | ES_Improved_Defenses_L2_Upgrade | ES_Improved_Defenses_L3_Upgrade | ES_More_Garrisons_L1_Upgrade = 1"
	}
	}
	 
	--RequiredCategories = {"Upgrade"}
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

