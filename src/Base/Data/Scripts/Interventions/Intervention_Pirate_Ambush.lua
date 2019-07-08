-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Pirate_Ambush.lua#1 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Pirate_Ambush.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Dan_Etter $
--
--            $Change: 25292 $
--
--          $DateTime: 2005/08/30 09:04:16 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")
require("pgspawnunits")

function Declare_Goal_Type()
	Category = "Intervention_Pirate_Ambush"
	
	reward_table = { Find_Object_Type("Imperial_Artillery_Corp"),
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
		
	plot = Get_Story_Plot("Intervention_Pirate_Ambush.xml")

	empire_player = Find_Player("EMPIRE")

	unit, count = Select_Reward_Unit(reward_table, empire_player, 1500 * empire_player.Get_Tech_Level())	

	plot.Activate()
	
	Wait_On_Flag("PIRATE_AMBUSH_NOTIFICATION_00", nil)

	spawn_location = FindTarget.Reachable_Target(empire_player, "Intervention_Helper_Weakly_Defended_Space", "Friendly", "Any", 1.0)

	event = plot.Get_Event("Pirate_Ambush_02")
	event.Set_Reward_Parameter(0, unit)
	event.Set_Reward_Parameter(1, spawn_location.Get_Game_Object())
	event.Set_Reward_Parameter(2, count)

	pirate_player = Find_Player("PIRATES")
	pirate_fleet = {
						"Pirate_Frigate",
						"Pirate_Frigate",
						"Pirate_Fighter_Squadron",
						"Pirate_Fighter_Squadron",
						"Pirate_Fighter_Squadron",
					}

	SpawnList( pirate_fleet, spawn_location.Get_Game_Object(), pirate_player, false, false )
	
	spawn_location.Get_Game_Object ().Force_Test_Space_Conflict ()
	
	Wait_On_Flag("PIRATE_AMBUSH_NOTIFICATION_01", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end