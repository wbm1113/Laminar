class gridState_resizing
{
    eventShift() {
        eventMgr.resetToDefault()

        eventMgr.events["mouseMove"].swap(1, "init")
        eventMgr.events["mouseMove"].swap(2, "gridState_resizing_track")
        eventMgr.events["mouseMove"].enabled := 1

        eventMgr.events["leftClickRelease"].swap(2, "gridState_resizing_resize")
        eventMgr.events["leftClickRelease"].enabled := 1

        eventMgr.events["rightClick"].swap(2, "gridState_resizing_abort")
        eventMgr.events["rightClick"].enabled := 1
    }

    menuShift() {
        menu.menus["file"].disable()
        menu.menus["edit"].disable()
        menu.menus["shape"].disable()
        menu.menus["line"].disable()
    }

    resetProperties() {
        scratchPad.clear().update()
        this.selectedShape := gridState_selecting.selectedShape
        this.x := this.initial_x := this.selectedShape.x
        this.y := this.initial_y := this.selectedShape.y
        this.w := this.initial_w := this.selectedShape.w
        this.h := this.initial_h := this.selectedShape.h
        this.x2 := this.initial_x2 := this.x + this.w ;// these are for autoAlign only
        this.y2 := this.initial_y2 := this.y + this.h ;// these are for autoAlign only
        actionStack.acceptingNewActions := 0
    }

    activate() {
        critical, on
        eventMgr.enabled := 0

        this.resetProperties()

        this.menuShift()

        grid.lastActiveState := grid.activeState
        grid.activeState := "resizing"

        this.eventShift()
        critical, off
    }

    track() {
        if this.orientation = "midLeft_rect" 
            or this.orientation = "topLeft_rect"
                or this.orientation = "bottomLeft_rect"
                    this.expandLeft()

        if this.orientation = "midTop_rect"
            or this.orientation = "topLeft_rect"
                or this.orientation = "topRight_rect"
                    this.expandUp()

        if this.orientation = "midRight_rect"
            or this.orientation = "topRight_rect"
                or this.orientation = "bottomRight_rect"
                    this.expandRight()

        if this.orientation = "midBottom_rect"
            or this.orientation = "bottomLeft_rect"
                or this.orientation = "bottomRight_rect"
                    this.expandDown()

        scratchPad.clear()
        scratchPad.drawRect("mediumGray", 1, this.initial_x, this.initial_y, this.initial_w, this.initial_h, 0, 1)

        if grid.detectOverlap_shapes(this.x, this.y, this.w, this.h, this.selectedShape.alias) {
            this.liveUpdate(0)
            , eventMgr.events["leftClickRelease"].swap(2, "gridState_resizing_abort")
            , alignMgr.clear()
        } else {
            this.liveUpdate()
            , alignMgr.detect(this.x, this.y, this.x2, this.y2, this.selectedShape.alias)
            , eventMgr.events["leftClickRelease"].swap(2, "gridState_resizing_resize")
        }
    }

    liveUpdate(valid = 1) {
        shape := this.selectedShape

        if (valid) {
            shape.rapidRepos(this.x, this.y, this.w, this.h)
        } else {
            scratchPad.drawRect("offRed", 1, this.x, this.y, this.w, this.h, 1)
        }

        this.lastLiveUpdate := valid
        scratchPad.update()
    }

    expandLeft() {
        cc := object()
        cc.x := coordComm.gridCoords[1]
        cc.y := coordComm.gridCoords[2]
        if (cc.x > this.selectedShape.x) {
            this.w := this.selectedShape.w - abs(cc.x - this.selectedShape.x)
            if this.w <= grid.minimumShapeWidth {
                this.x := this.selectedShape.x2 - grid.minimumShapeWidth
                this.w := grid.minimumShapeWidth
            } else this.x := cc.x
        } else {
            this.x := cc.x
            this.w := this.selectedShape.w + abs(cc.x - this.selectedShape.x)
        }
        this.x2 := this.x + this.w
    }

    expandUp() {
        cc := object()
        cc.x := coordComm.gridCoords[1]
        cc.y := coordComm.gridCoords[2]
        if (cc.y > this.selectedShape.y) {
            this.h := this.selectedShape.h - abs(cc.y - this.selectedShape.y)
            if this.h <= grid.minimumShapeHeight {
                this.y := this.selectedShape.y2 - grid.minimumShapeHeight
                this.h := grid.minimumShapeHeight
            } else this.y := cc.y
        } else {
            this.y := cc.y
            this.h := this.selectedShape.h + abs(cc.y - this.selectedShape.y)
        }
        this.y2 := this.y + this.h
    }

    expandRight() {
        cc := object()
        cc.x := coordComm.gridCoords[1]
        cc.y := coordComm.gridCoords[2]
        if (cc.x < this.selectedShape.x2) {
            this.w := this.selectedShape.w - abs(cc.x - this.selectedShape.x2)
            if this.w <= grid.minimumShapeWidth
                this.w := grid.minimumShapeWidth
        } else this.w := this.selectedShape.w + abs(cc.x - this.selectedShape.x2)
        this.x2 := this.x + this.w
    }

    expandDown() {
        cc := object()
        cc.x := coordComm.gridCoords[1]
        cc.y := coordComm.gridCoords[2]
        if (cc.y < this.selectedShape.y2) {
            this.h := this.selectedShape.h - abs(cc.y - this.selectedShape.y2)
            if this.h <= grid.minimumShapeHeight
                this.h := grid.minimumShapeHeight
        } else this.h := this.selectedShape.h + abs(cc.y - this.selectedShape.y2)
        this.y2 := this.y + this.h
    }

    resize() {
        eventMgr.enabled := 0

        actionStack.acceptingNewActions := 1
        this.selectedShape.repos(this.x, this.y, this.w, this.h)
        if grid.lastActiveState = "selecting"
            gridState_selecting.activate()
        else gridState_default.activate()
    }

    abort() {
        eventMgr.enabled := 0
        actionStack.acceptingNewActions := 0
        this.selectedShape.repos(this.initial_x, this.initial_y, this.initial_w, this.initial_h)
        gridState_default.activate()
    }
}