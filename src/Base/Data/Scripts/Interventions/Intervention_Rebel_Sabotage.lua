-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Rebel_Sabotage.lua#1 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Rebel_Sabotage.lua $
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
	Category = "Intervention_Rebel_Sabotage"
end

function Intervention_Thread()
	
	Begin_Intervention()
		
	plot = Get_Story_Plot("Intervention_Rebel_Sabotage.xml")

	credits = (PlayerObject.Get_Tech_Level() + 1) * 250
	
	rebel_player = Find_Player("REBEL")
	
	Commander = SpawnList( {"Fleet_Com_Rebel_Team"}, Target, rebel_player, false, false )
	
	event = plot.Get_Event("Rebel_Sabotage_00")
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", credits)
		
	event = plot.Get_Event("Rebel_Sabotage_01")
	event.Set_Event_Parameter(1, Target)
	event.Set_Reward_Parameter(0, credits)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", credits)

	plot.Activate()
	
	Wait_On_Flag("REBEL_SABOTAGE_NOTIFICATION_00", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end