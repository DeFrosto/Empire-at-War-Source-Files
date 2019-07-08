-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/SpaceMode/BurnUnits.lua#10 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/SpaceMode/BurnUnits.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Steve_Tall $
--
--            $Change: 37744 $
--
--          $DateTime: 2006/02/13 23:00:00 $
--
--          $Revision: #10 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()
	
	AllowEngagedUnits = true
	IgnoreTarget = true
	Category = "Burn_Units_Space"
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
	if (EvaluatePerception("Should_Firesale_Space", PlayerObject) > 0) then
		reveal_ai = FogOfWar.Reveal_All(PlayerObject)
		
		-- We're now also revealing FOW here for the human player (was previously handled by a hard-coded system)
		-- Make sure that there isn't a scripted scenario underway that doesn't want automatic FOW reveals
		--MessageBox("checking FOW reveal allowed- registry value:%f, skirmish perception:%f", GlobalValue.Get("Allow_AI_Controlled_Fog_Reveal"), EvaluatePerception("Is_Skirmish_Mode", PlayerObject))
		if Is_Multiplayer_Mode() == false and ((EvaluatePerception("Is_Skirmish_Mode", PlayerObject) == 1) or
						(GlobalValue.Get("Allow_AI_Controlled_Fog_Reveal") == 1)) then
			MessageBox("%s-- performing fog of war lift for the human player", tostring(Script))
			reveal_human = FogOfWar.Reveal_All(Find_Player("local"))
		end
	end

	-- Do this at least once (it may just be an attempt to burn off extra units, rather than a firesale)
	repeat
		target = Find_Nearest(MainForce, "Structure | Capital", PlayerObject, false)
		if target == nil then
			target = Find_Nearest(MainForce, PlayerObject, false)
		end	
	
		while TestValid(target) do
			DebugMessage("%s-- collecting all free units and attacking target:%s", tostring(Script), tostring(target))
			MainForce.Collect_All_Free_Units()
			BlockOnCommand(MainForce.Attack_Move(target), 20)
		end
	
	-- If this is a firesale condition, continue to burn off units
	-- This must be done within the same plan because we don't want to destroy the
	-- reveal objects turning FOW back on (which would result in the FOW being toggled repeatedly).
	until (EvaluatePerception("Should_Firesale_Space", PlayerObject) == 0)

	MainForce.Set_Plan_Result(true)
	
	Sleep(30)
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