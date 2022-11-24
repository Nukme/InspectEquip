if not InspectEquip then
    return
end


local IE = InspectEquip

local defaults_meta = {
    global = {
        ClientBuild = nil,
        IEVersion = nil,
        Locale = nil,
        Expansion = nil
    }
}

function IE:RegisterMetas()
    -- InspectEquip Meta Infomation DBObj
    self.metaDB = LibStub("AceDB-3.0"):New("InspectEquipMetaDB", defaults_meta, true)
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
