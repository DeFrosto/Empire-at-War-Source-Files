-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Indigenous_Revolt.lua#2 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Indigenous_Revolt.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Steve_Copeland $
--
--            $Change: 35533 $
--
--          $DateTime: 2005/12/19 10:40:49 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")

function Declare_Goal_Type()
	Category = "Intervention_Indigenous_Revolt"
	
	dialog = nil
	plot = nil
	event = nil
	indigenous_type = nil
	indigenous_spawner = nil
end

function Intervention_Thread()
	
	Begin_Intervention()
	
	if PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_R_Intervention_Indigenous_Revolt"
	else 
		ScriptExit()
	end
		
	indigenous_type = Target.Get_Affiliated_Indigenous_Type(PlayerObject)
	if not indigenous_type then
		ScriptExit()
	end
	
	if indigenous_type.Get_Name() == "EWOK_HUNTER" then
		indigenous_spawner = "EWOK_SPAWN_HOUSE"
	elseif indigenous_type.Get_Name() == "WOOKIE_WARRIOR" then
		indigenous_spawner = "WOOKIEE_SPAWN_HOUSE"
	elseif indigenous_type.Get_Name() == "JAWA_SCOUT" then
		indigenous_spawner = "JAWA_SANDCRAWLER"
	else
		ScriptExit()
	end
		
	plot = Get_Story_Plot("Intervention_Indigenous_Revolt.xml")
		
	event = plot.Get_Event("Indigenous_Revolt_00")
	event.Set_Reward_Parameter(0, Target)
	event.Set_Reward_Parameter(1, indigenous_spawner)
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	
	event = plot.Get_Event("Indigenous_Revolt_01")
	event.Set_Event_Parameter(0, Target)
	
	event = plot.Get_Event("Indigenous_Revolt_03")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())
	event.Set_Reward_Parameter(2, Target)

	event = plot.Get_Event("Indigenous_Revolt_05")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)

	event = plot.Get_Event("Indigenous_Revolt_06")
	event.Set_Reward_Parameter(0, Target)
	event.Set_Reward_Parameter(1, indigenous_spawner)
	
	event = plot.Get_Event("Indigenous_Revolt_07")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())
	event.Set_Reward_Parameter(2, Target)
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)	

	plot.Activate()
	
	Wait_On_Flag("INDIGENOUS_REVOLT_NOTIFICATION_00", Target)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end