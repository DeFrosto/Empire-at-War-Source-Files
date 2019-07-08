-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ProximitySpawnTrigger_R.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ProximitySpawnTrigger_R.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Andre_Arsenault $
--
--            $Change: 37816 $
--
--          $DateTime: 2006/02/15 15:33:33 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")

--When player units move near this object its spawn behavior becomes enabled

function Definitions()
	object_trap_size = 250
	Define_State("State_Init", State_Init)
	flag_structure_alive = true
	rebel = Find_Player("Rebel")
end

function State_Init(message)
	if message == OnEnter then
		Object.Set_Garrison_Spawn(false)
		Object.Event_Object_In_Range(Object_In_Range_Callback, object_trap_size)
	end
end

function Object_In_Range_Callback(my_object, nearby_object)
	if nearby_object.Get_Owner().Is_Human() then
		my_object.Set_Garrison_Spawn(true)
		facility_loc = my_object.Get_Position()
		script_marker = Find_Object_Type("Rebel_Training_Script_Marker")
		Create_Generic_Object (script_marker, facility_loc, rebel)
		my_object.Cancel_Event_Object_In_Range(Object_In_Range_Callback)
	end
end
