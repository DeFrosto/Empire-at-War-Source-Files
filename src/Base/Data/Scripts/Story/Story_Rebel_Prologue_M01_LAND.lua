-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Story/Story_Rebel_Prologue_M01_LAND.lua#14 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Story/Story_Rebel_Prologue_M01_LAND.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Brian_Hayes $
--
--            $Change: 22566 $
--
--          $DateTime: 2005/07/28 14:58:29 $
--
--          $Revision: #14 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStoryMode")


--
-- Definitions -- This function is called once when the script is first created.
-- 
function Definitions()

	DebugMessage("%s -- In Definitions", tostring(Script))
	
	StoryModeEvents = 
	{
		Rebel_M01_Begin = State_Rebel_M01_Begin
		,Rebel_M01_LAND_05 = State_Rebel_M01_LAND_05
		,Rebel_M01_LAND_06 = State_Rebel_M01_LAND_06
		,Rebel_M01_LAND_09 = State_Rebel_M01_LAND_09
	}
	
	rebel_player = nil
	tani_type = nil
	tani_object = nil
	empire_player = nil
	atst_type = nil
	atst_list = nil
	power = nil
	
	power_destroyed = false

	reinforcements = {}

	stormtrooper_type_list = { 
		"Imperial_Stormtrooper_Squad"
	}

	atst_type_list = { 
		"Imperial_Heavy_Scout_Squad"
	}



end



function State_Rebel_M01_Begin(message)
	if message == OnEnter then
		DebugMessage("%s -- State_E3_Demo_Ground_00(OnEnter)", tostring(Script))
		tani_start = Find_Hint("GENERIC_MARKER_LAND", "tanistart")
		tani_end = Find_Hint("GENERIC_MARKER_LAND", "taniend")
		reinforce1 = Find_Hint("GENERIC_MARKER_LAND", "reinforce1")
		reinforce2 = Find_Hint("GENERIC_MARKER_LAND", "reinforce2")
		reinforce_power = Find_Hint("GENERIC_MARKER_LAND", "atstpower")
		if not TestValid(tani_start) or not TestValid(tani_end) or not TestValid(reinforce1) or not TestValid(reinforce2) then
			MessageBox("didn't find marker")
		else
			--MessageBox("running tani")
			rebel_player = tani_start.Get_Owner()
			empire_player = rebel_player.Get_Enemy()
			tani_type = Find_Object_Type("Tani_Team")
			tani_list = Spawn_Unit(tani_type, tani_start, rebel_player)
			tani_object = tani_list[1]
			tani_object.Set_Selectable(false)
			tani_object.Move_To(tani_end)
		end
		
	elseif message == OnUpdate then
		-- Do interesting stuff here...then possibly advance the story arc state.
	elseif message == OnExit then
	end
end


function State_Rebel_M01_LAND_05(message)
	if message == OnEnter then
		--MessageBox("entering State_Rebel_M01_LAND_05")
		-- allow tani to be selectable again.
		tani_object.Set_Selectable(true)
		power = Find_Nearest(tani_start, "Power_Generator_R_M1")
		if not power then
			MessageBox("couldn't find power")
			return
		end
		
		Register_Timer(Timer_Deploy_ATST_Power, 1)
		Register_Timer(Timer_Deploy_Stormtroopers1, 22)
		Register_Timer(Timer_Deploy_Stormtroopers2, 25)
		Register_Timer(Timer_Deploy_ATST1, 40)
		Register_Timer(Timer_Deploy_ATST2, 45)
		
	elseif message == OnUpdate then
		if not TestValid(power) then
			-- the power generator must have been destroyed
			power = nil
		end
		
	elseif message == OnExit then
	end

end

function ATST_Deploy_Callback(atst_list)
	-- Add them to the list of things to release to the AI eventually.
	if TestValid(power) then
		for k, unit in pairs(atst_list) do
			table.insert(reinforcements, unit)
			unit.Attack_Target(power)
		end

	else
		for j, unit in pairs(atst_list) do
			--MessageBox("releasing: %s", tostring(unit))
			if TestValid(unit) then
				unit.Prevent_AI_Usage(false)
			end
		end
	end
end

-- Launch more units until the power generator is dead
function Timer_Deploy_ATST_Power()

	-- As long as there is a power supply, keep attacking it and ordering more units.
	if TestValid(power) then
		--MessageBox("landing ATSTs to attack the power plant and the AI should NOT use them yet")
	
		ReinforceList(atst_type_list, reinforce_power, empire_player, false, true, ATST_Deploy_Callback)
	end
end


-- Give the AI some Stormtroopers
function Timer_Deploy_Stormtroopers1()
	--MessageBox("Landing stormtroopers for the AI to use")

	ReinforceList(stormtrooper_type_list, reinforce1, empire_player, true, true)
end

-- Give the AI some Stormtroopers
function Timer_Deploy_Stormtroopers2()
	--MessageBox("Landing stormtroopers for the AI to use")

	ReinforceList(stormtrooper_type_list, reinforce2, empire_player, true, true)
end
	
-- Give the AI some ATSTs
function Timer_Deploy_ATST1()
	--MessageBox("Landing ATSTs for the AI to use")

	ReinforceList(atst_type_list, reinforce1, empire_player, true, true)
end

-- Give the AI some ATSTs
function Timer_Deploy_ATST2()
	--MessageBox("Landing ATSTs for the AI to use")

	ReinforceList(atst_type_list, reinforce2, empire_player, true, true)
end


function State_Rebel_M01_LAND_06(message)
	if message == OnEnter then
		--MessageBox("entering State_Rebel_M01_LAND_06")

		for j, unit in pairs(reinforcements) do
			--MessageBox("releasing: %s", tostring(unit))
			if TestValid(unit) then
				unit.Prevent_AI_Usage(false)
			end
		end

	elseif message == OnUpdate then
		
	elseif message == OnExit then
	end

end

function State_Rebel_M01_LAND_09(message)
	if message == OnEnter then
		--MessageBox("entering State_Rebel_M01_LAND_09")
		
	empire_player.Retreat()
		
	elseif message == OnUpdate then
		
	elseif message == OnExit then
	end
end
