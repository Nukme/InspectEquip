--[[
    @param  unit    - unitid
    @return noEnchantWarningSlots   - table of enchantment check slots
            Table Format:
                Key     - slots
                Value   - boolean flag
    @return WeaponEnchantOnly   - boolean flag
--]]
local _, _table_ = ...

if not InspectEquip then
    return
end

local IE = InspectEquip

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
        if
            _table_.primaryStats[tostring(curSpecID)] ~= nil and
                _table_.primaryStats[tostring(curSpecID)] == LE_UNIT_STAT_STRENGTH
         then
            noEnchantWarningSlots["HandsSlot"] = true
            noEnchantWarningSlots["FeetSlot"] = false
            noEnchantWarningSlots["WristSlot"] = false
        elseif
            _table_.primaryStats[tostring(curSpecID)] ~= nil and
                _table_.primaryStats[tostring(curSpecID)] == LE_UNIT_STAT_AGILITY
         then
            noEnchantWarningSlots["HandsSlot"] = false
            noEnchantWarningSlots["FeetSlot"] = true
            noEnchantWarningSlots["WristSlot"] = false
        elseif
            _table_.primaryStats[tostring(curSpecID)] ~= nil and
                _table_.primaryStats[tostring(curSpecID)] == LE_UNIT_STAT_INTELLECT
         then
            noEnchantWarningSlots["HandsSlot"] = false
            noEnchantWarningSlots["FeetSlot"] = false
            noEnchantWarningSlots["WristSlot"] = true
        end
        WeaponEnchantOnly = true
    end

    return noEnchantWarningSlots, WeaponEnchantOnly
end
