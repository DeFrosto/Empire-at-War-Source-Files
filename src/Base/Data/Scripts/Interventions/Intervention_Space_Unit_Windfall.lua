-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Space_Unit_Windfall.lua#6 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Space_Unit_Windfall.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 33437 $
--
--          $DateTime: 2005/11/28 17:40:14 $
--
--          $Revision: #6 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")

function Declare_Goal_Type()
	Category = "Intervention_Credit_Windfall"
	
	dialog = nil
	plot = nil
	event = nil
	unit = nil
	spawn_location = nil
	
	reward_table = { Find_Object_Type("Calamari_Cruiser"),
					Find_Object_Type("A_Wing_Squadron"),
					Find_Object_Type("Rebel_X-Wing_Squadron"),
					Find_Object_Type("Y-Wing_Squadron"),
					Find_Object_Type("Corellian_Corvette"),
					Find_Object_Type("Corellian_Gunboat"),
					Find_Object_Type("Marauder_Missile_Cruiser"),
					Find_Object_Type("Nebulon_B_Frigate"),
					Find_Object_Type("Alliance_Assault_Frigate"),
					
					Find_Object_Type("Broadside_Class_Cruiser"), 
					Find_Object_Type("Interdictor_Cruiser"), 
					Find_Object_Type("Tartan_Patrol_Cruiser"), 
					Find_Object_Type("Victory_Destroyer"), 
					Find_Object_Type("Acclamator_Assault_Ship"), 
					Find_Object_Type("Star_Destroyer"), 
					Find_Object_Type("TIE_Scout_Squadron"), }		
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

	unit, count = Select_Reward_Unit(reward_table, PlayerObject, 500 * PlayerObject.Get_Tech_Level())	
	
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