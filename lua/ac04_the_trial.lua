{$lua}

--[[

================================================================
==== ACE COMBAT 04: SHATTERED SKIES - THE TRIAL cheat table ====
================================================================

v150924

By death_the_d0g (death_the_d0g @ Twitter and deaththed0g @ Github)
This code was written on Notepad++ and is best viewed with the "word wrap" option off.
TODO:
- Further code improvement.
- Merge "Create Header" and "Create Memory Record" functions into one.
- Convert code to ASM.

]]

setMethodProperty(getMainForm(), "OnCloseQuery", nil) -- Disable CE's save prompt.

[ENABLE]

if syntaxcheck then return end -- Prevent script from running if it was not activated by the user.

------------------+
---- [TABLES] ----+
------------------+

local tbl = {}

-- Bytearray 1: used in [MISCELLANEOUS PLAYER & MISSION PARAMETERS FINDER]. --
-- Bytearray 2: used in [ENTITY LIST]. --

local bytearray_list =
    {
        "40 38 00 00 20 03 00 00 00 A6 8E C8 00 00 80 48 8C 00 46 00 FA 0? 00 00 00 00 00 00 00 00 00 00 FF FF ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? 00 0? 00 00 ?? ?? 00 00 ?? ?? 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0? 00 00 00 00 00 00 00 0? 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0? 00 00 ?? ?? ?0 ?? 00 ?? ?? ?? 00 00 ?0 ?? 98 C9 4D 01 9C C9 4D 01 C8 C9 4D 01 D4 C9 4D 01 DC C9 4D 01 E4 C9 4D 01 F0 C9 4D 01 F8 C9 4D 01 00 CA 4D 01 08 CA 4D 01 10 CA 4D 01 18 CA 4D 01 CC C9 4D 01 D8 C9 4D 01 E0 C9 4D 01 E8 C9 4D 01 F4 C9 4D 01 FC C9 4D 01 00 00 00 00 00 00 ?0 ?? ?0 ?? 0? ?? 00 ?? 00 00 ?? ?? 00 00 00 ?? ?? ?? 00 00 ?0 ?? 00 ?? ?? ?? 00 00 00 00 ?? ?? 00 00 00 ?? ?? ?? 00 00 ?? ?? ?0 ?0 0? ?? 00 ?? 00 00 00 00 00 00 00 ?? ?? ?? 00 00 00 00 ?0 ?? 0? ?? 00 ?? 00 00 ?? ?? 00 00 00 ?? ?? ?? 0? ?? ?? ?? 00 ?? ?? ?? ?? ?? ?? 0? 80 14 4B 01", 
        "A0 ?A 72 01 00 00 00 00 00 00 00 00 00 00 00 00"
    }
    
---------------------+
---- [FUNCTIONS] ----+
---------------------+

-- Create header --

local function create_header(header_name, header_appendtoentry, header_options)

    local header_memory_record_name = getAddressList().createMemoryRecord()
    header_memory_record_name.Description = header_name
    header_memory_record_name.isGroupHeader = true
    
    if header_appendtoentry ~= nil then
    
        header_memory_record_name.appendToEntry(header_appendtoentry)
        
    end
    
    if header_options then
    
        header_memory_record_name.options = "[moHideChildren, moAllowManualCollapseAndExpand, moManualExpandCollapse]"
        
    end
    
    return header_memory_record_name
    
end

-- PCSX2 check --

local function pcsx2_version_check()

    local version_id = nil

    local pcsx2_id_ram_start = nil

    local error_flag = nil

    local process_found = {}

    for processID, processName in pairs(getProcessList()) do

        if processName == "pcsx2.exe" or processName == "pcsx2-qt.exe" then

            process_found[#process_found + 1] = processName
            process_found[#process_found + 1] = processID

        end

    end

    if process_found[1] ~= nil then
    
        if (process_found[2] == getOpenedProcessID()) then
    
            if process_found[1] == "pcsx2.exe" then
    
                version_id = 1
    
                pcsx2_id_ram_start = getAddress(0x20000000)
                
                if readInteger(pcsx2_id_ram_start) == nil then
    
                    error_flag = 3
    
                end
    
            elseif process_found[1] == "pcsx2-qt.exe" then
    
                version_id = 2
    
                pcsx2_id_ram_start = getAddress(readPointer("pcsx2-qt.EEmem"))
                
                if readInteger(pcsx2_id_ram_start) == 0 then
    
                    error_flag = 3
    
                end
            
            end
        
        else
            
            error_flag = 2
            
        end
    
    else
    
        error_flag = 1
    
    end

    return {version_id, pcsx2_id_ram_start, error_flag}

end

-- Memory scanner --

local function memscan_func(scanoption, vartype, roundingtype, input1, input2, startAddress, stopAddress, protectionflags, alignmenttype, alignmentparam, isHexadecimalInput, isNotABinaryString, isunicodescan, iscasesensitive)

    local memory_scan = createMemScan()
    memory_scan.firstScan(scanoption, vartype, roundingtype, input1, input2 ,startAddress ,stopAddress ,protectionflags ,alignmenttype, alignmentparam, isHexadecimalInput, isNotABinaryString, isunicodescan, iscasesensitive)
    memory_scan.waitTillDone()
    local found_list = createFoundList(memory_scan)
    found_list.initialize()
    local address_list = {}
    
    if (found_list ~= nil) then
    
        for i = 0, found_list.count - 1 do
        
            table.insert(address_list, getAddress(found_list[i]))
            
        end
        
    end
    
    found_list.deinitialize()
    found_list.destroy()
    found_list = nil
    
    return address_list
    
end

-- Memory record creator --

local function create_memory_record(base_address, offset_list, vt_list, description_list, append_to_entry)

    for i = 1, #offset_list do
    
        local memory_record = getAddressList().createMemoryRecord()
        memory_record.Description = description_list[i]
        memory_record.setAddress(base_address + offset_list[i])
        
        if type(vt_list[i]) == "table" then
        
            if vt_list [i][1] == vtByteArray then
            
                memory_record.Type = vtByteArray
                memory_record.Aob.Size = vt_list[i][2]
                memory_record.ShowAsHex = true
                
            elseif vt_list [i][1] == vtString then
            
                memory_record.Type = vtString
                memory_record.String.Size = vt_list[i][2]
                
            end
            
        else
        
            memory_record.Type = vt_list[i]
            
        end
        
        memory_record.appendToEntry(append_to_entry)
        
    end
    
    return
    
end

-----------------+
---- [CHECK] ----+
-----------------+

-- Check how many instances of PCSX2 are running, the current version of the emulator and if it has a game loaded. --
-- Set the working RAM region ranges based on emulator version. --

Ac04Trial_pcsx2_id_ram_start = pcsx2_version_check()

if (Ac04Trial_pcsx2_id_ram_start[3] == nil) then

    -- Check if the emulator has the right game loaded. --
    
    local Ac04Trial_gameCheck = memscan_func(soExactValue, vtByteArray, nil, "DB 0F 49 40 9A 99 99 3E 9A 99 99 BE 00 D8 56 47 AC C5 A7 3B CD CC 1C 40 9A 99 39 40 89 56 22 42 ", nil, Ac04Trial_pcsx2_id_ram_start[2] + 0x200000, Ac04Trial_pcsx2_id_ram_start[2] + 0x4000000, "", 2, "0", true, nil, nil, nil)
    
    if #Ac04Trial_gameCheck ~= 0 then
        
        -- look up the bytearrays needed by the script. --
        
        for i = 1, #bytearray_list do
        
            local found = memscan_func(soExactValue, vtByteArray, nil, bytearray_list[i], nil, Ac04Trial_pcsx2_id_ram_start[2] + 0x700000, Ac04Trial_pcsx2_id_ram_start[2] + 0x1f00000, "", 1, "0", true, nil, nil, nil)
            
            if #found ~= nil then
            
                tbl[#tbl + 1] = found[1]
                
            end
            
        end
        
        -- If the search function returned the right amount of results then proceed with the rest of the script. --
        
        if #tbl == 2 then
        
            Ac04Trial_table_active = true
            
        else
        
            showMessage("<< Unable to activate this script (memscan_func error). >>")
            
        end
            
    else
    
        showMessage("<< This script is not compatible with the game you're currently emulating. >>")
        
    end
    
else

    if Ac04Trial_pcsx2_id_ram_start[3] == 1 then
    
        showMessage("<< Attach this table to a running instance of PCSX2 first. >>")
        
    elseif Ac04Trial_pcsx2_id_ram_start[3] == 2 then
    
        showMessage("<< Multiple instances of PCSX2 were detected. Only one is needed. >>")
        
    elseif Ac04Trial_pcsx2_id_ram_start[3] == 3 then
    
        showMessage("<< PCSX2 has no ISO file loaded. >>")
        
    end
    
end

----------------+
---- [MAIN] ----+
----------------+

-- Stuff to do if the CHECK section returns TRUE. --

if Ac04Trial_table_active then

    -- [MAIN HEADER] --
    -- Create a main header to attach child memory records. --
    
    Ac04Trial_main_header = create_header("AC04 The Trial", nil, nil)
    
    -- [MISCELLANEOUS MEMORY ADDRESSES] --
    -- Create sub headers/memory records to display addresses and values. --
    
    local ac04_misc_memory_addresses = create_header("Miscellaneous memory addresses", Ac04Trial_main_header, nil)
    
    -- Check if the player is currently in a mission. If not, create the "Jump to sequence" entry only, else create the complete set of entries. --
    
    if (readBytes(Ac04Trial_pcsx2_id_ram_start[2] + 0x51E768) <= 5 and readBytes(Ac04Trial_pcsx2_id_ram_start[2] + 0x51E768) >= 0) then
    
        create_memory_record(Ac04Trial_pcsx2_id_ram_start[2], {0x51E768}, {vtByte}, {"Jump to sequence"}, ac04_misc_memory_addresses)
        
    else
    
        local offset_list = {0x2FADB0, 0x30EF04, 0x203C51, 0x203C52, 0x203C22}
        local description_list = {"BGM ID", "SE volume", "Pause flag", "Aspect ratio flag", "Force 2P mode HUD"}
        local vt_list = {vtByte, vtSingle, vtByte, vtByte, vtByte, vtByte}
        
        create_memory_record(Ac04Trial_pcsx2_id_ram_start[2], offset_list, vt_list, description_list, ac04_misc_memory_addresses)
        
        -- [REPLAY CAMERA-RELATED ADDRESSES] --
        -- Same as above. --
        
        local ac04_replay_camera_memory_addresses = create_header("Replay camera-related addresses", Ac04Trial_main_header, true)
        
        local offset_list = {0x2FB128, 0x2FA654, 0x51E640}
        local description_list = {"Focus camera on NPC ID", "Camera type", "PAUSE graphics flag"}
        local vt_list = {vtByte, vtByte, vtByte}
        
        create_memory_record(Ac04Trial_pcsx2_id_ram_start[2], offset_list, vt_list, description_list, ac04_replay_camera_memory_addresses)
        
        -- [MISCELLANEOUS PLAYER & MISSION PARAMETERS FINDER] --
        -- Same as above. --
        
        local Ac04Trial_misc_values_header = create_header("Miscellaneous player & mission parameters finder", Ac04Trial_main_header, true)
        
        local offset_list = {0x0, 0x4, 0x8, 0xC, 0x30, 0x34, 0x2E5, 0x304, 0x306, 0x307, 0x31F}
        local description_list = {"Starting time limit", "Score rank", "RTB line placement", "Engagement area size", "Timer 1", "Timer 2", "Camera view type", "Current GUN amount", "Current MISSILE amount", "Current Special Weapon amount", "Current Special Weapon ID"}
        local vt_list = {vtDword, vtDword, vtSingle, vtSingle, vtDword, vtDword, vtByte, vtWord, vtByte, vtByte, vtByte}
        
        create_memory_record(tbl[1], offset_list, vt_list, description_list, Ac04Trial_misc_values_header)
        
        -- Freeze mission timer and set max GUN/missile/SpW ammo. --
        
        AddressList.getMemoryRecordByDescription("Timer 1").Active = true -- Timer      
        writeBytes(tbl[1] + 0x304, 65535) -- GUN
        writeBytes(tbl[1] + 0x306, 255) -- Missile
        writeBytes(tbl[1] + 0x307, 255) -- SpW
    
        -- [ENTITY LIST] --
        -- Same as above but do it for every entity found in the current mission. --
        
        local ac04_entity_list_header = create_header("Entity list", Ac04Trial_main_header, true)
        local entity_iff_tag_list = {"A-10A", "A-6E", "AA ARTY", "AAGUN", "ACV", "AEGIS", "AH-64", "ANTENNA", "AV-8B", "B-2", "B767", "BARRACKS", "BATTERY", "BATTLESHIP", "BRIDGE", "C-17", "CARRIER", "CH-47D", "CRANE", "CRUISER", "CTRL. CRUISER", "DESTROYER", "E-767", "EF2000", "F/A-18C", "F/A-18E", "F-117", "F-14A", "F-14D", "F-15C", "F-15E", "F-15S", "F-16C", "F-2", "F-20", "F-22A", "F-4E", "F-5E", "FUEL TANK", "GAS TANK", "GUNBOAT", "H.Q.", "HANGAR", "HOWITZER", "JAMMER", "KA-25A", "KA-50", "KC-10", "KFIR-C7", "LDG. SHIP", "LVTP", "MI-24D", "MICV", "MIG-1.44", "MIG-21", "MIG-29S", "MIG-31", "MIR. 2000", "MLRS", "MSSL", "MSSL. BOAT", "OIL FIELD", "PILLBOX", "PLANT", "PWR. PLANT", "RADAR", "RAFALE", "ROCKET", "S-37", "SAM", "SGARRIER", "SMOKESTACK", "SOLARPANEL", "STLTH. SHIP", "STONEHENGE", "STORAGE", "SU-35", "SU-37", "SUB. BASE", "SUBMARINE", "SUBSTATION", "SUPPLY SHIP", "TANK", "TANKER", "TORNADO", "TROOPSHIP", "TU-160", "TU-95", "TUGBOAT", "U-2", "TOWER", "WIG", "X-32 JSF", "XB-70", "C-130", "SR-71", "V-22", "RAH-66", "POST", "GUN", "GEN", "TANAGER", "AGATE", "TARANIS", "GEODE", "GNEISS", "KOLGA", "LAZULI", "FENRIS", "BELUGA", "HERNE", "TAISCH", "THIASSI", "RAVEN", "CONDOR", "MAGPIE", "SPARROW", "FINCH", "ORIOLE", "GEOFON", "ARK", "CREIDHNE", "BWLF-PI", "BWLF-NU", "701", "702", "FAYE", "SMIRNOVA", "GUNN", "RIGAUX", "WANG", "VAISALA", "KWEE", "DE VICO", "MRKOS", "CIFFREO", "TUTTLE", "LEVY", "BIELA", "HALLEY", "URATA", "TEMPEL", "ABELL", "NEUJMIN", "OLMSTEAD", "YELLOW"}
        local base_address = tbl[2] + 0x10
        local offset_list = {0x10, 0x14, 0x18, 0x20, 0x24, 0x28, 0x58, 0x5B, 0x5F, 0x70, 0x72, 0x76, 0x78}
        local description_list = {"X coordinate", "Z coordinate ", "Y coordinate", "Pitch value ", "Yaw value", "Roll value", "Entity allegiance (0 for FRIEND, 1 for ENEMY)", "Entity damage flag", "Is entity enabled?", "Entity hitpoints (HP) value", "Entity score value ", "Entity display TGT box ", "Entity IFF tag ID value"}
        local vt_list = {vtSingle, vtSingle, vtSingle, vtSingle, vtSingle, vtSingle, vtByte, vtByte, vtByte, vtWord, vtWord, vtByte, vtByte}
        
        -- Read the entity ID's value as a key and create a header using the string retrieved from the "entity_iff_tag_list" list as its name. --
        
        for i = 1, 45 do
        
            local iff_tag_value = readShortInteger(base_address + offset_list[13])
            
            if iff_tag_value < 1 or iff_tag_value > 146 then
                    
                -- Entity objects that do not have any ID string associated to them will receive custom ones. --
                
                if i == 1 then
                
                    entity_name = "PLAYER"
                    
                else
                
                    entity_name = "UNKNOWN"
                    
                end
                
            else
            
                entity_name = tostring(entity_iff_tag_list[iff_tag_value])
                
            end
            
            local ac04_entity_subheader = create_header(entity_name, ac04_entity_list_header, true)
            
            -- Create entity list's memory records. --
            
            for i = 1, #offset_list do
            
                create_memory_record(base_address, {offset_list[i]}, {vt_list[i]}, {description_list[i]}, ac04_entity_subheader)
                
            end
            
            base_address = base_address + 0x90
            
        end
        
    end
    
end

[DISABLE]

if syntaxcheck then return end -- Prevent script from running if it was not activated by the user. --

-- On exit destroy created memory records and clear tables. --

if Ac04Trial_table_active then

    Ac04Trial_table_active = nil
    for k, v in pairs(Ac04Trial_pcsx2_id_ram_start) do Ac04Trial_pcsx2_id_ram_start[k] = nil end
    
    getAddressList().getMemoryRecordByDescription("AC04 The Trial").destroy()
    
end
