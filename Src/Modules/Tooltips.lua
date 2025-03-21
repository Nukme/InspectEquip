if not InspectEquip then
    return
end

local IE = InspectEquip
local L = LibStub("AceLocale-3.0"):GetLocale("InspectEquip")

local band = bit.band
local tinsert = table.insert
local ssub = string.sub
local strformat = string.format

local addSource, addItemData
local unknownIcon = "Interface\\ICONS\\INV_Misc_QuestionMark"

addSource = function(tip, item, source, level)
    local next_field = gmatch(source, "[^_]+")

    local cat = next_field()
    local str = nil
    local subItems = {}
    if cat == "r" or cat == "d" then
        -- raid/dungeon, drops and quest items
        local zone = IE:GetZoneName(tonumber(next_field()))
        if not zone then
        end

        -- if cat == "r" then
        -- str = L["Raid"] .. ": " .. zone
        -- else
        -- str = L["Instances"] .. ": " .. zone
        -- end

        local mode = next_field()
        if mode == "q" then
            -- quest reward
            str = str .. " - " .. L["Quest Reward"]
        else
            -- drop
            mode = tonumber(mode)
            local boss = IE:GetBossName(tonumber(next_field() or 0))

            if zone and boss then
                str = zone .. " - " .. boss
            end
            -- mode
            if cat == "r" then
                -- raid
                if mode > 15 then
                    local sum = 0
                    local modebit = mode
                    while modebit ~= 0 do
                        sum = sum + bit.band(modebit, 1)
                        modebit = bit.rshift(modebit, 1)
                    end
                    if sum == 1 then
                        if mode == 16 then
                            str = str .. " (" .. PLAYER_DIFFICULTY1 .. " 10)"        -- 10 Normal
                        elseif mode == 32 then
                            str = str .. " (" .. PLAYER_DIFFICULTY1 .. " 25)"        -- 25 Normal
                        elseif mode == 64 then
                            str = str .. " (" .. PLAYER_DIFFICULTY2 .. " 10)"        -- 10 Heroic
                        elseif mode == 128 then
                            str = str .. " (" .. PLAYER_DIFFICULTY2 .. " 25)"        -- 25 Heroic
                        elseif mode == 256 then
                            str = str .. " (" .. PLAYER_DIFFICULTY3 .. ")"           -- LFR
                        elseif mode == 512 then
                            str = str .. " (" .. PLAYER_DIFFICULTY1 .. " 40)"        -- 40 Normal
                        elseif mode == 1024 then
                            str = str .. " (" .. PLAYER_DIFFICULTY1 .. ")"           --  Normal
                        elseif mode == 2048 then
                            str = str .. " (" .. PLAYER_DIFFICULTY2 .. ")"           --  Heroic
                        elseif mode == 4096 then
                            str = str .. " (" .. PLAYER_DIFFICULTY6 .. ")"           -- Mythic
                        elseif mode == 8192 then
                            str = str .. " (" .. PLAYER_DIFFICULTY3 .. ")"           -- LFR
                        elseif mode == 16384 then
                            str = str .. " (" .. PLAYER_DIFFICULTY_TIMEWALKER .. ")" -- Timewalker
                        end
                    elseif sum == 2 then
                        local n10 = (band(mode, 16) == 16)
                        local n25 = (band(mode, 32) == 32)
                        local h10 = (band(mode, 64) == 64)
                        local h25 = (band(mode, 128) == 128)
                        local lfr_legacy = (band(mode, 256) == 256)
                        local normal_legacy = (band(mode, 512) == 512)
                        local normal = (band(mode, 1024) == 1024)
                        local heroic = (band(mode, 2048) == 2048)
                        local mythic = (band(mode, 4096) == 4096)
                        local lfr = (band(mode, 8192) == 8192)
                        local timewalker = (band(mode, 16384) == 16384)
                        if not timewalker then
                            local dm = ""
                            if n10 then
                                dm = dm .. ", " .. PLAYER_DIFFICULTY1 .. " 10"
                            end
                            if n25 then
                                dm = dm .. ", " .. PLAYER_DIFFICULTY1 .. " 25"
                            end
                            if h10 then
                                dm = dm .. ", " .. PLAYER_DIFFICULTY2 .. " 10"
                            end
                            if h25 then
                                dm = dm .. ", " .. PLAYER_DIFFICULTY2 .. " 25"
                            end
                            if lfr_legacy then
                                dm = dm .. ", " .. PLAYER_DIFFICULTY3
                            end
                            if normal_legacy then
                                dm = dm .. ", " .. PLAYER_DIFFICULTY1 .. " 40"
                            end
                            if lfr then
                                dm = dm .. ", " .. PLAYER_DIFFICULTY3
                            end
                            if normal then
                                dm = dm .. ", " .. PLAYER_DIFFICULTY1
                            end
                            if heroic then
                                dm = dm .. ", " .. PLAYER_DIFFICULTY2
                            end
                            if mythic then
                                dm = dm .. ", " .. PLAYER_DIFFICULTY6
                            end
                            str = str .. " (" .. ssub(dm, 3) .. ")"
                        end
                    end
                end
            else
                -- dungeon
                if mode == 1 then
                    str = str .. " (" .. PLAYER_DIFFICULTY1 .. ")"           -- Normal
                elseif mode == 2 then
                    str = str .. " (" .. PLAYER_DIFFICULTY2 .. ")"           -- Heroic
                elseif mode == 4 then
                    str = str .. " (" .. PLAYER_DIFFICULTY6 .. ")"           -- Mythic
                elseif mode == 8 then
                    str = str .. " (" .. PLAYER_DIFFICULTY_TIMEWALKER .. ")" -- Timewalker
                elseif mode == 32768 then
                    str = str .. " (" .. L["Mythic Keystone"] .. ")"         -- Mythic Keystone
                end
            end
        end
    elseif cat == "v" or cat == "g" then
        -- vendor item
        if cat == "v" then
            str = L["Vendor"]
        else
            str = L["Guild Vendor"]
        end
        local typ = next_field()

        if typ then
            str = str .. ": "
            while typ do
                if typ == "c" then
                    -- currency
                    local currency = tonumber(next_field())
                    -- leg compatible
                    if currency == 390 or currency == 392 then
                        -- mark of honor : 137642
                        local curName = C_Item.GetItemInfo(137642)
                        local curTexture = select(10, C_Item.GetItemInfo(137642))
                        str = str .. "|T" .. curTexture .. ":0|t " .. " " .. curName .. " "
                    elseif currency == 395 then
                        local curTexture = C_CurrencyInfo.GetCoinIcon(10000)
                        str = str .. "|T" .. curTexture .. ":0|t " .. " " .. " "
                    end
                elseif typ == "i" then
                    -- item
                    local subItemId = tonumber(next_field())
                    local _, subItemLink, _, _, _, _, _, _, _, subItemTexture = C_Item.GetItemInfo(subItemId)
                    if not subItemLink then
                        subItemLink = "#" .. subItemId
                    end
                    if not subItemTexture then
                        subItemTexture = unknownIcon
                    end
                    str = str .. "|T" .. subItemTexture .. ":0|t " .. subItemLink .. " "
                    tinsert(subItems, subItemId)
                elseif typ == "m" then
                    -- money
                    local cost = tonumber(next_field())
                    str = str .. C_CurrencyInfo.GetCoinTextureString(cost) .. " "
                end

                typ = next_field()
            end
        end

        -- currency shortcuts, currently not used
        --[[
	elseif cat == "J" then -- Justice Points
		return addSource(tip, item, "v_c_395_" .. next_field(), level)
	elseif cat == "V" then -- Valor Points
		return addSource(tip, item, "v_c_396_" .. next_field(), level)
	elseif cat == "H" then -- Honor Points
		return addSource(tip, item, "v_c_392_" .. next_field(), level)
	elseif cat == "C" then -- Conquest Points
		return addSource(tip, item, "v_c_390_" .. next_field(), level)
	]]
        --
    elseif cat == "f" then -- Reputation rewards
        str = L["Reputation rewards"]
    elseif cat == "m" then -- Darkmoon Faire
        str = L["Darkmoon Faire"]
    elseif cat == "w" then -- World drops
        str = L["World drops"]
    elseif cat == "c" then -- Crafted
        str = L["Crafted"]
        -- local prof = C_Spell.GetSpellInfo(tonumber(next_field() or 0)).name
        -- if prof then
        --     str = str .. " - " .. prof
        -- end
    elseif cat == "q" then -- Quest Reward
        str = L["Quest Reward"]
    elseif cat == 'p' then -- PvP Reward
        str = L["PvP Reward"]
    elseif cat == 't' then -- Class Tier Set
        local acquisition = next_field()
        if acquisition == "r" or acquisition == "d" then
            -- raid/dungeon, drops and quest items
            local zone = IE:GetZoneName(tonumber(next_field()))

            -- if cat == "r" then
            -- str = L["Raid"] .. ": " .. zone
            -- else
            -- str = L["Instances"] .. ": " .. zone
            -- end

            local mode = next_field()
            if mode == "q" then
                -- quest reward
                str = str .. " - " .. L["Quest Reward"]
            else
                -- drop
                mode = tonumber(mode)
                local boss = IE:GetBossName(tonumber(next_field() or 0))
                if boss then
                    str = zone .. " - " .. boss
                end
                -- mode
                if cat == "r" then
                    -- raid
                    if mode > 15 then
                        local sum = 0
                        local modebit = mode
                        while modebit ~= 0 do
                            sum = sum + bit.band(modebit, 1)
                            modebit = bit.rshift(modebit, 1)
                        end
                        if sum == 1 then
                            if mode == 16 then
                                str = str .. " (" .. PLAYER_DIFFICULTY1 .. " 10)"        -- 10 Normal
                            elseif mode == 32 then
                                str = str .. " (" .. PLAYER_DIFFICULTY1 .. " 25)"        -- 25 Normal
                            elseif mode == 64 then
                                str = str .. " (" .. PLAYER_DIFFICULTY2 .. " 10)"        -- 10 Heroic
                            elseif mode == 128 then
                                str = str .. " (" .. PLAYER_DIFFICULTY2 .. " 25)"        -- 25 Heroic
                            elseif mode == 256 then
                                str = str .. " (" .. PLAYER_DIFFICULTY3 .. ")"           -- LFR
                            elseif mode == 512 then
                                str = str .. " (" .. PLAYER_DIFFICULTY1 .. " 40)"        -- 40 Normal
                            elseif mode == 1024 then
                                str = str .. " (" .. PLAYER_DIFFICULTY1 .. ")"           --  Normal
                            elseif mode == 2048 then
                                str = str .. " (" .. PLAYER_DIFFICULTY2 .. ")"           --  Heroic
                            elseif mode == 4096 then
                                str = str .. " (" .. PLAYER_DIFFICULTY6 .. ")"           -- Mythic
                            elseif mode == 8192 then
                                str = str .. " (" .. PLAYER_DIFFICULTY3 .. ")"           -- LFR
                            elseif mode == 16384 then
                                str = str .. " (" .. PLAYER_DIFFICULTY_TIMEWALKER .. ")" -- Timewalker
                            end
                        elseif sum == 2 then
                            local n10 = (band(mode, 16) == 16)
                            local n25 = (band(mode, 32) == 32)
                            local h10 = (band(mode, 64) == 64)
                            local h25 = (band(mode, 128) == 128)
                            local lfr_legacy = (band(mode, 256) == 256)
                            local normal_legacy = (band(mode, 512) == 512)
                            local normal = (band(mode, 1024) == 1024)
                            local heroic = (band(mode, 2048) == 2048)
                            local mythic = (band(mode, 4096) == 4096)
                            local lfr = (band(mode, 8192) == 8192)
                            local timewalker = (band(mode, 16384) == 16384)
                            if not timewalker then
                                local dm = ""
                                if n10 then
                                    dm = dm .. ", " .. PLAYER_DIFFICULTY1 .. " 10"
                                end
                                if n25 then
                                    dm = dm .. ", " .. PLAYER_DIFFICULTY1 .. " 25"
                                end
                                if h10 then
                                    dm = dm .. ", " .. PLAYER_DIFFICULTY2 .. " 10"
                                end
                                if h25 then
                                    dm = dm .. ", " .. PLAYER_DIFFICULTY2 .. " 25"
                                end
                                if lfr_legacy then
                                    dm = dm .. ", " .. PLAYER_DIFFICULTY3
                                end
                                if normal_legacy then
                                    dm = dm .. ", " .. PLAYER_DIFFICULTY1 .. " 40"
                                end
                                if lfr then
                                    dm = dm .. ", " .. PLAYER_DIFFICULTY3
                                end
                                if normal then
                                    dm = dm .. ", " .. PLAYER_DIFFICULTY1
                                end
                                if heroic then
                                    dm = dm .. ", " .. PLAYER_DIFFICULTY2
                                end
                                if mythic then
                                    dm = dm .. ", " .. PLAYER_DIFFICULTY6
                                end
                                str = str .. " (" .. ssub(dm, 3) .. ")"
                            end
                        end
                    end
                else
                    -- dungeon
                    if mode == 1 then
                        str = str .. " (" .. PLAYER_DIFFICULTY1 .. ")"           -- Normal
                    elseif mode == 2 then
                        str = str .. " (" .. PLAYER_DIFFICULTY2 .. ")"           -- Heroic
                    elseif mode == 4 then
                        str = str .. " (" .. PLAYER_DIFFICULTY6 .. ")"           -- Mythic
                    elseif mode == 8 then
                        str = str .. " (" .. PLAYER_DIFFICULTY_TIMEWALKER .. ")" -- Timewalker
                    end
                end
            end
        elseif acquisition == "tgv" then
            str = L["The Great Vault"]
        elseif acquisition == "cc" then
            str = L["Creation Catalyst"]
        elseif acquisition == "ic" then
            str = L["Inspiration Catalyst"]
        elseif acquisition == "cata" then
            str = L["Catalyst Console"]
        end
    elseif cat == "cc" then -- creation catalyst
        str = L["Creation Catalyst"]
    elseif cat == "ic" then
        str = L["Inspiration Catalyst"]
    elseif cat == "cata" then
        str = L["Catalyst Console"]
    end

    -- add line
    if str then
        local label
        local r, g, b = IE.configDB.global.ttR, IE.configDB.global.ttG, IE.configDB.global.ttB
        if level == 0 then
            label = L["Source"] .. ": "
        else
            local _, subItemLink, _, _, _, _, _, _, _, subItemTexture = C_Item.GetItemInfo(item)
            if subItemTexture then
                label = "    " .. L["Source"] .. "(|T" .. subItemTexture .. ":0|t):"
            else
                label = "    " .. L["Source"] .. "(# " .. item .. "):"
            end
        end
        -- tip:AddDoubleLine(label, str, r, g, b, r, g, b)
        tip:AddLine(label .. str, r, g, b)
    end

    -- add sub item info if available
    if (#subItems > 0) and (level == 0) then
        for _, subItem in pairs(subItems) do
            addItemData(tip, subItem, level + 1)
        end
    end
end

addItemData = function(tip, item, level)
    -- get source information
    local item_data = IE:GetItemData(item)

    -- 20240811 guard for "string expected, got table" error, root cause unknown

    if not item_data then
        return
    end

    if type(item_data) ~= "string" then
        return
    end

    local sourceCount = 0
    local skippedSourceCount = 0
    local maxSourceCount = IE.configDB.global.maxSourceCount

    for entry in gmatch(item_data, "[^;]+") do
        if sourceCount < maxSourceCount then
            addSource(tip, item, entry, level)
        else
            skippedSourceCount = skippedSourceCount + 1
        end
        sourceCount = sourceCount + 1
    end

    if skippedSourceCount > 0 then
        local r, g, b = IE.configDB.global.ttR, IE.configDB.global.ttG, IE.configDB.global.ttB
        tip:AddLine(strformat(L["... and %d other sources"], skippedSourceCount), r, g, b)
    end
end

function IE:AddToTooltip(tip, item)
    if IE.configDB.global.tooltips == false then
        return
    end


    addItemData(tip, item, 0)
end

-- Fix for DF 10.0.2 api change @ 20221117
-- More Fixes @ 20221118

function IE:ParseItem(tooltip, data)
    if not IE.DatabaseChecked then
        return
    end

    if data and data.id and C_Item.GetItemInfo(data.id) then
        -- 20250322
        -- for dev purpose
        -- for k, v in pairs(data) do
        --     print(k, ",", v)
        -- end

        -- 20250322
        -- Try to pass in item hyperlink string first, which would help determine if an item is crafted
        -- If not possible, pass in the item id

        local item_info = nil
        if data.hyperlink then
            item_info = data.hyperlink
        elseif data.guid then
            item_info = C_Item.GetItemLinkByGUID(data.guid)
        else
            item_info = data.id
        end

        IE:AddToTooltip(tooltip, item_info)
        tooltip:Show()
    end
end

function IE:HookTooltips()
    if IE.ItemTooltipHooked then
        return
    end

    TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
        if not data then
            return
        end
        self:ParseItem(tooltip, data)
    end)

    IE.ItemTooltipHooked = true
end
