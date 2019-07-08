-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Upgrade_Space_Station.lua#11 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Upgrade_Space_Station.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 27338 $
--
--          $DateTime: 2005/09/15 18:30:58 $
--
--          $Revision: #11 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")

function Declare_Goal_Type()
	
	Category = "Intervention_Upgrade_Space_Station"
		
	plot = nil
	event = nil
	dialog = nil
	base_type = nil
		
end

function Intervention_Thread()
	
	Begin_Intervention()
	
	if PlayerObject.Get_Faction_Name() == "EMPIRE" then
		dialog = "Dialog_E_Intervention_Upgrade_Space_Station"
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_R_Intervention_Upgrade_Space_Station"
	else 
		ScriptExit()
	end		
	
	base_type = Target.Get_Next_Starbase_Type()
	
	if not TestValid(base_type) then
		End_Intervention()
		ScriptExit()
	end	
	
	plot = Get_Story_Plot("Intervention_Upgrade_Space_Station.xml")
		
	event = plot.Get_Event("Upgrade_Space_Station_00")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE", base_type)
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", 1000)

	event = plot.Get_Event("Upgrade_Space_Station_01")
	event.Set_Event_Parameter(0, Target)
	event.Set_Event_Parameter(1, base_type.Get_Base_Level())
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", 1000)
	
	event = plot.Get_Event("Upgrade_Space_Station_03")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())
	event.Set_Reward_Parameter(2, Target)

	plot.Activate()
	
	Wait_On_Flag("UPGRADE_SPACE_STATION_NOTIFICATION_00", Target)

	plot.Suspend()

	plot.Reset()

	End_Intervention()

end

function Intervention_Original_Target_Owner_Changed(tf, old_player, new_player)
	--Cancel the mission, then reset the plot and quit
	event = plot.Get_Event("Upgrade_Space_Station_04")
	event.Set_Event_Parameter(0, Target)
	Story_Event("UPGRADE_SPACE_STATION_NOTIFICATION_ABORT", Target)	
	plot.Suspend()
	plot.Reset()
	ScriptExit()
end