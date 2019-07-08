-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/FreeStore/BusyTacticalFreeStore.lua#13 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/FreeStore/BusyTacticalFreeStore.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Steve_Copeland $
--
--            $Change: 35927 $
--
--          $DateTime: 2006/01/04 17:38:03 $
--
--          $Revision: #13 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgcommands")

function Base_Definitions()
	DebugMessage("%s -- In Base_Definitions", tostring(Script))

	Common_Base_Definitions()
	
	ServiceRate = 5

	if Definitions then
		Definitions()
	end
end

function main()

	DebugMessage("%s -- In main for %s", tostring(Script), tostring(FreeStore))
	
	if FreeStoreService then
		while 1 do
			FreeStoreService()
			PumpEvents()
		end
	end
	
	ScriptExit()
end

function On_Unit_Added(object)
	DebugMessage("%s -- Object: %s added to freestore", tostring(Script), tostring(object))
end


function FreeStoreService()
	DebugMessage("%s -- in FreeStoreService", tostring(Script))
	enemy_location = FindTarget.Reachable_Target(PlayerObject, "Current_Enemy_Location", "Tactical_Location", "Any_Threat", 0.5)
	friendly_location = FindTarget.Reachable_Target(PlayerObject, "Current_Friendly_Location", "Tactical_Location", "Any_Threat", 0.5)
end

function On_Unit_Service(object)
	DebugMessage("%s -- servicing object: %s", tostring(Script), tostring(object))
	
	if TestValid(object) and not object.Has_Active_Orders() and not object.Is_Category("Structure") 
						and not object.Is_Category("Transport") then
		DebugMessage("%s -- freestore anti-idle on object: %s", tostring(Script), tostring(object))
		
		-- Reset some abilities
		object.Activate_Ability("SPREAD_OUT", false)
		object.Activate_Ability("SPOILER_LOCK", false)
		Try_Ability(object, "ROCKET_ATTACK") -- Try to stay in rocket mode; switch to lasers when appropriate

		--If we're allowed to be offensive
		if EvaluatePerception("Allowed_As_Defender_Land", object.Get_Owner()) ~= 0 then

			-- Attack something
			closest_enemy = Find_Nearest(object, object.Get_Owner().Get_Enemy(), true)
			if TestValid(closest_enemy) then
				object.Attack_Move(closest_enemy)
			elseif TestValid(enemy_location) then
				object.Attack_Move(enemy_location)
			end	
			
		else
		
			-- Defend something
			closest_friendly_structure = Find_Nearest(object, "Structure", object.Get_Owner(), true)
			if TestValid(closest_friendly_structure) then
				object.Guard_Target(closest_friendly_structure)
			elseif TestValid(friendly_location) then
				object.Attack_Move(friendly_location)
			end
			
		end
	end
end
