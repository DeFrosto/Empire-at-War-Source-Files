-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/HoldPosition.lua#6 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/HoldPosition.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Steve_Copeland $
--
--            $Change: 16952 $
--
--          $DateTime: 2005/04/26 16:41:28 $
--
--          $Revision: #6 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()
	
	Category = "Hold_Position"
	TaskForce = {
	{
		"MainForce"						
		,"Vehicle = 0,2"
		,"Infantry = 0,4"
	},
	}
	
	RequiredCategories = { "Infantry | Vehicle " }

end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	WaitForAllReinforcements(MainForce, AITarget)
	BlockOnCommand(MainForce.Move_To(AITarget, 500, true)) -- true = wait for entire taskforce at intermediate zone points
	
	WaitForever()
	
	ScriptExit()
end

function MainForce_No_Units_Remaining()
	DebugMessage("%s -- All units dead or non-buildable.  Abandonning plan.", tostring(Script))
	ScriptExit()
end