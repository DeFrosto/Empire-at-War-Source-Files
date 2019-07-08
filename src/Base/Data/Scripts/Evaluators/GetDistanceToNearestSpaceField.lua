-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Evaluators/GetDistanceToNearestSpaceField.lua#2 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Evaluators/GetDistanceToNearestSpaceField.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Brian_Hayes $
--
--            $Change: 25932 $
--
--          $DateTime: 2005/09/05 11:53:29 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGBaseDefinitions")

function Clean_Up()
	-- any temporary object pointers need to be set to nil in this function.
	-- ie: Target = nil
	nearest_obj = nil
end

-- Receives:
-- String which is a space field category mask for the space fields to consider
function Evaluate(space_fields)
	
	nearest_obj = Find_Nearest_Space_Field(Target, space_fields)
	if TestValid(nearest_obj) then
		return Target.Get_Distance(nearest_obj)
	else
		return BIG_FLOAT
	end
end





