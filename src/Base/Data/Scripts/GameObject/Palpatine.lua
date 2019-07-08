-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/Palpatine.lua#4 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/Palpatine.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Steve_Copeland $
--
--            $Change: 34834 $
--
--          $DateTime: 2005/12/09 20:10:35 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

-- This include order is important.  We need the state service defined in main to override the one in heroplanattach.
require("HeroPlanAttach")
require("PGStateMachine")

function Definitions()


-- Hero plan self attachment stuff

	-- only join plans that meet our expense requirements.
	MinPlanAttachCost = 45000
	MaxPlanAttachCost = 0

	-- Commander hit list.
	Attack_Ability_Type_Names = {"All"}
	Attack_Ability_Weights = { BAD_WEIGHT }
	Attack_Ability_Types = WeightedTypeList.Create()
	Attack_Ability_Types.Parse(Attack_Ability_Type_Names, Attack_Ability_Weights)

	-- Prefer task forces with these units.
	Escort_Ability_Type_Names = { "All" }
	Escort_Ability_Weights = { BAD_WEIGHT }
	Escort_Ability_Types = WeightedTypeList.Create()
	Escort_Ability_Types.Parse(Escort_Ability_Type_Names, Escort_Ability_Weights)


-- Object script stuff

	Define_State("State_Init", State_Init);

	unit_trigger_number = 3
	divert_range = 300
	min_threat_to_use_ability = 400
	area_of_effect = 100
	ability_name = "AREA_EFFECT_CONVERT"
end

function State_Init(message)
	if message == OnEnter then
		--MessageBox("%s--Object:%s", tostring(Script), tostring(Object))

		-- Bail out if this is a human player
		if Object.Get_Owner().Is_Human() then
			ScriptExit()
		end

		-- prevent this from doing anything in galactic mode
		if Get_Game_Mode() ~= "Land" then
			return
		end

		-- Register a proximity around Palpatine at the range he might be willing to chase a unit to corrupt them
		--MessageBox("%s-- registering prox", tostring(Script))
		rebel_player = Find_Player("REBEL")
		Register_Prox(Object, Palpatine_Prox, divert_range, rebel_player)

	elseif message == OnUpdate then

		-- Track the number of fighters within the prox, resetting each service.
		nearby_unit_count = 0
		recent_enemy_units = {}
	end

end

-- If an enemy enters the prox, palpatine may want to chase them down for corruption
function Palpatine_Prox(self_obj, trigger_obj)

DebugMessage("%s -- In Prox", tostring(Script))

	-- Reject structures, which we can't corrupt
	if trigger_obj.Is_Category("Structure") then
		return
	end

	-- Reject heroes, which we can't affect
	if trigger_obj.Is_Category("LandHero") then
		return
	end

	-- Fix up trigger obj for sub-squadron individuals, so that only the squadron is tracked
	if trigger_obj.Is_Category("Infantry") then
		trigger_obj = trigger_obj.Get_Parent_Object()
	end
	
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
			if self_obj.Get_Hull() < 0.2 then
				threshold = 100
			else
				threshold = min_threat_to_use_ability
			end
			ConsiderDivertAndAOE(Object, ability_name, area_of_effect, recent_enemy_units, threshold)
		end
	end
end



function Evaluate_Attack_Ability(target, goal)
	return Get_Target_Weight(target, Attack_Ability_Types, Attack_Ability_Weights)
end

function Get_Escort_Ability_Weights(goal)
	return Escort_Ability_Types
end

