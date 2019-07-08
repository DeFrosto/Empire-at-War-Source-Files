-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Miscellaneous/FleetEvents.lua#1 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/Miscellaneous/FleetEvents.lua $
--
--    Original Author: James Yarrow
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

require("pgcommands")

function Init_Fleet_Events()

	FleetEventTable = DiscreteDistribution.Create()

	Accident = {}
	Accident.Is_Appropriate_For_Fleet = Accident_Is_Appropriate_For_Fleet
	Accident.Get_Avoidance_Chance = Accident_Get_Avoidance_Chance
	Accident.Execute = Accident_Execute
	Accident.Avoided = Accident_Avoided
	
	FleetEventTable.Insert(Accident, 0.3)

	r_fleet_commander_type = Find_Object_Type("Generic_Fleet_Commander_Rebel")
	e_fleet_commander_type = Find_Object_Type("Generic_Fleet_Commander_Empire")

end

function Accident_Is_Appropriate_For_Fleet(fleet)
	if fleet.Get_Parent_Object() then
		return false
	end
	
	if fleet.Get_Contained_Object_Count() < 10 then
		return false
	end
	
	if fleet.Contains_Hero() then
		return false
	end
	
	return true
end

function Accident_Get_Avoidance_Chance(fleet)

	if fleet.Contains_Object_Type(r_fleet_commander_type) or fleet.Contains_Object_Type(e_fleet_commander_type) then
		return 1.0
	end

	return 0.0

end

function Accident_Execute(fleet)
	fleet.Destroy_Contained_Objects(1.0)
	Game_Message("TEXT_FLEET_EVENT_HYPERSPACE_ACCIDENT")	
end

function Accident_Avoided(fleet)
	Game_Message("TEXT_FLEET_EVENT_HYPERSPACE_ACCIDENT_AVOIDED")	
end