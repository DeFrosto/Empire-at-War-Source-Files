-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/Sundered_Heart.lua#2 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/Sundered_Heart.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Steve_Copeland $
--
--            $Change: 35927 $
--
--          $DateTime: 2006/01/04 17:38:03 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")


function Definitions()

	Define_State("State_Init", State_Init);

	unit_trigger_number = 3
	force_trigger_number = 10
	ability_range = 1000
	min_threat_to_use_ability = 1000
	ability_name = "WEAKEN_ENEMY"
	area_of_effect = 300
end

function State_Init(message)
	if message == OnEnter then
		--MessageBox("%s--Object:%s", tostring(Script), tostring(Object))

		-- prevent this from doing anything in galactic mode
		--MessageBox("%s, mode %s", tostring(Script), Get_Game_Mode())
		if Get_Game_Mode() ~= "Space" then
			return
		end

		-- Bail out if this is a human player
		if Object.Get_Owner().Is_Human() then
			ScriptExit()
		end

		-- Register a proximity around this unit
		rebel_player = Find_Player("EMPIRE")
		Register_Prox(Object, Unit_Prox, ability_range, rebel_player)

	elseif message == OnUpdate then

		-- reset tracked units each service.
		nearby_unit_count = 0
		recent_enemy_units = {}
	end
end


-- If an enemy enters the prox, the unit may want to use the ability
function Unit_Prox(self_obj, trigger_obj)

	DebugMessage("%s -- In Prox", tostring(Script))

	-- Note: we're explicitly tracking individual infantry here (as opposed to their parents, the squads)

    if not trigger_obj then
		DebugMessage("Warning: prox received a nil trigger_obj .")
		return
	end

	-- If we haven't seen this unit recently, track him
	if recent_enemy_units[trigger_obj] == nil then
		recent_enemy_units[trigger_obj] = trigger_obj
		nearby_unit_count = nearby_unit_count + 1

		DebugMessage("%s -- Nearby unit count %d", tostring(Script), nearby_unit_count)

		if Object.Is_Ability_Ready(ability_name) then
			DebugMessage("%s -- ability ready: %s", tostring(Script), ability_name)
			if (nearby_unit_count >= unit_trigger_number) then
				DebugMessage("%s -- met min trigger number", tostring(Script))
				aoe_pos, aoe_victim_threat = Find_Best_Local_Threat_Center(recent_enemy_units, area_of_effect)
				if (aoe_pos ~= nil) then
					if (aoe_victim_threat > min_threat_to_use_ability) then
						DebugMessage("%s -- met min threat triggered; activating ability", tostring(Script))
						Try_Ability(Object, ability_name, aoe_pos)
					end
					if (nearby_unit_count >= force_trigger_number) then
						DebugMessage("%s -- an excess of units nearby; activating ability", tostring(Script))
						Try_Ability(Object, ability_name, aoe_pos)
					end
				end
			end
		end
	end
end
