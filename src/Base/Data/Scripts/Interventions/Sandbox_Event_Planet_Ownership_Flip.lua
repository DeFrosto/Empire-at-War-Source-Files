-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Sandbox_Event_Planet_Ownership_Flip.lua#3 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Sandbox_Event_Planet_Ownership_Flip.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 34107 $
--
--          $DateTime: 2005/12/02 17:34:04 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")
require("pginterventions")
require("pgcommands")

function Definitions()
	Category = "Sandbox_Event_Planet_Ownership_Flip"
	
	dialog = nil
	plot = nil
	event = nil

	MinContrastScale = 0.0
	MaxContrastScale = 2.0	
	TaskForce = {
	{
		"StructureForce"
		,"TaskForceRequired"
		,"DenyHeroAttach"
		,"E_Ground_Light_Vehicle_Factory | R_Ground_Light_Vehicle_Factory = 0,1"
		,"Power_Generator_R | Power_Generator_E = 0,1"
		,"E_Ground_Barracks | R_Ground_Barracks = 0,1"
	},
	{
		"UnitForce"
		,"TaskForceRequired"
		,"DenyHeroAttach"
		,"Fighter | Bomber | Corvette | Frigate | Capital = 0,5"
		,"Infantry | Vehicle | Air = 0,5"
	},
	}
	RequiredCategories =	{ 
								"Air | Infantry | Vehicle | AntiStructure",
								"Fighter | Bomber | Corvette | Frigate | Capital"
							}	
	AllowFreeStoreUnits = false
	MagicPlan = true	
	MagicPlanStealing = false
	
end

function StructureForce_Thread()

	StructureForce.Set_As_Goal_System_Removable(false)
	
	if EvaluatePerception("Is_Sandbox_Event_Allowed", PlayerObject) == 0 then
		ScriptExit()
	end	
	
	--Note this script is run by the enemy of the player that receives the story dialog
	if PlayerObject.Get_Faction_Name() == "EMPIRE" then
		dialog = "Dialog_R_Sandbox_Event_Planet_Ownership_Flip"
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_E_Sandbox_Event_Planet_Ownership_Flip"
	else 
		ScriptExit()
	end	

	plot = Get_Story_Plot("Sandbox_Event_Planet_Ownership_Flip.xml")
	
	event = plot.Get_Event("Planet_Ownership_Flip_00")
	event.Set_Reward_Parameter(0, Target)
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)

	event = plot.Get_Event("Planet_Ownership_Flip_01")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())
	
	plot.Activate()

	while not Check_Story_Flag(PlayerObject, "PLANET_OWNERSHIP_FLIP_NOTIFICATION_00", nil, true) do
		Sleep(1)
	end	
	
	BlockOnCommand(StructureForce.Produce_Force(Target))
	BlockOnCommand(UnitForce.Produce_Force(Target))
	
	plot.Suspend()
	plot.Reset()
	
	Sleep(300)

	ScriptExit()
end

function UnitForce_Thread()
	WaitForever()
	ScriptExit()
end

function UnitForce_Original_Target_Owner_Changed(tf, old_player, new_player)
end

function StructureForce_Original_Target_Owner_Changed(tf, old_player, new_player)
end