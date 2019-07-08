-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ObjectScript_NightSister.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/ObjectScript_NightSister.lua $
--
--    Original Author: James Yarrow
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


require("PGStateMachine")

function Definitions()

	ServiceRate = 1

	Define_State("State_Init", State_Init);

	drain_ability_name = "DRAIN_LIFE"
	unit_trigger_number = 4
	divert_range = 400
	min_threat_to_use_drain = 10
	drain_area_of_effect = 100

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

		nearby_unit_count = 0
		recent_enemy_units = {}

		-- Register a proximity around the unit at a range we're willing to divert for force confuse
		Register_Prox(Object, Divert_Prox, divert_range)
		
	elseif message == OnUpdate then

		if (nearby_unit_count >= unit_trigger_number) then
		
			ConsiderDivertAndAOE(Object, drain_ability_name, drain_area_of_effect, recent_enemy_units, min_threat_to_use_drain)
			
		end

		-- reset tracked units each service.
		nearby_unit_count = 0
		recent_enemy_units = {}
	end

end

-- If an ally enters the prox, the unit may want to chase them down to use the ability
function Divert_Prox(self_obj, trigger_obj)

	if not trigger_obj.Is_Category("Infantry") then
		return
	end
	
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
	if recent_enemy_units[trigger_obj] == nil then
		recent_enemy_units[trigger_obj] = trigger_obj
		nearby_unit_count = nearby_unit_count + 1
	end
	
end