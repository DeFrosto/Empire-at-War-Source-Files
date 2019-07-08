-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ObjectScript_Yoda.lua#2 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ObjectScript_Yoda.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 47639 $
--
--          $DateTime: 2006/06/30 09:59:28 $
--
--          $Revision: #2 $
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
	Attack_Ability_Type_Names = {"Infantry" }
	Attack_Ability_Weights = { 1 }
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
	
	safe_for_ability = false
	
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

		Register_Prox(Object, Yoda_Safe_Prox, 500)
		
	elseif message == OnUpdate then

		if not Object.Has_Active_Orders() then
			if safe_for_ability then
				Object.Activate_Ability("FORCE_SIGHT", true)
			elseif Object.Is_Ability_Active("FORCE_SIGHT") then
				Object.Activate_Ability("FORCE_SIGHT", false)
			end
		end
		
		safe_for_ability = true
		
	end

end

function Yoda_Safe_Prox(self_obj, trigger_obj)

	trigger_player = trigger_obj.Get_Owner()
	if not TestValid(trigger_player) or trigger_player == Object.Get_Owner() or trigger_player.Is_Neutral() then
		return
	end	
	
	safe_for_ability = false
	
end