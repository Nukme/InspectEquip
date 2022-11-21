if not InspectEquip then
    return
end

local _, _table_ = ...

local IE = InspectEquip
local L = LibStub("AceLocale-3.0"):GetLocale("InspectEquip")

--[[ **********************************************************************
        Configuration Default Values
     **********************************************************************]]

local defaults = {
    global = {
        tooltips = true,
        showUnknown = true,
        inspectWindow = true,
        charWindow = true,
        checkEnchants = true,
        listItemLevels = true,
        showAvgItemLevel = true,
        _StylizeClassTierCategory_ = true,
        ttR = 1.0,
        ttG = 0.75,
        ttB = 0.0,
        maxSourceCount = 5
    }
}

--[[ **********************************************************************
        Configuration Options Table
     **********************************************************************]]

local introOptions = {
    type = "group",
    name = "InspectEquip",
    args = {
        intro = {
            order = 0,
            type = "description",
            name = L["Gear Item Information Management Addon\n\n"]
        },
        version = {
            order = 1,
            type = "description",
            name = string.format("%s\n    %s\n\n", "|cFFFFD700" .. L["Version"] .. "|r",
                GetAddOnMetadata("InspectEquip", "Version"))
        },
        author = {
            order = 2,
            type = "description",
            name = string.format("%s\n    %s\n\n", "|cFFFFD700" .. L["Author"] .. "|r", "emelio (original), Nukme")
        },
        repo = {
            order = 3,
            type = "input",
            name = L["Github Repo"],
            width = "double",
            get = function()
                return GetAddOnMetadata("InspectEquip", "X-Repository")
            end
        },
        feedback = {
            order = 4,
            type = "input",
            name = L["NGA Feedback"],
            width = "double",
            get = function()
                return GetAddOnMetadata("InspectEquip", "X-NGA_Feedback")
            end
        }
    }
}

local generalOptions = {
    name = L["General Settings"],
    type = "group",
    args = {
        tooltips = {
            order = 1,
            type = "toggle",
            width = "full",
            name = L["Add drop information to tooltips"],
            desc = L["Add item drop information to all item tooltips"],
            get = function()
                return IE.configDB.global.tooltips
            end,
            set = function(_, v)
                IE.configDB.global.tooltips = v
                if v then
                    IE:HookTooltips()
                end
            end
        },
        showunknown = {
            order = 2,
            type = "toggle",
            width = "full",
            name = L["Include unknown items in overview"],
            desc = L["Show items that cannot be categorized in a seperate category"],
            get = function()
                return IE.configDB.global.showUnknown
            end,
            set = function(_, v)
                IE.configDB.global.showUnknown = v
            end
        },
        inspectwindow = {
            order = 3,
            type = "toggle",
            width = "full",
            name = L["Attach to inspect window"],
            desc = L["Show the equipment list when inspecting other characters"],
            get = function()
                return IE.configDB.global.inspectWindow
            end,
            set = function(_, v)
                IE.configDB.global.inspectWindow = v
            end
        },
        charwindow = {
            order = 4,
            type = "toggle",
            width = "full",
            name = L["Attach to character window"],
            desc = L["Also show the InspectEquip panel when opening the character window"],
            get = function()
                return IE.configDB.global.charWindow
            end,
            set = function(_, v)
                IE.configDB.global.charWindow = v
            end
        },
        checkenchants = {
            order = 5,
            type = "toggle",
            width = "full",
            name = L["Check for unenchanted items"],
            desc = L["Display a warning for unenchanted items"],
            get = function()
                return IE.configDB.global.checkEnchants
            end,
            set = function(_, v)
                IE.configDB.global.checkEnchants = v
            end
        },
        listitemlevels = {
            order = 6,
            type = "toggle",
            width = "full",
            name = L["Show item level in equipment list"],
            desc = L["Show the item level of each item in the equipment panel"],
            get = function()
                return IE.configDB.global.listItemLevels
            end,
            set = function(_, v)
                IE.configDB.global.listItemLevels = v
            end
        },
        showavgitemlevel = {
            order = 7,
            type = "toggle",
            width = "full",
            name = L["Show average item level in equipment list"],
            desc = L["Show the average item level of all items in the equipment panel"],
            get = function()
                return IE.configDB.global.showAvgItemLevel
            end,
            set = function(_, v)
                IE.configDB.global.showAvgItemLevel = v
            end
        },
        stylizeclasstiercategory = {
            order = 8,
            type = "toggle",
            width = "full",
            name = L["Stylize Class Tier Set category label"],
            desc = L["Show Class Tier Set category label with class color and class icon"],
            get = function()
                return IE.configDB.global._StylizeClassTierCategory_
            end,
            set = function(_, v)
                IE.configDB.global._StylizeClassTierCategory_ = v
            end
        },
        tooltipcolor = {
            order = 18,
            type = "color",
            name = L["Tooltip text color"],
            width = "full",
            get = function()
                return IE.configDB.global.ttR, IE.configDB.global.ttG, IE.configDB.global.ttB, 1.0
            end,
            set = function(_, r, g, b, a)
                IE.configDB.global.ttR = r
                IE.configDB.global.ttG = g
                IE.configDB.global.ttB = b
            end
        },
        maxsourcecount = {
            order = 19,
            type = "range",
            min = 1,
            max = 20,
            softMax = 10,
            step = 1,
            width = "double",
            name = L["Max. amount of sources in tooltips"],
            desc = L["The maximum amount of sources that are displayed in item tooltips"],
            get = function()
                return IE.configDB.global.maxSourceCount
            end,
            set = function(_, v)
                IE.configDB.global.maxSourceCount = v
            end
        },
        database = {
            order = 20,
            type = "group",
            inline = true,
            name = L["Database"],
            args = {
                resetdb = {
                    order = 1,
                    type = "execute",
                    width = "double",
                    name = L["Reset database"],
                    desc = L["Recreate the database"],
                    func = function()
                        IE:CreateLocalDatabase()
                    end
                }
            }
        }
    }
}

_table_.defaults = defaults
_table_.introOptions = introOptions
_table_.generalOptions = generalOptions

function InspectEquip:RegisterConfigs()
    -- General Settings Defaults DBObj
    self.configDB = LibStub("AceDB-3.0"):New("InspectEquipConfigDB", _table_.defaults, true)
end

function InspectEquip:RegisterMenus()
    LibStub("AceConfig-3.0"):RegisterOptionsTable("InspectEquip", _table_.introOptions)
    self.ConfigPanel = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("InspectEquip", "InspectEquip")

    LibStub("AceConfig-3.0"):RegisterOptionsTable("InspectEquip General Settings", _table_.generalOptions)
    self.GeneralSettings = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("InspectEquip General Settings",
        L["General Settings"], "InspectEquip")
end
