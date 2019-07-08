-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/BurnUnitsLand.lua#9 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/BurnUnitsLand.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Steve_Tall $
--
--            $Change: 37744 $
--
--          $DateTime: 2006/02/13 23:00:00 $
--
--          $Revision: #9 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()
	
	AllowEngagedUnits = true
	IgnoreTarget = true
	Category = "Burn_Units_Land"
	TaskForce = {
	{
		"MainForce"
		, "TaskForceRequired"
		, "DenySpecialWeaponAttach"
	}
	}

end

function MainForce_Thread()

	MainForce.Set_As_Goal_System_Removable(false)

	-- Cheat to wrap the game up if this is a firesale
	if (EvaluatePerception("Should_Firesale_Land", PlayerObject) > 0) then
		--MessageBox("%s-- performing fog of war lift, to facilitate firesale", tostring(Script))
		reveal_ai = FogOfWar.Reveal_All(PlayerObject)
		
		-- We're now also revealing FOW here for the human player (was previously handled by a hard-coded system)
		-- Make sure that there isn't a scripted scenario underway that doesn't want automatic FOW reveals
		-- MessageBox("checking FOW reveal allowed- registry value:%f, skirmish perception:%f", GlobalValue.Get("Allow_AI_Controlled_Fog_Reveal"), EvaluatePerception("Is_Skirmish_Mode", PlayerObject))
		if Is_Multiplayer_Mode() == false and ((EvaluatePerception("Is_Skirmish_Mode", PlayerObject) == 1) or
						(GlobalValue.Get("Allow_AI_Controlled_Fog_Reveal") == 1)) then
			MessageBox("%s-- performing fog of war lift for the human player", tostring(Script))
			reveal_human = FogOfWar.Reveal_All(Find_Player("local"))
		end
	end

	-- Do this at least once (it may just be an attempt to burn off extra units, rather than a firesale)
	repeat
		-- Cancel all goals
		Purge_Goals(PlayerObject)
		
		-- Use all idle units, mapwide
		MainForce.Collect_All_Free_Units()
	
		-- form up any spread out infantry
		MainForce.Activate_Ability("SPREAD_OUT", false)
	
		Try_Ability(MainForce, "ROCKET_ATTACK")
	
	
		-- Have each unit attack its nearest enemy structure until success or death
		for i, unit in pairs (MainForce.Get_Unit_Table()) do
			nearest_enemy = Find_Nearest(unit, "Structure", PlayerObject.Get_Enemy(), true)
			if not TestValid(nearest_enemy) then
				nearest_enemy = Find_Nearest(unit, PlayerObject.Get_Enemy(), true)
			end
			if TestValid(nearest_enemy) then
				unit.Attack_Target(nearest_enemy)
				unit.Lock_Current_Orders()
				MainForce.Release_Unit(unit)
			end
		end
	
		-- Only let this happen every so often
		Sleep(30) 
		MainForce.Set_Plan_Result(true)

	-- If this is a firesale condition, continue to burn off units
	-- This must be done within the same plan because we don't want to destroy the
	-- reveal objects turning FOW back on (which would result in the FOW being toggled repeatedly).
	until (EvaluatePerception("Should_Firesale_Land", PlayerObject) == 0)

--	if TestValid(target) then
--		DebugMessage("%s-- attacking target:%s", tostring(Script), tostring(target))
--		BlockOnCommand(MainForce.Attack_Target(target))
--		MainForce.Set_Plan_Result(true)
--	end
	
end

-- Override default event to prevent plan from ending under firesale conditions
-- We want the fog of war reveal for the player to persist.
function MainForce_No_Units_Remaining()
    DebugMessage("%s -- All units dead or non-buildable.", tostring(Script))
	if (EvaluatePerception("Should_Firesale_Space", PlayerObject) == 0) then
		DebugMessage("%s -- abandonning plan due to empty task force.", tostring(Script))
		ScriptExit()
	end
end