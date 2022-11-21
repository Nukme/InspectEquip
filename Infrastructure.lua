InspectEquip = LibStub("AceAddon-3.0"):NewAddon("InspectEquip", "AceConsole-3.0", "AceHook-3.0", "AceTimer-3.0",
    "AceEvent-3.0")

local IE = InspectEquip
local WIN = InspectEquip_InfoWindow -- > InfoWindow.xml
local TITLE = InspectEquip_InfoWindowTitle

function IE:OnInitialize()
    -- Register Config Values
    self:RegisterConfigs()

    -- Register Metas
    self:RegisterMetas()

    -- Register Items
    self:RegisterItems()

    -- Register Option Menus
    self:RegisterMenus()

    -- Register Slash Command
    self:RegisterChatCommand("inspectequip", function()
        InterfaceOptionsFrame_OpenToCategory(InspectEquip.ConfigPanel)
    end)

    self:SetParent(InspectFrame)
    WIN:Hide()
    TITLE:SetText("InspectEquip")

    self:ResetFlags()

    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("ADDON_LOADED")
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
        IE.InspectFrame_UnitChangedHooked = false
        self:Unhook("InspectFrame_UnitChanged")
    end
    self:UnhookAll()
    self:UnregisterEvent("UNIT_INVENTORY_CHANGED")
    self:UnregisterEvent("INSPECT_READY")
    self:CancelAllTimers()
    WIN:Hide()
end
