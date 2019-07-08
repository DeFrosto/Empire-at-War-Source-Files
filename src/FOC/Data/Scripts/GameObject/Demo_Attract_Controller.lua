-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Demo_Attract_Controller.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/Demo_Attract_Controller.lua $
--
--    Original Author: Dan Etter
--
--            $Author: Dan_Etter $
--
--            $Change: 41675 $
--
--          $DateTime: 2006/04/21 13:38:27 $
--
--          $Revision: #1 $
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
					
	controller = Find_First_Object("DEMO_CONTROLLER")
	hyper_gun = Find_Object_Type("GROUND_EMPIRE_HYPERVELOCITY_GUN")
	ion_cannon = Find_Object_Type("GROUND_ION_CANNON")
	starviper = Find_Object_Type("STARVIPER_FIGHTER")
	tie_phantom = Find_Object_Type("TIE_PHANTOM")
	tie_fighter = Find_Object_Type("TIE_FIGHTER")
	tie_bomber = Find_Object_Type("TIE_BOMBER")
	b_wing = Find_Object_Type("B-WING")
	x_wing = Find_Object_Type("X-WING")
	a_wing = Find_Object_Type("A-WING")
	star_base = Find_Object_Type("REBEL_STAR_BASE_3")

end


function State_Init(message)
	
	if (move_command == true) then
	
		empire_reveal = FogOfWar.Reveal_All(empire_player)
		rebel_reveal = FogOfWar.Reveal_All(rebel_player)
		uw_reveal = FogOfWar.Reveal_All(underworld_player)
	
		empire_unit_list = Find_All_Objects_Of_Type(empire_player)
		rebel_unit_list = Find_All_Objects_Of_Type(rebel_player)
		underworld_unit_list = Find_All_Objects_Of_Type(underworld_player)
		
		e_goto_list = Find_All_Objects_Of_Type ("STORY_TRIGGER_ZONE_02")
		r_goto_list = Find_All_Objects_Of_Type ("STORY_TRIGGER_ZONE_00")
		uw_goto_list = Find_All_Objects_Of_Type ("STORY_TRIGGER_ZONE_01")
				
		Move_Fleet(empire_unit_list, e_goto_list)
		Move_Fleet(rebel_unit_list, r_goto_list)
		Move_Fleet(underworld_unit_list, uw_goto_list)
		
		--MessageBox("Fleets Defined")
		
		move_command = false
	end

end

function Move_Fleet(list, loc_list)	
	for k, unit in pairs(list) do
		if TestValid(unit) then
			if not 
				(unit.Get_Type() == hyper_gun) and not 
				(unit.Get_Type() == ion_cannon) and not 
				(unit.Get_Type() == star_base) and not 
				(unit.Get_Type() == starviper) and not 
				(unit.Get_Type() == tie_phantom) and not 
				(unit.Get_Type() == tie_fighter) and not 
				(unit.Get_Type() == tie_bomber) and not 
				(unit.Get_Type() == a_wing) and not
				(unit.Get_Type() == x_wing) and not
				(unit.Get_Type() == b_wing) then
				
				rand_loc = GameRandom(1,3)
				unit.Attack_Move(loc_list[rand_loc].Get_Position())
			end
		end
	end
end