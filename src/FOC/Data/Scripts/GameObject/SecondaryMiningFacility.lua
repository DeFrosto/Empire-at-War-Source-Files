-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/SecondaryMiningFacility.lua#3 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/SecondaryMiningFacility.lua $
--
--    Original Author: Dan Etter
--
--            $Author: Dan_Etter $
--
--            $Change: 48955 $
--
--          $DateTime: 2006/07/17 11:23:19 $
--
--          $Revision: #3 $
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
		-- Do Nothing
	elseif message == OnUpdate then
		faction = Object.Get_Owner().Get_Faction_Name()
		if faction == "REBEL" or faction == "EMPIRE" or faction == "UNDERWORLD" then
			Set_Next_State("State_Controlled")
		end
	end
end

function State_Controlled(message)
	if message == OnEnter then
		Object.Get_Owner().Give_Money(800)
		Object.Disable_Capture(true)
		Sleep(3)
		Object.Take_Damage(10001)
	end
end

