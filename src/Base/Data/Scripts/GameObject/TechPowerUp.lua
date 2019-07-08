-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/TechPowerUp.lua#2 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/TechPowerUp.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Brian_Hayes $
--
--            $Change: 22908 $
--
--          $DateTime: 2005/08/02 11:13:31 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")


function Definitions()

   -- Object isn't valid at this point so don't do any operations that
   -- would require it.  State_Init is the first chance you have to do
   -- operations on Object
   
	DebugMessage("%s -- In Definitions", tostring(Script))
		
	Define_State("State_Init", State_Init);

	player = nil
	tech = nil
end


function State_Init(message)

	if message == OnEnter then
		-- Set up event handling for when an object moves within range
		Object.Event_Object_In_Range(object_in_range_handler, 20)
	elseif message == OnUpdate then
		-- Do nothing
	elseif message == OnExit then
		-- Do nothing
	end

end

function object_in_range_handler(prox_object, object)

	player = object.Get_Owner()
	if player.Is_Human() then
	
		tech = player.Give_Random_Sliceable_Tech()
		
		if not tech then 
			player.Give_Money(10000)
		end

		-- Cancel the object in range event from signaling anymore.	
		Object.Cancel_Event_Object_In_Range(object_in_range_handler)

		Object.Despawn()
	end
			
end