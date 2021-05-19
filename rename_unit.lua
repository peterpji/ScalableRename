local NameTable = import("/mods/ScalableRename/tables.lua").GetTable()
local domainCategories = { "NAVAL", "LAND", "AIR" }
local techCategories = { "TECH1", "TECH2", "TECH3" }

function InitRenameCounts()
    local renameCounts = {}
    for _, tech in techCategories do
        renameCounts[tech] = {}
        for _, domain in domainCategories do
            renameCounts[tech][domain] = 0
        end
    end
    return renameCounts
end
local RenameCounts = InitRenameCounts()


function GetCategory(unit, categoriesList)
    local categoryMatch
    for _, category in categoriesList do
        if EntityCategoryContains(categories[category], unit) then
            categoryMatch = category
            break
        end
    end
    return categoryMatch
end


function RandomNamingRate(namedUnitCount)
    if namedUnitCount == nil then
        return false
    end

    local threshold = math.max(math.pow(0.3, namedUnitCount), 0.05) --Controls how often names are given
    local randomNumber = math.random()
    local result
    if randomNumber < threshold then
        result = true
    else
        result = false
    end
    return result
end


function ShouldBeRenamed(unit, renamesDoneCount)
    -- Is rename already done
    if unit['IsChecked'] == true then
        return false
    end

    if unit:IsInCategory('EXPERIMENTAL') == true then
        return true
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
    if RandomNamingRate(renamesDoneCount) == false then
        return false
    end

    return true
end


function RenameUnit(unit)
    local tier = GetCategory(unit, techCategories)
    local domain = GetCategory(unit, domainCategories)
    local renamesDoneCount = RenameCounts[tier][domain]

    if ShouldBeRenamed(unit, renamesDoneCount) then
        local chosenNameTable
        if unit:IsInCategory('EXPERIMENTAL') then
            chosenNameTable = NameTable.Experimental
        else
            chosenNameTable = NameTable.Default
        end
        local newName = chosenNameTable[math.random(table.getsize(chosenNameTable))]
        unit:SetCustomName(newName)
        if tier ~= nil then
            RenameCounts[tier][domain] = 1 + renamesDoneCount
        end
    end
    unit['IsChecked'] = true
end
