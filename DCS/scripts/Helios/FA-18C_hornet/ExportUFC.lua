local lAircraft = "FA-18C_hornet"
local PrevExport = {}
if Helios.aircraft == lAircraft then
PrevExport.LuaExportStart = LuaExportStart
PrevExport.LuaExportStop = LuaExportStop
PrevExport.LuaExportBeforeNextFrame = LuaExportBeforeNextFrame
PrevExport.LuaExportAfterNextFrame = LuaExportAfterNextFrame
PrevExport.LuaExportActivityNextEvent = LuaExportActivityNextEvent

local scriptDebug = 0

local lIpAddress = nil           -- ip address of UFC if no DNS
local lHost = "HornetUFC.local"  -- hostname of the UFC if you have DNS resolution
local lPort = 9089 
local lInterval = 0.067
local lLowTickInterval = 1
local lConn
--local EveryFrameArguments = {[298]="%0.1f", [299]="%0.1f", [300]="%0.1f", [301]="%0.1f", [302]="%0.1f", [303]="%0.1f", [304]="%0.1f", [305]="%0.1f", [306]="%0.1f", [307]="%0.1f", [308]="%0.1f", [309]="%0.1f", [13]="%0.1f", [10]="%0.1f", [15]="%0.1f", [16]="%0.1f", [17]="%0.1f", [18]="%0.1f", [19]="%0.1f", [20]="%0.1f", [21]="%0.1f", [22]="%0.1f", [23]="%0.1f", [24]="%0.1f", [25]="%0.1f", [29]="%0.1f", [26]="%0.1f", [31]="%0.1f", [32]="%0.1f", [38]="%0.1f", [39]="%0.1f", [40]="%0.1f", [41]="%0.1f", [33]="%0.1f", [34]="%0.1f", [35]="%0.1f", [36]="%0.1f", [37]="%0.1f", [152]="%0.1f", [154]="%0.1f", [156]="%0.1f", [158]="%0.1f", [160]="%0.1f", [166]="%0.1f", [165]="%0.1f", [167]="%0.1f", [163]="%0.1f", [164]="%0.1f", [162]="%0.1f", [1]="%0.1f", [2]="%0.1f", [3]="%0.1f", [47]="%0.1f", [48]="%0.1f", [45]="%0.1f", [44]="%0.1f", [294]="%0.1f", [376]="%0.1f", [137]="%0.1f", [4]="%0.1f", [5]="%0.1f", [6]="%0.1f", [460]="%0.1f", [461]="%0.1f", [462]="%0.1f", [464]="%0.1f", [465]="%0.1f", [466]="%0.1f", [467]="%0.1f", [810]="%0.1f", [463]="%0.1f", [468]="%0.1f", [469]="%0.1f", [273]="%0.1f", [274]="%0.1f", [270]="%0.1f", [271]="%0.1f", [267]="%0.1f", [268]="%0.1f", [264]="%0.1f", [265]="%0.1f", [520]="%0.1f", [516]="%0.1f", [287]="%.4f", [286]="%.4f", [288]="%0.1f", [289]="%0.1f", [290]="%0.1f", [205]="%.4f", [206]="%.4f", [209]="%0.1f", [207]="%.4f", [208]="%.4f", [225]="%.4f", [217]="%.4f", [285]="%.4f", [242]="%0.2f", [310]="%.4f", [311]="%.4f", [400]="%.4f", [401]="%.4f"}
--local Arguments = {[345]="%.3f", [346]="%1d", [349]="%1d", [348]="%0.1f", [347]="%0.1f", [234]="%0.1f", [139]="%0.1f", [138]="%0.1f", [470]="%1d", [504]="%.3f", [295]="%0.1f", [296]="%1d", [404]="%0.1f", [402]="%0.1f", [403]="%0.1f", [379]="%0.1f", [378]="%0.1f", [336]="%1d", [332]="%1d", [333]="%1d", [334]="%1d", [335]="%1d", [409]="%0.1f", [410]="%0.1f", [381]="%0.1f", [382]="%0.1f", [383]="%0.1f", [384]="%0.1f", [454]="%0.1f", [455]="%0.1f", [456]="%0.1f", [457]="%0.1f", [368]="%1d", [375]="%0.1f", [377]="%1d", [331]="%1d", [369]="%0.1f", [226]="%0.1f", [228]="%1d", [229]="%1d", [238]="%0.1f", [233]="%0.1f", [293]="%0.1f", [241]="%0.1f", [240]="%0.1f", [340]="%0.1f", [341]="%0.1f", [344]="%0.1f", [343]="%0.1f", [342]="%0.1f", [453]="%1d", [43]="%1d", [42]="%1d", [510]="%1d", [511]="%0.1f", [513]="%0.1f", [514]="%1d", [260]="%1d", [575]="%1d", [338]="%.3f", [337]="%.3f", [339]="%0.1f", [237]="%0.1f", [413]="%.3f", [414]="%.3f", [415]="%.3f", [419]="%0.1f", [418]="%.3f", [417]="%.3f", [416]="%0.1f", [14]="%1d", [239]="%0.1f", [365]="%0.1f", [366]="%.3f", [411]="%0.1f", [412]="%1d", [405]="%0.1f", [408]="%0.1f", [451]="%.3f", [407]="%.3f", [406]="%.3f", [297]="%0.1f", [452]="%0.1f", [505]="%.3f", [506]="%.3f", [494]="%0.1f", [458]="%1d", [459]="%1d", [49]="%0.1f", [50]="%1d", [258]="%0.1f", [153]="%1d", [155]="%1d", [157]="%1d", [159]="%1d", [161]="%1d", [235]="%.1f", [236]="%0.1f", [135]="%0.1f", [46]="%1d", [30]="%1d", [11]="%1d", [27]="%1d", [140]="%0.1f", [141]="%.3f", [142]="%0.1f", [143]="%.3f", [144]="%0.1f", [145]="%.3f", [146]="%.3f", [147]="%0.1f", [148]="%0.1f", [51]="%0.1f", [52]="%.3f", [53]="%.3f", [54]="%1d", [55]="%1d", [56]="%1d", [57]="%1d", [58]="%1d", [59]="%1d", [60]="%1d", [61]="%1d", [62]="%1d", [63]="%1d", [64]="%1d", [65]="%1d", [66]="%1d", [67]="%1d", [68]="%1d", [69]="%1d", [70]="%1d", [72]="%1d", [73]="%1d", [75]="%1d", [76]="%0.1f", [77]="%.3f", [78]="%.3f", [79]="%1d", [80]="%1d", [81]="%1d", [82]="%1d", [83]="%1d", [84]="%1d", [85]="%1d", [86]="%1d", [87]="%1d", [88]="%1d", [89]="%1d", [90]="%1d", [91]="%1d", [92]="%1d", [93]="%1d", [94]="%1d", [95]="%1d", [96]="%1d", [97]="%1d", [98]="%1d", [203]="%.3f", [177]="%1d", [179]="%1d", [180]="%1d", [182]="%1d", [183]="%1d", [184]="%1d", [185]="%1d", [186]="%1d", [187]="%1d", [188]="%1d", [189]="%1d", [190]="%1d", [191]="%1d", [192]="%1d", [193]="%1d", [194]="%1d", [195]="%1d", [196]="%1d", [197]="%1d", [198]="%1d", [199]="%1d", [200]="%1d", [201]="%1d", [202]="%1d", [312]="%1d", [313]="%1d", [168]="%1d", [169]="%1d", [170]="%1d", [171]="%1d", [172]="%1d", [173]="%1d", [174]="%.3f", [440]="%0.1f", [443]="%0.1f", [128]="%1d", [129]="%1d", [130]="%1d", [131]="%1d", [132]="%1d", [133]="%1d", [134]="%1d", [100]="%1d", [101]="%1d", [102]="%1d", [103]="%1d", [106]="%1d", [111]="%1d", [112]="%1d", [113]="%1d", [114]="%1d", [115]="%1d", [116]="%1d", [117]="%1d", [118]="%1d", [119]="%1d", [120]="%1d", [121]="%1d", [122]="%1d", [99]="%1d", [110]="%1d", [107]="%0.1f", [108]="%.3f", [123]="%.3f", [109]="%.3f", [124]="%.3f", [126]="%.3f", [357]="%.3f", [358]="%.3f", [359]="%.3f", [360]="%.3f", [361]="%.3f", [362]="%.3f", [363]="%.3f", [364]="%.3f", [350]="%0.1f", [351]="%0.1f", [356]="%0.1f", [355]="%0.1f", [354]="%1d", [353]="%0.1f", [352]="%0.1f", [444]="%0.1f", [445]="%.3f", [446]="%0.1f", [447]="%0.1f", [230]="%1d", [373]="%0.1f", [374]="%0.1f", [277]="%1d", [275]="%1d", [272]="%1d", [269]="%1d", [266]="%1d", [263]="%.3f", [262]="%.3f", [261]="%0.1f", [216]="%.3f", [380]="%1d", [517]="%0.1f", [515]="%1d", [224]="%.3f", [292]="%.1f", [291]="%.3f", [215]="%1d"}
local lEveryFrameArguments = {}
local lArguments = {}

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

-- Exports.Lua from Helios F/A-18C Interface
print("Helios Aircraft Exports: " .. Helios.aircraft .." \n")

ProcessHighImportance = function(mainPanelDevice)
	-- Send Altimeter Values	
	--SendData(2051, string.format("%0.4f;%0.4f;%0.4f", mainPanelDevice:get_argument_value(220), mainPanelDevice:get_argument_value(219), mainPanelDevice:get_argument_value(218)))
	--SendData(2059, string.format("%0.2f;%0.2f;%0.3f", mainPanelDevice:get_argument_value(223), mainPanelDevice:get_argument_value(222), mainPanelDevice:get_argument_value(221)))		
	-- Calcuate HSI Value
	-- SendData(2029, string.format("%0.2f;%0.2f;%0.4f", mainPanelDevice:get_argument_value(29), mainPanelDevice:get_argument_value(30), mainPanelDevice:get_argument_value(31)))


--    --IFEI textures
--    local IFEI_Textures_table = {}
--    for i=1,16 do IFEI_Textures_table[i] = 0 end
--
--
--    -- getting the IFEI data
--    local li = parse_indication(5)  -- 5 for IFEI
--    if li then
--        --IFEI data
--
--        SendData("2052", string.format("%s",check(li.txt_BINGO)))
--        SendData("2053", string.format("%s",check(li.txt_CLOCK_H)))
--        SendData("2054", string.format("%s",check(li.txt_CLOCK_M)))
--        SendData("2055", string.format("%s",check(li.txt_CLOCK_S)))
--        SendData("2056", string.format("%s",check(li.txt_DD_1)):gsub(":","|"))
--        SendData("2057", string.format("%s",check(li.txt_DD_2)):gsub(":","|"))
--        SendData("2058", string.format("%s",check(li.txt_DD_3)):gsub(":","|"))
--        SendData("2060", string.format("%s",check(li.txt_DD_4)):gsub(":","|"))
--        SendData("2061", string.format("%s",check(li.txt_FF_L)))
--        SendData("2062", string.format("%s",check(li.txt_FF_R)))
--        SendData("2063", string.format("%s",check(li.txt_FUEL_DOWN)))
--        SendData("2064", string.format("%s",check(li.txt_FUEL_UP)))
--        SendData("2065", string.format("%s",check(li.txt_OilPress_L)))
--        SendData("2066", string.format("%s",check(li.txt_OilPress_R)))
--        SendData("2067", string.format("%s",check(li.txt_RPM_L)))
--        SendData("2068", string.format("%s",check(li.txt_RPM_R)))
--        SendData("2069", string.format("%s",check(li.txt_TEMP_L)))
--        SendData("2070", string.format("%s",check(li.txt_TEMP_R)))
--        --SendData("2071", string.format("%s",check(li.txt_TIMER_S)))
--        --SendData("2072", string.format("%s",check(li.txt_TIMER_M)))
--        --SendData("2073", string.format("%s",check(li.txt_TIMER_H)))
--        --SendData("2074", string.format("%s",check(li.txt_Codes)))
--        --SendData("2075", string.format("%s",check(li.txt_SP)))
--        --SendData("2076", string.format("%s",check(li.txt_DrawChar)))
--        --SendData("2077", string.format("%s",check(li.txt_T)))
--        --SendData("2078", string.format("%s",check(li.txt_TimeSetMode)))
--
--        --IFEI textures
--
----      IFEI_Textures_table[1]  =check_num(li.RPMTexture)
----      IFEI_Textures_table[2]  =check_num(li.TempTexture)
----      IFEI_Textures_table[3]  =check_num(li.FFTexture )
----      IFEI_Textures_table[4]  =check_num(li.NOZTexture)
----      IFEI_Textures_table[5]  =check_num(li.OILTexture)
----      IFEI_Textures_table[6]  =check_num(li.BINGOTexture)
----      IFEI_Textures_table[7]  =check_num(li.LScaleTexture)
----      IFEI_Textures_table[8]  =check_num(li.RScaleTexture)
----      IFEI_Textures_table[9]  =check_num(li.L0Texture)
----      IFEI_Textures_table[10] =check_num(li.R0Texture)
----      IFEI_Textures_table[11] =check_num(li.L50Texture)
----      IFEI_Textures_table[12] =check_num(li.R50Texture)
----      IFEI_Textures_table[13] =check_num(li.L100Texture)
----      IFEI_Textures_table[14] =check_num(li.R100Texture)
----      IFEI_Textures_table[15] =check_num(li.LPointerTexture)
----      IFEI_Textures_table[16] =check_num(li.RPointerTexture)
--
----
--    end
--
	-- getting the UFC data
	local li = parse_indication(6)  -- 6 for UFC
	if li then
--      SendData("2098", string.format("%s",li))
			
        --SendData("2080", string.format("%s",check(li.UFC_MainDummy)))
        --SendData("2081", string.format("%s",check(li.UFC_mask)))
        SendData("2082", string.format("%s",check(li.UFC_OptionDisplay1)))
        SendData("2083", string.format("%s",check(li.UFC_OptionDisplay2)))
        SendData("2084", string.format("%s",check(li.UFC_OptionDisplay3)))
        SendData("2085", string.format("%s",check(li.UFC_OptionDisplay4)))
        SendData("2086", string.format("%s",check(li.UFC_OptionDisplay5)))
        SendData("2087", string.format("%1s",check(li.UFC_OptionCueing1)):gsub(":","|"))
        SendData("2088", string.format("%1s",check(li.UFC_OptionCueing2)):gsub(":","|"))
        SendData("2089", string.format("%1s",check(li.UFC_OptionCueing3)):gsub(":","|"))
        SendData("2090", string.format("%1s",check(li.UFC_OptionCueing4)):gsub(":","|"))
        SendData("2091", string.format("%1s",check(li.UFC_OptionCueing5)):gsub(":","|"))
        SendData("2092", string.format("%2s",check(li.UFC_ScratchPadString1Display)))
        SendData("2093", string.format("%2s",check(li.UFC_ScratchPadString2Display)))
        SendData("2094", string.format("%7s",check(li.UFC_ScratchPadNumberDisplay)))
        SendData("2095", string.format("%2s",check(li.UFC_Comm1Display)))
        SendData("2096", string.format("%2s",check(li.UFC_Comm2Display)))
	end
	
	--SendData("2098", string.format("%s", table.concat(IFEI_Textures_table,", ") ) )    -- IFEI Textures

end

ProcessLowImportance = function(mainPanelDevice)
	-- Get Radio Frequencies
	--local lUHFRadio = GetDevice(54)
	--SendData(2000, string.format("%7.3f", lUHFRadio:get_frequency()/1000000))
	-- ILS Frequency
	--SendData(2251, string.format("%0.1f;%0.1f", mainPanelDevice:get_argument_value(251), mainPanelDevice:get_argument_value(252)))
	-- TACAN Channel
	--SendData(2263, string.format("%0.2f;%0.2f;%0.2f", mainPanelDevice:get_argument_value(263), mainPanelDevice:get_argument_value(264), mainPanelDevice:get_argument_value(265)))

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
		Helios.log.write(thisScript,string.format("Socket open %s : %i \n",lIpAddress,lPort))
	end
    if lConn ~= nil then 
		Helios.log.write(thisScript,"LuaExportStart() socket open for communication.")
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

parse_indication = function(indicator_id)  -- Thanks to [FSF]Ian code
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
end
end