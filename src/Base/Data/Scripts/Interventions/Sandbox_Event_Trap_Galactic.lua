-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Sandbox_Event_Trap_Galactic.lua#4 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Sandbox_Event_Trap_Galactic.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 34302 $
--
--          $DateTime: 2005/12/05 18:27:40 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")
require("pginterventions")

function Definitions()
	Category = "Sandbox_Event_Trap_Galactic"
	
	dialog = nil
	plot = nil
	event = nil
	start_time = nil
	
	TaskForce = {
	{
		"MainForce"
		,"TaskForceRequired"
		,"DenyHeroAttach"
	},
	}	
	
end

function MainForce_Thread()
		
	MainForce.Set_As_Goal_System_Removable(false)
	
	if EvaluatePerception("Is_Sandbox_Event_Allowed", PlayerObject) == 0 then
		ScriptExit()
	end	
	
	--Note this script is run by the enemy of the player that receives the story dialog
	if PlayerObject.Get_Faction_Name() == "EMPIRE" then
		dialog = "Dialog_R_Sandbox_Event_Trap"
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_E_Sandbox_Event_Trap"
	else 
		ScriptExit()
	end
		
	plot = Get_Story_Plot("Sandbox_Event_Trap_Galactic.xml")
		
	event = plot.Get_Event("Trap_Galactic_00")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
		
	event = plot.Get_Event("Trap_Galactic_01")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)		
		
	event = plot.Get_Event("Trap_Galactic_02")
	event.Set_Event_Parameter(1, Target)

	event = plot.Get_Event("Trap_Galactic_04")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())	
	event.Set_Reward_Parameter(2, Target)
	
	event = plot.Get_Event("Trap_Galactic_05")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())	
	
	plot.Activate()
	
	start_time = GetCurrentTime()
	while true do
		if Check_Story_Flag(PlayerObject, "TRAP_GALACTIC_NOTIFICATION_01", nil, true) then
		
			while not Check_Story_Flag(PlayerObject, "TRAP_GALACTIC_NOTIFICATION_02", nil, true) do
				Sleep(1)
			end	
			
			--Make sure the trap flag on the target is cleared
			Check_Story_Flag(PlayerObject, "TRAP_GALACTIC_NOTIFICATION_01", Target, true)
		
			plot.Suspend()
			plot.Reset()
			Sleep(300)
			ScriptExit()
		end
	
		if EvaluatePerception("Trigger_Trap_Galactic", PlayerObject, Target) == 0 then
			Story_Event("TRAP_GALACTIC_NOTIFICATION_00")
			plot.Suspend()
			plot.Reset()
			Sleep(300)
			ScriptExit()		
		end
		
		Sleep(1)
	end
	
end

function MainForce_Original_Target_Owner_Changed(tf, old_player, new_player)
end