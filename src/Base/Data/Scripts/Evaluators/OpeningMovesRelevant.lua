-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Evaluators/OpeningMovesRelevant.lua#6 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Evaluators/OpeningMovesRelevant.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Brian_Hayes $
--
--            $Change: 25932 $
--
--          $DateTime: 2005/09/05 11:53:29 $
--
--          $Revision: #6 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGBaseDefinitions")

function Clean_Up()
	-- any temporary object pointers need to be set to nil in this function.
	-- ie: Target = nil
end

function Evaluate()
	-- DebugMessage("%s -- Evaluating.", tostring(Script))

	-- This can't be done by an XML perception because it's a global perception that 
	-- needs to examine targets in a generic/portable way.

	-- Using the Reachable_Target function not because we care about reachability, but
	-- because it's a FindTarget variant that doesn't require a task force parameter (which we don't have).

	-- If there is not an enemy presence on one of the opening moves planets
        if not FindTarget.Reachable_Target(PlayerObject, "Opponent_Present_On_Rush_System", "Friendly | Enemy | Neutral", "Any_Threat", 1.0) then
		-- DebugMessage("%s -- No enemy presence at a rush system.", tostring(Script))

		-- And if there is at least one rush system which we don't own
		if FindTarget.Reachable_Target(PlayerObject, "Unowned_Rush_System", "Enemy | Neutral", "Any_Threat", 1.0) then
			DebugMessage("%s -- At least one rush system unowned by us.", tostring(Script))
			GlobalValue.Set(PlayerSpecificName(PlayerObject, "OPENING_MOVES_UNDERWAY"), 1.0)
			return 1.0
		end
	end

	GlobalValue.Set(PlayerSpecificName(PlayerObject, "OPENING_MOVES_UNDERWAY"), 0.0)
	return 0.0
end

