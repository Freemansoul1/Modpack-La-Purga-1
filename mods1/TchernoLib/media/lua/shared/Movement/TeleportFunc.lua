


MovePlayer = MovePlayer or {}

function MovePlayer.Teleport(isoMovingObject, x, y, z, args)
    isoMovingObject:setX(x)
    isoMovingObject:setY(y)
    isoMovingObject:setZ(z)
    
    if not args or not args.isPseudoMovement then
        isoMovingObject:setLx(x)
        isoMovingObject:setLy(y)
        isoMovingObject:setLz(z)
    end

    if args and args.isLongDistance then
        --TODO register callback on tick to enforce the teleport until the zone is loaded
    end
end