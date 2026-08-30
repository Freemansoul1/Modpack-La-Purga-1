

local lcl = lcl or {}
lcl.Verbose = false
lcl.NBSquaresPerCycle = 9

lcl.ArrayList_base   = __classmetatables[ArrayList.class].__index
lcl.ArrayList_size   = lcl.ArrayList_base.size
lcl.ArrayList_get    = lcl.ArrayList_base.get

lcl.igs_base = __classmetatables[IsoGridSquare.class].__index
lcl.igs_getX              = lcl.igs_base.getX
lcl.igs_getY              = lcl.igs_base.getY
lcl.igs_getZ              = lcl.igs_base.getZ
lcl.igs_getObjects        = lcl.igs_base.getObjects
lcl.igs_RemoveTileObject  = lcl.igs_base.RemoveTileObject
lcl.igs_getIsoWorldRegion  = lcl.igs_base.getIsoWorldRegion


lcl.io_base = __classmetatables[IsoObject.class].__index
lcl.io_getProperties     = lcl.io_base.getProperties
lcl.io_getObjectName     = lcl.io_base.getObjectName

lcl.pc_base = __classmetatables[PropertyContainer.class].__index
lcl.pc_Is     = lcl.pc_base.Is
lcl.pc_Val    = lcl.pc_base.Val

lcl.PZArrayList_base        = __classmetatables[PZArrayList.class].__index
lcl.PZArrayList_size        = lcl.PZArrayList_base.size
lcl.PZArrayList_get         = lcl.PZArrayList_base.get

lcl.cell_base = __classmetatables[IsoCell.class].__index
lcl.cell_getGridSquare  = lcl.cell_base.getGridSquare


function lcl.fixInsideSquare(sq)
    local fixApplied = false;
    if sq then
        local objects = lcl.igs_getObjects(sq)
        if objects then
            local pillarsLikeObjects = {}
            local hasEastWestWall = false
            for i=lcl.PZArrayList_size(objects)-1, 0, -1 do
                local isoObject = lcl.PZArrayList_get(objects,i)
                if isoObject then
                    local props = lcl.io_getProperties(isoObject)
                    if lcl.pc_Is(props,IsoFlagType.cutW) then
                        if lcl.pc_Is(props,IsoFlagType.WallSE) then--I see you NW pillar
                            table.insert(pillarsLikeObjects,isoObject)
                        else
                            hasEastWestWall = true
                        end
                    end
                end
            end
            if hasEastWestWall then
                for i=1, #pillarsLikeObjects do
                    lcl.igs_RemoveTileObject(sq,pillarsLikeObjects[i])
                    fixApplied = true
                    if lcl.Verbose then print ('Fix Inside square ',lcl.igs_getX(sq),' ',lcl.igs_getY(sq),' ',lcl.igs_getZ(sq),' remove object ',i) end
                end
            end
        end
    end
    return fixApplied
end

lcl.checkedPosList = {}
lcl.toCheckPosList = {}
lcl.toCheckRefPos = nil

function lcl.isChecked(currentPos, checkedPosList)
    if not checkedPosList[currentPos[1]] then checkedPosList[currentPos[1]] = {} end
    if not checkedPosList[currentPos[1]][currentPos[2]] then checkedPosList[currentPos[1]][currentPos[2]] = {} end
    return checkedPosList[currentPos[1]][currentPos[2]][currentPos[3]]
end

function lcl.fixSideSquare(clickingPos, nSq, checkedPosList, nbPosCheckedLocal, nbPosToCheck)
    if nSq then
        local nPos = {lcl.igs_getX(nSq),lcl.igs_getY(nSq),lcl.igs_getZ(nSq)}
        if not lcl.isChecked(nPos, checkedPosList) then
            if nbPosCheckedLocal < nbPosToCheck then
                return lcl.fixInsideChunkRegion(clickingPos, nPos, checkedPosList, nbPosCheckedLocal, nbPosToCheck)--recurse
            else--time's up, store for later
                table.insert(lcl.toCheckPosList,nPos)
                if lcl.toCheckRefPos == nil then lcl.toCheckRefPos = clickingPos end
            end
        end
    end
    return 0
end

function lcl.fixInsideChunkRegion(clickingPos, currentPos, checkedPosList, nbPosChecked, nbPosToCheck)
    --check around the ref square until it is not the same zone anymore
    if not clickingPos then
        if lcl.Verbose then print ('fixInsideChunkRegion missing clicking pos.') end
        return 0
    end
    if not checkedPosList then
        if lcl.Verbose then print ('fixInsideChunkRegion missing checkedPosList.') end
        return 0
     end

    local currentClicked = (currentPos == nil)
    if currentClicked then
        currentPos = clickingPos
    end
    if lcl.isChecked(currentPos, checkedPosList) then
        if lcl.Verbose then print ('fixInsideChunkRegion already checked square ',currentPos[1],' ',currentPos[2],' ',currentPos[3]) end
        return 0
    end
    
    local cell = getCell()
    local clickingSquare = lcl.cell_getGridSquare(cell, clickingPos[1],clickingPos[2],clickingPos[3])
    if not clickingSquare then
        if lcl.Verbose then print ('fixInsideChunkRegion stop on invalid square ',clickingPos[1],' ',clickingPos[2],' ',clickingPos[3]) end
        return nbPosToCheck-nbPosChecked;--stop the whole sequence
    end
    
    local iwr = lcl.igs_getIsoWorldRegion(clickingSquare)
    local currentSquare, currentIWR = nil,nil
    if currentClicked then
        currentSquare = clickingSquare
        currentIWR = iwr
    else
        currentSquare = lcl.cell_getGridSquare(cell, currentPos[1],currentPos[2],currentPos[3])
        if currentSquare then
            currentIWR = lcl.igs_getIsoWorldRegion(currentSquare)
        else
            --square is not valid: map border or currently loaded border.
        end
    end
    
    local nbCheckedLocally = 1
    if currentSquare then
        if currentIWR == iwr then
            if lcl.Verbose then print ('fixInsideChunkRegion checking square ',currentPos[1],' ',currentPos[2],' ',currentPos[3]) end
            lcl.fixInsideSquare(currentSquare)
            checkedPosList[currentPos[1]][currentPos[2]][currentPos[3]] = 1--checked and same iwr => continue the search
            nbCheckedLocally = nbCheckedLocally + lcl.fixSideSquare(clickingPos, currentSquare:getW(), checkedPosList, nbPosChecked+nbCheckedLocally, nbPosToCheck)
            nbCheckedLocally = nbCheckedLocally + lcl.fixSideSquare(clickingPos, currentSquare:getN(), checkedPosList, nbPosChecked+nbCheckedLocally, nbPosToCheck)
            nbCheckedLocally = nbCheckedLocally + lcl.fixSideSquare(clickingPos, currentSquare:getS(), checkedPosList, nbPosChecked+nbCheckedLocally, nbPosToCheck)
            nbCheckedLocally = nbCheckedLocally + lcl.fixSideSquare(clickingPos, currentSquare:getE(), checkedPosList, nbPosChecked+nbCheckedLocally, nbPosToCheck)
        else
            checkedPosList[currentPos[1]][currentPos[2]][currentPos[3]] = 2--different iwr => do not search further, tag to avoid looking for it later
            if lcl.Verbose then print ('fixInsideChunkRegion square from another region ',currentPos[1],' ',currentPos[2],' ',currentPos[3]) end
        end
    else
        if lcl.Verbose then print ('fixInsideChunkRegion NOT loaded square ',currentPos[1],' ',currentPos[2],' ',currentPos[3]) end
        --checkedPosList[currentPos[1]][currentPos[2]][currentPos[3]] = nil--notloaded/unloaded/unexisting => stop search from it but keep the path open
    end

    return nbCheckedLocally
end

function lcl.OnPlayerUpdate(player)
    if not (SandboxVars.FixInside and SandboxVars.FixInside.ActivePatch) then
        return--could be deactivated live from dedicated mod
    end

    if not lcl.toCheckRefPos then
        if not player then return end
        local sq = player:getCurrentSquare()
        if not sq then return end
        
        lcl.toCheckRefPos = { lcl.igs_getX(sq), lcl.igs_getY(sq), lcl.igs_getZ(sq)}
        if lcl.Verbose then print ('fixInsideChunkRegion starting from ref square ',lcl.toCheckRefPos[1],' ',lcl.toCheckRefPos[2],' ',lcl.toCheckRefPos[3]) end
        
        lcl.checkedPosList = {}
        lcl.toCheckPosList = {}
        
        local nbCheckedThisCycle = lcl.fixInsideChunkRegion(lcl.toCheckRefPos, lcl.toCheckRefPos, lcl.checkedPosList, 0, lcl.NBSquaresPerCycle)
        
        if nbCheckedThisCycle < lcl.NBSquaresPerCycle then--stop finished session
            if lcl.Verbose then print ('fixInsideChunkRegion short session finished. ',nbCheckedThisCycle) end
            lcl.toCheckRefPos = nil
        end
    else
        local nbCheckedThisCycle = 0
        for i=#lcl.toCheckPosList, 1, -1  do
            local pos = table.remove(lcl.toCheckPosList)
            if not lcl.isChecked(pos, lcl.checkedPosList) then--it could have been added miltiple times
                nbCheckedThisCycle = nbCheckedThisCycle + lcl.fixInsideChunkRegion(lcl.toCheckRefPos, pos, lcl.checkedPosList, nbCheckedThisCycle, lcl.NBSquaresPerCycle)
            end
            if nbCheckedThisCycle >= lcl.NBSquaresPerCycle then--stop session
                break
            end
        end
        if nbCheckedThisCycle < lcl.NBSquaresPerCycle then--stop finished session
            if lcl.Verbose then print ('fixInsideChunkRegion session finished.') end
            if #lcl.toCheckPosList > 0 then
                if lcl.Verbose then 
                    print ('fixInsideChunkRegion there is still job to do: ERROR. ',nbCheckedThisCycle, ' ',#lcl.toCheckPosList)
                    if tab2str then
                        print ('fixInsideChunkRegion CheckPosList ',tab2str(lcl.toCheckPosList))
                    end
                end
            end
            lcl.toCheckRefPos = nil
        end
    end
end

--I keep it active at start in order to be able to take it into account if activated by Star's "Change Sandbox Options" mod
--function lcl.init()
--    if SandboxVars.FixInside and SandboxVars.FixInside.ActivePatch then
        Events.OnPlayerUpdate.Add(lcl.OnPlayerUpdate)
--    end
--end
--Events.OnInitGlobalModData.Add(lcl.init)