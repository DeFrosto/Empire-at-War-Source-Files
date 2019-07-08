-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Fleet_Rescue.lua#1 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Fleet_Rescue.lua $
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
	Category = "Intervention_Fleet_Rescue"
	
	reward_table = { Find_Object_Type("Corellian_Corvette"),
					Find_Object_Type("Corellian_Gunboat"),
					Find_Object_Type("Nebulon_B_Frigate"), 
					Find_Object_Type("Marauder_Missile_Cruiser"), }
					
end

function Intervention_Thread()
	
	Begin_Intervention()
		
	plot = Get_Story_Plot("Intervention_Fleet_Rescue.xml")
	
	rebel_player = Find_Player("REBEL")
	
	unit, count = Select_Reward_Unit(reward_table, rebel_player, 2000 * rebel_player.Get_Tech_Level())
	
	event = plot.Get_Event("Fleet_Rescue_00")
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	
	event = plot.Get_Event("Fleet_Rescue_01")
	event.Set_Event_Parameter(0, Target)
	event.Set_Reward_Parameter(0, unit)
	event.Set_Reward_Parameter(1, Target)
	event.Set_Reward_Parameter(2, count)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", unit, count)

	plot.Activate()
	
	Wait_On_Flag("FLEET_RESCUE_NOTIFICATION_00", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end