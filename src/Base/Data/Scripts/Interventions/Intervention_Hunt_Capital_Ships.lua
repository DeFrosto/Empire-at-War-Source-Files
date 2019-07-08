-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Hunt_Capital_Ships.lua#1 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Hunt_Capital_Ships.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 22903 $
--
--          $DateTime: 2005/08/02 10:46:55 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")

function Declare_Goal_Type()
	Category = "Intervention_Hunt_Capital_Ships"
	
	dialog = nil
	plot = nil
	event = nil
	target_unit = nil
	reward_unit = nil
	reward_location = nil
	
end

function Intervention_Thread()
	
	Begin_Intervention()
	
	if PlayerObject.Get_Faction_Name() == "EMPIRE" then
		dialog = "Dialog_E_Intervention_Hunt_Capital_Ships"
		reward_unit = Find_Object_Type("Star_Destroyer")
		target_unit = Find_Object_Type("Calamari_Cruiser")
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_R_Intervention_Hunt_Capital_Ships"
		reward_unit = Find_Object_Type("Calamari_Cruiser")
		target_unit = Find_Object_Type("Star_Destroyer")
	else 
		ScriptExit()
	end
		
	plot = Get_Story_Plot("Intervention_Hunt_Capital_Ships.xml")
		
	event = plot.Get_Event("Hunt_Capital_Ships_00")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", reward_unit, 1)

	event = plot.Get_Event("Hunt_Capital_Ships_01")
	event.Set_Event_Parameter(0, target_unit)

	reward_location = FindTarget(Intervention, "Is_Home_Planet", "Friendly", 1.0)
	if not reward_location then
		reward_location = FindTarget(Intervention, "One", "Friendly", 1.0)
	end

	event = plot.Get_Event("Hunt_Capital_Ships_02")
	event.Set_Reward_Parameter(0, reward_unit)
	event.Set_Reward_Parameter(1, reward_location)
	event.Set_Reward_Parameter(2, 1)
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", reward_unit, 1)
	
	event = plot.Get_Event("Hunt_Capital_Ships_03")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())

	plot.Activate()
	
	Wait_On_Flag("HUNT_CAPITAL_SHIPS_NOTIFICATION_00", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end