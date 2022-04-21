-- InspectEquip
-- Original Author: emelio_
-- Maintainer: Nukme

local _, _table_ = ...

InspectEquip =
    LibStub("AceAddon-3.0"):NewAddon("InspectEquip", "AceConsole-3.0", "AceHook-3.0", "AceTimer-3.0", "AceEvent-3.0")
local L = LibStub("AceLocale-3.0"):GetLocale("InspectEquip")
local IE = InspectEquip
local IS = InspectEquip_ItemSources -- > ItemSources.lua
local WIN = InspectEquip_InfoWindow -- > InfoWindow.xml
local TITLE = InspectEquip_InfoWindowTitle
local AVGIL = InspectEquip_InfoWindowAvgItemLevel

local ItemUpgradeInfo = LibStub("LibItemUpgradeInfo-1.0")

local slots = {
    "HeadSlot",
    "NeckSlot",
    "ShoulderSlot",
    "BackSlot",
    "ChestSlot",
    "WristSlot",
    "HandsSlot",
    "WaistSlot",
    "LegsSlot",
    "FeetSlot",
    "Finger0Slot",
    "Finger1Slot",
    "Trinket0Slot",
    "Trinket1Slot",
    "MainHandSlot",
    "SecondaryHandSlot"
} -- TabardSlot, ShirtSlot

local noEnchantWarningSlots = {}
local WeaponEnchantOnly = false

local lines = {}
local numlines = 0
local curline = 0
local curUnit = nil
local curUnitName = nil
local curUser = nil
local curGUID = nil
local cached = false

local headers = {}
local numheaders = 0

local yoffset = -40
local hooked = false
local autoHidden = false

-- local origInspectUnit

local tonumber = tonumber
local gmatch = string.gmatch
local tinsert = table.insert
local tsort = table.sort
local band = bit.band
-- local Examiner = Examiner

-- local _,_,_,gameToc = GetBuildInfo()

local tooltipTimer = nil
local retryTimer = nil

function IE:OnInitialize()
    self.configDB = LibStub("AceDB-3.0"):New("InspectEquipConfigDB", _table_.defaults, true)
    LibStub("AceConfig-3.0"):RegisterOptionsTable("InspectEquip", _table_.options)
    InspectEquip.ConfigPanel = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("InspectEquip")
    self:RegisterChatCommand(
        "inspectequip",
        function()
            InterfaceOptionsFrame_OpenToCategory(InspectEquip.ConfigPanel)
        end
    )
    local version = GetAddOnMetadata("InspectEquip", "Version")
    local versionText = "|cFF808080 " .. version .. "|r"
    InspectEquip.Version = InspectEquip.ConfigPanel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    InspectEquip.Version:SetPoint("TOPRIGHT", InspectEquip.ConfigPanel, "TOPRIGHT", -15, -15)
    InspectEquip.Version:SetText(versionText)

    self:SetParent(InspectFrame)
    WIN:Hide()
    TITLE:SetText("InspectEquip")

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("ADDON_LOADED")

    -- self:InitLocalDatabase()
end

function IE:OnEnable()
    -- origInspectUnit = origInspectUnit or InspectUnit
    -- InspectUnit = function(...) IE:InspectUnit(...) end
    if PaperDollFrame then
        -- self:Print("PaperDollFrame Hooked.")
        self:SecureHookScript(PaperDollFrame, "OnShow", "PaperDollFrame_OnShow")
        self:SecureHookScript(PaperDollFrame, "OnHide", "PaperDollFrame_OnHide")
    end
    if GearManagerDialog then -- 4.0
        self:SecureHookScript(GearManagerDialog, "OnShow", "GearManagerDialog_OnShow")
        self:SecureHookScript(GearManagerDialog, "OnHide", "GearManagerDialog_OnHide")
    end
    if OutfitterFrame then
        self:SecureHookScript(OutfitterFrame, "OnShow", "GearManagerDialog_OnShow")
        self:SecureHookScript(OutfitterFrame, "OnHide", "GearManagerDialog_OnHide")
    end
    self:RegisterEvent("UNIT_INVENTORY_CHANGED")
    self:RegisterEvent("INSPECT_READY")
end

function IE:OnDisable()
    -- InspectUnit = origInspectUnit
    if hooked then
        hooked = false
        self:Unhook("InspectFrame_UnitChanged")
    end
    self:UnhookAll()
    self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
    self:UnregisterEvent("INSPECT_READY")
    self:CancelAllTimers()
    WIN:Hide()
end

local entered = false

function IE:PLAYER_ENTERING_WORLD()
    entered = true
    self:ScheduleTooltipHook()
    self:InitLocalDatabase()
    self:UnregisterEvent("PLAYER_ENTERING_WORLD")
end

function IE:ADDON_LOADED(e, name)
    if name == "Blizzard_InspectUI" then
        -- self:Print("InspectUI Loaded.")
        if InspectPaperDollFrame then
            -- self:Print("InspectPaperDollFrame Hooked.")
            self:SecureHookScript(InspectPaperDollFrame, "OnShow", "InspectPaperDollFrame_OnShow")
            self:SecureHookScript(InspectPaperDollFrame, "OnHide", "InspectPaperDollFrame_OnHide")
        end
    end
    if entered then
        self:ScheduleTooltipHook()
    end
end

-- Ugly hack, but some addons override the OnTooltipSetItem handler on
-- ItemRefTooltip, breaking IE. Using this timer, IE hopefully hooks after them.
function IE:ScheduleTooltipHook()
    if IE.configDB.profile.tooltips then
        if tooltipTimer then
            self:CancelTimer(tooltipTimer, true)
        end
        tooltipTimer = self:ScheduleTimer("HookTooltips", 3)
    end
end

function IE:SetParent(frame)
    WIN:SetParent(frame)
    WIN:ClearAllPoints()
    -- if not (frame == Examiner) then
    WIN:SetPoint("TOPLEFT", frame, "TOPRIGHT", 5, 0)
    -- else
    --	WIN:SetPoint("TOPLEFT", frame, "TOPRIGHT", -25, -13)
    -- end
end

function IE:NewLine()
    local row = CreateFrame("Frame", nil, WIN)
    row:SetHeight(12)
    row:SetWidth(200)

    local txt = row:CreateFontString(nil, "ARTWORK")
    txt:SetJustifyH("LEFT")
    txt:SetFontObject(GameFontHighlightSmall)
    txt:SetPoint("TOPLEFT", row, "TOPLEFT", 0, 0)
    row.text = txt

    row.yoffset = yoffset
    IE:SetLinePadding(row, 0)

    yoffset = yoffset - 15
    numlines = numlines + 1
    lines[numlines] = row

    row:EnableMouse(true)
    row:SetScript("OnEnter", IE.Line_OnEnter)
    row:SetScript("OnLeave", IE.Line_OnLeave)
    row:SetScript("OnMouseDown", IE.Line_OnClick)
end

function IE:SetLinePadding(line, padding)
    local padWidth = select(2, line.text:GetFont()) * padding * 0.6

    line:SetPoint("TOPLEFT", WIN, "TOPLEFT", 15 + padWidth, line.yoffset)
    line.padLeft = padWidth
end

function IE:ResetDisplay()
    for i = 1, numlines do
        lines[i].text:SetText("")
        IE:SetLinePadding(lines[i], 0)
        lines[i]:Hide()
    end
    curline = 0
end

function IE:AddLine(padding, text, link, item)
    curline = curline + 1
    if curline > numlines then
        self:NewLine()
    end
    local line = lines[curline]
    line.link = link
    line.item = item
    line.text:SetText(text)
    line:SetWidth(line.text:GetStringWidth())
    IE:SetLinePadding(line, padding)
    line:SetFrameLevel(WIN:GetFrameLevel() + 1)
    line:Show()
end

function IE:FullUnitName(name, realm)
    if realm and realm ~= "" then
        return name .. "-" .. realm
    else
        return name
    end
end

-- function IE:GetExaminerCache(unit)
--	local name, realm = UnitName(unit)
--	return Examiner_Cache and Examiner_Cache[self:FullUnitName(name, realm)]
-- end

--[[
function IE:InspectUnit(unit)
	origInspectUnit(unit)

	if IE.configDB.profile.inspectWindow then
		self:SetParent(InspectFrame)
		WIN:Hide()
		if not hooked and InspectFrame_UnitChanged then
			hooked = true
			self:SecureHook("InspectFrame_UnitChanged")
		end

		self:Inspect(unit)
	end
end
--]]
function IE:InspectFrame_UnitChanged()
    if InspectFrame.unit and IE.configDB.profile.inspectWindow then
        self:InspectUnit(InspectFrame.unit)
    else
        WIN:Hide()
    end
end

------------ TAINT REWORK ------------------
function IE:InspectPaperDollFrame_OnShow()
    if IE.configDB.profile.inspectWindow then
        self:SetParent(InspectFrame)
        WIN:Hide()
        if not hooked and InspectFrame_UnitChanged then
            hooked = true
            self:SecureHook("InspectFrame_UnitChanged")
        end

        self:Inspect(InspectFrame.unit)
    end
end

function IE:InspectPaperDollFrame_OnHide()
    if WIN:GetParent() == InspectFrame then
        WIN:Hide()
        autoHidden = false
    end
end
--------------------------------------------

function IE:PaperDollFrame_OnShow()
    if IE.configDB.profile.charWindow then
        IE:SetParent(CharacterFrame)
        IE:Inspect("player")
    end
end

function IE:PaperDollFrame_OnHide()
    if WIN:GetParent() == CharacterFrame then
        WIN:Hide()
        autoHidden = false
    end
end

function IE:GearManagerDialog_OnShow()
    if WIN:GetParent() == CharacterFrame and WIN:IsShown() then
        WIN:Hide()
        autoHidden = true
    end
end

function IE:GearManagerDialog_OnHide()
    if autoHidden and WIN:GetParent() == CharacterFrame then
        WIN:Show()
        autoHidden = false
    end
end

function IE:UNIT_INVENTORY_CHANGED(event, unit)
    if (unit == "player") and (WIN:IsVisible() or autoHidden) and (WIN:GetParent() == CharacterFrame) then
        IE:Inspect("player")
    elseif (unit == curUnit) and (UnitName(unit) == curUnitName) and (WIN:IsVisible()) then
        IE:Inspect(curUnit)
    end
end

function IE:INSPECT_READY(event, guid)
    if (guid == curGUID) and (UnitName(curUnit) == curUnitName) then
        IE:Inspect(curUnit)
    else
        -- probably mouseover changed... nothing we can do apparently :(
        -- (inspect by unit name / guid does not work)
    end
end

function IE:Inspect(unit, entry)
    noEnchantWarningSlots, WeaponEnchantOnly = IE:GetEnchantmentCheckSlots(unit)

    local unitName, unitRealm
    cached = (unit == "cache")

    if retryTimer then
        -- stop retry timer if present
        self:CancelTimer(retryTimer, true)
        retryTimer = nil
    end

    if (cached and (not entry)) or (not self:IsEnabled()) then
        WIN:Hide()
        return
    end

    local cacheItems = cached and entry.Items or nil

    if cached then
        unitName, unitRealm = entry.name, entry.realm
        curGUID = nil
    else
        if (not unit or not UnitExists(unit)) then
            unit = "player"
        end
        unitName, unitRealm = UnitName(unit)
        curGUID = UnitGUID(unit)

        if not CanInspect(unit) then
            entry = self:GetExaminerCache(unit)
            if entry then
                cached = true
                cacheItems = entry.Items
            end
        else
            -- ClearInspectPlayer()
            -- NotifyInspect(unit)
        end
    end
    if unitRealm == "" then
        unitRealm = nil
    end
    curUnit = unit
    curUnitName = unitName
    curUser = self:FullUnitName(unitName, unitRealm)
    TITLE:SetText("InspectEquip: " .. curUser .. (cached and " (Cache)" or ""))

    self:ResetDisplay()

    local items = {
        cats = {},
        items = {}
    }
    local extraArgs = {}
    local itemsFound = false
    local getItem
    if cached then
        getItem = function(slot)
            local istr = cacheItems[slot]
            if istr then
                local itemId = tonumber(istr:match("item:(%d+)"))
                return select(2, GetItemInfo(istr)) or ("[" .. itemId .. "]")
            else
                return nil
            end
        end
    else
        getItem = function(slot)
            return GetInventoryItemLink(unit, GetInventorySlotInfo(slot))
        end
    end

    local calciv = IE.configDB.profile.showAvgItemLevel
    local iLevelSum, iCount = 0, 16

    local ArtifactWeaponEquipped = false
    local ArtifactWeaponLevel = 0

    local TwohandWeaponEquipped = false
    local mainhandEquipped = false
    local offhandEquipped = false

    local MainhandLevel = 0
    local OffhandLevel = 0

    for _, slot in pairs(slots) do
        local itemLink = getItem(slot)
        local sourceKnown = true
        if itemLink then
            -- get source
            local source = self:GetItemSourceCategories(itemLink, unit)
            local _, _, rar = GetItemInfo(itemLink)

            if rar and rar >= 2 then
                if rar == 5 then
                    source = {L["Legendary"]}
                elseif rar == 6 then
                    source = {L["Artifact"]}
                elseif rar == 7 then
                    source = {L["Heirloom"]}
                else
                    if (not source) and IE.configDB.profile.showUnknown then
                        source = {L["Unknown"]}
                        sourceKnown = false
                    end
                end
            end

            if slot == "MainHandSlot" or slot == "SecondaryHandSlot" then
                local _, _, rar, _, _, _, subtype, _, equiploc, _, _, _, subclassid = GetItemInfo(itemLink)
                if rar and rar == 6 then
                    ArtifactWeaponEquipped = true
                end
                if
                    equiploc == "INVTYPE_2HWEAPON" or equiploc == "INVTYPE_RANGED" or
                        (equiploc == "INVTYPE_RANGEDRIGHT" and subclassid ~= 19)
                 then
                    TwohandWeaponEquipped = true
                end
            end

            if source then
                local enchantId = tonumber(itemLink:match("Hitem:%d+:(%d+):"))
                itemsFound = true

                local sourcelevel
                if sourceKnown then
                    sourcelevel = 1
                else
                    sourcelevel = 2
                end

                -- find category
                local cat = items
                local entry
                for _, entry in pairs(source) do
                    if cat.cats[entry] == nil then
                        cat.cats[entry] = {
                            catlevel = sourcelevel,
                            count = 0,
                            cats = {},
                            items = {}
                        }
                    end
                    cat = cat.cats[entry]
                    cat.count = cat.count + 1
                    cat.catlevel = sourcelevel
                end

                -- add item to category
                cat.hasItems = true
                cat.items[cat.count] = {
                    link = itemLink,
                    enchant = enchantId,
                    slot = slot
                }
            end

            -- Accumulate total item level w/o weapons
            if calciv then
                -- local lvl = ItemUpgradeInfo:GetUpgradedItemLevel(itemLink)
                local lvl = GetDetailedItemLevelInfo(itemLink)
                local isArtifactWeapon = false
                if lvl then
                    if slot == "MainHandSlot" then
                        mainhandEquipped = true
                        isArtifactWeapon = ItemUpgradeInfo:IsArtifact(itemLink)
                        if isArtifactWeapon then
                            if lvl >= ArtifactWeaponLevel then
                                ArtifactWeaponLevel = lvl
                            end
                        else
                            MainhandLevel = lvl
                        end
                    elseif slot == "SecondaryHandSlot" then
                        offhandEquipped = true
                        isArtifactWeapon = ItemUpgradeInfo:IsArtifact(itemLink)
                        if isArtifactWeapon then
                            if lvl >= ArtifactWeaponLevel then
                                ArtifactWeaponLevel = lvl
                            end
                        else
                            OffhandLevel = lvl
                        end
                    else
                        iLevelSum = iLevelSum + lvl
                    end
                end
            end
        elseif not cached then
            local texture = GetInventoryItemTexture(unit, GetInventorySlotInfo(slot))
            if texture and not retryTimer then
                -- item link is not yet available, but item texture is, i.e. the slot is not empty
                -- item link data will become available shortly, so we just try it again in a sec
                retryTimer = self:ScheduleTimer("Inspect", 1, unit)
            end
        end
    end

    if ArtifactWeaponEquipped then
        iLevelSum = iLevelSum + ArtifactWeaponLevel * 2
    end
    extraArgs.ArtifactWeaponLevel = ArtifactWeaponLevel

    if TwohandWeaponEquipped then
        if mainhandEquipped then
            if offhandEquipped then
                iLevelSum = iLevelSum + math.max(MainhandLevel, OffhandLevel) * 2
            else
                iLevelSum = iLevelSum + MainhandLevel * 2
            end
        else
            iLevelSum = iLevelSum + OffhandLevel * 2
        end
    else
        iLevelSum = iLevelSum + MainhandLevel + OffhandLevel
    end

    if itemsFound then
        self:AddCategory(items, 0, extraArgs)
        if calciv and iCount > 0 then
            local avgLvl = iLevelSum / iCount
            -- local _,avgLvl = GetAverageItemLevel()
            AVGIL:SetText(L["Avg. Item Level"] .. ": " .. string.format("%.2f", avgLvl))
            AVGIL:Show()
        else
            AVGIL:Hide()
        end
        self:FixWindowSize()
        if
            WIN:GetParent() == CharacterFrame and
                ((GearManagerDialog and GearManagerDialog:IsVisible()) or
                    (OutfitterFrame and OutfitterFrame:IsVisible()))
         then
            autoHidden = true
        else
            WIN:Show()
        end
    else
        WIN:Hide()
    end
end

function IE:AddCategory(cat, padding, extra)
    -- add items
    if cat.hasItems then
        self:AddItems(cat.items, padding + 1, extra)
    end

    -- sort subcategories by item count
    local t = {}
    for name, subcat in pairs(cat.cats) do
        tinsert(
            t,
            {
                name = name,
                subcat = subcat
            }
        )
    end
    -- tsort(t, function(a,b) return a.subcat.count > b.subcat.count end)
    -- tsort(t, function(a,b) return a.subcat.catlevel < b.subcat.catlevel end)
    tsort(
        t,
        function(a, b)
            if a.subcat.catlevel == b.subcat.catlevel then
                return a.subcat.count > b.subcat.count
            else
                return a.subcat.catlevel < b.subcat.catlevel
            end
        end
    )

    -- add subcategories
    for i = 1, #t do
        local name = t[i].name
        local subcat = t[i].subcat
        self:AddLine(padding, name .. " (" .. subcat.count .. ")")
        self:AddCategory(subcat, padding + 1, extra)
    end
end

function IE:AddItems(tab, padding, extra)
    for _, item in pairs(tab) do
        local suffix = ""
        local prefix = ""
        local isArtifactWeapon = false
        local itemClassID = select(12, GetItemInfo(item.link))
        if IE.configDB.profile.listItemLevels then
            -- local ilvl = ItemUpgradeInfo:GetUpgradedItemLevel(item.link)
            local ilvl, plvl = GetDetailedItemLevelInfo(item.link)
            if item.slot == "MainHandSlot" then
                isArtifactWeapon = ItemUpgradeInfo:IsArtifact(item.link)
            end
            if item.slot == "SecondaryHandSlot" then
                isArtifactWeapon = ItemUpgradeInfo:IsArtifact(item.link)
            end
            if isArtifactWeapon then
                ilvl = extra.ArtifactWeaponLevel
            end
            if ilvl then
                prefix = "|cffaaaaaa[" .. ilvl .. "]|r "
            end
        end
        if
            IE.configDB.profile.checkEnchants and (item.enchant == nil) and noEnchantWarningSlots[item.slot] and
                not isArtifactWeapon
         then
            if WeaponEnchantOnly then
                if item.slot == "MainHandSlot" or item.slot == "SecondaryHandSlot" then
                    if itemClassID == 2 then
                        suffix = "|cffff0000*|r"
                    end
                else
                    suffix = "|cffff0000*|r"
                end
            else
                suffix = "|cffff0000*|r"
            end
        end
        self:AddLine(padding, prefix .. item.link .. suffix, item.link, item)
    end
end

function IE:GetItemData(item)
    local id
    if type(item) == "number" then
        id = item
    else -- item string/link
        id = tonumber(item:match("item:(%d+)"))
    end

    if id then
        local isSrc = IS.Items[id]
        local locSrc = InspectEquipLocalDB.Items[id]
        if isSrc and locSrc then
            -- combine results
            return locSrc .. ";" .. isSrc
        elseif isSrc or locSrc then
            return isSrc or locSrc
        elseif IE:IsPvPItem(id) then
            return "p"
        end
    else
        return nil
    end
end

function IE:GetZoneName(id)
    return IS.Zones[id] or InspectEquipLocalDB.Zones[id]
end

function IE:GetBossName(id)
    return IS.Bosses[id] or InspectEquipLocalDB.Bosses[id]
end

function IE:FixWindowSize()
    local maxwidth = TITLE:GetStringWidth()
    for i = 1, numlines do
        local width = lines[i].text:GetStringWidth() + lines[i].padLeft
        if maxwidth < width then
            maxwidth = width
        end
    end
    local height = (curline * 15) + 55
    if IE.configDB.profile.showAvgItemLevel then
        height = height + 15
    end
    WIN:SetWidth(maxwidth + 40)
    WIN:SetHeight(height)
end

function IE.Line_OnEnter(row)
    if row.link then
        local isArtifactWeapon = ItemUpgradeInfo:IsArtifact(row.link)
        local itemClassID = select(12, GetItemInfo(row.link))
        -- anchor on the correct side based on where there's more room
        --[[
		GameTooltip:SetOwner(row, "ANCHOR_NONE")
		local ycenter = select(2, row:GetCenter()) * row:GetEffectiveScale()
		if ycenter > select(2, UIParent:GetCenter()) * UIParent:GetScale() then
			GameTooltip:SetPoint("TOPLEFT", row, "BOTTOMLEFT")
		else
			GameTooltip:SetPoint("BOTTOMLEFT", row, "TOPLEFT")
		end
		--]]
        GameTooltip:SetOwner(row, "ANCHOR_RIGHT")

        if (not cached) and (UnitName(curUnit) == curUnitName) then
            row.link = GetInventoryItemLink(curUnit, GetInventorySlotInfo(row.item.slot)) or row.link
        end
        GameTooltip:SetHyperlink(row.link)
        -- if row.item and IE.configDB.profile.checkEnchants and (row.item.enchant == nil) and noEnchantWarningSlots[row.item.slot] then
        if
            row.item and IE.configDB.profile.checkEnchants and (row.item.enchant == nil) and
                noEnchantWarningSlots[row.item.slot] and
                not isArtifactWeapon
         then
            if WeaponEnchantOnly then
                if row.item.slot == "MainHandSlot" or row.item.slot == "SecondaryHandSlot" then
                    if itemClassID == 2 then
                        GameTooltip:AddLine(" ")
                        GameTooltip:AddLine("|cffff0000" .. L["Item is not enchanted"] .. "|r")
                    end
                else
                    GameTooltip:AddLine(" ")
                    GameTooltip:AddLine("|cffff0000" .. L["Item is not enchanted"] .. "|r")
                end
            else
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine("|cffff0000" .. L["Item is not enchanted"] .. "|r")
            end
        end
        GameTooltip:Show()
    end
end

function IE.Line_OnLeave(row)
    GameTooltip:Hide()
end

function IE.Line_OnClick(row, button)
    if row.link then
        if IsControlKeyDown() then
            DressUpItemLink(row.link)
        elseif IsShiftKeyDown() then
            ChatEdit_InsertLink(row.link)
        end
    end
end
