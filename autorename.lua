local NameTable = import("/mods/Veterename/tables.lua").GetTable()
local allUnits = {} ;
local username = nil ;

function UpdateAllUnits()
    -- Add unit being built by others
    for _, unit in allUnits do
		if not unit:IsDead() and unit:GetFocus() and not unit:GetFocus():IsDead() then
			allUnits[unit:GetFocus():GetEntityId()] = unit:GetFocus()
		end
	end
	
	-- Remove dead
	for entityid, unit in allUnits do
		if unit:IsDead() then
			allUnits[entityid] = nil
		end
	end
end

function RenameVet()
        for index, unit in allUnits do
            local Ukills = unit:GetStat('KILLS', 0).Value
            if Ukills >= unit:GetBlueprint().Veteran.Level1 and Ukills != 0 and ( unit:GetCustomName(unit) == nil or unit:IsInCategory('COMMAND') == true ) then
                local unitname = unit:GetBlueprint().General.UnitName
                local newName
                local temptable ;
                if unit:IsInCategory('COMMAND') == true then
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
                    if temptable != nil then
                        newName = temptable[math.random(table.getsize (temptable) )]
                    end
                end
                if newName != nil then
                    unit:SetCustomName(newName)
                else
                    unit:SetCustomName("test")
                end
            end
        end
end

-- ForkThread
function Repeat()
    -- this piece of code will actually select units at the beginning of the game
    -- every other unit is eventually created by other units at some point, hence we are adding them via that way
    local selection = GetSelectedUnits()
    UISelectionByCategory("ALLUNITS", false, false, false, false)
    for _, unit in (GetSelectedUnits() or {}) do
        username = unit:GetCustomName(unit);
		allUnits[unit:GetEntityId()] = unit
	end
    SelectUnits(selection); -- select back what was previously selected
    --     
	while true do -- while there are units alive out there
		WaitSeconds(1)
        UpdateAllUnits()
		RenameVet()
	end 
end
-- Init

function VetInit() -- 
	if SessionIsReplay() == true then
		LOG("Veterename: Disabled ; Watching replay")
	else
		LOG("Veterename: Enabled")
		local newSelectionsMap = {
            ['shift-Backspace']        = {action =  'UI_Lua import("/mods/Veterename/autorename.lua").RenameVet()'},
		} -- shortcut
		IN_AddKeyMapTable(newSelectionsMap)
		ForkThread(Repeat)
	end
end