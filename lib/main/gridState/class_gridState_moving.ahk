class gridState_moving
{
    eventShift() {
        eventMgr.resetToDefault()

        eventMgr.events["mouseMove"].swap(1, "init")
        eventMgr.events["mouseMove"].swap(2, "gridState_moving_track")
        eventMgr.events["mouseMove"].enabled := 1

        eventMgr.events["rightClick"].swap(1, "gridState_moving_abort")
        eventMgr.events["rightClick"].enabled := 1

        eventMgr.events["leftClickRelease"].swap(2, "gridState_moving_move")
        eventMgr.events["leftClickRelease"].enabled := 1
    }

    menuShift() {
        menu.menus["file"].disable()
        menu.menus["edit"].disable()
        menu.menus["shape"].disable()
        menu.menus["line"].disable()
    }

    resetProperties() {
        this.selectedShape := gridState_selecting.selectedShape
        this.x := this.initial_x := this.selectedShape.x
        this.y := this.initial_y := this.selectedShape.y
        this.w := this.initial_w := this.selectedShape.w
        this.h := this.initial_h := this.selectedShape.h
        this.x2 := this.x + this.w ;// these are for autoAlign only
        this.y2 := this.y + this.h ;// these are for autoAlign only
        scratchPad.clear().update()
    }

    activate() {
        critical, on
        eventMgr.enabled := 0

        this.resetProperties()
        
        this.menuShift()

        cursor.set("pan")

        grid.lastActiveState := grid.activeState
        grid.activeState := "moving"

        this.eventShift()
        critical, off
    }

    liveUpdate(valid) {
        shape := this.selectedShape
        if (valid) {
            if (this.lastLiveUpdate = 0)
                scratchPad.clear().update()
            shape.rapidRepos(this.x, this.y, this.w, this.h)
        } else {
            scratchPad.clear()
            scratchPad.drawRect("offRed", 1, this.x, this.y, this.w, this.h, 1)
            scratchPad.update()
        }
        this.lastLiveUpdate := valid
    }

    detectAsynchronousCall() {
        return grid.activeState = "moving" ? 0 : 1
    }

    track() {
        if this.detectAsynchronousCall()
            return

        shape := this.selectedShape
        , cc := coordComm.gridCoords
        , this.x := (cc[1] - shape.w // 2)
        , this.y := (cc[2] - shape.h // 2)
        , this.x2 := this.x + shape.w
        , this.y2 := this.y + shape.h

        if grid.detectCollision_outOfBounds(this.x, this.y, this.x2, this.y2) 
        or grid.detectOverlap_shapes(this.x, this.y, shape.w, shape.h, shape.alias) {
            eventMgr.events["leftClickRelease"].swap(2, "gridState_moving_abort")
            , this.liveUpdate(0)
            , alignMgr.clear()
            return
        }

        this.collisionTarget := grid.detectProximity_shapes(cc[1], cc[2], grid.padding)

        if this.collisionTarget = 0 or this.collisionTarget.alias = shape.alias {
            eventMgr.events["leftClickRelease"].swap(2, "gridState_moving_move")
            , this.liveUpdate(1)
            , alignMgr.detect(this.x, this.y, this.x2, this.y2, this.selectedShape.alias)
        } else {
            eventMgr.events["leftClickRelease"].swap(2, "gridState_moving_abort")
            , this.liveUpdate(0)
            , alignMgr.clear()
        }
    }

    move() {
        eventMgr.enabled := 0
        alignMgr.clear()
        this.selectedShape.repos(this.x, this.y)
        gridState_selecting.activate()
    }

    abort() {
        eventMgr.enabled := 0
        actionStack.acceptingNewActions := 0
        this.selectedShape.repos(this.initial_x, this.initial_y, this.initial_w, this.initial_h)
        gridState_default.activate()
    }
}