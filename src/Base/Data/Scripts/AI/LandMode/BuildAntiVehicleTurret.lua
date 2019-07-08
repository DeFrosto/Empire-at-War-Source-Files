-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/BuildAntiVehicleTurret.lua#4 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/BuildAntiVehicleTurret.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: Steve_Copeland $
--
--            $Change: 35397 $
--
--          $DateTime: 2005/12/15 22:10:30 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

-- Build a single turret.

function Definitions()
	
	Category = "Build_AntiVehicle_Turret"
	TaskForce = {
	{
		"MainForce"					
		,"TaskForceRequired"
		,"UC_Empire_Buildable_Anti_Vehicle_Turret | UC_Rebel_Buildable_Anti_Vehicle_Turret | UC_Pirate_Buildable_Anti_Vehicle_Turret= 1"
	}
	}

end

function MainForce_Thread()
	--MessageBox("%s -- Building a turret.", tostring(Script))

	-- Make sure we've ended up with a build location that's reasonably close to our original target
	pad_table = MainForce.Get_Reserved_Build_Pads()
	for i,pad in pad_table do
		if pad.Get_Distance(AITarget) > 120 then
			ScriptExit()
		end
	end

	-- Build the task force
	-- Blocking shouldn't be necessary, but we'll use it to ease watching the script
	MainForce.Set_Plan_Result(true)
	BlockOnCommand(MainForce.Build_All())
	ScriptExit()
end



