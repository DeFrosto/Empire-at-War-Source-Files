-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UM11_ForceAdeptTwo.lua#5 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UM11_ForceAdeptTwo.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Jeff_Stewart $
--
--            $Change: 50386 $
--
--          $DateTime: 2006/08/03 17:45:23 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")


function Definitions()

   -- Object isn't valid at this point so don't do any operations that
   -- would require it.  State_Init is the first chance you have to do
   -- operations on Object
   
	DebugMessage("%s -- In Definitions", tostring(Script))
	Define_State("State_Init", State_Init);
	underworld_player = Find_Player("Underworld")
	empire_player = Find_Player("Empire")
end


function State_Init(message)
	if message == OnEnter then
		Register_Prox(Object, Prox_StartAI, 100, underworld_player)
		-- Do nothing
	elseif message == OnUpdate then
		-- Do nothing
	elseif message == OnExit then
		-- Do nothing
	end
end

function Prox_StartAI(self_obj, trigger_obj)
	target = Find_Nearest(Object, "URAI_FEN")
	if trigger_obj == target then
		Create_Thread("AdeptTwo_AI")
		self_obj.Cancel_Event_Object_In_Range(Prox_StartAI)
	end
end


function AdeptTwo_AI()
	while TestValid(Object) do
		if TestValid(target) then
			if target.Is_Ability_Active("STEALTH") then
				Object.Move_To(Object)
			else
				Object.Attack_Move(target)
				--MessageBox("attack move %s", tostring(target.Get_Type().Get_Name()))
			end
		end
		Sleep(5)
	end
end

