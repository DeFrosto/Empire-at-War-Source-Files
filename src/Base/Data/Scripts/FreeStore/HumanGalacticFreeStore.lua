-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/FreeStore/HumanGalacticFreeStore.lua#2 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/FreeStore/HumanGalacticFreeStore.lua $
--
--    Original Author: James Yarrow
--
--            $Author: Brian_Hayes $
--
--            $Change: 20677 $
--
--          $DateTime: 2005/06/24 17:01:12 $
--
--          $Revision: #2 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgcommands")
require("FleetEvents")

function Base_Definitions()

	ServiceRate = 1

	Common_Base_Definitions()
	
	if Definitions then
		Definitions()
	end
	
	FleetType = nil
	fleet_table = {}
	fleet_key = nil
	fleet = nil
	increment = 0.001
	roll = nil
	threshold = 0.0
	event = nil
	parent = nil
	
	Init_Fleet_Events()
end

function main()
	
	FleetType = Find_Object_Type("Galactic_Fleet")
	
	if FreeStoreService then
		while 1 do
			FreeStoreService()
			PumpEvents()
		end
	end
	
	ScriptExit()
end

function On_Unit_Service(object)
	parent = object.Get_Parent_Object()
	if parent and parent.Get_Type() == FleetType then
		fleet_table[parent] = parent
	end
end

function FreeStoreService()
	for fleet_key, fleet in pairs(fleet_table) do
		if TestValid(fleet) then
			Evaluate_Random_Event(fleet)
		else
			fleet_table[fleet_key] = nil
		end
		Sleep(0.5)
	end
end

function Evaluate_Random_Event(fleet)

	event = FleetEventTable.Sample()

	if not event.Is_Appropriate_For_Fleet(fleet) then
		return
	end
		
	--roll to determine whether an event takes place.  The chance of an event
	--increases with the amount of time that's passed with no event.
	roll = GameRandom.Get_Float()
	
	if roll > threshold then
		threshold = increment + threshold
		return
	end
	
	threshold = 0.0
		
	if GameRandom.Get_Float() > event.Get_Avoidance_Chance(fleet) then
		--Execute event
		event.Execute(fleet)
	else
		--Inform user that event was avoided
		event.Avoided(fleet)
	end
	
end

function On_Unit_Added(object)	
end