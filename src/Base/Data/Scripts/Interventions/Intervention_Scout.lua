-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Scout.lua#10 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Scout.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 32646 $
--
--          $DateTime: 2005/11/18 11:33:49 $
--
--          $Revision: #10 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")

function Declare_Goal_Type()
	Category = "Intervention_Scout"		
	
	plot = nil
	event = nil
	dialog = nil
	second_target = nil
	
end

function Intervention_Thread()
	
	Begin_Intervention()
		
	if PlayerObject.Get_Faction_Name() == "EMPIRE" then
		dialog = "Dialog_E_Intervention_Scout"
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_R_Intervention_Scout"
	else 
		ScriptExit()
	end			
		
	plot = Get_Story_Plot("Intervention_Scout.xml")
		
	event = plot.Get_Event("Scout_00")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	
	event = plot.Get_Event("Scout_01")
	event.Set_Event_Parameter(0, Target)
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())
	
	plot.Activate()
	
	Wait_On_Flag("SCOUT_NOTIFICATION_00", nil)

	second_target = FindTarget(Intervention, "Intervention_Helper_Good_Scout_Target", "Enemy", 0.5)
	
	if not second_target or second_target == Target then
		event = plot.Get_Event("Scout_06")
		event.Set_Dialog(dialog)
		event.Clear_Dialog_Text()
		event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION_COMPLETE", Target)	
		event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", 1000)	
		Story_Event("SCOUT_NOTIFICATION_03")
		Wait_On_Flag("SCOUT_NOTIFICATION_02")
		plot.Suspend()
		plot.Reset()
		End_Intervention()
		ScriptExit()
	end

	event = plot.Get_Event("Scout_02")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION_COMPLETE", Target)	
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", second_target)	
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", 1000)

	event = plot.Get_Event("Scout_03")
	event.Set_Event_Parameter(0, second_target)
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", 1000)

	event = plot.Get_Event("Scout_05")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())

	Story_Event("SCOUT_NOTIFICATION_01")

	Wait_On_Flag("SCOUT_NOTIFICATION_02", nil)

	plot.Suspend()

	plot.Reset()

	End_Intervention()

end

function Intervention_Original_Target_Owner_Changed(tf, old_player, new_player)
	--Take no action
end