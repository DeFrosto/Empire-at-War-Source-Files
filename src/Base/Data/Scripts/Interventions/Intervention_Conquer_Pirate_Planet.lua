-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Conquer_Pirate_Planet.lua#14 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Conquer_Pirate_Planet.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Dan_Etter $
--
--            $Change: 33933 $
--
--          $DateTime: 2005/12/01 16:36:13 $
--
--          $Revision: #14 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")

function Declare_Goal_Type()
	
	Category = "Intervention_Conquer_Pirate_Planet | Intervention_Conquer_Enemy_Planet"
		
	plot = nil
	reward_unit = nil
	event = nil
	dialog = nil

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
		dialog = "Dialog_E_Intervention_Conquer_Pirate_Planet"
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_R_Intervention_Conquer_Pirate_Planet"
	else 
		ScriptExit()
	end		
	
	reward_unit, reward_count = Select_Reward_Unit(reward_table, PlayerObject, 500 * (PlayerObject.Get_Tech_Level() + 1))	
		
	plot = Get_Story_Plot("Intervention_Conquer_Planet.xml")

	event = plot.Get_Event("Conquer_Planet_00")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", reward_unit, reward_count)

	event = plot.Get_Event("Conquer_Planet_01")
	event.Set_Event_Parameter(0, Target)
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()	
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", reward_unit, reward_count)
		
	event = plot.Get_Event("Conquer_Planet_02")
	event.Set_Reward_Parameter(0, reward_unit)
	event.Set_Reward_Parameter(1, Target)
	event.Set_Reward_Parameter(2, reward_count)

	event = plot.Get_Event("Conquer_Planet_03")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())
	event.Set_Reward_Parameter(2, Target)	

	--Start the plot
	plot.Activate()	

	Wait_On_Flag("CONQUER_PLANET_NOTIFICATION_00", Target)

	plot.Suspend()

	plot.Reset()

	End_Intervention()
end

function Intervention_Original_Target_Owner_Changed(tf, old_player, new_player)
	--Take no action
end