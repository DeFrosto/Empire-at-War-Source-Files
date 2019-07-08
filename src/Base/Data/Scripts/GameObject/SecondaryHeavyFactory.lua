-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/SecondaryHeavyFactory.lua#2 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/GameObject/SecondaryHeavyFactory.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 26022 $
--
--          $DateTime: 2005/09/05 20:23:04 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")

--Once this object has fully transitioned to a playable side it spits out vehicles for its owner

function Definitions()
	Define_State("State_Waiting_For_Control", State_Waiting_For_Control);
	Define_State("State_Controlled", State_Controlled);
end

function State_Waiting_For_Control(message)

	if message == OnEnter then
		Object.Set_Garrison_Spawn(false)
	elseif message == OnUpdate then
		faction = Object.Get_Owner().Get_Faction_Name()
		if faction == "REBEL" or faction == "EMPIRE" then
			Set_Next_State("State_Controlled")
		end
	end
end

function State_Controlled(message)
	if message == OnEnter then
		Object.Set_Garrison_Spawn(true)
		Object.Disable_Capture(true)
	end
end

