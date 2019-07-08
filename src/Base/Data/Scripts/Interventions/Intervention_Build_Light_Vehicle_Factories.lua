-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Build_Light_Vehicle_Factories.lua#12 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Build_Light_Vehicle_Factories.lua $
--
--    Original Author: James Yarrow
--
--            $Author: oksana_kubushyna $
--
--            $Change: 24968 $
--
--          $DateTime: 2005/08/26 13:28:21 $
--
--          $Revision: #12 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")

function Declare_Goal_Type()
	
	Category = "Intervention_Build_Light_Vehicle_Factories"

	dialog = nil
	reward_unit = nil
	build_object = nil
	factory_count = nil
	plot = nil
	event = nil
	reward_location = nil
	
	reward_table = { Find_Object_Type("Rebel_Heavy_Tank_Brigade"),
					Find_Object_Type("Rebel_Light_Tank_Brigade"),
					Find_Object_Type("Rebel_Speeder_Wing"),
					Find_Object_Type("Rebel_Heavy_Tank_Brigade"),
					Find_Object_Type("Rebel_Infantry_Squad"),
					Find_Object_Type("Rebel_Tank_Buster_Squad"),
					Find_Object_Type("Rebel_Infiltrator_Team"),
	
					Find_Object_Type("Imperial_Artillery_Corp"),
					Find_Object_Type("Imperial_Heavy_Scout_Squad"), 
					Find_Object_Type("Imperial_Anti_Aircraft_Company"), 
					Find_Object_Type("Imperial_Armor_Group"), 
					Find_Object_Type("Imperial_Heavy_Assault_Company"), 
					Find_Object_Type("Imperial_Anti_Infantry_Brigade"), 
					Find_Object_Type("Imperial_Stormtrooper_Squad"), 
					Find_Object_Type("Imperial_Light_Scout_Squad"),  }		
			
end

function Intervention_Thread()
	
	Begin_Intervention()
	
	if PlayerObject.Get_Faction_Name() == "EMPIRE" then
		dialog = "Dialog_E_Intervention_Build_Generic_Structure"
		build_object = Find_Object_Type("E_Ground_Light_Vehicle_Factory")
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_R_Intervention_Build_Generic_Structure"
		build_object = Find_Object_Type("R_Ground_Light_Vehicle_Factory")
	else 
		ScriptExit()
	end	

	reward_unit, reward_count = Select_Reward_Unit(reward_table, PlayerObject, 400 * PlayerObject.Get_Tech_Level())
	
	--determine how many factories should be built
	factory_count = EvaluatePerception("Intervention_Helper_Light_Vehicle_Factories_To_Build", PlayerObject)

	--find the xml defined plot for building a generic structure and fill in the skeleton so that
	--it asks the player to build the appropraite number of ion cannons
	plot = Get_Story_Plot("Intervention_Build_Generic_Structure.xml")
				
	--Setup the first event to pop up a dialog and give the player some money to spend on the factories				
	event = plot.Get_Event("Build_Generic_Structure_00")
	event.Set_Reward_Parameter(0, factory_count * 50)
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", factory_count)
	event.Add_Dialog_Text("TEXT_INTERVENTION_STRUCTURE", build_object)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", reward_unit, reward_count)
	
	--Set up the second event to fire when we build the correct number of ion cannons
	event = plot.Get_Event("Build_Generic_Structure_01")
	event.Set_Event_Parameter(0, build_object)
	event.Set_Event_Parameter(1, factory_count)
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())
	
	--Start the plot
	plot.Activate()	
	
	--Wait on notification from the story system that the task has been accomplished
	Wait_On_Flag("BUILD_GENERIC_STRUCTURE_NOTIFICATION_00", nil)
	
	--Find a suitable place to station the reward units
	reward_location = FindTarget(Intervention, "Intervention_Helper_Has_Light_Vehicle_Factory", "Friendly", 1.0)
	while not reward_location do
		Sleep(1)
		reward_location = FindTarget(Intervention, "Intervention_Helper_Has_Light_Vehicle_Factory", "Friendly", 1.0)
	end		
	
	--Set up an event to spawn the reward unit at the selected location and congratulate the player
	event = plot.Get_Event("Build_Generic_Structure_02")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", reward_unit, reward_count)

	event = plot.Get_Event("Build_Generic_Structure_03")
	event.Set_Reward_Parameter(0, reward_unit)
	event.Set_Reward_Parameter(1, reward_location)
	event.Set_Reward_Parameter(2, reward_count)	

	event = plot.Get_Event("Build_Generic_Structure_04")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())

	--Fire this story event to allow the plot to continue and run the event we just set up
	Story_Event("BUILD_GENERIC_STRUCTURE_NOTIFICATION_01")
	
	--Wait until the plot informs us that it's done, stop and reset it, then sleep for a while before we exit
	--to prevent interventions from spawning back-to-back
	Wait_On_Flag("BUILD_GENERIC_STRUCTURE_NOTIFICATION_02", nil)

	plot.Suspend()

	plot.Reset()

	End_Intervention()

end