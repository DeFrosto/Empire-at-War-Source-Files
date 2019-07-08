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
--              $File: 
--
--            $Author: Steve_Tall $
--
--            $Change: 
--
--          $DateTime: 
--
--          $Revision: 
--
--/////////////////////////////////////////////////////////////////////////////////////////////////


require("PGStoryMode")

-----------------------------------------------------------------------------------------------------------------------
-- Definitions -- This function is called once when the script is first created.
-----------------------------------------------------------------------------------------------------------------------
function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	StoryModeEvents = 
	{
		Tutorial_M05_Begin = State_Tutorial_M05_Begin,
		Tutorial_M05_Sand_Crawler_Destroyed_04 = State_Tutorial_M05_Sand_Crawler_Destroyed
	}

	unit_list = {}
	at_shield = false
	
	--init_done = false
	
	fog_id = nil
	fog_id2 = nil
	fog_id3 = nil
		
end


-----------------------------------------------------------------------------------------------------------------------
-- Function for Event: Tutorial_M05_Begin
-----------------------------------------------------------------------------------------------------------------------

function State_Tutorial_M05_Begin(message)
	if message == OnEnter then

		--MessageBox("]]] Tutorial M05 Begin")
		
		unit_list = Find_All_Objects_With_Hint("reinforce1")
		reinforce_point1 = unit_list[1]
		
		-- Get Empire & Rebel Players
		rebel_player = Find_Player("Rebel")
		empire_player = Find_Player("Empire")											  
		
		-- Make all objects with invulnerable hint, invulnerable
		unit_list = Find_All_Objects_With_Hint("invulnerable")
		for i,unit in pairs(unit_list) do
			unit.Make_Invulnerable(true)
		end
		
		--init_done = true

		Create_Thread("Mission_Thread") -- Created a separate thread so other states could activate!

		unit_list = Find_All_Objects_Of_Type("JAWA_SANDCRAWLER")
		sand_crawler = unit_list[1]

		unit_list = Find_All_Objects_Of_Type("POWER_GENERATOR_R_M1")
		power_generator = unit_list[1]
		
	end
end

-----------------------------------------------------------------------------------------------------------------------

function Mission_Thread()

	Sleep(4) -- wait for the letterbox to go away
	Story_Event("TAKE_REINFORCEMENT_POINT")
	
	while reinforce_point1.Get_Owner() ~= empire_player do
		Sleep(2)
	end
	
	Story_Event("DEPLOY_SQUADS")
	
	while true do
		unit_list = Find_All_Objects_Of_Type("STORMTROOPER_TEAM")
		DebugMessage("]]]] Stormtrooper teams = %d",table.getn(unit_list))
		if table.getn(unit_list) >= 4 then
			break
		end
		Sleep(2)
	end


	
	Force_Weather() -- Turn on sandstorms for a while
	Sleep(2) 
	--MessageBox("SQUADS_DEPLOYED")
	Story_Event("SQUADS_DEPLOYED")
	Sleep(30)
	
	
	
	--MessageBox("DESTROY_SAND_CRAWLER")
	--Story_Event("DESTROY_SAND_CRAWLER")
	if TestValid(sand_crawler) then
		fog_id = FogOfWar.Reveal(empire_player,sand_crawler.Get_Position(),200,200)
	end
	while TestValid(sand_crawler) do
		Sleep(2)
	end
	Sleep(2)
	Story_Event("SAND_CRAWLER_DESTROYED")
	--MessageBox("SAND_CRAWLER_DESTROYED")
	
			
	-- wait for empire forces to get within sight of the rebel shield
	at_shield_marker = Find_Hint("GENERIC_MARKER_LAND", "at-shield")
	at_shield_dist = 200
	Register_Prox(at_shield_marker,Prox_Shield,at_shield_dist,empire_player)
	while not at_shield do
		Sleep(2)
	end
	
	
	
	--MessageBox("DESTROY_POWER_GENERATOR")
	Story_Event("DESTROY_POWER_GENERATOR")
	if TestValid(power_generator) then
		fog_id2 = FogOfWar.Reveal(empire_player,power_generator.Get_Position(),200,200)
	end
	while TestValid(power_generator) do
		Sleep(2)
	end
	Sleep(2)


	--MessageBox("DESTROY_BASE")
	Story_Event("DESTROY_BASE")
end

-----------------------------------------------------------------------------------------------------------------------

function Prox_Shield(prox_obj, trigger_obj)
	prox_obj.Cancel_Event_Object_In_Range(Prox_Shield)
	at_shield = true
end

-----------------------------------------------------------------------------------------------------------------------

function State_Tutorial_M05_Sand_Crawler_Destroyed(message)
	if message == OnEnter then

		--MessageBox("Revealing Rebel Base")
		unit_list = Find_All_Objects_Of_Type("R_Ground_Base_Shield_Small")
		if table.getn(unit_list) == 0 then
			MessageBox("Couldn't find shield generator!")
		end
		shield_generator = unit_list[1]
		fog_id3 = FogOfWar.Reveal(empire_player,shield_generator.Get_Position(),380,380)
		
	end
end

-----------------------------------------------------------------------------------------------------------------------
-- Story_Mode_Service() - Processes each frame.
-----------------------------------------------------------------------------------------------------------------------

--function Story_Mode_Service()

--	if not init_done then
--		return
--	end
	

--end

-----------------------------------------------------------------------------------------------------------------------
