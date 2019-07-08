-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Pirate_Enlightenment.lua#2 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Pirate_Enlightenment.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 34855 $
--
--          $DateTime: 2005/12/10 13:03:09 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")
require("pgspawnunits")

function Declare_Goal_Type()
	Category = "Intervention_Pirate_Enlightenment"
end

function Intervention_Thread()
	
	Begin_Intervention()
		
	plot = Get_Story_Plot("Intervention_Pirate_Enlightenment.xml")
	
	credits = (PlayerObject.Get_Tech_Level() + 1) * 1000
	
	empire_player = Find_Player("EMPIRE")
	empire_fleet = {
						"Acclamator_Assault_Ship",
						"Broadside_Class_Cruiser",
					}
	
	pirate_player = Find_Player("PIRATES")
	pirate_fleet = {
						"Pirate_Frigate",
						"Pirate_Frigate",
						"Pirate_Frigate",
					}
	
	event = plot.Get_Event("Pirate_Enlightenment_00")
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	
	event = plot.Get_Event("Pirate_Enlightenment_01")
	event.Set_Event_Parameter(0, Target)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	
	event = plot.Get_Event("Pirate_Enlightenment_02_Win")
	event.Set_Reward_Parameter(0, credits)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", credits)
	

	plot.Activate()
	Wait_On_Flag("PIRATE_ENLIGHTENMENT_NOTIFICATION_00", nil)
	
	SpawnList( empire_fleet, Target, empire_player, false, false )

	Target.Force_Test_Space_Conflict ()
	
	Wait_On_Flag("PIRATE_ENLIGHTENMENT_NOTIFICATION_01", nil)
	
	SpawnList( pirate_fleet, Target, pirate_player, false, false )
	
	Target.Force_Test_Space_Conflict ()
	
	Wait_On_Flag("PIRATE_ENLIGHTENMENT_NOTIFICATION_END", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end