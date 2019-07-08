-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ObjectScript_Urai.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ObjectScript_Urai.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 50006 $
--
--          $DateTime: 2006/07/31 16:18:08 $
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
	Define_State("State_AI_Autofire", State_AI_Autofire)
	Define_State("State_Human_No_Autofire", State_Human_No_Autofire)
	Define_State("State_Human_Autofire", State_Human_Autofire)
	
	unit_trigger_number = 3
	divert_range = 300
	min_threat_to_use_stun = 50
	stun_area_of_effect = 75
	stun_ability_name = "STUN"
	
end

function State_Init(message)
	if message == OnEnter then

		-- prevent this from doing anything in galactic mode
		if Get_Game_Mode() ~= "Land" then
			ScriptExit()
		end

		nearby_stun_count = 0
		recent_stun_units = {}

		if Object.Get_Owner().Is_Human() then
			Register_Prox(Object, Urai_Stun_Prox, stun_area_of_effect)
			Set_Next_State("State_Human_No_Autofire")
		else
			Register_Prox(Object, Urai_Stun_Prox, divert_range)
			Set_Next_State("State_AI_Autofire")
		end
	end
end

function State_AI_Autofire(message)
	if message == OnUpdate then
		if (nearby_stun_count >= unit_trigger_number) then
			ConsiderDivertAndAOE(Object, stun_ability_name, stun_area_of_effect, recent_stun_units, Object.Get_Hull() * min_threat_to_use_stun)
		end
		
		-- reset tracked units each service.
		nearby_stun_count = 0
		recent_stun_units = {}
	end		
end

function State_Human_No_Autofire(message)
	if message == OnUpdate then
		if Object.Is_Ability_Autofire(stun_ability_name) then
			Set_Next_State("State_Human_Autofire")
		end
		
		-- reset tracked units each service.
		nearby_stun_count = 0
		recent_stun_units = {}
		
	end
end

function State_Human_Autofire(message)
	if message == OnUpdate then
	
		if Object.Is_Ability_Autofire(stun_ability_name) then
			if nearby_stun_count > 2 then
				Object.Activate_Ability(stun_ability_name, true)
			end
		else
			Set_Next_State("State_Human_No_Autofire")
		end
		
		-- reset tracked units each service.
		nearby_stun_count = 0
		recent_stun_units = {}
			
	end				
end

function Urai_Stun_Prox(self_obj, trigger_obj)

	if not trigger_obj.Is_Category("Infantry") then
		return
	end

	trigger_parent = trigger_obj.Get_Parent_Object()
	if TestValid(trigger_parent) then
		trigger_obj = trigger_parent
	end

	-- Reject heroes, which we can't affect
	if trigger_obj.Is_Category("LandHero") then
		return
	end
	
	if not trigger_obj.Get_Owner().Is_Enemy(Object.Get_Owner()) then
		return
	end

	if trigger_obj.Is_In_Garrison() then
		return
	end

	-- If we haven't seen this unit recently, track him
	if recent_stun_units[trigger_obj] == nil then
		recent_stun_units[trigger_obj] = trigger_obj
		nearby_stun_count = nearby_stun_count + 1
	end
end

function Evaluate_Attack_Ability(target, goal)
	return Get_Target_Weight(target, Attack_Ability_Types, Attack_Ability_Weights)
end

function Get_Escort_Ability_Weights(goal)
	return Escort_Ability_Types
end