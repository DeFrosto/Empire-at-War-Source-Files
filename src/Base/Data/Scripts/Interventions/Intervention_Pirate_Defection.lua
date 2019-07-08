-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Pirate_Defection.lua#1 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Pirate_Defection.lua $
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
	Category = "Intervention_Pirate_Defection"
end

function Intervention_Thread()
	
	Begin_Intervention()
		
	plot = Get_Story_Plot("Intervention_Pirate_Defection.xml")
	
	pirate_player = Find_Player("PIRATES")
	
	ATAT = Find_Object_Type("Imperial_Heavy_Assault_Company")
	
	event = plot.Get_Event("Pirate_Defection_00")
	event.Set_Reward_Parameter(0, Target)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", ATAT, 1)
				
	event = plot.Get_Event("Pirate_Defection_01")
	event.Set_Event_Parameter(0, Target)
	event.Set_Reward_Parameter(0, ATAT)
	event.Set_Reward_Parameter(1, Target)
	event.Set_Reward_Parameter(2, 1)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", ATAT, 1)

	
	plot.Activate()
	
	Wait_On_Flag("PIRATE_DEFECTION_NOTIFICATION_00", nil)
	
	Squad0 = SpawnList( {"Pirate_Soldier_Squad"}, Target, pirate_player, false, false )
	Squad1 = SpawnList( {"Pirate_Soldier_Squad"}, Target, pirate_player, false, false )
	Squad2 = SpawnList( {"Pirate_Soldier_Squad"}, Target, pirate_player, false, false )
	Squad3 = SpawnList( {"Pirate_Soldier_Squad"}, Target, pirate_player, false, false )
	Squad4 = SpawnList( {"Pirate_PLEX_Squad"}, Target, pirate_player, false, false )
	Squad5 = SpawnList( {"Pirate_PLEX_Squad"}, Target, pirate_player, false, false )
	Squad6 = SpawnList( {"Pirate_Skiff_Team"}, Target, pirate_player, false, false )
	Squad7 = SpawnList( {"Pirate_Skiff_Team"}, Target, pirate_player, false, false )
	Squad8 = SpawnList( {"Pirate_Swamp_Speeder_Team"}, Target, pirate_player, false, false )
	Squad9 = SpawnList( {"Pirate_Swamp_Speeder_Team"}, Target, pirate_player, false, false )
	
	Wait_On_Flag("PIRATE_DEFECTION_NOTIFICATION_01", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end