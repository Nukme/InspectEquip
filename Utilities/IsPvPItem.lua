--[[
    @param  item    - item link
    @return boolean flag
--]]
if not InspectEquip then
    return
end

local IE = InspectEquip
local L = LibStub("AceLocale-3.0"):GetLocale("InspectEquip")


local seasonAffix = {
    L["Dread"], -- BFA Season 1
    L["Sinister"], -- BFA Season 2
    L["Notorious"], -- BFA Season 3
    L["Corrupted"], -- BFA Season 4
    L["Sinful"], -- Shadowlands Season 1
    L["Unchained"], -- Shadowlands Season 2
    L["Cosmic"], -- Shadowlands Season 3
}

local subAffix = {
    L["Aspirant"], 
    L["Gladiator"],
}

function IE:IsPvPItem(item)
    for i, affix1 in pairs(seasonAffix) do
        for j, affix2 in pairs(subAffix) do
            local itemName = GetItemInfo(item)
            local match1 = string.match(itemName, affix1)
            local match2 = string.match(itemName, affix2)
            if match1 and match2 then
                return true
            end
        end
    end
    return false
end