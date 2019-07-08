-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/LandBombing.lua#3 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/LandBombing.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 32966 $
--
--          $DateTime: 2005/11/21 16:33:49 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()

	Category = "Land_Bombing_Run"
	IgnoreTarget = true
	TaskForce = 
	{
		{
			"MainForce"
			,"DenyHeroAttach"
			,"TaskForceRequired"
		}
	}

	result = nil
	
end

function MainForce_Thread()
	MainForce.Set_As_Goal_System_Removable(false)

	result = BlockOnCommand(MainForce.Bombing_Run(AITarget))
	
	if result and result > 0.65 then
		MainForce.Set_Plan_Result(true)
	end
	
	ScriptExit()
end