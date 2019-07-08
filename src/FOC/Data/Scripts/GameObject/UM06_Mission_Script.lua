-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UM06_Mission_Script.lua#5 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UM06_Mission_Script.lua $
--
--    Original Author: Jeff_Stewart
--
--            $Author: Jeff_Stewart $
--
--            $Change: 45703 $
--
--          $DateTime: 2006/06/05 13:27:42 $
--
--          $Revision: #5 $
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
			-- This is simply a sound to let the designer know the script is running
			-- Object.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
			
			neutral_player = Find_Player("Neutral")
			empire_player = Find_Player("Empire")
			rebel_player = Find_Player("Rebel")
			underworld_player = Find_Player("Underworld")
			
			-- Register prox events for battle chatter and game events
			--workers = Find_Hint("STORY_TRIGGER_ZONE","workers")
			--Register_Prox(hintworkers, Prox_HintWorkers, 75, underworld_player)
			
			warpone_a = Find_Hint("GENERIC_MARKER_SPACE","warponea")
			
			-- set up some global mission state flags
			started=false
			
		elseif message == OnUpdate then
			if not started then
				Register_Timer(Empire_Reinforcements,1)
				started=true
			end
		
		elseif message == OnExit then 
			--Do Nothing
		end
end

function Find_And_Attack(attack_list)
	Create_Thread("Hunt_Underworld",attack_list)
end

function Empire_Reinforcements()
	if not VictoryCondition_EclipseOwned then
		reinforce_list = { "STAR_DESTROYER" }
		ReinforceList(reinforce_list, warpone_a, empire_player, false, true, true, Find_And_Attack)
	
		Register_Timer(Empire_Reinforcements,10)
	end
end

