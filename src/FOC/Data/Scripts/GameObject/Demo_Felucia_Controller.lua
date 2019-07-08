-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Demo_Felucia_Controller.lua#17 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Demo_Felucia_Controller.lua $
--
--    Original Author: Dan Etter
--
--            $Author: Dan_Etter $
--
--            $Change: 43390 $
--
--          $DateTime: 2006/05/08 11:51:03 $
--
--          $Revision: #17 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGStoryMode")


function Definitions()

	StoryModeEvents = 
		{
			Demo_Bombard_Started = State_Demo_Bombard_Started
		}

	-- Object isn't valid at this point so don't do any operations that
    -- would require it.  State_Init is the first chance you have to do
    -- operations on Object
   
	DebugMessage("%s -- In Definitions", tostring(Script))
		
	Define_State("State_Init", State_Init);

	empire_player = Find_Player("Empire")
	rebel_player = Find_Player("Rebel")
	underworld_player = Find_Player("Underworld")
	
	move_command = true
	cine_triggered = false
	camera_offset = 225
	
	invulnerable = true
	
	stormtrooper = Find_Object_Type("SQUAD_STORMTROOPER")
	wall_corner = Find_Object_Type("EMPIRE_WALL_CORNER")
	wall_inside_corner = Find_Object_Type("EMPIRE_WALL__INSIDE_CORNER")
	wall = Find_Object_Type("EMPIRE_WALL")
	turbo_tower = Find_Object_Type("E_GROUND_TURBOLASER_TOWER")
	hv_gun = Find_Object_Type("GROUND_EMPIRE_HYPERVELOCITY_GUN")
	command_center = Find_Object_Type("IMPERIAL_COMMAND_CENTER")
	power = Find_Object_Type("POWER_GENERATOR_E")
	research = Find_Object_Type("E_GROUND_RESEARCH_FACILITY")
	bunker = Find_Object_Type("GARRISON_BUNKER_EMPIRE")
	barracks = Find_Object_Type("E_GROUND_BARRACKS")
	facotry = Find_Object_Type("E_GROUND_HEAVY_VEHICLE_FACTORY")
	array = Find_Object_Type("COMMUNICATIONS_ARRAY_E")
	shuttle = Find_Object_Type("LANDED_EMPIRE_SHUTTLE")
	platform = Find_Object_Type("EMPIRE_LANDING_PLATFORM_2X")
	build_pad = Find_Object_Type("SKIRMISH_BUILD_PAD")
	turret = Find_Object_Type("EMPIRE_ANTI_INFANTRY_TURRET")
	reinforcement_point = Find_Object_Type("REINFORCEMENT_POINT_EMPIRE")

end


function State_Init(message)
	
	if (move_command == true) then
	
		empire_reveal = FogOfWar.Reveal_All(empire_player)
		rebel_reveal = FogOfWar.Reveal_All(rebel_player)
		uw_reveal = FogOfWar.Reveal_All(underworld_player)
		
		underworld_player.Give_Money(10000)
	
		controller = Find_First_Object("FELUCIA_DEMO_CONTROLLER")
		
		empire_unit_list = Find_All_Objects_Of_Type(empire_player)
		empire_goto = Find_Hint("STORY_TRIGGER_ZONE_00", "empiregoto")
		
		uw_unit_list = Find_All_Objects_Of_Type(underworld_player)
		
		--MessageBox("Fleets Defined")
		
		move_command = false
		
		current_cinematic_thread = Create_Thread("Intro_Cinematic")
	end

end

function State_Demo_Bombard_Started(message)
	if message == OnEnter then
		Create_Thread("Bombardment_Cinematic")
	end
end

function Move_Units(list)	
	for k, unit in pairs(list) do
		if TestValid(unit) then
			if unit.Is_Category("Infantry") or unit.Is_Category("Vehicle") then
				if not
--					(unit.Get_Type() == wall_corner) and not
--					(unit.Get_Type() == wall_inside_corner) and not
--					(unit.Get_Type() == wall) and not
--					(unit.Get_Type() == turbo_tower) and not
--					(unit.Get_Type() == hv_gun) and not
--					(unit.Get_Type() == command_center) and not
--					(unit.Get_Type() == power) and not
--					(unit.Get_Type() == research) and not
--					(unit.Get_Type() == bunker) and not
--					(unit.Get_Type() == barracks) and not
--					(unit.Get_Type() == facotry) and not
--					(unit.Get_Type() == array) and not
--					(unit.Get_Type() == shuttle) and not
--					(unit.Get_Type() == platform) and not
--					(unit.Get_Type() == build_pad) and not
--					(unit.Get_Type() == turret) and not
--					(unit.Get_Type() == reinforcement_point) and not
					(unit.Get_Type() == stormtrooper) then
						unit.Move_To(empire_goto.Get_Position())
				end
			end
		end
	end
end

function Story_Handle_Esc()
	if current_cinematic_thread ~= nil then
		Thread.Kill(current_cinematic_thread)
		current_cinematic_thread = nil
		Create_Thread("End_Camera")
	end
end

function Make_Invulnerable(list, condition)	
	for k, unit in pairs(list) do
		if TestValid(unit) then
			if invulnerable == true then
				unit.Make_Invulnerable(true)
			else
				unit.Make_Invulnerable(false)
			end
		end
	end
end

-- ##########################################################################################
--	Intro Cinematic functions
-- ##########################################################################################

function Intro_Cinematic()
	invulnerable = true
	Create_Thread("Make_Invulnerable", uw_unit_list, invulnerable)
	
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()	
	Letter_Box_In(2)
	
	--Sleep(1)

	tyber = Find_First_Object("TYBER_ZANN")
	
	Transition_Cinematic_Camera_Key(tyber, 7, 50, 35, 135, 1, 1, 1, 0)
	Transition_Cinematic_Target_Key(tyber, 5, 0, 0, 10, 0, 0, 0, 0)
	Sleep(7)
	
	Transition_Cinematic_Camera_Key(tyber, 5, 50, 35, 225, 1, 1, 1, 0)
	
	Sleep(4.5)
	
	while true do
		camera_offset = camera_offset + 90
		Transition_Cinematic_Camera_Key(tyber, 5, 50, 35, camera_offset, 1, 1, 1, 0)
		
		if camera_offset == 315 then
			camera_offset = -45
		end
		
		Sleep(4.5)
	end
	
end

function End_Camera()
	Transition_To_Tactical_Camera(2)
	Letter_Box_Out(2)
	Sleep(2)
	Lock_Controls(0)
	End_Cinematic_Camera()
	Suspend_AI(0)
	
	invulnerable = false
	Create_Thread("Make_Invulnerable", uw_unit_list, invulnerable)
end

-- ##########################################################################################
--	Orbital Bombardment Cinematic functions
-- ##########################################################################################

function Bombardment_Cinematic()
	Fade_Screen_Out(0)
	Suspend_AI(1)
	Lock_Controls(1)
	Start_Cinematic_Camera()	
	Letter_Box_In(0)
	
	Allow_Localized_SFX(false)
	Weather_Audio_Pause(true)
	Enable_Fog(false)
	
	krayt = Find_Hint("PROP_KRAYT_CINE_UNIT", "firingkrayt")
	interceptor = Find_First_Object("PROP_INTERCEPTOR_CINE_UNIT")
	felucia = Find_First_Object("PROP_FELUCIA_PLANET_CINE_UNIT")
	
	krayt.Prevent_AI_Usage(true)
	
	interceptor.Play_SFX_Event("Structure_Magnepulse_Charge")
	
	--Set_Cinematic_Camera_Key(krayt, 200, 10, -60, 1, 1, 1, 0)
	Set_Cinematic_Camera_Key(krayt, 700, 15, 75, 1, 1, 1, 0)
	Set_Cinematic_Target_Key(felucia, 0, 0, 0, 1, 1, 0, 0)
	
	Fade_Screen_In(2)
	--Transition_Cinematic_Camera_Key(krayt, 8, 200, 10, 45, 1, 1, 1, 0)
	Transition_Cinematic_Camera_Key(krayt, 16, 200, 10, 45, 1, 1, 1, 0)
	
	Sleep(2.60)
	krayt.Play_SFX_Event("Structure_Magnepulse_Charge")
	Sleep(4.30)
	
	krayt.Play_Animation("Cinematic", false, 0)
	Sleep(2.65)
	krayt.Play_SFX_Event("Unit_Ion_Cannon_Fire")
	Sleep(2.75)
	krayt.Play_SFX_Event("Unit_Hyper_Velocity_Fire")
	Sleep(2)
	
	Transition_Cinematic_Target_Key(krayt, 8, 0, 0, 0, 0, 0, 0, 0)
	Fade_Screen_Out(1)
	
	Create_Thread("Move_Units", empire_unit_list)
	Sleep(1)
	
	Allow_Localized_SFX(true)
	Weather_Audio_Pause(false)
--	Enable_Fog(true)
	
--	-- Set_Cinematic_Camera_Key(target_pos, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
--	Set_Cinematic_Camera_Key(controller, 850, 35, 30, 1, 1, 0, 0)
--	-- Set_Cinematic_Target_Key(target_pos, x_dist, y_pitch, z_yaw, euler, pobj, use_object_rotation, cinematic_animation)
--	Set_Cinematic_Target_Key(controller, 0, -20, 15, 1, 1, 0, 0)
	
	Set_Cinematic_Camera_Key(controller, 700, 90, 15, 1, 1, 0, 0)
	Set_Cinematic_Target_Key(controller, 0, 0, 0, 1, 1, 0, 0)
	
	Fade_Screen_In(2)
	
--	-- Transition_Cinematic_Camera_Key(target_pos, time, xoffset_dist, yoffset_pitch, zoffset_yaw, angles?, attach_object, use_object_rotation, cinematic_animation)
--	Transition_Cinematic_Camera_Key(controller, 15, 850, 35, 100, 1, 1, 0, 0)
	Transition_Cinematic_Camera_Key(controller, 7, 835, 47, 90, 1, 1, 0, 0)

	Sleep(10)
	
	Fade_Screen_Out(1)
	Sleep(1)
	Lock_Controls(0)
	Sleep(1)
	End_Cinematic_Camera()
	Letter_Box_Out(0)	
	Suspend_AI(0)
	Fade_Screen_In(1)
	
	

end