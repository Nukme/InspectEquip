--[[
    @param  item    - item link
    @return boolean flag
--]]
if not InspectEquip then
    return
end

local _, _table_ = ...

local IE = InspectEquip

function IE:IsPvPItem(item)
    for i, affix1 in pairs(_table_.seasonAffix) do
        for j, affix2 in pairs(_table_.subAffix) do
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
