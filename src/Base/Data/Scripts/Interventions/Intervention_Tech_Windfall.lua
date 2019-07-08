-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Tech_Windfall.lua#2 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Tech_Windfall.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 23760 $
--
--          $DateTime: 2005/08/12 19:54:09 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")

function Declare_Goal_Type()
	Category = "Intervention_Tech_Windfall"
	
	dialog = nil
	plot = nil
	event = nil
	tech_level = nil
	
end

function Intervention_Thread()
	
	--Begin_Intervention()
	
	if PlayerObject.Get_Faction_Name() == "EMPIRE" then
		dialog = "Dialog_E_Intervention_Tech_Windfall"
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_R_Intervention_Tech_Windfall"
	else 
		ScriptExit()
	end
	
	tech_level = (PlayerObject.Get_Tech_Level() + 1)
	
	plot = Get_Story_Plot("Intervention_Windfall.xml")

	event = plot.Get_Event("Windfall_00")
	event.Set_Reward_Type("SET_TECH_LEVEL")
	event.Set_Reward_Parameter(0, PlayerObject.Get_Faction_Name())
	event.Set_Reward_Parameter(1, tech_level)
	event.Set_Dialog(dialog)
	
	event = plot.Get_Event("Windfall_01")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())
	
	plot.Activate()
	
	Wait_On_Flag("WINDFALL_NOTIFICATION_00", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end