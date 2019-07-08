-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Accumulate_Credits.lua#14 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Accumulate_Credits.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Dan_Etter $
--
--            $Change: 34008 $
--
--          $DateTime: 2005/12/02 10:41:38 $
--
--          $Revision: #14 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")

function Declare_Goal_Type()
	Category = "Intervention_Accumulate_Credits"
	
	dialog = nil
	plot = nil
	event = nil
	reward_unit = nil
	reward_location = nil
	
	reward_table = { Find_Object_Type("Rebel_Heavy_Tank_Brigade"),
					Find_Object_Type("Rebel_Light_Tank_Brigade"),
					Find_Object_Type("Rebel_Speeder_Wing"),
					Find_Object_Type("Rebel_Heavy_Tank_Brigade"),
					Find_Object_Type("Rebel_Infantry_Squad"),
					Find_Object_Type("Rebel_Tank_Buster_Squad"),
					Find_Object_Type("Rebel_Infiltrator_Team"),
	
					Find_Object_Type("Calamari_Cruiser"),
					Find_Object_Type("A_Wing_Squadron"),
					Find_Object_Type("Rebel_X-Wing_Squadron"),
					Find_Object_Type("Y-Wing_Squadron"),
					Find_Object_Type("Corellian_Corvette"),
					Find_Object_Type("Corellian_Gunboat"),
					Find_Object_Type("Marauder_Missile_Cruiser"),
					Find_Object_Type("Nebulon_B_Frigate"),
					Find_Object_Type("Alliance_Assault_Frigate"),

					Find_Object_Type("Imperial_Artillery_Corp"),
					Find_Object_Type("Imperial_Heavy_Scout_Squad"), 
					Find_Object_Type("Imperial_Anti_Aircraft_Company"), 
					Find_Object_Type("Imperial_Armor_Group"), 
					Find_Object_Type("Imperial_Heavy_Assault_Company"), 
					Find_Object_Type("Imperial_Anti_Infantry_Brigade"), 
					Find_Object_Type("Imperial_Stormtrooper_Squad"), 
					Find_Object_Type("Imperial_Light_Scout_Squad"), 
					
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
		dialog = "Dialog_E_Intervention_Accumulate_Credits"
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_R_Intervention_Accumulate_Credits"
	else 
		ScriptExit()
	end
	
	reward_unit, reward_count = Select_Reward_Unit(reward_table, PlayerObject, 500 * (PlayerObject.Get_Tech_Level() + 1))
	
	plot = Get_Story_Plot("Intervention_Accumulate_Credits.xml")
		
	event = plot.Get_Event("Accumulate_Credits_00")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_CREDIT_TARGET", 10000)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", reward_unit, reward_count)

	reward_location = FindTarget(Intervention, "One", "Friendly", 1.0)

	event = plot.Get_Event("Accumulate_Credits_01")
	event.Set_Reward_Parameter(0, reward_unit)
	event.Set_Reward_Parameter(1, reward_location)
	event.Set_Reward_Parameter(2, reward_count)
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", reward_unit, reward_count)
	
	event = plot.Get_Event("Accumulate_Credits_03")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())

	plot.Activate()
	
	Wait_On_Flag("ACCUMULATE_CREDITS_NOTIFICATION_00", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end