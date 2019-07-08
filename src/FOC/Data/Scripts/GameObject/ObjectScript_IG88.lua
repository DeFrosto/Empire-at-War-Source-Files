-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ObjectScript_IG88.lua#5 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ObjectScript_IG88.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 50006 $
--
--          $DateTime: 2006/07/31 16:18:08 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

-- This include order is important.  We need the state service defined in main to override the one in heroplanattach.
require("HeroPlanAttach")
require("PGStateMachine")

function Definitions()


-- Hero plan self attachment stuff

	-- only join plans that meet our expense requirements.
	MinPlanAttachCost = 5000
	MaxPlanAttachCost = 0

	-- Commander hit list.
	Attack_Ability_Type_Names = {"Infantry", "Fighter", "Corvette" }
	Attack_Ability_Weights = { 1, 1, BAD_WEIGHT }
	Attack_Ability_Types = WeightedTypeList.Create()
	Attack_Ability_Types.Parse(Attack_Ability_Type_Names, Attack_Ability_Weights)

	-- Prefer task forces with these units.
	Escort_Ability_Type_Names = { "All" }
	Escort_Ability_Weights = { 1.0 }
	Escort_Ability_Types = WeightedTypeList.Create()
	Escort_Ability_Types.Parse(Escort_Ability_Type_Names, Escort_Ability_Weights)


-- Object script stuff

	ServiceRate = 1

	Define_State("State_Init", State_Init)

	unit_trigger_number = 3
	
	contaminate_range = 150
	min_threat_to_use_contaminate = 150
	contaminate_area_of_effect = 75
	contaminate_ability_name = "RADIOACTIVE_CONTAMINATE"
	
end

function State_Init(message)
	if message == OnEnter then

		-- Bail out if this is a human player
		if Object.Get_Owner().Is_Human() then
			ScriptExit()
		end

		-- prevent this from doing anything in galactic mode
		if Get_Game_Mode() ~= "Land" then
			ScriptExit()
		end

		nearby_contaminate_count = 0
		recent_contaminate_units = {}

		Register_Prox(Object, IG88_Contaminate_Prox, contaminate_range)
		
	elseif message == OnUpdate then

		if nearby_contaminate_count >= unit_trigger_number then
			target, threat = Find_Best_Local_Threat_Center(recent_contaminate_units, contaminate_area_of_effect)
			if threat and threat >= min_threat_to_use_contaminate then
				Try_Ability(Object, contaminate_ability_name, target)
			end
		end
		
		nearby_contaminate_count = 0
		recent_contaminate_units = {}
		
	end

end


function IG88_Contaminate_Prox(self_obj, trigger_obj)

	if not trigger_obj.Get_Owner().Is_Enemy(Object.Get_Owner()) then
		return
	end	
	
	if trigger_obj.Is_Category("Infantry") then
		trigger_parent = trigger_obj.Get_Parent_Object()
		if TestValid(trigger_parent) then
			trigger_obj = trigger_parent
		end
	elseif (not trigger_obj.Is_Category("Vehicle")) or (trigger_obj.Get_Hull() > 0.25) then
		return
	end
	
	if trigger_obj.Is_In_Garrison() then
		return
	end	
	
	-- If we haven't seen this unit recently, track him
	if recent_contaminate_units[trigger_obj] == nil then
		recent_contaminate_units[trigger_obj] = trigger_obj
		nearby_contaminate_count = nearby_contaminate_count + 1
	end	
end


function Evaluate_Attack_Ability(target, goal)
	return Get_Target_Weight(target, Attack_Ability_Types, Attack_Ability_Weights)
end

function Get_Escort_Ability_Weights(goal)
	return Escort_Ability_Types
end