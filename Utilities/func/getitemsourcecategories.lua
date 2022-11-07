--[[
    @param  itemLink    - item link
    @param  unit    - unitid
    @return {L[""]} - localized category name

--]]
local _, _table_ = ...

if not InspectEquip then
    return
end

local IE = InspectEquip
local L = LibStub("AceLocale-3.0"):GetLocale("InspectEquip")


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
            end
        end
    end
    return nil
end
