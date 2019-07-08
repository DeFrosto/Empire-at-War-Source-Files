-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/E3_Felucia_Zone.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/E3_Felucia_Zone.lua $
--
--    Original Author: Jeff_Stewart
--
--            $Author: Jeff_Stewart $
--
--            $Change: 43357 $
--
--          $DateTime: 2006/05/08 09:03:19 $
--
--          $Revision: #4 $
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
			-- Register a prox event that looks for any nearby units
			empire_player = Find_Player("Empire")
			underworld_player = Find_Player("Underworld")
			reinforce_list = {
				"Imperial_Stormtrooper_Squad"
			}
			Register_Prox(Object, Reinforce_Point, 50, underworld_player)
		elseif message == OnUpdate then
			--Do Nothing
		elseif message == OnExit then 
		end
end

function Reinforce_Point()
	--This function tests whether tyber zann is close to the landing platform
	--if so, we drop off a few stormtroopers, if not set the timer a little shorter
	--so that we check again earlier
		Object.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
		--function ReinforceList(type_list, entry_marker, player, allow_ai_usage, delete_after_scenario, ignore_reinforcement_rules, callback)
		--ReinforceList(reinforce_list, Object, empire_player, false, true, true, Find_And_Attack)
		
		player_unit_list = Find_All_Objects_Of_Type(empire_player)
		closest_infantry = Find_Nearest(Object, underworld_player, true)
		area = closest_infantry.Get_Position()
	
		for i, player_unit in pairs(player_unit_list) do
			if TestValid(player_unit) then
				--MessageBox("Player_Back_To_Vulnerable")
				player_unit.Attack_Move(area)
			end
		end
end

function Find_And_Attack(attack_list)
	--This function is passed to every unloaded storm trooper squad
	--the squads look for tyber's location and attack move towards it
	closest_infantry = Find_Nearest(Object, underworld_player, true)
	--tyber_zann=Find_First_Object("TYBER_ZANN")
	area = closest_infantry.Get_Position()
	for k, unit in pairs(attack_list) do
		if TestValid(unit) then
			if TestValid(closest_infantry) then
				unit.Attack_Move(area)
			end
		end
	end
end

