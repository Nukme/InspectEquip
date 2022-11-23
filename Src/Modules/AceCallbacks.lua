InspectEquip = LibStub("AceAddon-3.0"):NewAddon("InspectEquip", "AceConsole-3.0", "AceHook-3.0", "AceTimer-3.0",
    "AceEvent-3.0")

local IE = InspectEquip

function IE:OnInitialize()
    self:RegisterConfigs()

    self:RegisterMetas()

    self:RegisterItems()

    self:RegisterMenus()

    self:RegisterInfoWindow()

    self:RegisterFlags()

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("ADDON_LOADED")

    self:RegisterChatCommand("inspectequip", function()
        InterfaceOptionsFrame_OpenToCategory(InspectEquip.ConfigPanel)
    end)
end

function IE:OnEnable()
    if PaperDollFrame then
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
    if IE.InspectFrame_UnitChangedHooked then
        self:Unhook("InspectFrame_UnitChanged")
        IE.InspectFrame_UnitChangedHooked = false
    end
    self:UnhookAll()
    self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
    self:UnregisterEvent("INSPECT_READY")
    self:CancelAllTimers()
    IE.InfoWindow:Hide()
end
