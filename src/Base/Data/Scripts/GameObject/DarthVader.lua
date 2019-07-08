-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/DarthVader.lua#7 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/DarthVader.lua $
--
--    Original Author: Brian Hayes
--
--            $Author: Steve_Copeland $
--
--            $Change: 32988 $
--
--          $DateTime: 2005/11/21 17:52:47 $
--
--          $Revision: #7 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

-- This include order is important.  We need the state service defined in main to override the one in heroplanattach.
require("HeroPlanAttach")
require("PGStateMachine")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	-- only join plans that meet our expense requirements.
	MinPlanAttachCost = 5000
	MaxPlanAttachCost = 0

	-- Special Ability: Rescue Hero	
--	Special_Ability_Type_Names = { "Blackhole", "Boba Fett", "Captain Firmus Piet" }
--	Special_Ability_Weights = { 1, 1, 1 }
--	Special_Ability_Types = WeightedTypeList.Create()
--	Special_Ability_Types.Parse(Special_Ability_Type_Names, Special_Ability_Weights)

	-- Darth Vader hit list.
--	Attack_Ability_Type_Names = { 
--		"Princess Leia", "Han Solo", "Luke Skywalker", "Obi Wan Kanobi",	-- Attack these types.
--		"Mon Mothma", "Admiral Akbar", "General Crix Madine" 					-- Stay away from these types.
--	}
--  Attack_Ability_Weights = { 
--		0.5, 0.5, 1.0, 1.0,				-- attack type weights.
--		-1, BAD_WEIGHT, -0.5				-- feared type weights.
--	}

	Attack_Ability_Type_Names = { 
		"Capital", "Corvette", "Frigate", "Fighter"   	-- Attack these types.
	}
	Attack_Ability_Weights = { 
		1, 1, 1, 1					-- attack type weights.
	}



	Attack_Ability_Types = WeightedTypeList.Create()
	Attack_Ability_Types.Parse(Attack_Ability_Type_Names, Attack_Ability_Weights)

	-- Prefer task forces with these units.
	Escort_Ability_Type_Names = { "Infantry", "Fighter", "Corvette", "Frigate", "Capital" }
	Escort_Ability_Weights = { 1, 2, 3, 4, 5 }
	Escort_Ability_Types = WeightedTypeList.Create()
	Escort_Ability_Types.Parse(Escort_Ability_Type_Names, Escort_Ability_Weights)
	
-- tactical behavior stuff

	Define_State("State_Init", State_Init);

	unit_trigger_number = 10
	divert_range = 400
	min_threat_to_use_ability = 10
	ability_name = "FORCE_WHIRLWIND"
	area_of_effect = 75

end

--function Evaluate_Attack_Ability(target, goal)
--	if StringCompare(goal, "Rescue") then
--		return Get_Target_Weight(target, Special_Ability_Types, Special_Ability_Weights)
--	else then
--		return Get_Target_Weight(target, Attack_Ability_Types, Attack_Ability_Weights)
--	end
--end


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

		-- Register a proximity around MaraJade at the range she might be willing to chase a unit to corrupt them
		--MessageBox("%s-- registering prox", tostring(Script))
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

	-- Vader can only force push infantry
	if not trigger_obj.Is_Category("Infantry") then
		return
	end
	
	-- Reject heroes, which are often infantry, but we can't affect
	if trigger_obj.Is_Category("LandHero") then
		return
	end

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
