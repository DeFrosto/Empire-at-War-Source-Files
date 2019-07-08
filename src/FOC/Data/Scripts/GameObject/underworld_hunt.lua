-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/underworld_hunt.lua#3 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/underworld_hunt.lua $
--
--    Original Author: Dan Etter
--
--            $Author: Dan_Etter $
--
--            $Change: 42962 $
--
--          $DateTime: 2006/05/04 11:48:01 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

-- This plan is for an Underworld unit to seek out the nearest enemy and attack move to him.

require("PGStateMachine")


function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
		
	Define_State("State_Init", State_Init);
	
	move_command = true
	
	empire_player = Find_Player("Empire")
	rebel_player = Find_Player("Rebel")
	underworld_player = Find_Player("Underworld")
	
end

function State_Init(message)
	
	if (move_command == true) then
		if TestValid(Find_First_Object("DEMO_CONTROLLER_LAND_E")) then
			defender = empire_player
		elseif TestValid(Find_First_Object("DEMO_CONTROLLER_LAND_R")) then
			defender = rebel_player
		else
			defender = underworld_player
		end
	
		Create_Thread("hunt", defender)
		--MessageBox("Thread created")
		
		move_command = false
	end

end

function hunt(faction)
	if faction == Find_Player("Underworld") then
		rand_num = GameRandom(1,2)
		if rand_num == 1 then
			faction = empire_player
		end
		if rand_num == 2 then
			faction = rebel_player
		end
	end
	while TestValid(Object) do
		closest_enemy = Find_Nearest(Object, faction, true)	
		if TestValid(closest_enemy) then
			Object.Attack_Move(closest_enemy)
		end
	Sleep(1)
	end
end