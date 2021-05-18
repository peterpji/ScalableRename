local NameTable = import("/mods/ScalableRename/tables.lua").GetTable()
local domainCategories = { "NAVAL", "LAND", "AIR" }
local techCategories = { "TECH1", "TECH2", "TECH3" }
local RenameCounts = {
    TECH1 = 0,
    TECH2 = 0,
    TECH3 = 0
}

function GetTier(unit)
    local found_tier
    for _, tier in techCategories do
        if EntityCategoryContains(categories[tier], unit) then
            found_tier = tier
            break
        end
    end
    return found_tier
end

function RandomNamingRate(namedUnitCount)
    if namedUnitCount == nil then
        return false
    end

    local threshold = math.pow(0.5, namedUnitCount)
    local randomNumber = math.random()
    local result
    if randomNumber < threshold then
        result = true
    else
        result = false
    end
    return result
end

function RenameUnit(username, unit)
    local tier = GetTier(unit)
    if unit['IsChecked'] == nil and string.find(unit:GetBlueprint().Description, 'Interceptor') == nil and unit:IsInCategory('STRUCTURE') == false and RandomNamingRate(RenameCounts[tier]) and ( unit:GetCustomName(unit) == nil or unit:IsInCategory('COMMAND') == true ) then
        local chosenNameTable
        if unit:IsInCategory('EXPERIMENTAL') then
            chosenNameTable = NameTable.Experimental
        else
            chosenNameTable = NameTable.Default
        end
        local newName = chosenNameTable[math.random(table.getsize(chosenNameTable))]
        unit:SetCustomName(newName)
        if tier ~= nil then
            RenameCounts[tier] = 1 + RenameCounts[tier]
        end
    end
    unit['IsChecked'] = true
end
