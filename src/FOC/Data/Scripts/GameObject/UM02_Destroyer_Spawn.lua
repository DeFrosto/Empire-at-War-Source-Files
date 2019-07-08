-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UM02_Destroyer_Spawn.lua#7 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UM02_Destroyer_Spawn.lua $
--
--    Original Author: Jeff_Stewart
--
--            $Author: Jeff_Stewart $
--
--            $Change: 48731 $
--
--          $DateTime: 2006/07/13 13:13:22 $
--
--          $Revision: #7 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGSpawnUnits")
require("JGS_FunctionLib") -- added library of commonly used functions

function Definitions()

   -- Object isn't valid at this point so don't do any operations that
   -- would require it.  State_Init is the first chance you have to do
   -- operations on Object
   
	DebugMessage("%s -- In Definitions", tostring(Script))
	Define_State("State_Init", State_Init);
end


function State_Init(message)
		if message == OnEnter then
			-- Register a prox event that looks for any nearby units
			empire_player = Find_Player("Empire")
			underworld_player = Find_Player("Underworld")
			random_var = GameRandom(2,30)
			Register_Timer(Respawn, random_var)
			last_droid = nil
		elseif message == OnUpdate then
			--Do Nothing
		elseif message == OnExit then 
			--Do Nothing
		end
end

function Respawn()
	-- respawns destroyer droids from the production lines until deleted by script
	if not TestValid(last_droid) then
		Object.Play_SFX_Event("Unit_AT_AT_Rope_Drop")
		last_droid = Create_Generic_Object("Destroyer_Droid",Object.Get_Position(),empire_player)
		--attack_list = {last_droid}
		Create_Thread("DD_Hunt_Underworld",{last_droid})
		Register_Timer(Respawn, 90)
	else
		Register_Timer(Respawn, 15)
	end
end

function DD_Hunt_Underworld(attack_list)
	local enemy_player = Find_Player("Underworld")
	while true do
	  if not VictoryStarted and not DefeatStarted then
		for k, unit in pairs(attack_list) do
			if TestValid(unit) then
				if not unit.Get_Owner().Is_Human() then
					local closest_enemy = Find_Nearest(unit, enemy_player, true)	
					if  unit.Is_Ability_Ready("ROCKET_ATTACK") then
						unit.Activate_Ability("ROCKET_ATTACK", false)
					end
					unit.Attack_Move(closest_enemy)
				end
			end
		end
	  end
      Sleep(4)
	end
end

