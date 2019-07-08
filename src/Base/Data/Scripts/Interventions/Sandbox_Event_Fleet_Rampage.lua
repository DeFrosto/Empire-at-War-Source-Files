-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Sandbox_Event_Fleet_Rampage.lua#4 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Sandbox_Event_Fleet_Rampage.lua $
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
require("pgcommands")

function Definitions()
	Category = "Sandbox_Event_Fleet_Rampage"
	
	dialog = nil
	plot = nil
	event = nil
	destroyed_count = nil
	original_count = nil
	perception_name = nil

	MinContrastScale = 3.0
	MaxContrastScale = 3.0		
	TaskForce = {
	{
		"MainForce"
		,"TaskForceRequired"
		,"DenyHeroAttach"
		,"Fighter | Bomber | Corvette | Frigate | Capital = 100%"
		,"Accuser_Star_Destroyer | Home_One = 100%"
	},
	}	
	
	RequiredCategories = { "SpaceHero" }
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
		dialog = "Dialog_R_Sandbox_Event_Fleet_Rampage"
		perception_name = "Has_Accuser"
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_E_Sandbox_Event_Fleet_Rampage"
		perception_name = "Has_Home_One"
	else 
		ScriptExit()
	end
		
	plot = Get_Story_Plot("Sandbox_Event_Fleet_Rampage.xml")
	
	event = plot.Get_Event("Fleet_Rampage_00")
	event.Set_Dialog(dialog)
	event = plot.Get_Event("Fleet_Rampage_01")
	event.Set_Dialog(dialog)
	event = plot.Get_Event("Fleet_Rampage_02")
	event.Set_Dialog(dialog)
	event = plot.Get_Event("Fleet_Rampage_03")
	event.Set_Dialog(dialog)
	
	plot.Activate()
	
	Sleep(1)
	
	AssembleForce(MainForce)
	destroyed_count = 0
	original_count = MainForce.Get_Force_Count()
	
	while TestValid(Target) and MainForce.Get_Force_Count() > 0 do
		BlockOnCommand(MainForce.Move_To(Target))
		
		if GameRandom.Get_Float() < 0.33 then
			Story_Event("FLEET_RAMPAGE_NOTIFICATION_02")
		end
		
		Target = FindTarget(MainForce, "Trigger_Fleet_Rampage", "Enemy", 0.5)
	end
	
	plot.Suspend()
	plot.Reset()
	MainForce.Release_Forces(1.0)
	Sleep(300)	
	ScriptExit()
end

function MainForce_Original_Target_Owner_Changed(tf, old_player, new_player)
end

function MainForce_Unit_Destroyed(tf)
	destroyed_count = destroyed_count + 1
	
	if EvaluatePerception(perception_name, PlayerObject, Target) == 0 then
		Story_Event("FLEET_RAMPAGE_NOTIFICATION_00")
		MainForce.Release_Forces(1.0)
	elseif destroyed_count > original_count / 2 then
		Story_Event("FLEET_RAMPAGE_NOTIFICATION_01")
		MainForce.Release_Forces(1.0)			
	end
end
