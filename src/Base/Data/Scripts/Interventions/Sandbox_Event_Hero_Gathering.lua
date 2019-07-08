-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Sandbox_Event_Hero_Gathering.lua#4 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Sandbox_Event_Hero_Gathering.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 34107 $
--
--          $DateTime: 2005/12/02 17:34:04 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")
require("pginterventions")

function Definitions()
	Category = "Sandbox_Event_Hero_Gathering"
	
	dialog = nil
	plot = nil
	event = nil
	start_time = nil
	
	TaskForce = {
	{
		"MainForce"
		,"TaskForceRequired"
		,"DenyHeroAttach"
		,"Darth_Team | Obi_Wan_Team = 1"
		,"Boba_Fett_Team | Han_Solo_Team = 1"
		,"General_Veers_Team | Droids_Team = 1"
	},
	}	
	AllowFreeStoreUnits = false
	MagicPlan = true	
	MagicPlanStealing = false
end

function MainForce_Thread()
		
	MainForce.Set_As_Goal_System_Removable(false)
	
	if EvaluatePerception("Is_Sandbox_Event_Allowed", PlayerObject) == 0 then
		ScriptExit()
	end	
	
	--Note this script is run by the enemy of the player that receives the story dialog
	if PlayerObject.Get_Faction_Name() == "EMPIRE" then
		dialog = "Dialog_R_Sandbox_Event_Hero_Gathering"
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_E_Sandbox_Event_Hero_Gathering"
	else 
		ScriptExit()
	end
		
	plot = Get_Story_Plot("Sandbox_Event_Hero_Gathering.xml")
		
	event = plot.Get_Event("Hero_Gathering_00")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
		
	event = plot.Get_Event("Hero_Gathering_01")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)		
	
	event = plot.Get_Event("Hero_Gathering_06")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())	
	
	BlockOnCommand(MainForce.Produce_Force(Target))
	LandUnits(MainForce)
	plot.Activate()
	
	start_time = GetCurrentTime()
	while true do
		if Check_Story_Flag(PlayerObject, "HERO_GATHERING_NOTIFICATION_01", nil, true) then	
			plot.Suspend()
			plot.Reset()
			Sleep(300)
			ScriptExit()
		end
	
		if EvaluatePerception("Trigger_Hero_Gathering", PlayerObject, Target) == 0 then
			Story_Event("HERO_GATHERING_NOTIFICATION_00")
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

function MainForce_No_Units_Remaining()
	--Do nothing - in particular don't use the default behavior of quitting the plan
end