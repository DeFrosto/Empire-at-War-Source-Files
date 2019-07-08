-- $Id: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UM02_Mission_Script.lua#3 $
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
--              $File: //depot/Projects/StarWars_Expansion/Run/Data/Scripts/GameObject/UM02_Mission_Script.lua $
--
--    Original Author: Jeff_Stewart
--
--            $Author: Jeff_Stewart $
--
--            $Change: 43152 $
--
--          $DateTime: 2006/05/05 11:57:49 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////

require("PGStateMachine")
require("PGSpawnUnits")
require("JGS_FunctionLib") -- added library of commonly used functions

function Definitions()
	-- Object isn't valid at this point so don't do any operations that
	-- would require it.  State_Init is the first chance you have to do
	-- operations on Object
	DebugMessage("%s -- In Definitions", tostring(Script))
	Define_State("State_Init", State_Init);
end


function State_Init(message)
		if message == OnEnter then
			-- This is simply a sound to let the designer know the script is running
			-- Object.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
			
			neutral_player = Find_Player("Neutral")
			empire_player = Find_Player("Empire")
			underworld_player = Find_Player("Underworld")
			tyber_zann = Find_Nearest(Object,"TYBER_ZANN")
			Register_Death_Event(tyber_zann, Tyber_Destroyed)
			urai_fen = Find_Nearest(Object,"URAI_FEN")
			Register_Death_Event(urai_fen, Urai_Destroyed)
			
			pad1 = Find_Hint("REINFORCEMENT_POINT", "pad1")
			pad2 = Find_Hint("REINFORCEMENT_POINT", "pad2")
			pad3 = Find_Hint("REINFORCEMENT_POINT", "pad3")
			pad4 = Find_Hint("REINFORCEMENT_POINT", "pad4")

			-- Register prox events for battle chatter and game events
			chatter1 = Find_Hint("GENERIC_MARKER_LAND","chatterbadfeeling")
			Register_Prox(chatter1, Prox_Chatter_BadFeeling, 60, underworld_player)
			
			startdroids=Find_Hint("GENERIC_MARKER_LAND","startdestroyerdroids")
			Register_Prox(startdroids, Prox_StartDestroyers, 60, underworld_player)

			seescontrols=Find_Hint("GENERIC_MARKER_LAND","seencontrols")
			Register_Prox(seescontrols, Prox_HintAtControls, 60, underworld_player)

			gotcontrols=Find_Hint("GENERIC_MARKER_LAND","factorycontrols")
			Register_Prox(gotcontrols, Prox_UseControls, 60, underworld_player)
			Register_Prox(gotcontrols, Prox_UseControls_Wrong, 60, underworld_player)
			
			droidworksloc=Find_Hint("GENERIC_MARKER_LAND","droidworksloc")
			Register_Prox(droidworksloc, Prox_CapturedDroidWorks, 60, underworld_player)
			
			droidworks=Find_Hint("U_GROUND_DROID_WORKS","droidworks")
			Register_Death_Event(droidworks, DroidWorks_Destroyed)

			-- set up some global mission state flags
			
			MissionPartOneStarted = false
			MissionPartTwoStarted = false
			MissionPartTwoSetup = true
			
			PadOneCaptured = false
			PadTwoCaptured = false
			PadThreeCaptured = false
			PadFourCaptured = false
			
			VictoryCondition_DroidWorks = false
			VictoryCondition_LandingPads = false
			
			DefeatCondition_TyberDead = false
			DefeatCondition_UraiDead = false
			DefeatCondition_DroidWorksDead = false
			
			VictoryStarted = false
			DefeatStarted = false
			
			Create_Thread("CINE_Start_Mission")
		elseif message == OnUpdate then
			--Do Nothing
			if MissionPartTwoStarted then
				if MissionPartTwoSetup then
					MissionPartTwoSetup = false
					Mid_Mission_Setup()
				end
				
				
				if VictoryCondition_DroidWorks and VictoryCondition_LandingPads then
					if not VictoryStarted then
						VictoryStarted = true
						Create_Thread("EndMissionVictory")
					end
				end
			end
			if DefeatCondition_TyberDead or DefeatCondition_UraiDead or DefeatCondition_DroidWorksDead then
				if not DefeatStarted then
					DefeatStarted = true
					Create_Thread("EndMissionDefeat")
				end
			end
		elseif message == OnExit then 
			--Do Nothing
		end
end

-- delay a short time and then start the game
function CINE_Start_Mission()
	Suspend_AI(1)
	Lock_Controls(1)
	--Fade_Screen_Out(1)
	--Sleep(1)
	Letter_Box_In(0)
	Start_Cinematic_Camera()	
	Fade_Screen_In(1)
	Sleep(1)
	
	MessageBox("Insert Game Intro Cinematic Here")

	Sleep(1)
	Fade_Screen_Out(1)
	End_Cinematic_Camera()
	Letter_Box_Out(.5)	
	Lock_Controls(0)
	Suspend_AI(0)
	Sleep(1)
	Fade_Screen_In(1)
	Sleep(1)
	
	MissionPartOneStarted = true
end

function Tyber_Destroyed()
	DefeatCondition_TyberDead = true
end

function Urai_Destroyed()
	DefeatCondition_UraiDead = true
end

function DroidWorks_Destroyed()
	DefeatCondition_DroidWorksDead = true
end

-- triggered when tyber exits the landing pad, to set the mood
function Prox_Chatter_BadFeeling(self_obj, trigger_obj)
	if MissionPartOneStarted then 
		-- CHATTER -- Tyber Zann: "I've got a bad feeling about this."
		if not trigger_obj then
			DebugMessage("Warning: prox received a nil trigger_obj .")
			return
		end
		tyber=Find_Nearest(self_obj, "TYBER_ZANN")
		tyber_distance=self_obj.Get_Distance(tyber)
		if tyber_distance < 200 then 
			tyber.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
			self_obj.Cancel_Event_Object_In_Range(Prox_Chatter_BadFeeling)
		end
	end
end

-- triggered when the player gets close to the droid pens, which will then begin spawning droids
function Prox_StartDestroyers(self_obj, trigger_obj)
	if MissionPartOneStarted then 
		-- Begin producing destroyer droids
		if not trigger_obj then
			DebugMessage("Warning: prox received a nil trigger_obj .")
			return
		end
		closest_infantry = Find_Nearest(self_obj, "TYBER_ZANN")
		closest_infantry.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
	
		droid1 = Find_Hint("GENERIC_MARKER_LAND","ddroid1")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid1.Get_Position(),empire_player)
		droid2 = Find_Hint("GENERIC_MARKER_LAND","ddroid2")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid2.Get_Position(),empire_player)
		droid3 = Find_Hint("GENERIC_MARKER_LAND","ddroid3")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid3.Get_Position(),empire_player)
		droid4 = Find_Hint("GENERIC_MARKER_LAND","ddroid4")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid4.Get_Position(),empire_player)
		droid5 = Find_Hint("GENERIC_MARKER_LAND","ddroid5")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid5.Get_Position(),empire_player)
		droid6 = Find_Hint("GENERIC_MARKER_LAND","ddroid6")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid6.Get_Position(),empire_player)
		droid7 = Find_Hint("GENERIC_MARKER_LAND","ddroid7")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid7.Get_Position(),empire_player)
		droid8 = Find_Hint("GENERIC_MARKER_LAND","ddroid8")
		Create_Generic_Object("UM02_DESTROYER_SPAWNER",droid8.Get_Position(),empire_player)
	
		self_obj.Cancel_Event_Object_In_Range(Prox_StartDestroyers)
		Create_Thread("StartMissionObjective")
	end
end

-- delay a short time and then display the mission objective
function StartMissionObjective()
	Sleep(2)
	Create_Thread("Set_Hint_At_Object",gotcontrols)
end

-- triggered when player gets close to the droid controls for part one of the mission
function Prox_HintAtControls(self_obj, trigger_obj)
	if MissionPartOneStarted then 
		-- CHATTER -- Tyber Zann: "There are the controls!"
		if not trigger_obj then
			DebugMessage("Warning: prox received a nil trigger_obj .")
			return
		end
		closest_infantry = Find_Nearest(self_obj, "TYBER_ZANN")
		closest_infantry.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
		self_obj.Cancel_Event_Object_In_Range(Prox_HintAtControls)
	end
end

-- triggered when the player gets urai at the controls, triggering part two
function Prox_UseControls(self_obj, trigger_obj)
	if MissionPartOneStarted then 
		if not trigger_obj then
			DebugMessage("Warning: prox received a nil trigger_obj .")
			return
		end
		urai=Find_Nearest(self_obj, "URAI_FEN")
		urai_distance=self_obj.Get_Distance(urai)
		if urai_distance < 60 then 
			self_obj.Cancel_Event_Object_In_Range(Prox_UseControls)
			self_obj.Cancel_Event_Object_In_Range(Prox_UseControls_Wrong)
			urai.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
			Create_Thread("Remove_Hint_At_Object",gotcontrols)
			Create_Thread("UraiUsesControls")	
		end
	end
end

function UraiUsesControls()

	urai_fen=Find_Nearest(Object, "URAI_FEN")
	urai_fen.Change_Owner(neutral_player)
	BlockOnCommand(urai_fen.Move_To(gotcontrols))
	Sleep(5)

	-- finds all destroyer droid spawners and deletes them
	unit_list = Find_All_Objects_Of_Type("UM02_DESTROYER_SPAWNER")
	for k, unit in pairs(unit_list) do
		if TestValid(unit) then
			unit.Despawn()
		end
	end

	-- finds all destroyer droids and deactivates them
	droid_list = Find_All_Objects_Of_Type("DESTROYER_DROID")
	for k, unit in pairs(droid_list) do
		if TestValid(unit) then
			newunit = Create_Generic_Object("DESTROYER_DROID",unit.Get_Position(),neutral_player)
			newunit.Teleport_And_Face(unit)
			newunit.Attach_Particle_Effect("HAN_SOLO_TARGET_STUN_EFFECT")
			unit.Take_Damage(10000)
		end
	end
	
	Sleep(1)
	urai_fen.Change_Owner(underworld_player)
	urai_fen.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
	Sleep(2)
	Create_Thread("CINE_Mid_Mission")
end

-- triggered when the player gets tyber close to controls
function Prox_UseControls_Wrong(self_obj, trigger_obj)
	if MissionPartOneStarted then 
		-- CHATTER -- Tyber Zann: "I don't know how to use this thing. Urai get over here."
		if not trigger_obj then
			DebugMessage("Warning: prox received a nil trigger_obj .")
			return
		end
		tyber=Find_Nearest(self_obj, "TYBER_ZANN")
		tyber_distance=self_obj.Get_Distance(tyber)
		if tyber_distance < 60 then 
			tyber.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
			self_obj.Cancel_Event_Object_In_Range(Prox_UseControls_Wrong)
		end
	end
end

-- mid-mission cinematic where jabba lands and gives his best
function CINE_Mid_Mission()
	Suspend_AI(1)
	Lock_Controls(1)
	Fade_Screen_Out(1)
	Sleep(1)
	Letter_Box_In(0)
	Start_Cinematic_Camera()	
	Fade_Screen_In(1)
	Sleep(1)
	
	MessageBox("Insert Mid-Mission Cinematic Here")

	Sleep(1)
	Fade_Screen_Out(1)
	End_Cinematic_Camera()
	Letter_Box_Out(.5)	
	Lock_Controls(0)
	Suspend_AI(0)
	Sleep(1)
	Fade_Screen_In(1)
	Sleep(1)
	
	MissionPartTwoStarted = true
end

function Mid_Mission_Setup()
	-- Destroys all magnetically sealed doors
	unit_list = Find_All_Objects_Of_Type("UM02_MAGNETICALLY_SEALED_DOORWAY")
	for k, unit in pairs(unit_list) do
		if TestValid(unit) then
			unit.Take_Damage(50000)
		end
	end
	
	Create_Thread("MidMissionObjective")
end

function Check_LandingPads()
	reinforce_list = {
		"Pirate_Soldier_Squad",
		"Pirate_Plex_Squad"
	}
	Register_Timer(JabbaGuysLand, 1)
	while not VictoryCondition_LandingPads do
		if pad1.Get_Owner() == underworld_player and not PadOneCaptured then
			--MessageBox("WOOHOO pad one!!!!")
			PadOneCaptured = true
		end
		if pad2.Get_Owner() == underworld_player and not PadTwoCaptured then
			--MessageBox("WOOHOO pad two!!!!")
			PadTwoCaptured = true
		end
		if pad3.Get_Owner() == underworld_player and not PadThreeCaptured then
			--MessageBox("WOOHOO pad three!!!!")
			PadThreeCaptured = true
		end
		if pad4.Get_Owner() == underworld_player and not PadFourCaptured then
			--MessageBox("WOOHOO pad four!!!!")
			PadFourCaptured = true
		end
		if PadOneCaptured and PadTwoCaptured and PadThreeCaptured and PadFourCaptured then
			--MessageBox("WOOHOO ALL CAPTURED!!!!")
			VictoryCondition_LandingPads = true
		end
		Sleep(1)
	end
end

function JabbaGuysLand ()
	if not PadOneCaptured then
		ReinforceList(reinforce_list, pad1, empire_player, false, true, true, Find_And_Attack)
	end
	if not PadTwoCaptured then
		ReinforceList(reinforce_list, pad2, empire_player, false, true, true, Find_And_Attack)
	end
	if not PadThreeCaptured then
		ReinforceList(reinforce_list, pad3, empire_player, false, true, true, Find_And_Attack)
	end
	if not PadFourCaptured then
		ReinforceList(reinforce_list, pad4, empire_player, false, true, true, Find_And_Attack)
	end
	Register_Timer(JabbaGuysLand, 90)
end

function Find_And_Attack(attack_list)
	Create_Thread("Hunt_Underworld",attack_list)
end

-- delay a short time and then display the mission objective
function MidMissionObjective()
	Sleep(2)
	Create_Thread("Set_Hint_At_Object",droidworksloc)
	
	-- this creates a small timer/re-timer system that checks for victory conditions on landing pads
	Create_Thread("Check_LandingPads")
end

-- triggered when the player gets urai at the droid works
function Prox_CapturedDroidWorks(self_obj, trigger_obj)
	if MissionPartTwoStarted then 
		if not trigger_obj then
			DebugMessage("Warning: prox received a nil trigger_obj .")
			return
		end
		urai=Find_Nearest(self_obj, "URAI_FEN")
		urai_distance=self_obj.Get_Distance(urai)
		if urai_distance < 60 then 
			self_obj.Cancel_Event_Object_In_Range(Prox_CapturedDroidWorks)
			urai.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
			Create_Thread("UraiUsesDroidWorks")	
			Create_Thread("Remove_Hint_At_Object",droidworksloc)
		end
	end
end

function UraiUsesDroidWorks()

	urai_fen=Find_Nearest(Object, "URAI_FEN")
	urai_fen.Change_Owner(neutral_player)
	BlockOnCommand(urai_fen.Move_To(droidworksloc))
	Sleep(5)
	
	-- changes control of droid works to underworld player
	droidworks=Find_Hint("U_GROUND_DROID_WORKS","droidworks")
	VictoryCondition_DroidWorks = true
	droidworks.Change_Owner(underworld_player)

	-- finds all droid nodes and captures them
	unit_list = Find_All_Objects_Of_Type("UNDERWORLD_DROID_NODE")
	for k, unit in pairs(unit_list) do
		if TestValid(unit) then
			unit.Change_Owner(underworld_player)
		end
	end

	-- finds all destroyer droids and "activates" them
	droid_list = Find_All_Objects_Of_Type("DESTROYER_DROID")
	for k, unit in pairs(droid_list) do
		if TestValid(unit) then
			unit.Change_Owner(underworld_player)
			unit.Attach_Particle_Effect("HAN_SOLO_TARGET_STUN_EFFECT")
		end
	end
	
	Sleep(1)
	urai_fen.Change_Owner(underworld_player)
	urai_fen.Play_SFX_Event("SFX_UMP_EmpireKesselAlarm")
end


-- delay a short time and then show game has been won VICTORY
function EndMissionVictory()
	Suspend_AI(1)
	Lock_Controls(1)
	Fade_Screen_Out(1)
	Sleep(1)
	Letter_Box_In(0)
	Start_Cinematic_Camera()	
	Fade_Screen_In(1)
	Sleep(1)
	
	MessageBox("Insert Game Victory Cinematic Here")
	MissionPartTwoStarted = true

	Sleep(1)
	Fade_Screen_Out(1)
	End_Cinematic_Camera()
	Letter_Box_Out(.5)	
	Lock_Controls(0)
	Suspend_AI(0)
	Sleep(1)
	--Fade_Screen_In(1)
	--Sleep(1)
end

-- delay a short time and then show game has been lost DEFEAT
function EndMissionDefeat()
	Suspend_AI(1)
	Lock_Controls(1)
	Fade_Screen_Out(1)
	Sleep(1)
	Letter_Box_In(0)
	Start_Cinematic_Camera()	
	Fade_Screen_In(1)
	Sleep(1)
	
	MessageBox("Insert Game Defeat Cinematic Here")
	MissionPartTwoStarted = true

	Sleep(1)
	Fade_Screen_Out(1)
	End_Cinematic_Camera()
	Letter_Box_Out(.5)	
	Lock_Controls(0)
	Suspend_AI(0)
	Sleep(1)
	--Fade_Screen_In(1)
	--Sleep(1)
end
