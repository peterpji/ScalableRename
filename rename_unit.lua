local NameTable = import("/mods/ScalableRename/tables.lua").GetTable()
local domainCategories = { "NAVAL", "LAND", "AIR" }
local techCategories = { "TECH1", "TECH2", "TECH3" }
local RenameCounts = {
    TECH1 = 0,
    TECH2 = 0,
    TECH3 = 0
}


function GetNameCommander(username, unit)
    local Ukills = unit:GetStat('KILLS', 0).Value
    local newName
    if Ukills >= unit:GetBlueprint().Veteran.Level5 then
        newName = "<[["..username.."]]>"
    elseif Ukills >= unit:GetBlueprint().Veteran.Level4 then
        newName = "[["..username.."]]"
    elseif Ukills >= unit:GetBlueprint().Veteran.Level3 then
        newName = "<["..username.."]>"
    elseif Ukills >= unit:GetBlueprint().Veteran.Level2 then
        newName = "["..username.."]"
    elseif Ukills >= unit:GetBlueprint().Veteran.Level1 then
        newName = "<"..username..">"
    else
        newName = username
    end
    return newName
end

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

    local threshold = 1 / namedUnitCount
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
    if unit['IsChecked'] == nil and RandomNamingRate(RenameCounts[tier]) and ( unit:GetCustomName(unit) == nil or unit:IsInCategory('COMMAND') == true ) then
        local unitname = unit:GetBlueprint().General.UnitName
        local newName
        local temptable ;
        if unit:IsInCategory('COMMAND') == true then
            newName = GetNameCommander(username, unit)
        else
            if unit:IsInCategory('EXPERIMENTAL') then
                if unit:IsInCategory('UEF') then
                    temptable = NameTable.UEFT4table
                elseif unit:IsInCategory('CYBRAN') then
                    temptable = NameTable.CybranT4table
                elseif unit:IsInCategory('AEON') then
                    temptable = NameTable.AeonT4table
                elseif unit:IsInCategory('SERAPHIM') then
                    temptable = NameTable.SeraphimT4table
                end
            elseif unit:IsInCategory('DEFENSE') then
                temptable = NameTable.Defense
            elseif unit:IsInCategory('STRUCTURE') then
                temptable = NameTable.Structures
            elseif unit:IsInCategory('BATTLESHIP') == true or unit:IsInCategory('BATTLECRUISER') then
                temptable = NameTable.BNaval
            elseif unit:IsInCategory('NAVAL') then
                temptable = NameTable.Naval
            elseif unit:IsInCategory('AIR') and unit:IsInCategory('GROUNDATTACK') then
                temptable = NameTable.Gunships
            elseif unit:IsInCategory('AIR') then
                temptable = NameTable.AirTable
            else
                temptable = NameTable.Default
            end
            if temptable ~= nil then
                newName = temptable[math.random(table.getsize (temptable) )]
            end
        end
        if newName ~= nil then
            unit:SetCustomName(newName)
            if tier ~= nil then
                RenameCounts[tier] = 1 + RenameCounts[tier]
            end
        else
            unit:SetCustomName("test")
        end
    end
    unit['IsChecked'] = true
end
