-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Empire_Oppression.lua#1 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Empire_Oppression.lua $
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
	Category = "Intervention_Empire_Oppression"
end

function Intervention_Thread()
	
	Begin_Intervention()
		
	plot = Get_Story_Plot("Intervention_Empire_Oppression.xml")
	
	smuggler = Find_Object_Type("Smuggler_Team_R")
	bounty_hunter = Find_Object_Type("Bounty_Hunter_Team_R")
	
	event = plot.Get_Event("Empire_Oppression_00")
	event.Set_Reward_Parameter(0, Target)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", smuggler, 1)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", bounty_hunter, 1)
		
	event = plot.Get_Event("Empire_Oppression_01")
	event.Set_Event_Parameter(0, Target)
	event.Set_Reward_Parameter(0, smuggler)
	event.Set_Reward_Parameter(1, Target)
	event.Set_Reward_Parameter(2, 1)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", smuggler, 1)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", bounty_hunter, 1)
	
	event = plot.Get_Event("Empire_Oppression_02")
	event.Set_Reward_Parameter(0, bounty_hunter)
	event.Set_Reward_Parameter(1, Target)
	event.Set_Reward_Parameter(2, 1)
	
	plot.Activate()
		
	Wait_On_Flag("EMPIRE_OPPRESSION_NOTIFICATION_00", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end