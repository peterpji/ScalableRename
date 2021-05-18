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

function ShouldBeRenamed(unit, tier)
    -- Is rename already done
    if unit['IsChecked'] == true then
        return false
    end

    -- Is commander
    if unit:IsInCategory('COMMAND') == true then
        return false
    end

    -- Ignore structures
    if unit:IsInCategory('STRUCTURE') == true then
        return false
    end

    -- Ignore asf, inties, scouts etc
    if unit:IsInCategory('AIR') == true and unit:IsInCategory('GROUNDATTACK') == false and unit:IsInCategory('BOMBER') == false then
        return false
    end

    -- Already renamed
    if unit:GetCustomName(unit) ~= nil then
        return false
    end

    -- Randomize naming
    if RandomNamingRate(RenameCounts[tier]) == false then
        return false
    end

    return true
end

function RenameUnit(username, unit)
    local tier = GetTier(unit)
    if ShouldBeRenamed(unit, tier) then
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
