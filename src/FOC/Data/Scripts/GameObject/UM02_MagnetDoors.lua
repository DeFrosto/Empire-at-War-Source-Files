-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UM02_MagnetDoors.lua#3 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UM02_MagnetDoors.lua $
--
--    Original Author: Jeff_Stewart
--
--            $Author: Jeff_Stewart $
--
--            $Change: 46875 $
--
--          $DateTime: 2006/06/23 09:05:00 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGSpawnUnits")

function Definitions()

   -- Object isn't valid at this point so don't do any operations that
   -- would require it.  State_Init is the first chance you have to do
   -- operations on Object
   
	DebugMessage("%s -- In Definitions", tostring(Script))
	Define_State("State_Init", State_Init);
end


function State_Init(message)
		if message == OnEnter then
			--Do Nothing
			chatter_timer = 120
			health_state = Object.Get_Hull()
		elseif message == OnUpdate then
			--Do Nothing
			if TestValid(Object) then
				if Object.Get_Hull() < health_state then
					if chatter_timer > 120 then 
						tyber=Find_Nearest(Object, "TYBER_ZANN")
						if TestValid(tyber) then
							tyber_distance=Object.Get_Distance(tyber.Get_Position())
							if tyber_distance < 200 then 
								-- if tyber in range when door is shot, play sound
								--tyber.Play_SFX_Event("SFX_UMP_TyberFreePrisoner") -- NOT this sound, only placeholder
								chatter_timer = 0;
							end
						end
					end
				end
			end
			health_state = Object.Get_Hull()
			chatter_timer = chatter_timer + 1
		elseif message == OnExit then 
			--Do Nothing
		end
end


