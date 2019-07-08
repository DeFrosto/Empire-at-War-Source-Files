-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Library/PGEvents.lua#52 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Library/PGEvents.lua $
--
--    Original Author: Brian Hayes
--
--            $Author: Steve_Copeland $
--
--            $Change: 35187 $
--
--          $DateTime: 2005/12/14 14:59:10 $
--
--          $Revision: #52 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

--
-- Default Event Handlers.
--

require("PGTaskForce")

function GoHeal(tf, unit, healer, release)
	DebugMessage("%s -- Moving %s to healer %s.", tostring(Script), tostring(unit), tostring(healer))
	if release then
		unit.Move_To(healer)
		unit.Lock_Current_Orders()
		tf.Release_Unit(unit)
	else
		unit.Divert(healer)
	end
end

function GoKite(tf, unit, kite_pos, release)
	DebugMessage("%s -- Moving %s to pos %s", tostring(Script), tostring(unit), tostring(kite_pos))
	if release then
		Try_Ability(unit,"Turbo") -- Enable Turbo mode, if we have it.
		Try_Ability(unit,"JET_PACK", kite_pos)
		Try_Ability(unit,"EJECT_VEHICLE_THIEF")
		Try_Ability(unit,"SPRINT")
		Try_Ability(unit, "SPOILER_LOCK")
		Try_Ability(unit, "REPLENISH_WINGMEN")

		unit.Move_To(kite_pos)
		unit.Lock_Current_Orders()
		tf.Release_Unit(unit)
	else
		if not unit.Is_On_Diversion() then
			--MessageBox("%s -- Diverting: %s", tostring(Script), tostring(unit))
			Try_Ability(unit,"Turbo") -- Enable Turbo mode, if we have it.
			Try_Ability(unit,"JET_PACK", kite_pos)
			Try_Ability(unit,"EJECT_VEHICLE_THIEF")
			Try_Ability(unit,"SPRINT")
			Try_Ability(unit, "SPOILER_LOCK")
			Try_Ability(unit, "REPLENISH_WINGMEN")

			unit.Divert(kite_pos)
		end
	end
end

function Try_Good_Ground(tf, unit)
	DebugMessage("%s-- looking for good ground", tostring(Script))
	nearest_good_ground_indicator = Find_Nearest(unit, "Prop_Good_Ground_Area")
	if nearest_good_ground_indicator then
		dist_to_good_ground = unit.Get_Distance(nearest_good_ground_indicator)
		DebugMessage("%s-- found good ground, dist:%d", tostring(Script), dist_to_good_ground)
		if (dist_to_good_ground < 300) and (dist_to_good_ground > 20) then

			DebugMessage("%s-- moving to good ground!", tostring(Script))
			unit.Activate_Ability("SPREAD_OUT", false)
			unit.Move_To(nearest_good_ground_indicator)
			unit.Lock_Current_Orders()
			tf.Release_Unit(unit)
		end
	end
end

-- This should be useful for getting units within the minimum attack range
-- or outside the maximum attack range on opponents who behave like artillery
function Respond_To_MinRange_Attacks(tf, unit)

	DebugMessage("%s-- looking at attacker for minrange response", tostring(Script))

	min_range_attackers = {
		"R_Ground_Turbolaser_Tower"
		,"E_Ground_Turbolaser_Tower"
		,"MPTL"
		,"SPMAT_Walker"
		,"Marauder_Missile_Cruiser"
		,"Broadside_Class_Cruiser"
		}

	deadly_enemy = FindDeadlyEnemy(unit)
	if TestValid(deadly_enemy) then
		deadly_enemy_type = deadly_enemy.Get_Type()
		if Is_Type_In_List(deadly_enemy_type, min_range_attackers) then
			DebugMessage("%s -- attacked by min range attacker", tostring(Script))
			
			-- Move any units in the task force which are in range of the attacker 
			-- to a position over the max range or under the min range
			approach_or_flee_range = ((deadly_enemy_type.Get_Max_Range() - deadly_enemy_type.Get_Min_Range()) * 2 / 3) + deadly_enemy_type.Get_Min_Range()
			for i, tf_unit in pairs(tf.Get_Unit_Table()) do
				DebugMessage("%s -- considering run or approach for %s", tostring(Script), tostring(tf_unit))
				distance = tf_unit.Get_Distance(deadly_enemy)
				if distance < deadly_enemy_type.Get_Max_Range() then
					if distance < approach_or_flee_range then
						DebugMessage("%s -- trying to run inside min attack range", tostring(Script))
						tf_unit.Move_To(deadly_enemy)
						tf_unit.Lock_Current_Orders()
						tf.Release_Unit(unit)
					else
						DebugMessage("%s -- trying to run outside max attack range", tostring(Script))
						GoKite(tf, tf_unit, Project_By_Unit_Range(deadly_enemy, tf_unit))
					end
				end
			end
		end
	end
end


function Is_Type_In_List(unit_type, type_name_list)
	for i, type_name in pairs(type_name_list) do
		DebugMessage("%s -- type:%s checking match to:%s", tostring(Script), unit_type.Get_Name(), type_name)
		if unit_type == Find_Object_Type(type_name) then
			return true
		end
	end
	return false
end

-- Check if the passed ability is one of the type that the AI wants to turn back on when cancelled
function IsAbilityAllowedToRecover(ability)
	allowed_abilities = {
		"SPOILER_LOCK"
		,"Turbo"
	}
	
	for i, allowed_ability in pairs(allowed_abilities) do
		if ability == allowed_ability then
			return true
		end
	end
	
	return false
end

function Default_Space_Conflict_Begin()
	DebugMessage("%s -- In Default_Space_Conflict_Begin.", tostring(Script))
	InSpaceConflict = true
	GlobalValue.Set(PlayerSpecificName(PlayerObject, "CONTACT_OCCURED"), 0.0)
end

function Default_Space_Conflict_End()
	DebugMessage("%s -- In Default_Space_Conflict_End.", tostring(Script))
	InSpaceConflict = false
	GlobalValue.Set(PlayerSpecificName(PlayerObject, "CONTACT_OCCURED"), 0.0)
end

function Default_Unit_Destroyed()
	DebugMessage("%s -- In Default_Unit_Destroyed.", tostring(Script))
end

function Default_Unit_Damaged(tf, unit, attacker, deliberate)
	DebugMessage("%s -- In Default_Unit_Damaged.", tostring(Script))
	
	if not TestValid(unit) or not TestValid(attacker) or attacker.Is_Category("Structure") then
		return
	end

	--MessageBox("difficulty: %s", PlayerObject.Get_Difficulty())
	
	-- all units but Interdictors try to maneuver against artillery and turbolasers
	-- Interdictors should use missile shield instead
    if unit.Get_Type() ~= Find_Object_Type("Interdictor_Cruiser") then
		Respond_To_MinRange_Attacks(tf, unit)
	end
	
	-- If the unit is infantry, try to use any nearby "good ground"
	if unit.Is_Category("Infantry") then
		Try_Good_Ground(tf, unit)
	end

	-- Only Hard AI uses unit self-preservation
	if PlayerObject.Get_Difficulty() ~= "Hard" then
		DebugMessage("%s-- not hard mode, so bailing on unit damaged handling", tostring(Script))
		return
	end


	-- Use "Power to Shields" if this unit has it and it's ready
	lib_shield_level = unit.Get_Shield()
	if lib_shield_level < 0.2 then
		Try_Ability(unit, "INVULNERABILITY")
	elseif lib_shield_level < 0.8 then
		Try_Ability(unit, "Defend")
	end

	-- Hero preservation behavior: they should run if threatened and have a chance to flee
	-- Trying out default handling instead for heroes for now
	--if (unit.Contains_Hero() or unit.Get_Type().Is_Hero()) then
	if nil then
		time_before_death = unit.Get_Time_Till_Dead()
		DebugMessage("%s -- Hero %s has been shot; anticipating death in %.3f.", tostring(Script), tostring(unit), time_before_death)
		if time_before_death < 90 then
			DebugMessage("%s -- Hero %s is at risk of death, trying to hide.", tostring(Script), tostring(unit))
			if TestValid(unit) then
				hide_target = FindTarget(tf, "Space_Area_Is_Hidden", "Tactical_Location", 1.0, 5000.0)

				-- Move to a safe location
				Try_Ability(unit,"Turbo")
				Try_Ability(unit,"JET_PACK", hide_target)
				Try_Ability(unit,"EJECT_VEHICLE_THIEF")
				Try_Ability(unit,"SPRINT")
				unit.Move_To(hide_target)
				tf.Release_Unit(unit)
			end
		end

	-- non-hero fighters will always willingly dogfight other fighters
	elseif deliberate and attacker.Is_Category("Fighter") and unit.Is_Category("Fighter") then

		DebugMessage("%s -- Fighter shot by fighter, releasing unit from tf and attacking.", tostring(Script))
		tf.Release_Unit(unit)
		unit.Attack_Target(attacker)
		unit.Activate_Ability("SPOILER_LOCK", false)
		
	-- Default handling for a dying unit in both space and land modes.
	-- Is this unit not fodder AND do we have low health AND (we have a bad face off OR we're rapidly being killed for any reason)
	elseif 	 (unit.Get_Hull() < 0.5) and ((unit.Get_AI_Power_Vs_Unit(attacker) > 0) or (unit.Get_Time_Till_Dead() < 25)) then

		-- Turn off any abilities that would hinder self-preservation
		unit.Activate_Ability("Power_To_Weapons", false)

		-- Try to find the nearest healing structure appropriate for this unit
		if unit.Is_Category("Infantry") then
			DebugMessage("%s -- Finding Infantry healer for %s.", tostring(Script), tostring(unit))
			healer = Find_Nearest(unit, "HealsInfantry", PlayerObject, true)
		elseif unit.Is_Category("Vehicle") then
			DebugMessage("%s -- Finding Vehicle healer for %s.", tostring(Script), tostring(unit))
			healer = Find_Nearest(unit, "HealsVehicles", PlayerObject, true)
		end 
		
		-- Try to find a protected kiting location
		friendly = Find_Nearest(unit, PlayerObject, true) -- TODO Not working?
		xfire_pos = Get_Most_Defended_Position(unit, PlayerObject)
		if xfire_pos then
			kite_pos = Project_By_Unit_Range(attacker, xfire_pos)
		else
			DebugMessage("Failed to find a Most Defended Position, using position of nearby friendly.")
			kite_pos = Project_By_Unit_Range(attacker, friendly)
		end
		
		kite_pos_dist = unit.Get_Distance(kite_pos)
		--DebugMessage("%s -- For %s, kite_pos_dist is %.3f", tostring(Script), tostring(unit), kite_pos_dist)

		-- Try to heal if we have a healer; it's only appropraite if it's closer than the kite position
		-- and it doesn't look like we'll need to move toward the attacker to reach our lure destination.
		if healer then
			healer_dist = unit.Get_Distance(healer)
			if (healer_dist < kite_pos_dist) and (healer_dist < attacker.Get_Distance(healer)) then
				DebugMessage("%s -- Defensive Reaction: Attempting to heal %s.", tostring(Script), tostring(unit))
				GoHeal(tf, unit, healer, unit.Get_Type().Is_Hero())
				return
			end
		end

		if (not unit.Has_Property("Fodder")) then
		
			-- Try to kite the attacker if there are some friendlies nearby 
			-- and it doesn't look like we'll need to move toward the attacker to reach our lure destination.
			-- TODO: try this when fixed (EvaluatePerception("FriendlyForceNearUnit", PlayerObject, unit) > 0)
			if friendly and (unit.Get_Distance(friendly) < 1800) and (kite_pos_dist < attacker.Get_Distance(kite_pos)) then
				DebugMessage("%s -- Defensive Reaction: Attempting to kite with %s.", tostring(Script), tostring(unit))
				GoKite(tf, unit, kite_pos, unit.Get_Type().Is_Hero())
	
			-- Nothing good was found to do, so just run.
			else
				DebugMessage("%s -- Defensive Reaction: %s running away from %s.", tostring(Script), tostring(unit), tostring(attacker))
				GoKite(tf, unit, Project_By_Unit_Range(attacker, unit), unit.Get_Type().Is_Hero())
			end
		end

	end
end

function Default_Original_Target_Destroyed()
	--DebugMessage("%s -- Original target destroyed.  Aborting.", tostring(Script))
	Attacking = false
	--ScriptExit() Some plans now have behaviors to occur after this event.
end

function Default_Current_Target_Destroyed(tf)
	--MessageBox("%s -- Current target destroyed.  Aborting.", tostring(Script))
	Attacking = false
	
	-- Turn off some unending abilities that might no longer be appropriate
	tf.Activate_Ability("SPREAD_OUT", false)

	--ScriptExit() Some plans now have behaviors to occur after this event.
end

function Default_Original_Target_Owner_Changed(tf, old_player, new_player)
	if InvasionActive == true then
		return
	end
	
	DebugMessage("%s -- Original target ownership changed.  Aborting.", tostring(Script))
	ScriptExit()
end


function Should_Crush(unit, target)

	-- don't crush in easy mode
	if (PlayerObject.Get_Difficulty() == "Easy") then
		return false
	end
	
	-- don't try to crush again if already on a diversion
	if unit.Is_On_Diversion() then
		return false
	end
		
	-- if the vehicle is good at it, the victim is infantry, and vulnerable to crushing
	if	unit.Has_Property("GoodInfantryCrusher") and target.Is_Category("Infantry") and target.Is_Ability_Active("SPREAD_OUT") then
		return true
	end
		
	-- if the vehicle can crush anything and is close enough			
	if unit.Has_Property("IsSupercrusher") and (unit.Get_Distance(target) < 75) then
		return true
	end
	
	return false
end


function Default_Target_In_Range(tf, unit, target)
	--MessageBox("%s -- unit:  Default_Target_In_Range for: %s.", tostring(Script), tostring(unit), tostring(target))

	-- We'll assume that once the first unit within a task force is in range, the attack has begun.
	Attacking = true

	-- Certain units like to try to crush other units, but we can't crush Rebel units that are spread out
	if Should_Crush(unit, target) then
		DebugMessage("%s -- Attempting to crush %s with %s", tostring(Script), tostring(target), tostring(unit))
		unit.Divert(Project_By_Unit_Range(unit, target))
	end
    
	-- Turn various abilities that would be useful.  
	-- The ability time-out or the plan ending will turn off the ability.
	Try_Ability(unit,"Power_To_Weapons")
	Try_Ability(unit,"SPREAD_OUT")
	Try_Ability(unit,"DEPLOY_TROOPERS")
	Try_Ability(unit, "BARRAGE", target)
	
	-- T4bs like to generally be in rocket mode because it has better range... 
	-- If we find ourselves shooting at a non-structure, switch it off so we can do more damage
	unit.Activate_Ability("ROCKET_ATTACK", target.Is_Category("Structure"))

	-- Use barrage (ATST and missile boats) if the ability is ready and there are other enemies near the target.
--	if unit.Has_Ability("BARRAGE") and unit.Is_Ability_Ready("BARRAGE") then
--		MessageBox("%s -- unit has barrage ready and is in range", tostring(Script))
--		enemy_nearest_target = Find_Nearest(target, PlayerObject, false)
--		MessageBox("%s -- unit ready to barrage %s near %s(%d)", tostring(Script), tostring(target), tostring(enemy_nearest_target), target.Get_Distance(enemy_nearest_target))
--		if TestValid(enemy_nearest_target) and (target.Get_Distance(enemy_nearest_target) < 100) then
--			unit.Activate_Ability("BARRAGE", target)
--		end
--	end

	GlobalValue.Set(PlayerSpecificName(PlayerObject, "CONTACT_OCCURED"), 1.0)
end

function Default_Hardpoint_Target_In_Range(tf, unit, target)
	DebugMessage("%s -- A hardpoint of %s can now fire on target %s.", tostring(Script), tostring(unit), tostring(attacker))
end

function Default_No_Units_Remaining()
	DebugMessage("%s -- All units dead or non-buildable.  Abandonning plan.", tostring(Script))
	ScriptExit()
end

function Default_Unit_Diversion_Finished(tf, unit)

	-- Turn off turbo, if we happened to be using it to assist in a divert (evasive maneuver).
	unit.Activate_Ability("Turbo", false)	
	unit.Activate_Ability("SPOILER_LOCK", false)
end

-- This fires if the countdown was going and it is now refreshed or if you come out of a nebula
function Default_Unit_Ability_Ready(tf, unit, ability)

	--MessageBox("%s ready for %s", ability, tostring(unit))
	
	-- Try to recover use of interrupted abilities.
	if lib_cancelled_abilities[unit] and lib_cancelled_abilities[unit][ability] then
		--MessageBox("%s-- attempting to recover use of %s", tostring(Script), ability)
		unit.Activate_Ability(ability, true)
		lib_cancelled_abilities[unit][ability] = false
	end
end

-- An ability was interrupted before naturally finishing.
function Default_Unit_Ability_Cancelled(tf, unit, ability)
	DebugMessage("%s -- Ability %s of %s has been cancelled!", tostring(Script), ability, tostring(unit))

	-- Track certain abilities that get cancelled, so we can recover them later
	if IsAbilityAllowedToRecover(ability) then
	
		-- make a new ability table for this unit, if one doesn't yet exist
		if not lib_cancelled_abilities[unit] then
			lib_cancelled_abilities[unit] = {}
		end
		
		lib_cancelled_abilities[unit][ability] = true
	end
end

-- An ability finished naturally by its duration running out or by being turned off.
function Default_Unit_Ability_Finished(tf, unit)
	--DebugMessage("%s -- An ability for %s has finished!", tostring(Script), ability, tostring(unit))
end
