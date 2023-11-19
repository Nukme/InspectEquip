if not InspectEquip then
    return
end

local _, _table_ = ...

local IE = InspectEquip
local L = LibStub("AceLocale-3.0"):GetLocale("InspectEquip")



local defaults_item = {
    global = {
        Zones = {},
        Bosses = {},
        Items = {}
    }
}



function IE:RegisterItems()
    -- InspectEquip EJ Item Information DBObj
    IE.ejDB = LibStub("AceDB-3.0"):New("InspectEquipEJItemDB", defaults_item, true)

    -- InspectEquip Manual Item Information DBObj
    IE.manDB = _table_.ManualItemDB
end

function IE:RegisterInfoWindow()
    IE.InfoWindow = InspectEquip_InfoWindow
    IE.InfoWindowTitle = InspectEquip_InfoWindowTitle
    IE.InfoWindowAVGIL = InspectEquip_InfoWindowAvgItemLevel

    self:InfoWindowSetParent(InspectFrame)
    IE.InfoWindowTitle:SetText("InspectEquip")
    IE.InfoWindow:Hide()
end

function IE:RegisterFlags()
    IE.DatabaseChecked = false
    IE.ItemTooltipHooked = false
    IE.InspectFrame_UnitChangedHooked = false
    IE.PlayerEntered = false
end

function IE:PLAYER_ENTERING_WORLD()
    IE.PlayerEntered = true
    self:CheckDatabase()
    self:HookTooltips()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function IE:ADDON_LOADED(e, name)
    if name == "Blizzard_InspectUI" then
        if InspectPaperDollFrame then
            self:SecureHookScript(InspectPaperDollFrame, "OnShow", "InspectPaperDollFrame_OnShow")
            self:SecureHookScript(InspectPaperDollFrame, "OnHide", "InspectPaperDollFrame_OnHide")
        end
    end
    if IE.PlayerEntered then
        self:HookTooltips()
    end
end

function IE:CheckDatabase()
    if IE.DatabaseChecked then
        return
    end

    local _, clientbuild = GetBuildInfo()
    local ieversion = C_AddOns.GetAddOnMetadata("InspectEquip", "Version")
    local locale = GetLocale()
    local expansion = GetExpansionLevel()

    if self:AreMetasMatching(clientbuild, ieversion, locale, expansion) then
        IE.DatabaseChecked = true
    else
        self:ScheduleTimer("CreateEJDatabase", 5)
        self:UpdateMetas(clientbuild, ieversion, locale, expansion)
    end
end

function IE:IsPvPItem(item)
    for i, affix1 in pairs(_table_.seasonAffix) do
        for j, affix2 in pairs(_table_.subAffix) do
            local item_name = GetItemInfo(item)
            if item_name then
                local match1 = string.match(item_name, affix1)
                local match2 = string.match(item_name, affix2)
                if match1 and match2 then
                    return true
                end
            end
        end
    end
    return false
end

function IE:GetEnchantmentCheckSlots(unit)
    -- slots with combat related enchants change over expansions
    local expansionLevel = GetExpansionLevel()
    local noEnchantWarningSlots = {
        ["HeadSlot"] = false,
        ["NeckSlot"] = false,
        ["ShoulderSlot"] = false,
        ["BackSlot"] = false,
        ["ChestSlot"] = false,
        ["WristSlot"] = false,
        ["HandsSlot"] = false,
        ["WaistSlot"] = false,
        ["LegsSlot"] = false,
        ["FeetSlot"] = false,
        ["Finger0Slot"] = false,
        ["Finger1Slot"] = false,
        ["Trinket0Slot"] = false,
        ["Trinket1Slot"] = false,
        ["MainHandSlot"] = false,
        ["SecondaryHandSlot"] = false
    }
    local WeaponEnchantOnly = false

    if expansionLevel == 7 then
        -- BFA: Mainhand, Offhand(weapon only), Finger0, Finger1
        noEnchantWarningSlots["MainHandSlot"] = true
        noEnchantWarningSlots["SecondaryHandSlot"] = true
        noEnchantWarningSlots["Finger0Slot"] = true
        noEnchantWarningSlots["Finger1Slot"] = true
        WeaponEnchantOnly = true
    elseif expansionLevel == 8 then
        -- Shadowlands: Mainhand, Offhand(weapon only), Finger0, Finger1, Chest, Cloak, Boots, Gloves, Bracers
        noEnchantWarningSlots["MainHandSlot"] = true
        noEnchantWarningSlots["SecondaryHandSlot"] = true
        noEnchantWarningSlots["Finger0Slot"] = true
        noEnchantWarningSlots["Finger1Slot"] = true
        noEnchantWarningSlots["BackSlot"] = true
        noEnchantWarningSlots["ChestSlot"] = true
        local curSpecID = nil
        if unit == "player" then
            local curSpec = GetSpecialization()
            curSpecID = GetSpecializationInfo(curSpec)
        elseif unit == "target" then
            curSpecID = GetInspectSpecialization(unit)
        end
        if _table_.primaryStats[tostring(curSpecID)] ~= nil and
            _table_.primaryStats[tostring(curSpecID)] == LE_UNIT_STAT_STRENGTH
        then
            noEnchantWarningSlots["HandsSlot"] = true
            noEnchantWarningSlots["FeetSlot"] = false
            noEnchantWarningSlots["WristSlot"] = false
        elseif _table_.primaryStats[tostring(curSpecID)] ~= nil and
            _table_.primaryStats[tostring(curSpecID)] == LE_UNIT_STAT_AGILITY
        then
            noEnchantWarningSlots["HandsSlot"] = false
            noEnchantWarningSlots["FeetSlot"] = true
            noEnchantWarningSlots["WristSlot"] = false
        elseif _table_.primaryStats[tostring(curSpecID)] ~= nil and
            _table_.primaryStats[tostring(curSpecID)] == LE_UNIT_STAT_INTELLECT
        then
            noEnchantWarningSlots["HandsSlot"] = false
            noEnchantWarningSlots["FeetSlot"] = false
            noEnchantWarningSlots["WristSlot"] = true
        end
        WeaponEnchantOnly = true
    elseif expansionLevel == 9 then
        -- Dragonflight: Weapon, Offhand(weapon only), Finger0, Finger1, Chest, Cloak, Boots, Bracers, Legs
        noEnchantWarningSlots["MainHandSlot"] = true
        noEnchantWarningSlots["SecondaryHandSlot"] = true
        noEnchantWarningSlots["Finger0Slot"] = true
        noEnchantWarningSlots["Finger1Slot"] = true
        noEnchantWarningSlots["BackSlot"] = true
        noEnchantWarningSlots["ChestSlot"] = true
        noEnchantWarningSlots["FeetSlot"] = true
        noEnchantWarningSlots["WristSlot"] = true
        noEnchantWarningSlots["LegsSlot"] = true

        WeaponEnchantOnly = true
    end

    return noEnchantWarningSlots, WeaponEnchantOnly
end

function IE:GetItemSourceCategories(itemLink, unit)
    local data = IE:GetItemData(itemLink)
    if data then
        for entry in gmatch(data, "[^;]+") do
            local next_field = gmatch(entry, "[^_]+")
            local cat = next_field()

            if cat == "r" or cat == "d" then
                -- raid/dungeon
                local zone = IE:GetZoneName(tonumber(next_field()))
                local mode = next_field()
                local zoneType
                if cat == "r" then
                    zoneType = L["Raid"]
                else
                    zoneType = L["Instances"]
                end
                return { zoneType, zone }
            elseif cat == "v" or cat == "g" then
                -- vendor
                local mainCat
                if cat == "v" then
                    mainCat = L["Vendor"]
                else
                    mainCat = L["Guild Vendor"]
                end
                local typ = next_field()
                while typ do
                    if typ == "c" then
                        -- currency
                        local currency = tonumber(next_field())
                        next_field()
                        local curName = GetCurrencyInfo(currency)
                        return { mainCat, curName }
                    elseif typ == "i" then
                        -- item
                        next_field()
                    elseif typ == "m" then
                        -- money
                        next_field()
                    end
                    typ = next_field()
                end
                return { mainCat }
            elseif cat == "f" then
                -- reputation rewards
                return { L["Reputation rewards"] }
            elseif cat == "m" then
                -- darkmoon cards
                return { L["Darkmoon Faire"] }
            elseif cat == "w" then
                -- world drops
                return { L["World drops"] }
            elseif cat == "c" then
                -- crafted
                return { L["Crafted"] }
            elseif cat == "q" then
                -- quest rewards
                return { L["Quest Reward"] }
            elseif cat == "p" then
                -- pvp rewards
                return { L["PvP"] }
            elseif cat == "t" then
                -- class tier set
                if IE.configDB.global._StylizeClassTierCategory_ then
                    local className, classFilename = UnitClass(unit)
                    return { "|T" ..
                    _table_.CLASS_ICONS[classFilename] ..
                    ":0|t " .. "|c" .. RAID_CLASS_COLORS[classFilename].colorStr .. L["Class Tier Set"] .. "|r" }
                else
                    return { L["Class Tier Set"] }
                end
            elseif cat == "cc" then
                -- class tier set off-pieces
                return { L["Creation Catalyst"] }
            elseif cat == "ic" then
                -- class tier set off-pieces
                return { L["Inspiration Catalyst"] }
            end
        end
    end
    return nil
end
