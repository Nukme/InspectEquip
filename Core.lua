if not InspectEquip then
    return
end

local _, _table_ = ...

local IE = InspectEquip

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

function IE:RegisterItems()
    -- InspectEquip EJ Item Information DBObj
    self.ejDB = LibStub("AceDB-3.0"):New("InspectEquipEJItemDB", defaults_item, true)

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
    IE.DatabaseChecked = false;
    IE.ItemTooltipHooked = false;
    IE.InspectFrame_UnitChangedHooked = false;
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

function IE:CheckDatabase()
    if IE.DatabaseChecked then
        return
    end

    local _, clientbuild = GetBuildInfo()
    local ieversion = GetAddOnMetadata("InspectEquip", "Version")
    local locale = GetLocale()
    local expansion = GetExpansionLevel()

    if self:AreMetasMatching(clientbuild, ieversion, locale, expansion) then
        IE.DatabaseChecked = true
    else
        self:ScheduleTimer("CreateEJDatabase", 5)
        self:UpdateMetas(clientbuild, ieversion, locale, expansion)
    end
end
