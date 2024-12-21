local ModComponents = TYU:RegisterNewClass()

local ModPart = {}
ModComponents.ModPart = ModPart

function ModPart:NewChild()
    local instance = setmetatable({}, {__index = self})
    return instance
end

function ModPart:New(name, dataName)
    local new = setmetatable({}, {__index = self})
    new.Name = name
    new.DataName = dataName
    return new
end

function ModPart:GetGlobalField(...)
    return TYU:GetGlobalLibData(self.DataName, ...)
end

function ModPart:SetGlobalField(value, ...)
    TYU:SetGlobalLibData(value, self.DataName, ...)
end

function ModPart:GetTempGlobalField(...)
    return TYU:GetTempGlobalLibData(self.DataName, ...)
end

function ModPart:SetTempGlobalField(value, ...)
    TYU:SetTempGlobalLibData(value, self.DataName, ...)
end

function ModPart:GetPlayerField(entity, ...)
    return TYU:GetPlayerLibData(entity, self.DataName, ...)
end

function ModPart:SetPlayerField(entity, value, ...)
    TYU:SetPlayerLibData(entity, value, self.DataName, ...)
end

function ModPart:GetTempField(entity, ...)
    return TYU:GetTempEntityLibData(entity, self.DataName, ...)
end

function ModPart:SetTempField(entity, value, ...)
    TYU:SetTempEntityLibData(entity, value, self.DataName, ...)
end

function ModPart:AddCallback(callback, func, optional)
    local function fncall(mod, ...)
        return func(self, ...)
    end
    self.Mod:AddCallback(callback, fncall, optional)
end

function ModPart:AddPriorityCallback(callback, priority, func, optional)
    local function fncall(mod, ...)
        return func(self, ...)
    end
    self.Mod:AddPriorityCallback(callback, priority, fncall, optional)
end

do 
    local ModItem = ModPart:NewChild()

    ModItem.Mod = TYU
    ModItem.ID = -1
    ModItem.Item = -1
    ModItem.Name = nil
    ModItem.DataName = nil
    ModItem.ClassName = "ModItem"

    ModComponents.ModItem = ModItem

    function ModItem:New(name, dataName)
        local new = setmetatable({}, {__index = self})
        new.ID = Isaac.GetItemIdByName(name)
        new.Item = new.ID
        new.Name = name
        new.DataName = dataName
        return new
    end
end

do 
    local ModEntity = ModPart:NewChild()

    ModEntity.Mod = TYU
    ModEntity.ID = 0
    ModEntity.Type = 0
    ModEntity.Variant = 0
    ModEntity.SubType = 0
    ModEntity.Name = nil
    ModEntity.DataName = nil
    ModEntity.ClassName = "ModEntity"

    ModComponents.ModEntity = ModEntity

    function ModEntity:New(name, dataName)
        local new = setmetatable({}, {__index = self})
        new.Type = Isaac.GetEntityTypeByName(name)
        new.Variant = Isaac.GetEntityVariantByName(name)
        new.SubType = Isaac.GetEntitySubTypeByName(name)
        new.ID = new.Type
        new.Name = name
        new.DataName = dataName
        return new
    end
end

do
    local ModPlayer = ModPart:NewChild()
    
    ModPlayer.Mod = TYU
    ModPlayer.ID = -1
    ModPlayer.Type = 0
    ModPlayer.Name = nil
    ModPlayer.DataName = nil
    ModPlayer.ClassName = "ModPlayer"

    ModComponents.ModPlayer = ModPlayer

    function ModPlayer:New(name, tainted, dataName)
        local new = setmetatable({}, {__index = self})
        new.ID = Isaac.GetPlayerTypeByName(name, tainted)
        new.Type = new.ID
        new.Name = name
        new.DataName = dataName
        return new
    end
end

do
    local ModTrinket = ModPart:NewChild()

    ModTrinket.Mod = TYU
    ModTrinket.ID = -1
    ModTrinket.Trinket = -1
    ModTrinket.Name = nil
    ModTrinket.DataName = nil
    ModTrinket.ClassName = "ModTrinket"

    ModComponents.ModTrinket = ModTrinket

    function ModTrinket:New(name, dataName)
        local new = setmetatable({}, {__index = self})
        new.ID = Isaac.GetTrinketIdByName(name)
        new.Trinket = new.ID
        new.Name = name
        new.DataName = dataName
        return new
    end
end

do 
    local ModCard = ModPart:NewChild()

    ModCard.Mod = TYU
    ModCard.ID = -1
    ModCard.Name = nil
    ModCard.DataName = nil
    ModCard.ClassName = "ModCard"

    ModComponents.ModCard = ModCard

    function ModCard:New(name, dataName)
        local new = setmetatable({}, {__index = self})
        new.ID = Isaac.GetCardIdByName(name)
        new.Name = name
        new.DataName = dataName
        return new
    end
end

do 
    local ModPill = ModPart:NewChild()

    ModPill.Mod = TYU
    ModPill.ID = -1
    ModPill.Name = nil
    ModPill.DataName = nil
    ModPill.ClassName = "ModPill"

    ModComponents.ModPill = ModPill

    function ModPill:New(name, dataName)
        local new = setmetatable({}, {__index = self})
        new.ID = Isaac.GetPillEffectByName(name)
        new.Name = name
        new.DataName = dataName
        return new
    end
end

do
    local ModEnchantment = ModPart:NewChild()
    
    ModEnchantment.Mod = TYU

    ModEnchantment.ID = -1
    ModEnchantment.Type = 0
    ModEnchantment.Name = nil
    ModEnchantment.DataName = nil
    ModEnchantment.ClassName = "ModEnchantment"

    ModComponents.ModEnchantment = ModEnchantment

    function ModEnchantment:New(name, dataName)
        local new = setmetatable({}, {__index = self})
        new.ID = Isaac.GetNullItemIdByName(name)
        new.Type = new.ID
        new.Name = name
        new.DataName = dataName
        return new
    end
end

return ModComponents