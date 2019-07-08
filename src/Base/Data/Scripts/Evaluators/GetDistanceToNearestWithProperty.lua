-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Evaluators/GetDistanceToNearestWithProperty.lua#3 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Evaluators/GetDistanceToNearestWithProperty.lua $
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
	nearest_obj = nil
end

-- Receives:
-- property_flag_name as defined in GameObjectPropertiesType.xml
-- affiliation_type is optional qualifier of "enemy" or "friendly"
function Evaluate(property_flag_name, affiliation_type)
	
	if affiliation_type == "ENEMY" then
		nearest_obj = Find_Nearest(Target, property_flag_name, PlayerObject, false)
	elseif affiliation_type == "FRIENDLY" then
		nearest_obj = Find_Nearest(Target, property_flag_name, PlayerObject, true)
	else
		nearest_obj = Find_Nearest(Target, property_flag_name)
	end

	if TestValid(nearest_obj) then
		return Target.Get_Distance(nearest_obj)
	else
		return BIG_FLOAT
	end
end




