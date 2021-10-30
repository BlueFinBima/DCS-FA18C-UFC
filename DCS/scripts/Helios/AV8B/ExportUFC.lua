local lAircraft = "AV8BNA"
local PrevExport = {}
if Helios.aircraft == lAircraft then
PrevExport.LuaExportStart = LuaExportStart
PrevExport.LuaExportStop = LuaExportStop
PrevExport.LuaExportBeforeNextFrame = LuaExportBeforeNextFrame
PrevExport.LuaExportAfterNextFrame = LuaExportAfterNextFrame
PrevExport.LuaExportActivityNextEvent = LuaExportActivityNextEvent

local scriptDebug = 0

local lIpAddress = nil
local lHost = "ufc.home"
local lPort = 9089
local lInterval = 0.067
local lLowTickInterval = 1
local lConn
local lEveryFrameArguments = {}
local lArguments = {[446]="%0.1f", [462]="%0.1f", [463]="%0.1f", [464]="%0.1f", [465]="%0.1f", [466]="%0.1f", [467]="%0.1f", [468]="%0.1f", [469]="%0.1f"}
--local lArguments = {}

local parse_indication
local ProcessHighImportance
local ProcessLowImportance
local FlushData
local SendData
local ProcessArguments
local ResetChangeValues
local ProcessInput
local StrSplit
local round
local check

LuaExportStart = nil
LuaExportBeforeNextFrame = nil
LuaExportAfterNextFrame = nil
LuaExportStop = nil
LuaExportActivityNextEvent = nil

local thisScript = debug.getinfo(1,'S').short_src:gsub("\\","/"):match('^.*/(.*).[Ll][Uu][Aa]"]$')
if Helios.debug then
	if lIpAddress == nil then
		Helios.log.write(thisScript,string.format("intends to communicate on " .. lHost .. ":" .. lPort .. "\n"))
	else
		Helios.log.write(thisScript,string.format("intends to communicate on " .. lIpAddress .. ":" .. lPort .. "\n"))
	end
	Helios.log.write(thisScript,string.format("Aircraft: " .. Helios.aircraft))
	Helios.log.write(thisScript,string.format("Local Mods - Running " .. thisScript))
end

-- Exports.Lua from Helios AV-8B Interface
print("Helios Aircraft Exports: " .. Helios.aircraft .." \n")

ProcessHighImportance = function(mainPanelDevice)
	local li = parseIndication(5)
	if li then
		--Helios.log.write(thisScript,string.format("UFC Dump " .. Heliosdump(li)))
		--Helios.log.write(thisScript,string.format("UFC Comm 1: " .. check(li.ufc_chnl_1_m) .. check(li.ufc_chnl_1_v)))
        SendData(2092, string.format("%2s",check(li.ufc_left_position)))
        SendData(2094, string.format("%7s",check(li.ufc_right_position)))
        --SendData(2095, string.format("%2s",check(li.ufc_chnl_1_m) .. check(li.ufc_chnl_1_v)))
		--SendData(2096, string.format("%2s",check(li.ufc_chnl_2_m) .. check(li.ufc_chnl_2_v)))
        SendData(2095, string.format("%2s",check(li.ufc_chnl_1_v)))
		SendData(2096, string.format("%2s",check(li.ufc_chnl_2_v)))
	end

 	li = parseIndication(6)
	if li then
		SendData(2082, string.format("%-4s",check(li.ODU_Option_1_Text)))
		SendData(2083, string.format("%-4s",check(li.ODU_Option_2_Text)))
		SendData(2084, string.format("%-4s",check(li.ODU_Option_3_Text)))
		SendData(2085, string.format("%-4s",check(li.ODU_Option_4_Text)))
		SendData(2086, string.format("%-4s",check(li.ODU_Option_5_Text)))
		SendData(2087, string.format("%1s",check(li.ODU_Option_1_Slc):gsub(":","|")))  -- ":" is reserved
		SendData(2088, string.format("%1s",check(li.ODU_Option_2_Slc):gsub(":","|")))  -- ":" is reserved
		SendData(2089, string.format("%1s",check(li.ODU_Option_3_Slc):gsub(":","|")))  -- ":" is reserved
		SendData(2090, string.format("%1s",check(li.ODU_Option_4_Slc):gsub(":","|")))  -- ":" is reserved
		SendData(2091, string.format("%1s",check(li.ODU_Option_5_Slc):gsub(":","|")))  -- ":" is reserved
		-- test command 00000000*2096=20:2095=13:2087=!:2088=!:2089=!:2090=!:2091=!:2082=BLUE:2083=FIN :2084=BIMA:2085=2019:2086=test:2094=123.567:2092=~0:2093=-:326=1:336=1:197=1:365=1:196=1: 
	end
end

ProcessLowImportance = function(mainPanelDevice)
end

function Heliosdump(var, depth)
        depth = depth or 0
        if type(var) == "string" then
            return 'string: "' .. var .. '"\n'
        elseif type(var) == "nil" then
            return 'nil\n'
        elseif type(var) == "number" then
            return 'number: "' .. var .. '"\n'
        elseif type(var) == "boolean" then
            return 'boolean: "' .. tostring(var) .. '"\n'
        elseif type(var) == "function" then
            if debug and debug.getinfo then
                fcnname = tostring(var)
                local info = debug.getinfo(var, "S")
                if info.what == "C" then
                    return string.format('%q', fcnname .. ', C function') .. '\n'
                else
                    if (string.sub(info.source, 1, 2) == [[./]]) then
                        return string.format('%q', fcnname .. ', defined in (' .. info.linedefined .. '-' .. info.lastlinedefined .. ')' .. info.source) ..'\n'
                    else
                        return string.format('%q', fcnname .. ', defined in (' .. info.linedefined .. '-' .. info.lastlinedefined .. ')') ..'\n'
                    end
                end
            else
                return 'a function\n'
            end
        elseif type(var) == "thread" then
            return 'thread\n'
        elseif type(var) == "userdata" then
            return tostring(var)..'\n'
        elseif type(var) == "table" then
                depth = depth + 1
                out = "{\n"
                for k,v in pairs(var) do
                        out = out .. (" "):rep(depth*4).. "["..k.."] = " .. Heliosdump(v, depth)
                end
                return out .. (" "):rep((depth-1)*4) .. "}\n"
        else
                return tostring(var) .. "\n"
        end
end

-- for some reason, this causes a failure on my system so commenting it
-- out in the hope that others don't see a problem with it.
-- os.setlocale("ISO-8559-1", "numeric")

-- Simulation id
local lID = string.format("%08x*",os.time())

-- State data for export
local lPacketSize = 0
local lSendStrings = {}
local lLastData = {}

-- Frame counter for non important data
local lTickCount = 0


-- DCS Export Functions
LuaExportStart= function()
if scriptDebug > 0 then Helios.log.write(thisScript,"LuaExportStart() invoked.") end

-- Works once just before mission start.
	
    -- 2) Setup udp sockets to talk to helios
    package.path  = package.path..";.\\LuaSocket\\?.lua"
    package.cpath = package.cpath..";.\\LuaSocket\\?.dll"
   
    socket = require("socket")
    
    lConn = socket.udp()
	lConn:setsockname("*", 0)
	lConn:setoption('broadcast', true)
    lConn:settimeout(.001) -- set the timeout for reading the socket 
	if lIpAddress == nil then -- if we do not have an IP address, perform DNS lookup
		lIpAddress = socket.dns.toip(lHost)
		if lIpAddress == nil then 
			Helios.log.write(thisScript,string.format("Hostname %s could not be resolved, setting to LocalHost\n",lHost))
			lIpAddress = "127.0.0.1"
		else
			Helios.log.write(thisScript,string.format("Socket open %s : %i \n",lIpAddress,lPort))
		end
	end
    if lConn ~= nil then 
		Helios.log.write(thisScript,"LuaExportStart() socket open for communication.")
		SendData(65535,1)
	else
		Helios.log.write(thisScript,"LuaExportStart() socket failed to open.")
	end

    if PrevExport.LuaExportStart then
        PrevExport.LuaExportStart()
    end
end

LuaExportBeforeNextFrame= function()
	if scriptDebug > 0 then Helios.log.write(thisScript,"LuaExportBeforeNextFrame() invoked.") end
	ProcessInput()
    if PrevExport.LuaExportBeforeNextFrame then
       PrevExport.LuaExportBeforeNextFrame()
    end
end

LuaExportAfterNextFrame= function()
	if scriptDebug > 0 then Helios.log.write(thisScript,"LuaExportAfterNextFrame() invoked.") end
    if PrevExport.LuaExportAfterNextFrame  then
        PrevExport.LuaExportAfterNextFrame()
    end

end

LuaExportStop= function()
	if scriptDebug > 0 then Helios.log.write(thisScript,"LuaExportStop() invoked.") end
-- Works once just after mission stop.
    lConn:close()
    if PrevExport.LuaExportStop  then
        PrevExport.LuaExportStop()
    end
end

LuaExportActivityNextEvent= function(t)
	if scriptDebug > 0 then Helios.log.write(thisScript,"LuaExportActivityNextEvent() invoked.") end
	if scriptDebug > 0 and c == nil then Helios.log.write(thisScript,"Connection object is Nil in LuaExportActivityNextEvent().") end
	local lt = t + lInterval
    local lot = lt

	lTickCount = lTickCount + 1

	local lDevice = GetDevice(0)

	if type(lDevice) == "table" then
		lDevice:update_arguments()

		ProcessArguments(lDevice, lEveryFrameArguments)
		ProcessHighImportance(lDevice)

		if lTickCount >= lLowTickInterval then
			ProcessArguments(lDevice, lArguments)
			ProcessLowImportance(lDevice)
			lTickCount = 0
		end

		FlushData()
	end
    if PrevExport.LuaExportActivityNextEvent then
        lot = PrevExport.LuaExportActivityNextEvent(t)  -- if we were given a value then pass it on
    end
    if  lt > lot then 
        lt = lot -- take the lesser of the next event times
    end
    return lt
end

-- Network Functions
FlushData = function()
	if #lSendStrings > 0 then
		local packet = lID .. table.concat(lSendStrings, ":") .. "\n"
		socket.try(lConn:sendto(packet, lIpAddress, lPort))
		lSendStrings = {}
		lPacketSize = 0
	end
end

SendData = function(id, value)
    if scriptDebug > 4 then Helios.log.write(thisScript,"Pre SendData: " .. id .. "=" .. value) end
	if string.len(value) > 3 and value == string.sub("-0.00000000",1, string.len(value)) then
		value = value:sub(2)
	end
	
	if lLastData[id] == nil or lLastData[id] ~= value then
		local data =  id .. "=" .. value
		local dataLen = string.len(data)

		if dataLen + lPacketSize > 576 then
			FlushData()
		end
        if scriptDebug > 4 then Helios.log.write(thisScript,"SendData: " .. data) end

		table.insert(lSendStrings, data)
		lLastData[id] = value	
		lPacketSize = lPacketSize + dataLen + 1
	end	
end

-- Status Gathering Functions
ProcessArguments = function(device, arguments)
	local lArgument , lFormat , lArgumentValue
		
	for lArgument, lFormat in pairs(arguments) do 
		lArgumentValue = string.format(lFormat,device:get_argument_value(lArgument))
		SendData(lArgument, lArgumentValue)
	end
end

-- Data Processing Functions

parseIndication = function(indicator_id)  -- Thanks to [FSF]Ian code
	local ret = {}
	local li = list_indication(indicator_id)
	if li == "" then return nil end
	local m = li:gmatch("-----------------------------------------\n([^\n]+)\n([^\n]*)\n")
	while true do
	local name, value = m()
	if not name then break end
		ret[name] = value
	end
	return ret
end

ProcessInput = function()
    local lInput = lConn:receive()
    local lCommand, lCommandArgs, lDevice, lArgument, lLastValue
    
    if lInput then
	
        lCommand = string.sub(lInput,1,1)
        
		if lCommand == "R" then
            Helios.log.write(thisScript,"Reset Received - " .. lInput)
			ResetChangeValues()
		end
	
		if (lCommand == "C") then
            if scriptDebug > 3 then Helios.log.write(thisScript,"Command Received - " .. lInput) end
			lCommandArgs = StrSplit(string.sub(lInput,2),",")
			lDevice = GetDevice(lCommandArgs[1])
			if type(lDevice) == "table" then
				lDevice:performClickableAction(lCommandArgs[2],lCommandArgs[3])	
			end
		end
    end 
end

-- Helper Functions
StrSplit = function(str, delim, maxNb)
    -- Eliminate bad cases...
    if string.find(str, delim) == nil then
        return { str }
    end
    if maxNb == nil or maxNb < 1 then
        maxNb = 0    -- No limit
    end
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gfind(str, pat) do
        nb = nb + 1
        result[nb] = part
        lastPos = pos
        if nb == maxNb then break end
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

round = function(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

check = function(s)
    if type(s) == "string" then 
        --Helios.log.write(thisScript,"Check: String value" .. s)
        print("Variable type is "..type(s))
        return s
    else
	    return "*"
    end
end
ResetChangeValues = function()
	lLastData = {}
	lTickCount = 10
	SendData(65536,1)
end
end