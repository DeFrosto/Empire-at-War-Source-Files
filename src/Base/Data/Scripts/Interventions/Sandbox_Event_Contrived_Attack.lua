-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Sandbox_Event_Contrived_Attack.lua#5 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Sandbox_Event_Contrived_Attack.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 34107 $
--
--          $DateTime: 2005/12/02 17:34:04 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")
require("pginterventions")

function Definitions()
	Category = "Sandbox_Event_Contrived_Attack"
	
	dialog = nil
	plot = nil
	event = nil
	
	MinContrastScale = 1.0
	MaxContrastScale = 1.4	
	TaskForce = {
	{
		"MainForce"
		,"TaskForceRequired"
		,"DenyHeroAttach"
		,"Fighter | Bomber | Corvette | Frigate | Capital = 100%"
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
		dialog = "Dialog_R_Sandbox_Event_Contrived_Attack"
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_E_Sandbox_Event_Contrived_Attack"
	else 
		ScriptExit()
	end
		
	plot = Get_Story_Plot("Sandbox_Event_Contrived_Attack.xml")

	event = plot.Get_Event("Contrived_Attack_00")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
		
	event = plot.Get_Event("Contrived_Attack_02")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	
	event = plot.Get_Event("Contrived_Attack_04")
	event.Set_Dialog(dialog)
	
	event = plot.Get_Event("Contrived_Attack_07")
	event.Set_Dialog(dialog)	
		
	event = plot.Get_Event("Contrived_Attack_05")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())

	event = plot.Get_Event("Contrived_Attack_08")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())	
		
	plot.Activate()
	
	Sleep(45)
	Story_Event("CONTRIVED_ATTACK_NOTIFICATION_00")
	Sleep(15)
	
	BlockOnCommand(MainForce.Produce_Force(Target))
	BlockOnCommand(MainForce.Force_Test_Space_Conflict())

	if MainForce.Get_Force_Count() == 0 then
		Story_Event("CONTRIVED_ATTACK_NOTIFICATION_01")
	else
		Story_Event("CONTRIVED_ATTACK_NOTIFICATION_02")
	end
	
	while not Check_Story_Flag(PlayerObject, "CONTRIVED_ATTACK_NOTIFICATION_03", nil, true) do
		Sleep(1)
	end	

	plot.Suspend()

	plot.Reset()
	
	MainForce.Release_Forces(1.0)
	
	Sleep(600)
end

function MainForce_No_Units_Remaining()
	--Do nothing - in particular don't use the default behavior of quitting the plan
end