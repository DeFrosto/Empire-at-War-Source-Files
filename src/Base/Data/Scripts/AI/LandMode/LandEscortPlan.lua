-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/LandEscortPlan.lua#9 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/LandEscortPlan.lua $
--
--    Original Author: Brian Hayes
--
--            $Author: Steve_Copeland $
--
--            $Change: 34279 $
--
--          $DateTime: 2005/12/05 16:46:43 $
--
--          $Revision: #9 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

--
-- Land Mode Escort
--

function Definitions()
	
	Category = "Land_Escort"
	IgnoreTarget = true
	TaskForce = {
	{
		"MainForce"
		,"DenyHeroAttach"
		,"Infantry = 1"
		,"LandHero = 0,1"
	}
	}
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force());
	QuickReinforce(PlayerObject, AITarget, MainForce)	

	DebugMessage("Taskforce %s following object %s.", tostring(MainForce), tostring(Target))

	-- Give an initial order to put the escorts in a state that the Escort function expects
	MainForce.Guard_Target(AITarget)

	while true do
		Escort(MainForce, AITarget)
	end
	ScriptExit()
end
