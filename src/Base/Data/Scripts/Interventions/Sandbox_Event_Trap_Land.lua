-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Sandbox_Event_Trap_Land.lua#4 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Interventions/Sandbox_Event_Trap_Land.lua $
--
--    Original Author: James Yarrow
--
--            $Author: James_Yarrow $
--
--            $Change: 34302 $
--
--          $DateTime: 2005/12/05 18:27:40 $
--
--          $Revision: #4 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")
require("pginterventions")
require("pgcommands")
require("pgspawnunits")

function Definitions()
	Category = "Sandbox_Event_Trap_Land"
	
	dialog = nil
	plot = nil
	event = nil
	
	TaskForce = {
	{
		"MainForce"
		,"TaskForceRequired"
		,"DenyHeroAttach"
	},
	}	
	
	AllowFreeStoreUnits = false	
end

function MainForce_Thread()
		
	MainForce.Set_As_Goal_System_Removable(false)
	
	if GameRandom.Get_Float() < 0.75 then
		--Player got lucky, no trap after all
		WaitForever()	
		ScriptExit()
	end
	
	Sleep(20)
	
	if PlayerObject.Get_Faction_Name() == "REBEL" then	
		unit_list = {	"Rebel_Light_Tank_Brigade", 
						"Rebel_Light_Tank_Brigade", 
						"Rebel_Light_Tank_Brigade", 
						"Rebel_Infantry_Squad",
						"Rebel_Infantry_Squad",						
						"Rebel_Infantry_Squad",											
						"Rebel_Infantry_Squad", }
		objective_name = "TEXT_TAR_EVENT_TRAP_02"
	elseif PlayerObject.Get_Faction_Name() == "EMPIRE" then
		unit_list = {	"Imperial_Heavy_Scout_Squad", 
						"Imperial_Heavy_Scout_Squad", 
						"Imperial_Armor_Group",
						"Imperial_Stormtrooper_Squad",
						"Imperial_Stormtrooper_Squad",						
						"Imperial_Stormtrooper_Squad",												
						"Imperial_Stormtrooper_Squad", }
		objective_name = "TEXT_MON_EVENT_TRAP_02"
	else
		ScriptExit()
	end
		
	Game_Message("TEXT_ENCYCLOPEDIA_HOLOCRON_UPDATED")
	Add_Objective(objective_name, false)	
	reinforce_point = FindTarget(MainForce, "Current_Enemy_Location", "Tactical_Location", 1.0)

	ReinforceList(unit_list, reinforce_point, PlayerObject, true, false, true, nil)
		
	WaitForever()
	
	ScriptExit()
	
end