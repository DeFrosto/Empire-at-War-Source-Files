-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/TacticalMultiplayerBuildLandUnitsGeneric.lua#10 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/TacticalMultiplayerBuildLandUnitsGeneric.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Steve_Copeland $
--
--            $Change: 35613 $
--
--          $DateTime: 2005/12/19 18:19:19 $
--
--          $Revision: #10 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Tactical_Multiplayer_Build_Land_Units_Generic"
	IgnoreTarget = true
	TaskForce = {
	{
		"ReserveForce"
		,"RC_Level_Two_Tech_Upgrade | RC_Level_Three_Tech_Upgrade | RC_Level_Four_Tech_Upgrade = 0,1"
		,"EC_Level_Two_Tech_Upgrade | EC_Level_Three_Tech_Upgrade | EC_Level_Four_Tech_Upgrade = 0,1"
		,"Rebel_Infiltrator_Team | EN_Imperial_Pod_Walker_Company | RN_Rebel_Pod_Walker_Company | Pirate_Skiff_Team | Rebel_Pod_Walker_Company | Rebel_Infantry_Squad | Imperial_Stormtrooper_Squad | Rebel_Tank_Buster_Squad | Imperial_Light_Scout_Squad | Rebel_Artillery_Brigade | Imperial_Artillery_Corp | Rebel_Light_Tank_Brigade | Imperial_Anti_Infantry_Brigade | Rebel_Heavy_Tank_Brigade | Imperial_Armor_Group | Imperial_Heavy_Scout_Squad | Imperial_Heavy_Assault_Company | Imperial_Anti_Aircraft_Company | Rebel_Speeder_Wing | Boba_Fett_Team_Land_MP | Darth_Team_Land_MP | General_Veers_Team | Emperor_Palpatine_Team | Mara_Jade_Team | Han_Solo_Team_Land_MP | Obi_Wan_Team | Droids_Team | Katarn_Team = 0,3"
		}
	}
	RequiredCategories = {"Infantry | Vehicle | Air | LandHero | Upgrade"}
	AllowFreeStoreUnits = false

end

function ReserveForce_Thread()
			
	BlockOnCommand(ReserveForce.Produce_Force())
	ReserveForce.Set_Plan_Result(true)
	ReserveForce.Set_As_Goal_System_Removable(false)

	-- Give some time to accumulate money.
	tech_level = PlayerObject.Get_Tech_Level()
	min_credits = 2000
	if tech_level == 1 then
		min_credits = 3000
	elseif tech_level >= 2 then
		min_credits = 4000
	end
	
	max_sleep_seconds = 80
	current_sleep_seconds = 0
	while (PlayerObject.Get_Credits() < min_credits) and (current_sleep_seconds < max_sleep_seconds) do
		current_sleep_seconds = current_sleep_seconds + 1
		Sleep(1)
	end
		
	ScriptExit()
end