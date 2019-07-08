-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/SpeederBike.lua#6 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/SpeederBike.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Steve_Copeland $
--
--            $Change: 34834 $
--
--          $DateTime: 2005/12/09 20:10:35 $
--
--          $Revision: #6 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")


function Definitions()

	Define_State("State_Init", State_Init);

	unit_trigger_number = 3
	divert_range = 500
	min_threat_to_use_ability = 10
	ability_name = "UNTARGETED_STICKY_BOMB"
	area_of_effect = 80
end

function State_Init(message)
	if message == OnEnter then
		--MessageBox("%s--Object:%s", tostring(Script), tostring(Object))

		-- prevent this from doing anything in galactic mode
		--MessageBox("%s, mode %s", tostring(Script), Get_Game_Mode())
		if Get_Game_Mode() ~= "Land" then
			return
		end

		-- Bail out if this is a human player
		if Object.Get_Owner().Is_Human() then
			ScriptExit()
		end

		-- Register a proximity around this unit
		rebel_player = Find_Player("REBEL")
		Register_Prox(Object, Unit_Prox, divert_range, rebel_player)

	elseif message == OnUpdate then

		-- reset tracked units each service.
		nearby_unit_count = 0
		recent_enemy_units = {}
	end
end


-- If an enemy enters the prox, the unit may want to chase them down to use the ability
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

		if (nearby_unit_count >= unit_trigger_number) then
			ConsiderDivertAndAOE(Object, ability_name, area_of_effect, recent_enemy_units, min_threat_to_use_ability)
		end
    
	end
end
