-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/Slave_I.lua#6 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/Slave_I.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Steve_Copeland $
--
--            $Change: 30304 $
--
--          $DateTime: 2005/10/27 13:21:25 $
--
--          $Revision: #6 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")


function Definitions()

	--MessageBox("%s -- slave_I definitions", tostring(Script))




	Define_State("State_Init", State_Init);

	nearby_unit_count = 0
	unit_trigger_number = 2
	
	recent_enemy_units = {}
end

function State_Init(message)
	if message == OnEnter then
		--MessageBox("%s--Object:%s", tostring(Script), tostring(Object))

		-- Bail out if this is a human player
		if Object.Get_Owner().Is_Human() then
			ScriptExit()
		end

		-- Register a proximity around Fett's ship at his weapon range
		rebel_player = Find_Player("REBEL")
		Register_Prox(Object, Fett_Prox, 200, rebel_player)
	elseif message == OnUpdate then

		-- Track the number of fighters within the prox, resetting each service.
		nearby_unit_count = 0
		recent_enemy_units = {}
	end

end


function Fett_Prox(self_obj, trigger_obj)
	
	-- prevent this from doing anything in galactic mode
	--MessageBox("%s, mode %s", tostring(Script), Get_Game_Mode())
	if Get_Game_Mode() ~= "Space" then
		return
	end

	if not trigger_obj then
		DebugMessage("Warning: prox received a nil trigger_obj .")
		return
	end

	-- Don't track sub-squadron individuals
	no_fighters_present = true
	if trigger_obj.Is_Category("Fighter") or trigger_obj.Is_Category("Bomber") then
		trigger_obj = trigger_obj.Get_Parent_Object()
		no_fighters_present = false
	end


	if not trigger_obj then
		DebugMessage("Warning: apparently fighter or bomber had no parent.  Individually placed sub squadron objects are not allowed.")
		return
	end

	-- If we haven't seen this guy recently, track him
	if recent_enemy_units[trigger_obj] == nil then
		recent_enemy_units[trigger_obj] = 1
		nearby_unit_count = nearby_unit_count + 1
    
--		DebugMessage("%s-- nearby_unit_count %d", tostring(Script), nearby_unit_count)
--		for unit, i in pairs(recent_enemy_units) do
--			DebugMessage("%d unit: %s  owner: %s", i, tostring(unit), unit.Get_Owner().Get_Faction_Name())
--		end
	
		-- If there is a non_fighter/bomber in range or are over X fighters or bombers in range 
		--UNUSED
		--or this guy is tougher than fett, drop the charge. (Object.Get_AI_Power_Vs_Unit(trigger_obj) > 0))
		if Object.Is_Ability_Ready("HARMONIC_BOMB") and 
			no_fighters_present or (nearby_unit_count >= unit_trigger_number) then
			Try_Ability(Object, "HARMONIC_BOMB")
			recent_enemy_units = {}
		end
	end
end

