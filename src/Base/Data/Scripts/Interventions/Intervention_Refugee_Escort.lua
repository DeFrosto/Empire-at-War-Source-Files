-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Refugee_Escort.lua#1 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Refugee_Escort.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Dan_Etter $
--
--            $Change: 25292 $
--
--          $DateTime: 2005/08/30 09:04:16 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")
require("pgspawnunits")

function Declare_Goal_Type()
	Category = "Intervention_Refugee_Escort"
end

function Intervention_Thread()
	
	Begin_Intervention()
		
	plot = Get_Story_Plot("Intervention_Refugee_Escort.xml")
	
	credits = (PlayerObject.Get_Tech_Level() + 1) * 750
	
	rebel_player = Find_Player("REBEL")
	
	home_location = FindTarget.Reachable_Target(rebel_player, "One", "Friendly", "Any", .045)
	
	event = plot.Get_Event("Refugee_Escort_00")
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_MON_EVENT_REFUGEE_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_MON_EVENT_REFUGEE_DESTINATION", home_location.Get_Game_Object())
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", credits)
	
	event = plot.Get_Event("Refugee_Escort_00a")
	event.Set_Reward_Parameter(0, Target)
	
	event = plot.Get_Event("Refugee_Escort_01")
	event.Set_Event_Parameter(1, home_location.Get_Game_Object())
	event.Set_Reward_Parameter(0, credits)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_MON_EVENT_REFUGEE_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_MON_EVENT_REFUGEE_DESTINATION", home_location.Get_Game_Object())
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", credits)

	plot.Activate()
	
	Wait_On_Flag("REFUGEE_ESCORT_NOTIFICATION_00", nil)
	
	refugee = SpawnList( {"Rebel_Refugee_Team"}, Target, rebel_player, false, false )
	
	Wait_On_Flag("REFUGEE_ESCORT_NOTIFICATION_01", nil)
	
	for i,unit in pairs(refugee) do
		unit.Despawn()
	end
	
	Wait_On_Flag("REFUGEE_ESCORT_NOTIFICATION_02", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end