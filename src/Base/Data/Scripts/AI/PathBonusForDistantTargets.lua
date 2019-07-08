-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/PathBonusForDistantTargets.lua#5 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/PathBonusForDistantTargets.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 22769 $
--
--          $DateTime: 2005/07/29 18:54:31 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

-- Tell the script pooling system to pre-cache this number of scripts.
ScriptPoolCount = 1

--
--
--

function Definitions()
	DebugMessage("%s -- In Definitions", tostring(Script))
	
	Category = "Distant_System_Path_Bonus"
	IgnoreTarget = true
	TaskForce = 
	{
	{
		"EmptyForce"
		, "TaskForceRequired"
	}
	}
	
	DebugMessage("%s -- Done Definitions", tostring(Script))
	
	planet_list = nil
	markup_table = {}
end

function EmptyForce_Thread()

	EmptyForce.Set_As_Goal_System_Removable(false)
	planet_list = FindPlanet.Get_All_Planets()
	
	while true do
		for i,planet in pairs(planet_list) do
		
			if TestValid(planet) then
				path_start = _FindStageArea(PlayerObject, planet, EmptyForce)
				if path_start then
					path = Find_Path(PlayerObject, path_start, planet)
					value = (EvaluatePerception("OffensiveValueCombined", PlayerObject, planet)
						+ EvaluatePerception("Is_Neglected_By_My_Opponent_Space", PlayerObject, planet)) / 2
					markup_table[planet] = Apply_Markup(PlayerObject, path, value, markup_table[planet])
				end
			else
				planet_list[i] = nil
			end
			Sleep(1)
		end
	end
end

