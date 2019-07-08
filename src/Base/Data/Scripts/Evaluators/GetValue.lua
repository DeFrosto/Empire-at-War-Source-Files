-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Evaluators/GetValue.lua#3 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Evaluators/GetValue.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Brian_Hayes $
--
--            $Change: 25932 $
--
--          $DateTime: 2005/09/05 11:53:29 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGBaseDefinitions")

function Clean_Up()
	-- any temporary object pointers need to be set to nil in this function.
	-- ie: Target = nil
	lookup_string = nil
	ret_value = nil
end

function Evaluate(requested_value)
	lookup_string = PlayerSpecificName(PlayerObject, requested_value)
	DebugMessage("%s -- Accessing global script registry value %s.", tostring(Script), lookup_string)
	ret_value = GlobalValue.Get(PlayerSpecificName(PlayerObject, requested_value))
	
	-- handle the case where no value is found
	if not ret_value then
		DebugMessage("%s -- script registry lookup string %s not found.", tostring(Script), lookup_string)
		return 0.0
	end
	
	return ret_value
end



