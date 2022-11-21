if not InspectEquip then
    return
end

local _, _table_ = ...


local IE = InspectEquip
local L = LibStub("AceLocale-3.0"):GetLocale("InspectEquip")

local band = bit.band
local bor = bit.bor
local tinsert = table.insert
local strfind = string.find
local max = math.max

-- check for 5.0+ client, because EJ api was changed
local _retail_ = select(4, GetBuildInfo()) >= 70000


-- Max wait cycles for database update
local MAX_WC = 1 -- 5
local DATA_RECEIVED_WC = 1 -- 7

local newDataReceived
local newDataCycles = 0

-- GUI
local bar, barText
local coUpdate
local bar2

local defaults_meta = {
    global = {
        ClientBuild = nil,
        IEVersion = nil,
        Locale = nil,
        Expansion = nil
    }
}

local defaults_item = {
    global = {
        Zones = {},
        Bosses = {},
        Items = {}
    }
}

function IE:RegisterMetas()
    -- InspectEquip Meta Infomation DBObj
    self.metaDB = LibStub("AceDB-3.0"):New("InspectEquipMetaDB", defaults_meta, true)
end

function IE:AreMetasMatching(clientbuild, ieversion, locale, expansion)
    -- game client build
    if self.metaDB.global.ClientBuild ~= clientbuild then
        return false
    end

    -- addon version
    if self.metaDB.global.IEVersion ~= ieversion then
        return false
    end

    -- game client locale
    if self.metaDB.global.Locale ~= locale then
        return false
    end

    -- game content expansion
    if self.metaDB.global.Expansion ~= expansion then
        return false
    end

    return true
end

function IE:UpdateMetas(clientbuild, ieversion, locale, expansion)
    self.metaDB.global.ClientBuild = clientbuild
    self.metaDB.global.IEVersion = ieversion
    self.metaDB.global.Locale = locale
    self.metaDB.global.Expansion = expansion
end

function IE:RegisterItems()
    -- InspectEquip EJ Item Information DBObj
    self.ejDB = LibStub("AceDB-3.0"):New("InspectEquipItemDB", defaults_item, true)

    -- InspectEquip Manual Item Information DBObj
    self.manDB = _table_.ManualItemSources
end

function IE:LoadDatabase()
    if IE.DatabaseLoaded then
        return
    end

    local _, clientbuild = GetBuildInfo()
    local ieversion = GetAddOnMetadata("InspectEquip", "Version")
    local locale = GetLocale()
    local expansion = GetExpansionLevel()

    if self:AreMetasMatching(clientbuild, ieversion, locale, expansion) then
        IE.DatabaseLoaded = true
    else
        self:ScheduleTimer("CreateEJDatabase", 5)
        self:UpdateMetas(clientbuild, ieversion, locale, expansion)
    end
end

local function createUpdateGUI()

    if not bar then
        bar = CreateFrame("STATUSBAR", nil, UIParent, "TextStatusBar, BackdropTemplate")
    end
    bar:SetWidth(300)
    bar:SetHeight(30)
    bar:SetPoint("CENTER", 0, -100)
    bar:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = 1,
        tileSize = 10,
        edgeSize = 10,
        insets = {
            left = 1,
            right = 1,
            top = 1,
            bottom = 1
        }
    })
    bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    bar:SetBackdropColor(0, 0, 0, 1)
    bar:SetStatusBarColor(0.6, 0.6, 0, 0.4)
    bar:SetMinMaxValues(0, 100)
    bar:SetValue(0)
    bar:Hide()

    if not bar2 then
        bar2 = CreateFrame("STATUSBAR", nil, UIParent, "TextStatusBar, BackdropTemplate")
    end
    bar2:SetWidth(300)
    bar2:SetHeight(10)
    bar2:SetPoint("CENTER", 0, -130)
    bar2:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = 1,
        tileSize = 10,
        edgeSize = 10,
        insets = {
            left = 1,
            right = 1,
            top = 1,
            bottom = 1
        }
    })
    bar2:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    bar2:SetBackdropColor(0, 0, 0, 1)
    bar2:SetStatusBarColor(0, 1, 1, 0.6)
    bar2:SetMinMaxValues(0, 100)
    bar2:SetValue(0)
    bar2:Hide()

    if not barText then
        barText = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    end
    barText:SetPoint("CENTER", bar, "CENTER")
    barText:SetJustifyH("CENTER")
    barText:SetJustifyV("CENTER")
    barText:SetTextColor(1, 1, 1)
    barText:SetText("InspectEquip: " .. L["Updating database..."])

end

local ejDisabled = false
-- local ejToggle = ToggleEncounterJournal

-- this function disables the EJ GUI during update
-- because using the EJ during update will result in an invalid database
-- (other addons may still use the EJ api and possibly destroy the DB that way...)
local function DisableEJ()
    if ejDisabled then
        return
    end
    ejDisabled = true

    -- hide EJ
    if EncounterJournal then
        if EncounterJournal:IsShown() then
            EncounterJournal:Hide()
        end
    end

    -- 2020/12/4 note: ToggleEncounterJournal() is a protected function, so
    -- any attempt to replace it or other functions within it would cause taint
    -- and result in block message & UI lock-in-combat after scanning EJ to build database.
    -- A /reload could restore the protected state of ToggleEncounterJournal().
    -- Use Ace Hook as a workaround.
    -- Idea is to enforce the hiding of EJ UI.

    -- ejToggle = ToggleEncounterJournal
    -- ToggleEncounterJournal = function() end
    IE:SecureHook("ToggleEncounterJournal", function()
        EncounterJournal:Hide()
    end)
    EJMicroButton:Disable()
end

local function EnableEJ()
    if not ejDisabled then
        return
    end
    ejDisabled = false

    -- ToggleEncounterJournal = ejToggle
    IE:Unhook("ToggleEncounterJournal")
    EJMicroButton:Enable()
    EJMicroButton:SetAlpha(1)
end

local function EndUpdate()
    bar:SetScript("OnUpdate", nil)
    bar:Hide()
    bar2:Hide()
    EnableEJ()
    coUpdate = nil
    IE:UnregisterEvent("EJ_LOOT_DATA_RECIEVED")
end

local function UpdateTick()
    if coUpdate then
        -- wait for loot data
        if newDataReceived then -- data received this frame
            newDataCycles = newDataCycles + DATA_RECEIVED_WC
            newDataReceived = false
        end
        if newDataCycles > 0 then
            newDataCycles = newDataCycles - 1
            return
        end
        local ok, msg = coroutine.resume(coUpdate)
        if not ok then
            EndUpdate()
            message("[InspectEquip] Could not update database: " .. msg)
        end
    end
end

local function UpdateBar()
    bar:SetValue(bar:GetValue() + 1)
    coroutine.yield()
end

local function UpdateBar2()
    bar2:SetValue(bar2:GetValue() + 1)
    coroutine.yield()
end

local function GetReverseMapping(baseMap)
    local map = {}
    local id, name
    for id, name in pairs(baseMap) do
        map[name] = id
    end
    return map
end

local function DifficultyToMode(diff, raid)
    if diff == 1 then
        -- 5 normal
        return 1
    elseif diff == 2 then
        -- 5 heroic
        return 2
    elseif diff == 23 then
        -- 5 mythic(dungeons)
        return 4
    elseif diff == 24 then
        -- 5 timewalker
        return 8
    elseif diff == 3 then
        -- 10 normal
        return 16
    elseif diff == 4 then
        -- 25 normal
        return 32
    elseif diff == 5 then
        -- 10 heroic
        return 64
    elseif diff == 6 then
        -- 25 heroic
        return 128
    elseif diff == 7 then
        -- 25 lfr  (Legacy LFRs; everything prior to Siege of Orgrimmar)
        return 256
    elseif diff == 9 then
        -- 40 vanilla raid
        return 512
    elseif diff == 14 then
        -- normal(raids)
        return 1024
    elseif diff == 15 then
        -- heroic(raids)
        return 2048
    elseif diff == 16 then
        -- mythic(raids)
        return 4096
    elseif diff == 17 then
        -- lfr(raids)
        return 8192
    elseif diff == 33 then
        -- raid timewalker
        return 16384
    end
end

local function AddToDB(tempDB, itemID, zoneID, bossID, mode)
    local sources = tempDB[itemID]
    local entry
    if sources then
        for _, entry in pairs(sources) do
            if (entry[1] == zoneID) and (entry[2] == bossID) then
                entry[3] = bor(entry[3], mode)
                return
            end
        end
        tinsert(sources, { zoneID, bossID, mode })
    else
        tempDB[itemID] = { { zoneID, bossID, mode } }
    end
end

local function SaveToDB(tempDB, entryType)
    local itemID, sources, entry
    for itemID, sources in pairs(tempDB) do
        local str = IE.itemDB.global.Items[itemID]
        local isEntry = self.manDB.Items[itemID]

        -- loop through sources we found
        for _, entry in pairs(sources) do
            local entryStr = entryType .. "_" .. entry[1] .. "_" .. entry[3] .. "_" .. entry[2]

            -- skip if already in self.manDB DB
            if not (isEntry and (strfind(";" .. isEntry .. ";", ";" .. entryStr .. ";"))) then
                if str then
                    str = str .. ";" .. entryStr
                else
                    str = entryStr
                end
            end

        end

        IE.itemDB.global.Items[itemID] = str
    end
end

local function GetInstanceCount(isRaid)
    local i = 1
    local id
    repeat
        id = EJ_GetInstanceByIndex(i, isRaid)
        i = i + 1
    until not id
    return i - 2
end

local function GetTotalLootCount()
    bar2:Show()
    local lootCount = 0
    local tierCount = EJ_GetNumTiers()
    local tier, i
    for tier = 1, tierCount do
        if _retail_ then
            EJ_SelectTier(tier)
        end

        local isRaid = false
        while true do
            i = 1
            local insID, insName = EJ_GetInstanceByIndex(i, isRaid)

            while insID do
                EJ_SelectInstance(insID)
                local diff
                local difficulties
                if _retail_ then
                    if isRaid then
                        difficulties = { 3, 4, 5, 6, 7, 9, 14, 15, 16, 17, 33 }
                    else
                        difficulties = { 1, 2, 23, 24 }
                    end
                end
                for _, diff in ipairs(difficulties) do
                    if EJ_IsValidInstanceDifficulty(diff) then
                        EJ_SetDifficulty(diff)
                        lootCount = lootCount + EJ_GetNumLoot()
                    elseif (insID == 741 or insID == 742 or insID == 744) and diff == 9 then
                        EJ_SetDifficulty(diff)
                        lootCount = lootCount + EJ_GetNumLoot()
                    end
                end
                UpdateBar2()
                i = i + 1
                insID, insName = EJ_GetInstanceByIndex(i, isRaid)
            end

            if isRaid then
                break
            else
                isRaid = true
            end
        end
    end
    return lootCount
end

local function UpdateFunction(recursive)
    local _, i, j, tier

    -- reset EJ
    DisableEJ()
    EJ_EndSearch()
    EJ_ClearSearch()
    if _retail_ then
        EJ_ResetLootFilter()
        C_EncounterJournal.ResetSlotFilter()
    else
        EJ_SetClassLootFilter(0)
    end
    newDataReceived = false
    IE:RegisterEvent("EJ_LOOT_DATA_RECIEVED")

    -- init/reset database
    local db = IE.itemDB.global
    db.Zones = {}
    db.Bosses = {}
    db.Items = {}

    -- count total number of instances
    local insCount = 0
    local tierCount = 1
    if _retail_ then
        -- as of 5.x there are multiple tiers (classic, bc, wotlk, cata, mop...)
        tierCount = EJ_GetNumTiers()
        for tier = 1, tierCount do
            local tierName = EJ_GetTierInfo(tier)
            EJ_SelectTier(tier)
            -- IE:Print("Tier: " .. tostring(tier) .. " = " .. tierName)
            local dungeonCount = GetInstanceCount(false)
            local raidCount = GetInstanceCount(true)
            -- IE:Print(" ==> " .. tostring(dungeonCount) .. " Dungeons, " .. tostring(raidCount) .. " Raids")
            insCount = insCount + dungeonCount + raidCount
        end
    else
        local dungeonCount = GetInstanceCount(false)
        local raidCount = GetInstanceCount(true)
        insCount = dungeonCount + raidCount
        -- IE:Print(" ==> " .. tostring(dungeonCount) .. " Dungeons, " .. tostring(raidCount) .. " Raids")
    end

    -- set bar max value
    local startValue = bar:GetValue()
    bar:SetMinMaxValues(0, startValue + insCount + 2)
    bar2:SetMinMaxValues(0, startValue + insCount)

    -- get self.manDB mapping for zone/boss name -> zone/boss id
    local zoneMap = GetReverseMapping(self.manDB.Zones)
    local bossMap = GetReverseMapping(self.manDB.Bosses)

    UpdateBar()

    -- temp db to allow for merging of modes
    local tempDungeonDB = {}
    local tempRaidDB = {}
    local totalLootCount = 0

    local waitCycles = 0
    -- get loot
    for tier = 1, tierCount do
        if _retail_ then
            EJ_SelectTier(tier)
        end

        -- loop through all instances of this tier, dungeons first, then raids
        local isRaid = false
        while true do
            i = 1
            local insID, insName = EJ_GetInstanceByIndex(i, isRaid)
            local tempDB = isRaid and tempRaidDB or tempDungeonDB

            while insID do
                -- get zone id for db
                local zoneID = zoneMap[insName]
                if not zoneID then
                    -- zone is not in db
                    -- zoneID = db.NextZoneID
                    zoneID = insID
                    db.Zones[zoneID] = insName
                    zoneMap[insName] = zoneID
                    -- db.NextZoneID = db.NextZoneID + 1
                end

                EJ_SelectInstance(insID)
                local diff
                local difficulties
                if _retail_ then
                    if isRaid then
                        difficulties = { 3, 4, 5, 6, 7, 9, 14, 15, 16, 17, 33 }
                    else
                        difficulties = { 1, 2, 23, 24 }
                    end
                end
                for _, diff in ipairs(difficulties) do
                    if EJ_IsValidInstanceDifficulty(diff) then
                        newDataCycles = DATA_RECEIVED_WC * 3
                        EJ_SetDifficulty(diff)
                        local mode = DifficultyToMode(diff, isRaid)
                        local n = EJ_GetNumLoot()

                        -- the problem here is that when the items are not in the cache, EJ_GetNumLoot() will not
                        -- return the correct number. it returns the number of items that are cached, which may be
                        -- 0 or a number lower than the correct number. it seems to be impossible to determine the
                        -- correct number without waiting. EJ_LOOT_DATA_RECIEVED events are received, but we don't
                        -- know which event is the last one. also, no EJ_LOOT_DATA_RECIEVED are received if all
                        -- items are already in the cache. so we try to wait a couple of frames until we have a
                        -- number that is somehow stable.
                        -- at the end we count all items again, and if we then have more items, we start all over
                        -- again (at this point, the items are already cached, so the 2nd iteration is faster).

                        -- Not sure but it seems that Blizzard has made EJ pre-loaded and the loot count is stable in LEG.

                        local wc = 0
                        local wcMax = MAX_WC
                        while wc < wcMax do
                            coroutine.yield()
                            wc = wc + 1
                            local nNew = EJ_GetNumLoot()
                            if n ~= nNew then
                                wcMax = wc + MAX_WC
                            end
                            n = nNew
                        end
                        waitCycles = waitCycles + wc

                        totalLootCount = totalLootCount + n

                        -- IE:Print("T=" .. tostring(tier) .. " I=" .. insName .. " D=" .. diff .. " M=" .. mode .. " ! #loot = " .. n .. " [wc = " .. wc .. "]")

                        for j = 1, n do
                            -- get item info
                            -- local itemID, encID, itemName, _, _, _, itemLink = C_EncounterJournal.GetLootInfoByIndex(j)
                            local t = C_EncounterJournal.GetLootInfoByIndex(j)
                            local itemID = t.itemID
                            local encID = t.encounterID
                            local itemName = t.name
                            local itemLink = t.link

                            -- wait until data has arrived
                            -- this doesn't seem necessary
                            -- while not itemID do
                            --	coroutine.yield()
                            --	waitCycles = waitCycles + 1
                            --	itemName, _, _, _, itemID, itemLink, encID = EJ_GetLootInfoByIndex(j)
                            -- end

                            local encName = EJ_GetEncounterInfo(encID)

                            -- if not encName then
                            --	IE:Print("no encounter name! encID = " .. encID)
                            -- end

                            -- get boss id for db
                            local bossID = bossMap[encName]
                            if not bossID then
                                -- boss is not in db
                                -- bossID = db.NextBossID
                                bossID = encID -- unique ID of the encounter
                                db.Bosses[bossID] = encName
                                bossMap[encName] = bossID
                                -- db.NextBossID = db.NextBossID + 1
                            end

                            -- add item to db
                            AddToDB(tempDB, itemID, zoneID, bossID, mode)
                        end
                    elseif (insID == 741 or insID == 742 or insID == 744) and diff == 9 then
                        newDataCycles = DATA_RECEIVED_WC * 3
                        EJ_SetDifficulty(diff)
                        local mode = DifficultyToMode(diff, isRaid)
                        local n = EJ_GetNumLoot()
                        local wc = 0
                        local wcMax = MAX_WC
                        while wc < wcMax do
                            coroutine.yield()
                            wc = wc + 1
                            local nNew = EJ_GetNumLoot()
                            if n ~= nNew then
                                wcMax = wc + MAX_WC
                            end
                            n = nNew
                        end
                        waitCycles = waitCycles + wc

                        totalLootCount = totalLootCount + n
                        for j = 1, n do
                            -- get item info
                            -- local itemID, encID, itemName, _, _, _, itemLink = EJ_GetLootInfoByIndex(j)

                            local t = C_EncounterJournal.GetLootInfoByIndex(j)
                            local itemID = t.itemID
                            local encID = t.encounterID
                            local itemName = t.name
                            local itemLink = t.link

                            local encName = EJ_GetEncounterInfo(encID)

                            -- get boss id for db
                            local bossID = bossMap[encName]
                            if not bossID then
                                -- boss is not in db
                                -- bossID = db.NextBossID
                                bossID = encID -- unique ID of the encounter
                                db.Bosses[bossID] = encName
                                bossMap[encName] = bossID
                                -- db.NextBossID = db.NextBossID + 1
                            end

                            -- add item to db
                            AddToDB(tempDB, itemID, zoneID, bossID, mode)
                        end
                    end
                end

                -- next instance
                UpdateBar()
                i = i + 1
                insID, insName = EJ_GetInstanceByIndex(i, isRaid)
            end

            if isRaid then
                -- done with dungeons + raids, next tier
                break
            else
                -- done with dungeons, now do it again for raids
                isRaid = true
            end
        end
    end

    -- save to db

    SaveToDB(tempDungeonDB, "d")
    SaveToDB(tempRaidDB, "r")

    UpdateBar()

    -- Check loot count
    local lootCountVerification = GetTotalLootCount()

    -- IE:Print("totalLootCount = " .. totalLootCount .. " / lootCountVerification = " .. lootCountVerification)

    -- Check if EJ db is stable
    if totalLootCount < lootCountVerification then
        -- We missed some items, retry...
        -- IE:Print("Restarting update...")
        UpdateFunction((recursive and recursive or 0) + 1)
    else
        -- Done
        EndUpdate()
        -- IE:Print("Wait cycles = " .. waitCycles)
    end

end

function IE:EJ_LOOT_DATA_RECIEVED(event, itemID)
    -- self:Print("LOOT_DATA_RECEIVED [" .. (itemID and itemID or "nil") .. "]")
    newDataReceived = true
end

function IE:CreateEJDatabase()

    if coUpdate then
        -- update already in progress
        return
    end

    -- load encounter journal
    if not IsAddOnLoaded("Blizzard_EncounterJournal") then
        local loaded, reason = LoadAddOn("Blizzard_EncounterJournal")
        if not loaded then
            message("[InspectEquip] Could not load encounter journal: " .. reason)
        end
    end

    -- show progress bar
    createUpdateGUI()
    bar:Show()

    -- start update
    coUpdate = coroutine.create(UpdateFunction)
    local ok, msg = coroutine.resume(coUpdate)
    if ok then
        bar:SetScript("OnUpdate", UpdateTick)
    else
        EndUpdate()
        message("[InspectEquip] Could not update database: " .. msg)
    end

    IE.DatabaseLoaded = true;

end
