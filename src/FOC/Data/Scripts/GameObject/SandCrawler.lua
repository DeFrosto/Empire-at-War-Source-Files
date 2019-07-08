-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/SandCrawler.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/SandCrawler.lua $
--
--    Original Author: Brian Hayes
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

--
-- This is a pretty simple trigger script.
-- It just listens for any object entering a box of 100 meters centered on the marker
--
-- 4/29/2005 10:50:24 AM -- BMH
--


--
-- Definitions -- This function is called once when the script is first created.
--
-- @since 4/29/2005 10:51:40 AM -- BMH
-- 
function Definitions()

   -- Object isn't valid at this point so don't do any operations that
   -- would require it.  State_Init is the first chance you have to do
   -- operations on Object

	-- half-width of the box around our object.
	object_trap_size = 80
   
	DebugMessage("%s -- In Definitions", tostring(Script))
		
	Define_State("State_Init", State_Init);
	Define_State("State_Object_Is_Damaged", State_Object_Is_Damaged);

end


--
-- State_Object_In_Range -- We've caught an object.
-- 
-- @param message The message describing our progression through this state.  OnEnter, OnUpdate, OnExit.
-- @since 4/29/2005 10:51:40 AM -- BMH
-- 
function State_Object_Is_Damaged(message)
	if message == OnEnter then
		DebugMessage("%s -- State_Object_Is_Damaged(OnEnter), Caught %s", tostring(Script), tostring(caught_object))

		marker = Find_Hint("E3Demo_Marker_Tanks", "Tank_Marker");
		-- marker = Find_Hint("E3Demo_Marker_Tanks");

		DebugMessage("%s -- Got marker %s", tostring(Script), tostring(marker))
		Point_Camera_At(marker)
		units = BlockOnCommand(Reinforce_Unit(reinforce_type, marker, caught_object.Get_Owner().Get_Enemy()))
		-- units = Spawn_Unit(reinforce_type, marker, caught_object.Get_Owner().Get_Enemy())

		for i,unit in ipairs(units) do
			unit.Prevent_AI_Usage(true)
			unit.Attack_Move(caught_object)
			DebugMessage("%s -- Issued move order for unit %s", tostring(Script), tostring(unit))
		end

		-- Sleep for 60 seconds then reset the trap.
		-- Sleep(60)

		-- Go back to State_Init to reset the trap.
		-- Set_Next_State("State_Init")
		
	elseif message == OnUpdate then
	elseif message == OnExit then
	end
end


--
-- State_Init -- The Init state.  Set our trap to catch an object.
-- 
-- @param message The message describing our progression through this state.  OnEnter, OnUpdate, OnExit.
-- @since 4/29/2005 10:51:40 AM -- BMH
-- 
function State_Init(message)

	if message == OnEnter then
      -- When an object enters within 50 meters call our event.
		DebugMessage("%s -- State_Init(OnEnter)", tostring(Script))
      Object.Event_Object_In_Range(object_in_range_handler, object_trap_size)

		reinforce_type = Find_Object_Type("Rebel_Light_Tank_Brigade")
		storm_type = Find_Object_Type("Stormtrooper")

	elseif message == OnUpdate then

--       if Object.Get_Hull() < 1.0 then
--          Set_Next_State("State_Object_Is_Damaged")
--       end

	elseif message == OnExit then
	end

end


--
-- object_in_range_handler -- Our object in range callback handler.  Passed into the 
--				Object.Event_Object_In_Range function during State_Init.
-- 
-- @param object GameObject of the object that entered our box
-- @since 4/29/2005 10:51:40 AM -- BMH
-- 
function object_in_range_handler(prox_obj, object)

	if object.Get_Type() ~= storm_type then
		return
	end
	-- DebugMessage("%s -- Object %s in range.", tostring(Script), tostring(object))

	-- Cancel the object in range event from signaling anymore.	
	Object.Cancel_Event_Object_In_Range(object_in_range_handler)

	-- gotcha!
	caught_object = object;

	-- Advance our state to Object_In_Range
  	Set_Next_State("State_Object_Is_Damaged")
end

