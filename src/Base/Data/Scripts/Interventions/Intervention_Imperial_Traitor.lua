-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Imperial_Traitor.lua#1 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Imperial_Traitor.lua $
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
	Category = "Intervention_Imperial_Traitor"
end

function Intervention_Thread()
	
	Begin_Intervention()
		
	plot = Get_Story_Plot("Intervention_Imperial_Traitor.xml")
	
	credits = (PlayerObject.Get_Tech_Level() + 1) * 750
	
	event = plot.Get_Event("Imperial_Traitor_00")
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", credits)
		
	event = plot.Get_Event("Imperial_Traitor_01")
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_LOCATION", Target)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", credits)
	event.Set_Event_Parameter(0, Target)
	event.Set_Reward_Parameter(0, credits)

	plot.Activate()
	
	Wait_On_Flag("IMPERIAL_TRAITOR_NOTIFICATION_00", nil)

	plot.Suspend()

	plot.Reset()
	
	End_Intervention()

end