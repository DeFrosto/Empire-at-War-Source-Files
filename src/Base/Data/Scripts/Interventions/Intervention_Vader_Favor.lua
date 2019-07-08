-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Vader_Favor.lua#1 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Vader_Favor.lua $
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
	Category = "Intervention_Vader_Favor"
	
	reward_table = { Find_Object_Type("Imperial_Artillery_Corp"),
					Find_Object_Type("Imperial_Heavy_Scout_Squad"),
					Find_Object_Type("Imperial_Armor_Group"), 
					Find_Object_Type("Imperial_Anti_Infantry_Brigade"), }
end

function Intervention_Thread()
	
	Begin_Intervention()
		
	plot = Get_Story_Plot("Intervention_Vader_Favor.xml")
	
	empire_player = Find_Player("EMPIRE")
	
	unit, count = Select_Reward_Unit(reward_table, empire_player, 2000 * empire_player.Get_Tech_Level())
		
	event = plot.Get_Event("Vader_Favor_00")
	event.Set_Reward_Parameter(0, Target)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", unit, count)
	
	event = plot.Get_Event("Vader_Favor_00_restricted")
	event.Set_Event_Parameter(0, Target)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	
	event = plot.Get_Event("Vader_Favor_01")
	event.Set_Event_Parameter(1, Target)
	event.Set_Reward_Parameter(0, Target)
	
	event = plot.Get_Event("Vader_Favor_02")
	event.Set_Event_Parameter(0, Target)
	
	event = plot.Get_Event("Vader_Favor_03")
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", unit, count)
	event.Set_Reward_Parameter(0, unit)
	event.Set_Reward_Parameter(1, Target)
	event.Set_Reward_Parameter(2, count)

	plot.Activate()
	
	Wait_On_Flag("VADER_FAVOR_NOTIFICATION_00", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end