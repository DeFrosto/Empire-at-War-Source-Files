-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/FreeStore/GalacticHeroFreeStore.lua#5 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/FreeStore/GalacticHeroFreeStore.lua $
--
--    Original Author: Steve_Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 33437 $
--
--          $DateTime: 2005/11/28 17:40:14 $
--
--          $Revision: #5 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgcommands")

function Definitions()
	DebugMessage("%s -- Defining custom freestore movement perceptions", tostring(Script))

	-- Table which maps heroes to perceptions for systems they like to hang out on when not in active use
	-- The boolean is for whether or not the hero prefers to stay in space, if he has a choice
	-- Generally, this is to find the system where their abilities provide the best defensive or infrastructure bonuses
	CustomUnitPlacement = {
		EMPEROR_PALPATINE_TEAM = {"Is_Home_Planet", false}
		,GRAND_MOFF_TARKIN_TEAM = {"Is_Home_Planet", true}
		,DARTH_TEAM = {nil, false}
		,GENERAL_VEERS_TEAM = {nil, false}
		,BOBA_FETT_TEAM = {nil, true}
		,PIET_TEAM = {nil, true}
		
		,MON_MOTHMA_TEAM = {"Is_Home_Planet", false}
		,HOME_ONE = {nil, true}
		,HAN_SOLO_TEAM = {nil, false}
		,OBI_WAN_TEAM = {nil, false}
		,DROIDS_TEAM = {nil, false}
		,LUKE_TEAM = {nil, true}
	}
	
end

function Find_Custom_Target(object)
	object_type = object.Get_Type()
	object_type_name = object_type.Get_Name()

	unit_entry = CustomUnitPlacement[object_type_name]

	if unit_entry then
		perception = unit_entry[1]
		prefers_space = unit_entry[2]
		if perception then
			target = FindTarget.Reachable_Target(PlayerObject, perception, "Friendly", "No_Threat", 1.0, object)
			DebugMessage("%s -- Found target %s for %s", tostring(Script), tostring(target), object_type_name)
			return target
		elseif prefers_space then
			return Find_Space_Unit_Target(object)
		else
			return Find_Ground_Unit_Target(object)
		end
	else
		DebugMessage("%s -- Error: Type %s not found in CustomUnitPlacement table.", tostring(Script), object_type_name)
	end
end
	

