-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Demo_Land_Controller.lua#4 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Demo_Land_Controller.lua $
--
--    Original Author: Dan Etter
--
--            $Author: Dan_Etter $
--
--            $Change: 42961 $
--
--          $DateTime: 2006/05/04 11:30:48 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGStoryMode")


function Definitions()

	-- Object isn't valid at this point so don't do any operations that
    -- would require it.  State_Init is the first chance you have to do
    -- operations on Object
   
	DebugMessage("%s -- In Definitions", tostring(Script))
		
	Define_State("State_Init", State_Init);

	empire_player = Find_Player("Empire")
	rebel_player = Find_Player("Rebel")
	underworld_player = Find_Player("Underworld")
	
	move_command = true
					
	controller = Find_First_Object("DEMO_CONTROLLER_LAND")
	mptl = Find_Object_Type("MPTL")
	t4b = Find_Object_Type("T4B_TANK")
	t2b = Find_Object_Type("T2B_TANK")
	luke = Find_Object_Type("LUKE_SKYWALKER_JEDI")
	yoda = Find_Object_Type("YODA")
	speeder = Find_Object_Type("SNOWSPEEDER")
	r_infantry_squad = Find_Object_Type("REBEL_INFANTRY_SQUAD")
	r_infantry = Find_Object_Type("SQUAD_REBEL_TROOPER")

	destroyer_squad = Find_Object_Type("DESTROYER_DROID_COMPANY")
	destroyer = Find_Object_Type("DESTROYER_DROID")
	disruptor_squad = Find_Object_Type("UNDERWORLD_DISRUPTOR_MERC_SQUAD")
	disruptor = Find_Object_Type("UNDERWORLD_DISRUPTOR_MERC")
	merc_squad = Find_Object_Type("UNDERWORLD_MERC_SQUAD")
	merc = Find_Object_Type("UNDERWORLD_MERC")
	
	spmat = Find_Object_Type("SPMAT_WALKER")
	juggernaut = Find_Object_Type("HAV_JUGGERNAUT")
	dark_phase_1_squad = Find_Object_Type("DARKTROOPER_P1_COMPANY")
	dark_phase_1 = Find_Object_Type("DARK_TROOPER_PHASEI")
	dark_phase_2_squad = Find_Object_Type("DARKTROOPER_P2_COMPANY")
	dark_phase_2 = Find_Object_Type("DARK_TROOPER_PHASEII")
	dark_phase_3_squad = Find_Object_Type("DARKTROOPER_P3_COMPANY")
	dark_phase_3 = Find_Object_Type("DARK_TROOPER_PHASEIII")
	stormtrooper_squad = Find_Object_Type("IMPERIAL_STORMTROOPER_SQUAD")
	stormtrooper = Find_Object_Type("SQUAD_STORMTROOPER")
	lancet = Find_Object_Type("LANCET_AIR_ARTILLERY")	
	
end

function State_Init(message)
	
	if (move_command == true) then
	
		empire_unit_list = Find_All_Objects_Of_Type(empire_player)
		rebel_unit_list = Find_All_Objects_Of_Type(rebel_player)
		underworld_unit_list = Find_All_Objects_Of_Type(underworld_player)
		
		empire_reveal = FogOfWar.Reveal_All(empire_player)
		rebel_reveal = FogOfWar.Reveal_All(rebel_player)
		uw_reveal = FogOfWar.Reveal_All(underworld_player)
						
		eg_list = Find_All_Objects_With_Hint("eg")
		rg_list = Find_All_Objects_With_Hint("rg")
		
		bossk = Find_First_Object("BOSSK")
		ig88 = Find_First_Object("IG-88")
		yoda = Find_First_Object("YODA")
		
		speeder_list = Find_All_Objects_Of_Type("SNOWSPEEDER")
		lancet_list = Find_All_Objects_Of_Type("LANCET_AIR_ARTILLERY")
		
		dest0_list = Find_All_Objects_With_Hint("dest0")
		dest0 = Find_Hint("STORY_TRIGGER_ZONE_00", "dest0")
		dest1_list = Find_All_Objects_With_Hint("dest1")
		dest1 = Find_Hint("STORY_TRIGGER_ZONE_00", "dest1")
						
		Create_Thread("Move_IG88", ig88)
		Create_Thread("Move_Bossk", bossk)
		
		Create_Thread("Move_Destroyer_group", eg_list)
		Create_Thread("Move_Destroyer_group1", rg_list)
		
		Create_Thread("Guard_Self", empire_unit_list)
		Create_Thread("Guard_Self", rebel_unit_list)
				
		Create_Thread("Yoda_Attack", yoda)
		
		--MessageBox("Fleets Defined")
		
		move_command = false
	end

end

function Yoda_Attack(unit)
	while true do
		if TestValid(unit) then
			closest_enemy = Find_Nearest(unit, underworld_player, true)	
			if TestValid(closest_enemy) then
				unit.Activate_Ability("BERSERKER", closest_enemy)
			end
		end
	Sleep(1)
	end
end

function Guard_Self(group)
	for k, unit in pairs(group) do
		if TestValid(unit) then
			if unit.Is_Category("Infantry") or unit.Is_Category("Vehicle") then
				if not (unit.Get_Type() == stormtrooper) and not (unit.Get_Type() == r_infantry) then
					unit.Guard_Target(unit.Get_Position())
				end
			end
		end
	end
end

function Move_Air_Units(group)	
	for k, unit in pairs(group) do
		if TestValid(unit) then
			unit.Attack_Move(dest0.Get_Position())
		end
	end
end

function Move_Air_Units1(group)	
	for k, unit in pairs(group) do
		if TestValid(unit) then
			unit.Attack_Move(dest1.Get_Position())
		end
	end
end

function Move_IG88(unit)	
	rand_loc = GameRandom(1,3)
	if TestValid(unit) then
		unit.Attack_Move(dest0_list[rand_loc].Get_Position())
	end
end

function Move_Bossk(unit)	
	rand_loc = GameRandom(1,3)
	if TestValid(unit) then
		unit.Attack_Move(dest1_list[rand_loc].Get_Position())
	end
end

function Move_Destroyer_group(group)	
	rand_loc = GameRandom(1,3)
	for k, unit in pairs(group) do
		
		if TestValid(unit) then
			unit.Attack_Move(dest0_list[rand_loc].Get_Position())
		end
	end
		
--	sleeptimer = GameRandom(8, 11)
--	Sleep(sleeptimer)
--	Deploy_Destroyer_group(group, dest0_list[rand_loc])
end

function Move_Destroyer_group1(group)	
	rand_loc = GameRandom(1,3)
	for k, unit in pairs(group) do
		
		if TestValid(unit) then
			unit.Attack_Move(dest1_list[rand_loc].Get_Position())
		end
	end
		
--	sleeptimer = GameRandom(12, 14)
--	Sleep(sleeptimer)
--	Deploy_Destroyer_group(group, dest0_list[rand_loc])
end

--function Deploy_Destroyer_group(group, loc)	
--	for k, unit in pairs(group) do
--		if TestValid(unit) then
--			unit.Activate_Ability("DEPLOY", true)		
--		end
--	end
--
--end
