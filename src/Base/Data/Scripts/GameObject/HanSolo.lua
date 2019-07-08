-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/HanSolo.lua#2 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/HanSolo.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Steve_Copeland $
--
--            $Change: 33197 $
--
--          $DateTime: 2005/11/22 20:39:04 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

-- This plan is for the individual Han Solo, contrast the HanSoloPlan which is used for the Han/Chewie team.

-- This include order is important.  We need the state service defined in main to override the one in heroplanattach.
require("HeroPlanAttach")
require("PGStateMachine")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

-- Hero plan self attachment stuff

	-- only join plans that meet our expense requirements.
	MinPlanAttachCost = 45000
	MaxPlanAttachCost = 0

	-- Commander hit list.
	Attack_Ability_Type_Names = { 
		"Death_Star",	-- Attack these types.
		"Darth_Team" ,"Boba_Fett_Team" 				-- Stay away from these types.
	}
	Attack_Ability_Weights = { 
		10,   				-- attack type weights.
		BAD_WEIGHT, BAD_WEIGHT   				-- feared type weights.
	}
	Attack_Ability_Types = WeightedTypeList.Create()
	Attack_Ability_Types.Parse(Attack_Ability_Type_Names, Attack_Ability_Weights)

	-- Prefer task forces with these units.
	Escort_Ability_Type_Names = { "Capital", "Corvette", "Frigate", "Fleet_Com_Rebel_Team", "Fleet_Com_Empire_Team" }
	Escort_Ability_Weights = { 10, 10, 10, BAD_WEIGHT, BAD_WEIGHT }
	Escort_Ability_Types = WeightedTypeList.Create()
	Escort_Ability_Types.Parse(Escort_Ability_Type_Names, Escort_Ability_Weights)


	Define_State("State_Init", State_Init);

	unit_trigger_number = 3
	divert_range = 300
	min_threat_to_use_ability = 400
	area_of_effect = 150
	ability_name = "AREA_EFFECT_STUN"
end


function Evaluate_Attack_Ability(target, goal)
	return Get_Target_Weight(target, Attack_Ability_Types, Attack_Ability_Weights)
end

function Get_Escort_Ability_Weights(goal)
	return Escort_Ability_Types
end

function HeroService()

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

		-- Register a proximity around the unit at the range he might be willing to chase a unit to use an ability
		--MessageBox("%s-- registering prox", tostring(Script))
		rebel_player = Find_Player("EMPIRE")
		Register_Prox(Object, Unit_Prox, divert_range, rebel_player)

	elseif message == OnUpdate then

		-- Track the number of fighters within the prox, resetting each service.
		nearby_unit_count = 0
		recent_enemy_units = {}
	end

end


-- If an enemy enters the prox, han may want to chase them down for stun
function Unit_Prox(self_obj, trigger_obj)

	DebugMessage("%s -- In Prox", tostring(Script))

	-- Reject non-vehicles
	if not trigger_obj.Is_Category("Vehicle") then
		return
	end

	-- Reject heroes, which we can't affect
	if trigger_obj.Is_Category("LandHero") then
		return
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
			ConsiderDivertAndAOE(Object, ability_name, area_of_effect, recent_enemy_units, min_threat_to_use_ability)
		end
	end
end



