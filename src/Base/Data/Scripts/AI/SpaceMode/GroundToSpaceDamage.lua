-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/SpaceMode/GroundToSpaceDamage.lua#9 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/SpaceMode/GroundToSpaceDamage.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Steve_Copeland $
--
--            $Change: 28979 $
--
--          $DateTime: 2005/10/12 10:11:12 $
--
--          $Revision: #9 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))

	Category = "Ground_To_Space_Damage"
	IgnoreTarget = true
	TaskForce = 
	{
		{
			"MainForce"
			,"DenySpecialWeaponAttach"
			,"DenyHeroAttach"
			,"Ground_Empire_Hypervelocity_Gun = 1"
		}
	}
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())

	-- Keep firing at the biggest (and probably slowest) enemy until it's dead
--	AITarget = FindTarget(MainForce, "Needs_Hypervelocity_Shot", "Enemy_Unit", 1.0)
--	DebugMessage("%s -- Found Target %s", tostring(Script), tostring(AITarget))

	-- Try to fire each variety this weapon might be
	MainForce.Fire_Special_Weapon("Ground_Empire_Hypervelocity_Gun", AITarget)

	-- Rely on the Weapon Online event to fire the gun subsequent times
	while TestValid(AITarget) do
		Sleep(5)
	end
	
	ScriptExit()
end

function MainForce_Special_Weapon_Online(tf, special_weapon)
	if TestValid(AITarget) then
		special_weapon.Fire_Special_Weapon(AITarget)
	else
		ScriptExit()
	end
end
