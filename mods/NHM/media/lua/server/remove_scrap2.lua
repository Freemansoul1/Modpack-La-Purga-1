require "BuildingObjects/ISMoveableCursor"
 
local function removeMode(_tagTable, _tag, _titleTable, _title)
    for i=1, #_tagTable do
        if _tagTable[i] == _tag then
            table.remove(_tagTable, i);
            break
        end
    end
    for i=1, #_titleTable do
        if _titleTable[i] == _tag then
            table.remove(_titleTable, i);
            break
        end
    end
end
 
removeMode(ISMoveableCursor.modes.tags,"scrap", ISMoveableCursor.modes.titles, getText("IGUI_Scrap"));