-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Rebel_Revolt.lua#4 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Rebel_Revolt.lua $
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

require("pginterventions")
require("pgspawnunits")

function Declare_Goal_Type()
	Category = "Intervention_Rebel_Revolt"
	
	reward_table = { Find_Object_Type("Imperial_Artillery_Corp"),
					Find_Object_Type("Imperial_Heavy_Scout_Squad"), 
					Find_Object_Type("Imperial_Anti_Aircraft_Company"), 
					Find_Object_Type("Imperial_Armor_Group"), 
					Find_Object_Type("Imperial_Heavy_Assault_Company"), 
					Find_Object_Type("Imperial_Anti_Infantry_Brigade"),  
					Find_Object_Type("Broadside_Class_Cruiser"), 
					Find_Object_Type("Interdictor_Cruiser"), 
					Find_Object_Type("Tartan_Patrol_Cruiser"), 
					Find_Object_Type("Victory_Destroyer"), 
					Find_Object_Type("Acclamator_Assault_Ship"), 
					Find_Object_Type("Star_Destroyer"),  }
end

function Intervention_Thread()
	
	Begin_Intervention()
		
	plot = Get_Story_Plot("Intervention_Rebel_Revolt.xml")
	
	rebel_player = Find_Player("REBEL")
	empire_player = Find_Player("EMPIRE")
	
	unit, count = Select_Reward_Unit(reward_table, empire_player, 1500 * empire_player.Get_Tech_Level())
	
	reward_unit1 = Find_Object_Type("Rebel_Infantry_Squad")
	reward_unit2 = Find_Object_Type("Rebel_Tank_Buster_Squad")
	
	event = plot.Get_Event("Rebel_Revolt_00")
	event.Set_Reward_Parameter(0, Target)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", unit, count)
		
	event = plot.Get_Event("Rebel_Revolt_01")
	event.Set_Event_Parameter(0, Target)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", unit, count)

	
	plot.Activate()
	
	Wait_On_Flag("REBEL_REVOLT_SPAWN_UNITS", nil)
	Target.Change_Owner(rebel_player)
	enemy_units1 = Spawn_Unit(reward_unit1, Target, rebel_player)
	enemy_units2 = Spawn_Unit(reward_unit2, Target, rebel_player)
	
	Wait_On_Flag("REBEL_REVOLT_NOTIFICATION_00", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end