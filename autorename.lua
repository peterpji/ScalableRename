local RenameUnit = import("/mods/ScalableRename/rename_unit.lua").RenameUnit
local allUnits = {} ;
local username = nil ;

function InitAllUnits()
    -- this piece of code will actually select units at the beginning of the game
    -- every other unit is eventually created by other units at some point, hence we are adding them via that way
    local selection = GetSelectedUnits()
    UISelectionByCategory("ALLUNITS", false, false, false, false)
    for _, unit in (GetSelectedUnits() or {}) do
        username = unit:GetCustomName(unit);
		allUnits[unit:GetEntityId()] = unit
	end
    SelectUnits(selection); -- select back what was previously selected
end

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
            RenameUnit(username, unit)
        end
end

-- ForkThread
function Repeat()
    InitAllUnits()
	while true do -- while there are units alive out there
		WaitSeconds(1)
        UpdateAllUnits()
		RenameVet()
	end
end

function AddDeveloperHotkeys()
    local newSelectionsMap = {
        ['shift-Backspace']        = {action =  'UI_Lua import("/mods/Veterename/autorename.lua").RenameVet()'},
    } -- shortcut
    IN_AddKeyMapTable(newSelectionsMap)
end

-- Init
function VetInit()
	if SessionIsReplay() == true then
		LOG("Veterename: Disabled ; Watching replay")
	else
		LOG("Veterename: Enabled")
        AddDeveloperHotkeys()
		ForkThread(Repeat)
	end
end
