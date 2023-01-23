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
-- local bar2


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

    -- if not bar2 then
    --     bar2 = CreateFrame("STATUSBAR", nil, UIParent, "TextStatusBar, BackdropTemplate")
    -- end
    -- bar2:SetWidth(300)
    -- bar2:SetHeight(10)
    -- bar2:SetPoint("CENTER", 0, -130)
    -- bar2:SetBackdrop({
    --     bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    --     edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    --     tile = 1,
    --     tileSize = 10,
    --     edgeSize = 10,
    --     insets = {
    --         left = 1,
    --         right = 1,
    --         top = 1,
    --         bottom = 1
    --     }
    -- })
    -- bar2:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
    -- bar2:SetBackdropColor(0, 0, 0, 1)
    -- bar2:SetStatusBarColor(0, 1, 1, 0.6)
    -- bar2:SetMinMaxValues(0, 100)
    -- bar2:SetValue(0)
    -- bar2:Hide()

    if not barText then
        barText = bar:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    end
    barText:SetPoint("CENTER", bar, "CENTER")
    barText:SetJustifyH("CENTER")
    barText:SetJustifyV("MIDDLE")
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
    -- bar2:Hide()
    EnableEJ()
    coUpdate = nil
end

local function UpdateTick()
    if coUpdate then
        -- wait for loot data
        -- if newDataReceived then -- data received this frame
        --     newDataCycles = newDataCycles + DATA_RECEIVED_WC
        --     newDataReceived = false
        -- end
        -- if newDataCycles > 0 then
        --     newDataCycles = newDataCycles - 1
        --     return
        -- end
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
    elseif diff == 8 then
        -- mythic keystone
        return 32768
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
                        difficulties = { 1, 2, 23, 24, 8 }
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

local function GetInstanceLootCount()
    local tier_index = EJ_GetCurrentTier()
    local tier_name = EJ_GetTierInfo(tier_index)

    local instance_name = EJ_GetInstanceInfo()
    local instance_difficulty = EJ_GetDifficulty()
    local instance_lootnum = EJ_GetNumLoot()

    -- if instance_lootnum == 0 then
    --     for x = 1, 100 do
    --         instance_lootnum = EJ_GetNumLoot()
    --         print(x)
    --     end
    -- end

    local loot_index = 1
    local item_info = C_EncounterJournal.GetLootInfoByIndex(loot_index)
    while item_info do
        loot_index = loot_index + 1
        item_info = C_EncounterJournal.GetLootInfoByIndex(loot_index)
    end

    local instance_loot_count = loot_index - 1

    print("Tier: " .. tier_name)
    -- print("ID: " .. EncounterJournal.instanceID)
    print("Instance: " .. instance_name)
    print("Difficulty: " .. instance_difficulty)
    print("API Loot Number: " .. instance_lootnum)
    print("FOR Loot Count: " .. instance_loot_count)

    return instance_lootnum
end

local function ResetEJ()
    EJ_EndSearch()
    EJ_ClearSearch()
    -- if EncounterJornal then
    --     if EncounterJornal.instanceID then
    --         EncounterJornal.instanceID = nil
    --     end
    -- end
    -- EncounterJournalNavBarHomeButton:Click()
    -- NavBar_Reset(EncounterJournal.navBar)
    EJ_ResetLootFilter()
    C_EncounterJournal.ResetSlotFilter()
end

local function GetInstanceTotalCount()
    local instance_count = 0
    local dungeon_count  = 0
    local raid_count     = 0
    local tier_count     = EJ_GetNumTiers()

    for tier = 1, tier_count do
        local tier_name = EJ_GetTierInfo(tier)
        EJ_SelectTier(tier)
        dungeon_count = GetInstanceCount(false)
        raid_count = GetInstanceCount(true)
        instance_count = instance_count + dungeon_count + raid_count
        -- IE:Print("Tier: " .. tier_name)
        -- IE:Print("Total: " .. instance_count)
    end

    return instance_count
end

local function BLIZ_SelectInstance(instance_id)
    -- Codes from Blizzard_EncounterJournal.lua
    -- To make EJ_SelectInstance() work properly
    -- so that EJ_GetNumLoot() could work properly
    EJ_HideNonInstancePanels()
    EncounterJournal.instanceSelect:Hide()
    EncounterJournal.creatureDisplayID = 0
    EncounterJournal.instanceID = instance_id;
    EncounterJournal.encounterID = nil;
    EJ_SelectInstance(instance_id)
    EncounterJournal_LootUpdate();
    EncounterJournal_ClearDetails();
end

local function UpdateEJDBZones(instance_id, instance_name)
    IE.ejDB.global.Zones[instance_id] = instance_name
end

local function UpdateEJDBBosses(encounter_id, encounter_name)
    IE.ejDB.global.Bosses[encounter_id] = encounter_name
end

local function UpdateEJDBItems(instance_id, encounter_id, item_id, diff, is_raid)
    local mode = DifficultyToMode(diff, is_raid)

    local item_source = IE.ejDB.global.Items[item_id]

    if not item_source then
        IE.ejDB.global.Items[item_id] = { { instance_id, encounter_id, mode, is_raid } }
    else
        for _, entry in pairs(item_source) do
            if (entry[1] == instance_id) and (entry[2] == encounter_id) then
                entry[3] = bit.bor(entry[3], mode)
                return
            end
        end
        table.insert(item_source, { instance_id, encounter_id, mode, is_raid })
    end
end

local function ReorganizeEJDBItems()
    local item_table = IE.ejDB.global.Items
    IE.ejDB.global.Items = {}

    for item_id, item_source in pairs(item_table) do
        for _, entry in pairs(item_source) do
            local instance_id = entry[1]
            local encounter_id = entry[2]
            local mode = entry[3]
            local type = entry[4] and "r" or "d"
            local item_str = type .. "_" .. instance_id .. "_" .. mode .. "_" .. encounter_id

            if IE.ejDB.global.Items[item_id] then
                IE.ejDB.global.Items[item_id] = IE.ejDB.global.Items[item_id] .. ";" .. item_str
            else
                IE.ejDB.global.Items[item_id] = item_str
            end
        end
    end

end

local function GetInstanceDifficultyList(is_raid)
    local list
    if is_raid then
        list = { 3, 4, 5, 6, 7, 9, 14, 15, 16, 17, 33 }
    else
        list = { 1, 2, 23, 24, 8 }
    end
    return list
end

local function UpdatePerLoot(instance_id, loot_index, diff, is_raid)
    local t = C_EncounterJournal.GetLootInfoByIndex(loot_index)
    local item_id = t.itemID
    local encounter_id = t.encounterID
    local encounter_name = EJ_GetEncounterInfo(encounter_id)

    UpdateEJDBBosses(encounter_id, encounter_name)
    UpdateEJDBItems(instance_id, encounter_id, item_id, diff, is_raid)
end

local function UpdatePerDifficulty(instance_id, diff, is_raid)
    local loot_count = EJ_GetNumLoot()

    -- loop through all eligible loots
    for loot_index = 1, loot_count do
        UpdatePerLoot(instance_id, loot_index, diff, is_raid)
    end
end

local function UpdatePerInstance(instance_id, is_raid)
    local diff_list = GetInstanceDifficultyList(is_raid)

    -- Exceptions: MC BWL TAQ, since they don't have valid difficulty returns from EJ API
    if instance_id == 741 or instance_id == 742 or instance_id == 744 then
        local diff = 9
        EJ_SetDifficulty(diff)
        UpdatePerDifficulty(instance_id, diff, is_raid)
        return
    end

    -- loop through valid difficulties
    for _, diff in pairs(diff_list) do
        if EJ_IsValidInstanceDifficulty(diff) then
            EJ_SetDifficulty(diff)
            UpdatePerDifficulty(instance_id, diff, is_raid)
        end
    end
end

local function UpdatePerTier(is_raid)
    local instance_count = GetInstanceCount(is_raid)

    -- loop through instances
    for instance_index = 1, instance_count do
        local instance_id, instance_name = EJ_GetInstanceByIndex(instance_index, is_raid)
        BLIZ_SelectInstance(instance_id)
        UpdateEJDBZones(instance_id, instance_name)
        UpdatePerInstance(instance_id, is_raid)

        UpdateBar()
    end
end

local function UpdateEJDB()
    local tier_count = EJ_GetNumTiers()

    -- loop through tiers
    for tier = 1, tier_count do
        EJ_SelectTier(tier)
        UpdatePerTier(false) -- dungeon
        UpdatePerTier(true) -- raid
    end
end

local function ResetEJDB()
    IE.ejDB.global.Items = {}
    IE.ejDB.global.Zones = {}
    IE.ejDB.global.Bosses = {}
end

local function UpdateFunction(recursive)
    DisableEJ()
    ResetEJ()
    ResetEJDB()

    -- set bar max value
    local instance_total_count = GetInstanceTotalCount()
    bar:SetMinMaxValues(0, instance_total_count + 2)
    -- bar2:SetMinMaxValues(0, instance_total_count)

    UpdateBar()

    local totalLootCount = 0

    UpdateEJDB()
    ReorganizeEJDBItems()

    UpdateBar()

    EndUpdate()
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

    IE.DatabaseChecked = true;
end
