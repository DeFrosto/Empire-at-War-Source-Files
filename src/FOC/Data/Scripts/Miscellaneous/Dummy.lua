-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Miscellaneous/Dummy.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Miscellaneous/Dummy.lua $
--
--    Original Author: Brian Hayes
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

require("PGStoryMode")

function gal()
	-- Spawn_Unit(Find_Object_Type("Smuggler_Team_E"), Find_First_Object("Sullust"), Find_Player("Empire"))
	Find_First_Object("Generic_Smuggler_E").Get_Parent_Object().Activate_Ability()
end

function mov()
	Find_First_Object("Tartan_Patrol_Cruiser").Move_To(Find_First_Object("Skirmish_Empire_Star_Base_1"))
	MessageBox("Moved")
end

function tone()
	while true do
		DebugMessage("%s -- %s", tostring(Script), Thread.Get_Name(Thread.Get_Current_ID()))
		Sleep(1)
	end
end
function ttwo()
	while true do
		DebugMessage("%s -- %s", tostring(Script), Thread.Get_Name(Thread.Get_Current_ID()))
		Sleep(1.1)
	end
end
function tthree()
	while true do
		DebugMessage("%s -- %s", tostring(Script), Thread.Get_Name(Thread.Get_Current_ID()))
		Sleep(1.3)
	end
end

function Kill_Em()
	for k, id in pairs(threads) do
		Thread.Kill(id)
	end
end

function Kill_Em2()
	Thread.Kill_All()
end

function Kill_Em3()
	Thread.Create("Kill_Em2")
end

function Test_Threads()
	threads = {}
	table.insert(threads, Thread.Create("tone"))
	table.insert(threads, Thread.Create("ttwo"))
	table.insert(threads, Thread.Create("tthree"))
end

function Do_It()
	Create_Thread("test_call")
end

function test_call()
	MessageBox("test_call")
end

function stest()
	MessageBox("%s", tostring((Find_First_Object("X-Wing").Get_Parent_Object()).Move_To(Find_First_Object("IPV1_System_Patrol_Craft"))))
end

function ref()
	Reinforce_Unit(Find_Object_Type("Corellian_Corvette"), false, Find_Player("Rebel"), true, false)
end

function move()
	MessageBox("Begin")
	-- Find_Player("Empire").Enable_As_Actor()
	-- FogOfWar.Reveal_All(Find_Player("Empire"))
	-- unit_list = { "Rebel_Heavy_Tank_Brigade" }
	unit_list = { "Boba_Fett_Team" }
	-- unit_list = { "Darth_Team" }
	--unit_list = { "Han_Solo_Team" }
	ReinforceList(unit_list, Find_First_Object("Corellian_Corvette"), Find_Player("Rebel"), false, true, true, test_call)
	--Formation_Attack(tanks, trooper)
	MessageBox("Done")
	Sleep(500)
end

function find()
	trooper = Find_First_Object("Stormtrooper_Team")
	tanks = Find_All_Objects_Of_Type("T4B_Tank")
end

function one()
	Spawn_Unit(Find_Object_Type("Rebel_Heavy_Tank_Brigade"), Find_First_Object("Power_Generator_R"), Find_Player("Rebel"))
end

function two()
	Spawn_Unit(Find_Object_Type("Corellian_Corvette"), Find_First_Object("Skirmish_Rebel_Star_Base_1"), Find_Player("Rebel"))
end


