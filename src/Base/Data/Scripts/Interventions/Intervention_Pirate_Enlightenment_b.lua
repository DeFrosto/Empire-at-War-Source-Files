-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Pirate_Enlightenment_b.lua#1 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Pirate_Enlightenment_b.lua $
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
	Category = "Intervention_Pirate_Enlightenment_b"
end

function Intervention_Thread()
	
	Begin_Intervention()
		
	plot = Get_Story_Plot("Intervention_Pirate_Enlightenment_b.xml")
	
	empire_player = Find_Player("EMPIRE")
	empire_fleet = {
						"Imperial_Stormtrooper_Squad",
						"Broadside_Class_Cruiser",
					}
		
	event = plot.Get_Event("Pirate_Enlightenment_b_00")
	event.Set_Reward_Parameter(0, Target)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	
	event = plot.Get_Event("Pirate_Enlightenment_b_01")
	event.Set_Reward_Parameter(0, Target)
	
	event = plot.Get_Event("Pirate_Enlightenment_b_02")
	event.Set_Event_Parameter(0, Target)
	

	plot.Activate()
	Wait_On_Flag("PIRATE_ENLIGHTENMENT_B_NOTIFICATION_00", nil)
	
	SpawnList( empire_fleet, Target, empire_player, false, false )
	
	Target.Force_Test_Space_Conflict ()
	
	Wait_On_Flag("PIRATE_ENLIGHTENMENT_B_NOTIFICATION_END", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end