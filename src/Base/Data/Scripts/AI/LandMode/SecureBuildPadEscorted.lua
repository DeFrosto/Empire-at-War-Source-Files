-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/SecureBuildPadEscorted.lua#8 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/AI/LandMode/SecureBuildPadEscorted.lua $
--
--    Original Author: Steve Copeland
--
--            $Author: James_Yarrow $
--
--            $Change: 36065 $
--
--          $DateTime: 2006/01/06 15:57:55 $
--
--          $Revision: #8 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("pgevents")

function Definitions()

	Category = "Secure_Contestable_Escorted"
	IgnoreTarget = true
	TaskForce = 
	{
		{
			"MainForce"
			--,"Infantry | AT_AT_Walker = 1" -- AT-ATs can secure a point by dropping infantry
			,"Infantry = 1"
		},
		{
			"EscortForce"		
			,"Infantry | Vehicle | LandHero = 1,3"
			--,"EscortForce"
		}
	}

	AllowEngagedUnits = false
	
	wait_for_build_time = 30
	hold_good_ground_time = 60
end

function MainForce_Thread()
	BlockOnCommand(MainForce.Produce_Force())
	
	QuickReinforce(PlayerObject, AITarget, MainForce, EscortForce)
	
	-- move to contestables
	difficulty = PlayerObject.Get_Difficulty()
	if difficulty == "Hard" then
		BlockOnCommand(MainForce.Move_To(AITarget, MainForce.Get_Self_Threat_Max()))
	else
		BlockOnCommand(MainForce.Attack_Move(AITarget, MainForce.Get_Self_Threat_Max()))
	end
	
	MainForce.Set_As_Goal_System_Removable(false)

	if TestValid(Target) then
        if (EvaluatePerception("Is_Build_Pad", PlayerObject, Target) == 1) then

			-- Build pads may have an existing enemy structure than needs to be removed
			-- Note that the enemy player can build structures late or rebuild destroyed structures, thus the need to repeat.
			structure = Target.Get_Build_Pad_Contents()
			if (structure == nil) or
				(TestValid(structure) and PlayerObject.Get_Faction_Name() ~= structure.Get_Owner().Get_Faction_Name()) then
				
					-- Look for nearby "good ground"
					nearest_good_ground_indicator = Find_Nearest(Target, "Prop_Good_Ground_Area")
					if nearest_good_ground_indicator and (Target.Get_Distance(nearest_good_ground_indicator) < 75) then
					
						-- Move into position and let autonomous idle behavior defend the location for a while.
						BlockOnCommand(MainForce.Move_To(nearest_good_ground_indicator))
						Sleep(hold_good_ground_time)
						MainForce.Set_As_Goal_System_Removable(true)
					else
					
						-- Attack any structure that might be there
						if TestValid(structure) then
							BlockOnCommand(MainForce.Attack_Target(structure))
						end
		
						-- Guard the spot to give another plan the chance to can something here
						-- Wait indefinately, if this is a refinery pad and we have no refineries.
						if EvaluatePerception("Is_Refinery_Pad", PlayerObject, Target) == 1 and
									EvaluatePerception("Num_Refineries", PlayerObject) == 0 then
							wait_for_build_time = -1
						end
						--MessageBox("%s, %s--Guarding for %d", tostring(Script), tostring(Target), wait_for_build_time)
						BlockOnCommand(MainForce.Guard_Target(AITarget), wait_for_build_time, Target_Has_Structure)
					end
				
			end

		else
		
			-- Stand guard so that we can retain usage of this structure
			MainForce.Guard_Target(AITarget)
			Sleep(10)
		end
	end

	MainForce.Set_Plan_Result(true)

	ScriptExit()
end

-- Does the plan's original Target have a friendlystructure on it?
function Target_Has_Structure()
	if TestValid(Target) then
		structure = Target.Get_Build_Pad_Contents()
        if TestValid(structure) then
			--MessageBox("%s, %s-- Target has structure, abandonning guard.", tostring(Script), tostring(Target))
			return true
		end
	end
	return false
end

-- Override default handling, which will kill the plan
function MainForce_Original_Target_Owner_Changed(tf, old_player, new_player)
end


function EscortForce_Thread()
	BlockOnCommand(EscortForce.Produce_Force())
	
	QuickReinforce(PlayerObject, AITarget, EscortForce, MainForce)

	-- Give an initial order to put the escorts in a state that the Escort function expects
	EscortForce.Guard_Target(MainForce)

	EscortAlive = true
	while EscortAlive do
		Escort(EscortForce, MainForce)
	end
end

function EscortForce_No_Units_Remaining()
	EscortAlive = false
end

-- Override default handling, which will kill the plan
function EscortForce_Original_Target_Owner_Changed(tf, old_player, new_player)
end

