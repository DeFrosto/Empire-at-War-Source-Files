-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/FreeStore/BusyTacticalFreeStore.lua#12 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/FreeStore/BusyTacticalFreeStore.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 55010 $
--
--          $DateTime: 2006/09/19 19:14:06 $
--
--          $Revision: #12 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgcommands")

function Base_Definitions()

	Common_Base_Definitions()
	
	ServiceRate = 20
	UnitServiceRate = 2

	if Definitions then
		Definitions()
	end
	
	FREE_STORE_ATTACK_RANGE = 600.0
end

function main()
	
	if FreeStoreService then
		while 1 do
			FreeStoreService()
			PumpEvents()
		end
	end
	
	ScriptExit()
end

function On_Unit_Added(object)
end


function FreeStoreService()
	enemy_location = FindTarget.Reachable_Target(PlayerObject, "Current_Enemy_Location", "Tactical_Location", "Any_Threat", 0.5)
	friendly_location = FindTarget.Reachable_Target(PlayerObject, "Current_Friendly_Location", "Tactical_Location", "Any_Threat", 0.5)
	aggressive_mode = (EvaluatePerception("Allowed_As_Defender_Land", PlayerObject) > 0.0)
	
	--Manage the space station in space mode
	if Get_Game_Mode() == "Space" then
		if TestValid(space_station) then
			station_threat = FindDeadlyEnemy(space_station)
			if station_threat then
				space_station.Attack_Target(station_threat)
			end
			
			--Maybe this station has a special weapon?
			special_target = FindTarget.Reachable_Target(PlayerObject, "Needs_Hypervelocity_Shot", "Enemy_Unit", "Any_Threat", 0.5, space_station, 1500.0)
			if TestValid(special_target) then
				space_station.Fire_Special_Weapon(special_target, PlayerObject)
			end
		else
			space_station = PlayerObject.Get_Space_Station()
		end
	end
end

function On_Unit_Service(object)
	
	if not TestValid(object) then
		return
	end
	
	if object.Is_Category("Structure") or object.Is_Category("Transport") then
		return
	end
	
	current_target = object.Get_Attack_Target()
	if TestValid(current_target) then

		if Service_Heal(object, 0.6) then
			return
		end
		
		if Service_Kite(object) then
			return
		end

		object.Activate_Ability("SPOILER_LOCK", false)

		Try_Weapon_Switch(object, current_target)
	end
	
	if not object.Has_Active_Orders() then
		
		--Keep bored objects mobile
		object.Activate_Ability("SPOILER_LOCK", true)		

		if Service_Kite(object) then
			return
		end		
		
		if Service_Heal(object, 1.0) then
			return
		end		
		
		-- Reset some abilities
		object.Activate_Ability("SPREAD_OUT", false)
		
		if Service_Garrison(object) then
			return
		end
		
		if Service_Attack(object) then
			return
		end
		
		Service_Guard(object)
		
	end
end

function Service_Heal(object, health_threshold)

	--Add difficulty factor here

	if object.Get_Hull() < health_threshold then
	
		-- Try to find the nearest healing structure appropriate for this unit
		lib_fs_healer_property_flag = Get_Special_Healer_Property_Flag(object)
		if not lib_fs_healer_property_flag then
			if object.Is_Category("Infantry") then
				lib_fs_healer_property_flag = "HealsInfantry"
			elseif object.Is_Category("Vehicle") then
				lib_fs_healer_property_flag = "HealsVehicles"
			end 
		end
		
		if lib_fs_healer_property_flag then
			healer = Find_Nearest(object, lib_fs_healer_property_flag, PlayerObject, true)
		end
	
		if TestValid(healer) then
		
			if object.Get_Distance(healer) > 100.0 then
				object.Activate_Ability("SPREAD_OUT", false)
				Try_Ability(object,"Turbo")
				Try_Ability(object,"JET_PACK", healer)
				Try_Ability(object,"SPRINT")
				Try_Ability(object, "SPOILER_LOCK")
				Try_Ability(object, "STEALTH")
				Try_Ability(object, "FORCE_CLOAK")
				
				object.Move_To(healer, 10)
				return true
			end
		end
	end

	return false
	
end

function Service_Garrison(object)
	
	if object.Has_Property("CanContainGarrison") then
		
		lib_garrison_table = object.Get_Garrisoned_Units()
		if table.getn(lib_garrison_table) > 0 then
		
			lib_garrison_needs_heals = true
			lib_garrison_healer = Find_Nearest(object, "HealsInfantry", object.Get_Owner(), true)
			lib_garrison_enemy = Find_Nearest(object, object.Get_Owner(), false)
			lib_eject_for_heal = TestValid(lib_garrison_healer) and (object.Get_Distance(lib_garrison_healer) < 150)
			lib_eject_for_attack = (not object.Has_Property("GarrisonCanFire")) and TestValid(lib_garrison_enemy) and (object.Get_Distance(lib_garrison_enemy) < FREE_STORE_ATTACK_RANGE)
			
			for i,garrison in pairs(lib_garrison_table) do
				if garrison.Get_Hull() > 0.4 then
					lib_garrison_needs_heals = false
					if lib_eject_for_attack and garrison.Is_Good_Against(lib_garrison_enemy) then
						garrison.Leave_Garrison()
					end
				elseif lib_eject_for_heal then
					garrison.Leave_Garrison()
				end
			end
			
			if lib_garrison_needs_heals and TestValid(lib_garrison_healer) then
				object.Move_To(lib_garrison_healer)
				return true
			end
			
		end
	end
	
	
	return false
end

function Service_Attack(object)

	--Move to the enemy position rather than the enemy itself in order to leave us free
	--to run autonomous targeting.  While this doesn't provide chase behavior we're probably
	--repeating this enough that we don't care
	closest_enemy = Find_Nearest(object, object.Get_Owner(), false)

	if TestValid(closest_enemy) and not closest_enemy.Is_Good_Against(object) then
		if object.Get_Distance(closest_enemy) < FREE_STORE_ATTACK_RANGE then
			object.Attack_Move(closest_enemy.Get_Position())
			return true		
		elseif aggressive_mode then
			if not Try_Garrison(nil, object, false, FREE_STORE_ATTACK_RANGE / 2.0) then
				object.Attack_Move(closest_enemy.Get_Position())
			end
			return true
		end
	elseif TestValid(enemy_location) then
		if aggressive_mode then
			object.Attack_Move(enemy_location)
			return true
		end
	end			
		
	return false
end

function Service_Guard(object)

	if Try_Deploy_Garrison(object, nil, 0.0) then
		return true
	end

	closest_friendly_structure = Find_Nearest(object, "Structure", object.Get_Owner(), true)
	if TestValid(closest_friendly_structure) then
		object.Guard_Target(closest_friendly_structure)
		return true
	elseif TestValid(friendly_location) then
		object.Attack_Move(friendly_location)
		return true
	end

	return false

end

function Service_Kite(object)
	
	lib_fs_deadly_enemy = FindDeadlyEnemy(object)
	
	if TestValid(lib_fs_deadly_enemy) then
		
		if lib_fs_deadly_enemy.Is_Good_Against(object) then
		
			if Try_Ability(object, "PROXIMITY_MINES", object) then
				return true
			end
			
			if Try_Ability(object, "BUZZ_DROIDS", object) then
				return true
			end		
		
			object.Activate_Ability("SPREAD_OUT", false)
			Try_Ability(object, "TURBO")
			Try_Ability(object, "SPRINT")
			Try_Ability(object, "SPOILER_LOCK")
			Try_Ability(object, "STEALTH")
			Try_Ability(object, "FORCE_CLOAK")
		
			if object.Get_Hull() > 0.5 then
				Try_Ability(object, "STIM_PACK")
			end		
		
			lib_fs_kite_pos = Project_By_Unit_Range(lib_fs_deadly_enemy, object)
			if Try_Ability(object, "JET_PACK", lib_fs_kite_pos) then
				return true
			end
	
			object.Move_To(lib_fs_kite_pos)
			
			return true
		end
		
	end

	return false
end