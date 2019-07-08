-- $Id: //depot/Projects/StarWars/Run/Data/Scripts/Library/PGDebug.lua#3 $
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
--              $File: //depot/Projects/StarWars/Run/Data/Scripts/Library/PGDebug.lua $
--
--    Original Author: Brian Hayes
--
--            $Author: Steve_Copeland $
--
--            $Change: 32792 $
--
--          $DateTime: 2005/11/19 14:56:25 $
--
--          $Revision: #3 $
--
--/////////////////////////////////////////////////////////////////////////////////////////////////


function DebugEventAlert(event, params)
	message = tostring(Script) .. ": handled event " .. tostring(event)
	
	function AppendParameter(ival, parameter)
		message = message .. "\nParameter " .. tostring(ival) .. ": " .. tostring(parameter)
	end
	
	table.foreachi(params, AppendParameter)
	
	MessageBox(message)
end

function MessageBox(...)
	_MessagePopup(string.format(unpack(arg)))
end

function ScriptMessage(...)
	_ScriptMessage(string.format(unpack(arg)))
end

function DebugMessage(...)
	_ScriptMessage(string.format(unpack(arg)))
end

function OutputDebug(...)
	_OuputDebug(string.format(unpack(arg)))
end

function ScriptError(...)
	outstr = string.format(unpack(arg))
	_OuputDebug(outstr .. "\n")
	_ScriptMessage(outstr)
	outstr = DumpCallStack()
	_OuputDebug(outstr .. "\n")
	_ScriptMessage(outstr)
	ScriptExit()
end

function DebugPrintTable(unit_table)
	DebugMessage("%s -- unit table contents:", tostring(Script))
	for key, obj in pairs(unit_table) do
		DebugMessage("%s -- \t\t** unit:%s", tostring(Script), tostring(obj))
	end
end
