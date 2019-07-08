-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Build_Land_Units.lua#10 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Intervention_Build_Land_Units.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 23281 $
--
--          $DateTime: 2005/08/06 14:49:58 $
--
--          $Revision: #10 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pginterventions")

function Declare_Goal_Type()
	
	Category = "Intervention_Build_Land_Units"
	
	plot = nil
	required_count = nil
	event = nil
	build_object = nil
	dialog = nil
		
end

function Intervention_Thread()
	
	Begin_Intervention()
	
	if PlayerObject.Get_Faction_Name() == "EMPIRE" then
		dialog = "Dialog_E_Intervention_Build_Units"
		build_object = Find_Object_Type("Imperial_Stormtrooper_Squad")
	elseif PlayerObject.Get_Faction_Name() == "REBEL" then
		dialog = "Dialog_R_Intervention_Build_Units"
		build_object = Find_Object_Type("Rebel_Infantry_Squad")
	else 
		ScriptExit()
	end	
	
	plot = Get_Story_Plot("Intervention_Build_Units.xml")

	required_count = GameRandom(3, 8)

	event = plot.Get_Event("Build_Units_00")
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_QUANTITY", required_count)
	event.Add_Dialog_Text("TEXT_INTERVENTION_UNIT", build_object)
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", required_count * 500)

	event = plot.Get_Event("Build_Units_01")
	event.Set_Event_Parameter(0, build_object)
	event.Set_Event_Parameter(1, required_count)
	event.Set_Dialog(dialog)
	event.Clear_Dialog_Text()
	event.Add_Dialog_Text("TEXT_INTERVENTION_REWARD", "TEXT_CREDITS", required_count * 500)

	event = plot.Get_Event("Build_Units_02")
	event.Set_Reward_Parameter(0, required_count * 500)	
	
	event = plot.Get_Event("Build_Units_03")
	event.Set_Reward_Parameter(1, PlayerObject.Get_Faction_Name())

	--Start the plot
	plot.Activate()	

	Wait_On_Flag("BUILD_UNITS_NOTIFICATION_00", nil)

	plot.Suspend()

	plot.Reset()

	End_Intervention()

end