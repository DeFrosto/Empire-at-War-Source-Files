-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Evaluators/EvaluateInGalacticContext.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Evaluators/EvaluateInGalacticContext.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Andre_Arsenault $
--
--            $Change: 37816 $
--
--          $DateTime: 2006/02/15 15:33:33 $
--
--          $Revision: #1 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGBaseDefinitions")

-- Evaluate galactic perceptions from a tactical context.
-- Note that galactic perceptions won't update while in tactical mode.
-- XML usage example: Script_EvaluateInGalacticContext.Evaluate{Parameter_Script_String = "GenericPlanetValue"}

function Clean_Up()
	-- any temporary object pointers need to be set to nil in this function.
	-- ie: Target = nil
	ret_value = nil
end

function Evaluate(perception_name)

	-- Galactic perceptions have no context in skirmish mode
	if EvaluatePerception("Is_Skirmish_Mode", PlayerObject) == 0 then
		ret_value = Evaluate_In_Galactic_Context(perception_name, PlayerObject)
	else
		ret_value = nil
	end
	
	-- handle the case where no value is found
	if not ret_value then
		DebugMessage("%s -- Error, unable to evaluate perception %s.", tostring(Script), perception_name)
		ret_value = 0.0
	end
	
	--DebugMessage("%s -- Evaluated in galactic context: %s: %.3f.", tostring(Script), perception_name, ret_value)	
	
	return ret_value
end 





