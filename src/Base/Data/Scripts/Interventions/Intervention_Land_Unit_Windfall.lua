-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Land_Unit_Windfall.lua#8 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Land_Unit_Windfall.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 33437 $
--
--          $DateTime: 2005/11/28 17:40:14 $
--
--          $Revision: #8 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")

function Declare_Goal_Type()
	Category = "Intervention_Land_Unit_Windfall"
	
	dialog = nil
	plot = nil
	event = nil
	unit = nil
	spawn_location = nil

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
		dialog = "Dialog_E_Intervention_Unit_Windfall"
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_R_Intervention_Unit_Windfall"
	else 
		ScriptExit()
	end
	
	unit, count = Select_Reward_Unit(reward_table, PlayerObject, 200 * PlayerObject.Get_Tech_Level())	
	
	while not spawn_location do
		spawn_location = FindTarget(Intervention, "Major_Intervention_Value", "Friendly", 1.0)
		Sleep(1)
	end
		
	plot = Get_Story_Plot("Intervention_Windfall.xml")

	event = plot.Get_Event("Windfall_00")
	event.Set_Reward_Type("UNIQUE_UNIT")
	event.Set_Reward_Parameter(0, unit)
	event.Set_Reward_Parameter(1, spawn_location)
	event.Set_Reward_Parameter(2, count)
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", unit, count)
	
	event = plot.Get_Event("Windfall_01")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())
	
	plot.Activate()
	
	Wait_On_Flag("WINDFALL_NOTIFICATION_00", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end