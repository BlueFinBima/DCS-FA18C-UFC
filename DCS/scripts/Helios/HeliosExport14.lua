--
-- this export.lua is provided by the BlueFinBima Helios project
--
local lfs = require "lfs"
debug = require "debug"
-- os.setlocale("ISO-8859-1","numeric")
local InvokeChildExports = nil
local ThisExport = {}
local PrevExport = {}
PrevExport.LuaExportStart = LuaExportStart
PrevExport.LuaExportStop = LuaExportStop
PrevExport.LuaExportBeforeNextFrame = LuaExportBeforeNextFrame
PrevExport.LuaExportAfterNextFrame = LuaExportAfterNextFrame
PrevExport.LuaExportActivityNextEvent = LuaExportActivityNextEvent

LuaExportStart = nil
LuaExportStop = nil
LuaExportBeforeNextFrame = nil
LuaExportAfterNextFrame = nil
LuaExportActivityNextEvent = nil
Helios = {}
Helios.log = {}
Helios.debug = true
Helios.suppressDCSInfoMessage = false


local scriptDebug = 0   -- local control of tracing
local lInterval = 0.067
-- introspect the script and where it was run from
local thisScript = debug.getinfo(1,'S').short_src:gsub("\\","/"):gsub("//","/"):match('^.*/(.*).([Ll][Uu][Aa]).*"]$')
local thisPath = debug.getinfo(1,'S').short_src:gsub("\\","/"):gsub("//","/"):match('^.*"(.*/)[Ss][Cc][Rr][Ii][Pp][Tt][Ss]/.*.([Ll][Uu][Aa]).*"]$')
local llogFile
local lDebugLogFileName = thisPath .. "Logs/Helios.log"

Helios.log.write = function(caller, message)
    if Helios.debug then
    	if llogFile then
			local lAircraft = Helios.aircraft
			if lAircraft == nil then lAircraft = "*" end
    		llogFile:write(string.format("%s %s: %s\r\n", os.date("%H:%M:%S"), lAircraft .. '|' .. caller, message))
        end
    end
end
if Helios.debug then
	llogFile = assert(io.open(lDebugLogFileName, "w"))
	if llogFile then
		   Helios.log.write(thisScript,"Helios Exports Initialisation")
		   Helios.log.write(thisScript,"Current Directory=" .. lfs.currentdir())
	end
end

InvokeChildExports = function ()
		-- This function attempts to determine the aircraft type which will usually happen on first 
		-- invocation for local aircraft missions, however if the export file gets invoked as part 
		-- of a mission, then there will not be an aircraft so we have to be prepared to find the 
		-- aircraft type at a later time so this function is also called as part of LuaExportStart
		-- * * * We also need to check the best way to get hooked in to missions where the pilot chooses a different aircraft type * * * 
		local DCSInfo = LoGetSelfData()
		if DCSInfo == nil then
			if Helios.suppressDCSInfoMessage == false then
				Helios.log.write(thisScript,string.format("DCSInfo / LoGetSelfData is nil in InvokeChildExports"))
				Helios.suppressDCSInfoMessage = true
			end
				
		else
			local k,v
			for k,v in pairs(DCSInfo) do
					if type(v) == "string" or type(v) == "number" then 
					Helios.log.write(thisScript,"DCSInfo - Key: " .. k .. " Value: " .. v)	
					end
			end
			Helios.aircraft = DCSInfo.Name
			if Helios.Debug then 
			-- invoke all of the Export scripts in the Debug Directory if we're in DEBUG mode
				Helios.log.write(thisScript,string.format("Debug Scripts: " .. Helios.aircraft))
				for file in lfs.dir(thisPath .. "Scripts/Helios/Debug/") do
					if file:match('(.*).([Ll][Uu][Aa])$') ~= nil then 
						Helios.log.write(thisScript,"Mods - Calling " .. thisPath .. "Scripts/Helios/Debug/" .. file)
						log.write('USERMOD.HELIOS',log.INFO,thisScript,"Mods - Calling " .. thisPath .. "Scripts/Helios/Debug/" .. file)
						dofile(thisPath .. "Scripts/Helios/Debug/" .. file)
					end
				end	
			end
			Helios.log.write(thisScript,string.format("Common Scripts: " .. Helios.aircraft))
			-- invoke all of the Export scripts in the common Directory
			for file in lfs.dir(thisPath .. "Scripts/Helios/common/") do
				if file:match('(.*).([Ll][Uu][Aa])$') ~= nil then 
					Helios.log.write(thisScript,"Mods - Calling " .. thisPath .. "Scripts/Helios/common/" .. file)
					log.write('USERMOD.HELIOS',log.INFO,thisScript,"Mods - Calling " .. thisPath .. "Scripts/Helios/common/" .. file)
					dofile(thisPath .. "Scripts/Helios/common/" .. file)
				end
			end		
			-- invoke all of the Export scripts in the Aircraft Directory
			local lAircraftScripts = false  -- if the directory does not exist, then this will be false.  An empty directory should return true due to . and ..
			for file in lfs.dir(thisPath .. "Scripts/Helios/" .. Helios.aircraft .."/") do
				lAircraftScripts = true                                             -- in an empty directory there will still be . and .. so this will be true 
				if file:match('(.*).([Ll][Uu][Aa])$') ~= nil then 
					Helios.log.write(thisScript,"Mods - Calling " .. thisPath .. "Scripts/Helios/" .. Helios.aircraft .. "/" .. file)
					log.write('USERMOD.HELIOS',log.INFO,thisScript,"Mods - Calling " .. thisPath .. "Scripts/Helios/" .. Helios.aircraft .. "/" .. file)
					dofile(thisPath .. "Scripts/Helios/" .. Helios.aircraft .. "/" .. file)
				end
			end
			if not lAircraftScripts then -- no directory exists for the aircraft so run the scripts in the UFO directory 
				for file in lfs.dir(thisPath .. "Scripts/Helios/UFO/") do
					if file:match('(.*).([Ll][Uu][Aa])$') ~= nil then 
						Helios.log.write(thisScript,"Mods - Calling " .. thisPath .. "Scripts/Helios/UFO/" .. file)
						log.write('USERMOD.HELIOS',log.INFO,thisScript,"Mods - Calling " .. thisPath .. "Scripts/Helios/UFO/" .. file)
						dofile(thisPath .. "Scripts/Helios/UFO/" .. file)
					end
				end
			end
		end
	end
LuaExportStart = function()
if scriptDebug > 0 then Helios.log.write(thisScript,"LuaExportStart() invoked.") end
    -- the only reason for code in this function is to catch a later
	-- aircraft selection and invoke the necessary child scripts.
	if Helios.aircraft == nil then
    	Helios.log.write(thisScript,"Invoking child exports from LuaExportStart()")
		InvokeChildExports()
	else
		local DCSInfo = LoGetSelfData()
		if DCSInfo == nil then
			Helios.log.write(thisScript,string.format("DCSInfo / LoGetSelfData is nil in InvokeChildExports"))
		else
			if DCSInfo.Name ~= Helios.aircraft then
				Helios.log.write(thisScript,"Aircraft change from " .. Helios.aircraft .. " to " .. DCSInfo.Name )
				-- if the aircraft name does not match the one that we previously had
				-- then we need to unhook the existing exports and reattach some new ones.
				InvokeChildExports()
				if Helios.aircraft == nil then
					   Helios.log.write(thisScript,"Aircraft remains NIL after InvokeChildExports() called from LuaExportStart().")
				end
			end
		end
	end
	if PrevExport.LuaExportStart then 
		PrevExport.LuaExportStart()
	end
end
LuaExportStop = function()
if scriptDebug > 0 then Helios.log.write(thisScript,"LuaExportStop() invoked.") end
	if PrevExport.LuaExportStop then
		PrevExport.LuaExportStop()
	end
	-- A stop has been issued so we unhook the child routines because if
	-- we restart, it could be with a new aircraft
	LuaExportStart = ThisExport.LuaExportStart
	LuaExportStop = ThisExport.LuaExportStop
	LuaExportAfterNextFrame = ThisExport.LuaExportAfterNextFrame
	LuaExportBeforeNextFrame = ThisExport.LuaExportBeforeNextFrame
	LuaExportActivityNextEvent = ThisExport.LuaExportActivityNextEvent
	Helios.aircraft = nil
end
LuaExportAfterNextFrame = function()
if scriptDebug > 0 then Helios.log.write(thisScript,"LuaExportAfterNextFrame() invoked.") end

	if PrevExport.LuaExportAfterNextFrame then
		PrevExport.LuaExportAfterNextFrame()
	end
end
LuaExportBeforeNextFrame = function()
if scriptDebug > 0 then Helios.log.write(thisScript,"LuaExportBeforeNextFrame() invoked.") end
    -- the only reason for code in this function is to catch a later
	-- aircraft selection and invokve the necessary child scripts.
	if Helios.aircraft == nil then
    	Helios.log.write(thisScript,"Invoking child exports from LuaExportBeforeNextFrame()")
		InvokeChildExports()
		if Helios.aircraft == nil then
		   Helios.log.write(thisScript,"Aircraft remains NIL after InvokeChildExports() called from LuaExportBeforeNextFrame().")
		else 
		   LuaExportStart() -- If we are successful at catching a late Aircraft selection then we need to call LuaExportStart() to allow them to set their UDP connections
		end
	else
	local DCSInfo = LoGetSelfData()
	if DCSInfo == nil then
			Helios.log.write(thisScript,string.format("DCSInfo / LoGetSelfData is nil in InvokeChildExports"))
	else
		if DCSInfo.Name ~= Helios.aircraft then
			-- if the aircraft name does not match the one that we previously had
			-- then we need to unhook the existing exports and reattach some new ones.
			Helios.log.write(thisScript,"Aircraft change from " .. Helios.aircraft .. " to " .. DCSInfo.Name)
			InvokeChildExports()
			if Helios.aircraft == nil then
			   Helios.log.write(thisScript,"Aircraft remains NIL after InvokeChildExports() called from LuaExportBeforeNextFrame().")
			end
		end
	end
end
if PrevExport.LuaExportBeforeNextFrame then 
	PrevExport.LuaExportBeforeNextFrame()
end
end
LuaExportActivityNextEvent = function(t)
	if scriptDebug > 0 then Helios.log.write(thisScript,"LuaExportActivityNextEvent() invoked.") end
	local lt = t + lInterval
    local lot = lt
	if PrevExport.LuaExportActivityNextEvent then
		lt = PrevExport.LuaExportActivityNextEvent(t)
	end
	if  lt > lot then 
        lt = lot -- take the lesser of the next event times
    end
	return lt
end
--
-- save away the stub routines in this script so that they can be restored
-- on exit
--
ThisExport.LuaExportStart = LuaExportStart
ThisExport.LuaExportStop = LuaExportStop
ThisExport.LuaExportAfterNextFrame = LuaExportAfterNextFrame
ThisExport.LuaExportBeforeNextFrame = LuaExportBeforeNextFrame
ThisExport.LuaExportActivityNextEvent = LuaExportActivityNextEvent
--
-- Everything prepared so attempt to set up the scripting
--
Helios.log.write(thisScript,"Script Path: " .. thisPath)

--  Need to find out if we're in VR mode so we run the options file and set a global
Helios.log.write(thisScript,"Loading options from - " .. lfs.writedir():gsub("\\","/") .. "config/options.lua")
dofile(lfs.writedir():gsub("\\","/") .. "config/options.lua")
Helios.vr = options.VR.enable
options = nil
Helios.log.write(thisScript,"VR option = " .. tostring(Helios.vr))

if Helios.aircraft == nil then
	InvokeChildExports()
	if Helios.aircraft == nil then
	   Helios.log.write(thisScript,"Aircraft remains NIL after InvokeChildExports().")
	end
end