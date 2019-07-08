-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Demo_DeathStar_Controller.lua#5 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Demo_DeathStar_Controller.lua $
--
--    Original Author: Dan Etter
--
--            $Author: Dan_Etter $
--
--            $Change: 43419 $
--
--          $DateTime: 2006/05/08 14:42:03 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGStoryMode")


function Definitions()

	StoryModeEvents = 
		{
			Demo_Executor_Destroyed = State_Demo_Executor_Destroyed,
			Demo_SuperLaser_Started = State_Demo_SuperLaser_Started,
			Demo_Start = State_Demo_Start
		}
   
	DebugMessage("%s -- In Definitions", tostring(Script))
		
	Define_State("State_Init", State_Init);

	empire_player = Find_Player("Empire")
	rebel_player = Find_Player("Rebel")
	underworld_player = Find_Player("Underworld")
	
	move_command = true

end


function State_Init(message)
	
	if (move_command == true) then
	
		empire_reveal = FogOfWar.Reveal_All(empire_player)
		rebel_reveal = FogOfWar.Reveal_All(rebel_player)
		uw_reveal = FogOfWar.Reveal_All(underworld_player)
		
		--MessageBox("Fleets Defined")
		
		move_command = false
	end

end

function State_Demo_Executor_Destroyed(message)
	if message == OnEnter then
		--MessageBox("Executor Cinematic Started")
		Create_Thread("Executor_Cinematic")
	end
end

function State_Demo_SuperLaser_Started(message)
	if message == OnEnter then
		--MessageBox("Cinematic Started")
		Create_Thread("SuperLaser_Cinematic")
	end
end


-- ##########################################################################################
--	Executor Cinematic functions
-- ##########################################################################################

function Executor_Cinematic()
	Fade_Screen_Out(0)
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()	
	Letter_Box_In(0)
	
	executor = Find_First_Object("EXECUTOR_DEATH_CLONE")
	
	Set_Cinematic_Camera_Key(executor, 4000, 10, 70, 1, 1, 1, 0)
	Set_Cinematic_Target_Key(executor, 0, 0, 0, 0, 0, 0, 0)
	
	Fade_Screen_In(0)
	Transition_Cinematic_Camera_Key(executor, 16, 2000, 5, 130, 1, 1, 1, 0)
	
	Sleep(15)
	
	Fade_Screen_Out(1)
	Lock_Controls(0)
	Sleep(1)
	End_Cinematic_Camera()
	Letter_Box_Out(0)	
	Suspend_AI(0)
	Sleep(1)
	Fade_Screen_In(1)

	
end


-- ##########################################################################################
--	Super Laser Cinematic functions
-- ##########################################################################################

function SuperLaser_Cinematic()
	Fade_Screen_Out(0)
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()	
	Letter_Box_In(0)
	
	deathstar = Find_First_Object("DEATH_STAR_II")
	home_one = Find_First_Object("HOME_ONE")
	
	Set_Cinematic_Camera_Key(home_one, 2000, 30, 15, 1, 1, 1, 0)
	Set_Cinematic_Target_Key(deathstar, 0, 2500, 0, 0, 0, 0, 0)
	
	Fade_Screen_In(2)
	Transition_Cinematic_Camera_Key(home_one, 18, 1700, 5, 45, 1, 1, 1, 0)
	
	Sleep(2)
	Transition_Cinematic_Target_Key(deathstar, 18, 0, 0, 1500, 0, 0, 0, 0)
	Sleep(14)
	
	Fade_Screen_Out(1)
	Sleep(1)
	Lock_Controls(0)
	Sleep(1)
	End_Cinematic_Camera()
	Letter_Box_Out(0)	
	Suspend_AI(0)
	Fade_Screen_In(1)
	
	

end