-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UM11_ForceAdeptOne.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UM11_ForceAdeptOne.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Jeff_Stewart $
--
--            $Change: 49737 $
--
--          $DateTime: 2006/07/27 16:30:27 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")


function Definitions()

   -- Object isn't valid at this point so don't do any operations that
   -- would require it.  State_Init is the first chance you have to do
   -- operations on Object
   
	DebugMessage("%s -- In Definitions", tostring(Script))
	Define_State("State_Init", State_Init);
end


function State_Init(message)

	if message == OnEnter then
		healme = Find_Nearest(Object, "EMPIRE_BUILDABLE_BACTA_TANK")
		target = Find_Nearest(Object, "TYBER_ZANN")
	
		Create_Thread("AdeptOne_AI")
	elseif message == OnUpdate then
		-- Do nothing
	elseif message == OnExit then
		-- Do nothing
	end

end

function AdeptOne_AI()
	while TestValid(Object) do
		if Object.Get_Hull() < 0.65 then
			if TestValid(healme) then
				Object.Move_To(healme)
				--MessageBox("move %s", tostring(healme.Get_Type().Get_Name()))
			end
		else
			if TestValid(target) then
				if target.Is_Ability_Active("STEALTH") then
					Object.Move_To(Object)
				else
					Object.Attack_Move(target)
					--MessageBox("attack move %s", tostring(target.Get_Type().Get_Name()))
				end
			end
		end
		Sleep(2)
	end
end
	