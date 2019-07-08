-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UMP_Mission_Script.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UMP_Mission_Script.lua $
--
--    Original Author: Jeff_Stewart
--
--            $Author: Jeff_Stewart $
--
--            $Change: 53005 $
--
--          $DateTime: 2006/08/30 09:54:11 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("JGS_FunctionLib") -- added library of commonly used functions
require("PGStateMachine")
require("PGSpawnUnits")

function Definitions()
	-- Object isn't valid at this point so don't do any operations that
	-- would require it.  State_Init is the first chance you have to do
	-- operations on Object
	DebugMessage("%s -- In Definitions", tostring(Script))
	Define_State("State_Init", State_Init);
end


function State_Init(message)
		if message == OnEnter then
			
			neutral_player = Find_Player("Neutral")
			empire_player = Find_Player("Empire")
			underworld_player = Find_Player("Underworld")
			
			silri = Find_First_Object("SILRI")
			
			silri.Prevent_AI_Usage(true)
			
			Register_Timer(Silri_Summon, 6)
			
		elseif message == OnUpdate then
			--Do Nothing
		elseif message == OnExit then 
			--Do Nothing
		end
end

function Silri_Summon()
	MessageBox("Summoning...")
	
	silri.Activate_Ability("SUMMON", silri)
	
	Register_Timer(Silri_Summon, 6)
end
