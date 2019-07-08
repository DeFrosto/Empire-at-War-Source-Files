-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/ObiWanPlan.lua#2 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/ObiWanPlan.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Steve_Copeland $
--
--            $Change: 32792 $
--
--          $DateTime: 2005/11/19 14:56:25 $
--
--          $Revision: #2 $
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

	-- Commander hit list.
	Attack_Ability_Type_Names = { 
		"Infantry",	-- Attack these types.
		"Darth_Team" ,"Boba_Fett_Team" 				-- Stay away from these types.
	}
	Attack_Ability_Weights = { 
		10,   				-- attack type weights.
		BAD_WEIGHT, BAD_WEIGHT   				-- feared type weights.
	}
	Attack_Ability_Types = WeightedTypeList.Create()
	Attack_Ability_Types.Parse(Attack_Ability_Type_Names, Attack_Ability_Weights)

	-- Prefer task forces with these units.
	Escort_Ability_Type_Names = { "Infantry", "Vehicle", "Air", "Fleet_Com_Rebel_Team", "Fleet_Com_Empire_Team" }
	Escort_Ability_Weights = { 3, 10, 3, BAD_WEIGHT, BAD_WEIGHT }
	Escort_Ability_Types = WeightedTypeList.Create()
	Escort_Ability_Types.Parse(Escort_Ability_Type_Names, Escort_Ability_Weights)
	
-- tactical behavior stuff

	Define_State("State_Init", State_Init);

	heal_ability_name = "AREA_EFFECT_HEAL"
	infantry_trigger_number = 1
	divert_range = 500
	min_threat_to_use_heal = 100
	max_health_considered = 0.4
	heal_area_of_effect = 300
	
	invulnerability_ability_name = "TARGETED_INVULNERABILITY"
	min_threat_to_use_invulnerability = 400
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

		-- Register a proximity around the unit at a range we're willing to divert for ability use
		--MessageBox("%s-- registering prox", tostring(Script))
		rebel_player = Find_Player("REBEL")
		Register_Prox(Object, Divert_Prox, divert_range, rebel_player)
		
		-- Register a prox for the AOE at range invulnerability ability
		-- ...maybe we can get away with using the same prox
		--Register_Prox(Object, Range_Prox, 

	elseif message == OnUpdate then

		-- reset tracked units each service.
		nearby_unit_count = 0
		recent_tracked_units = {}
		nearby_infantry_count = 0
		recent_tracked_infantry = {}
	end

end

-- If an ally enters the prox, the unit may want to chase them down to use the ability
function Divert_Prox(self_obj, trigger_obj)

	DebugMessage("%s -- In Prox", tostring(Script))

	if not trigger_obj then
		DebugMessage("Warning: prox received a nil trigger_obj .")
		return
	end

	-- Obiwan can heal only infantry and only cares about the wounded
	-- Note: we're explicitly tracking individual infantry here (as opposed to their parents, the squads)
	if trigger_obj.Is_Category("Infantry") and trigger_obj.Get_Hull() < max_health_considered then

		-- If we haven't seen this unit recently, track him
		if recent_tracked_infantry[trigger_obj] == nil then
			recent_tracked_infantry[trigger_obj] = trigger_obj
			nearby_infantry_count = nearby_infantry_count + 1
			DebugMessage("%s -- Nearby wounded infantry count %d", tostring(Script), nearby_infantry_count)
	
			if (nearby_infantry_count >= infantry_trigger_number) then
				ConsiderDivertAndAOE(Object, heal_ability_name, heal_area_of_effect, recent_tracked_infantry, min_threat_to_use_heal)
			end
		end

	end
	
	-- Obiwan can protect anything as long as the ability is ready.
	-- However, he only cares about something being attacked that has a minimum significance
	if self_obj.Is_Ability_Ready(invulnerability_ability_name) 
		and TestValid(FindDeadlyEnemy(trigger_obj))
		and ((trigger_obj.Get_Type().Get_Combat_Rating() > min_threat_to_use_invulnerability) or trigger_obj.Get_Type().Is_Hero()) then
			trigger_obj.Activate_Ability(invulnerability_ability_name, true)
	end
end

