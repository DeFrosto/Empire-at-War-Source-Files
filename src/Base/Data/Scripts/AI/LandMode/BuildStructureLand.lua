-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/BuildStructureLand.lua#2 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/BuildStructureLand.lua $
--
--    Original Author: Steve Copeland
--
--            $Author: Steve_Tall $
--
--            $Change: 36754 $
--
--          $DateTime: 2006/01/25 16:13:32 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")


function Definitions()
	
	Category = "Tactical_Multiplayer_Build_Basic_Structure"
	IgnoreTarget = true
	TaskForce = {
	{
		"MainForce"
		,"UC_Power_Generator_R | UC_Power_Generator_E | UC_E_Ground_Base_Shield | UC_R_Ground_Base_Shield | UC_E_Small_Ground_Base_Shield | UC_R_Small_Ground_Base_Shield | UC_Empire_Mineral_Processor | UC_Rebel_Mineral_Processor | UC_Empire_Ground_Mining_Facility | UC_Rebel_Ground_Mining_Facility | UC_E_Ground_Turbolaser_Tower | UC_R_Ground_Turbolaser_Tower | UC_E_Ground_Light_Vehicle_Factory | UC_R_Ground_Light_Vehicle_Factory | UC_E_Ground_Heavy_Vehicle_Factory | UC_R_Ground_Heavy_Vehicle_Factory | UC_E_Ground_Research_Facility | UC_R_Ground_Research_Facility | UC_Communications_Array_E | UC_Communications_Array_R = 1"
	}
	}
--	RequiredCategories = {"Structure"}
	AllowFreeStoreUnits = false

end

function MainForce_Thread()

	BlockOnCommand(MainForce.Build_All())
	MainForce.Set_Plan_Result(true)
	ScriptExit()
end



