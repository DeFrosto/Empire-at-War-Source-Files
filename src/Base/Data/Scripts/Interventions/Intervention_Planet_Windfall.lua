-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Planet_Windfall.lua#5 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Planet_Windfall.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 33437 $
--
--          $DateTime: 2005/11/28 17:40:14 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")

function Declare_Goal_Type()
	Category = "Intervention_Planet_Windfall"
	
	dialog = nil
	plot = nil
	event = nil
		
end

function Intervention_Thread()
	
	Begin_Intervention()
	
	if PlayerObject.Get_Faction_Name() == "EMPIRE" then
		dialog = "Dialog_E_Intervention_Planet_Windfall"
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_R_Intervention_Planet_Windfall"
	else 
		ScriptExit()
	end
		
	plot = Get_Story_Plot("Intervention_Windfall.xml")

	event = plot.Get_Event("Windfall_00")
	event.Set_Reward_Type("PLANET_FACTION")
	event.Set_Reward_Parameter(0, Target)
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	
	event = plot.Get_Event("Windfall_01")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())
	
	plot.Activate()
	
	Wait_On_Flag("WINDFALL_NOTIFICATION_00", nil)

	plot.Suspend()

	plot.Reset()	
	
	End_Intervention()

end