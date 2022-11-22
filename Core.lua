if not InspectEquip then
    return
end

local _, _table_ = ...

local IE = InspectEquip

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
