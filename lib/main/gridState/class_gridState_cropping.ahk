class gridState_cropping
{
    orientation := ""

    eventShift() {
        eventMgr.enabled := 0
        eventMgr.resetToDefault()

        eventMgr.events["mouseMove"].swap(1, "init")
        eventMgr.events["mouseMove"].swap(2, "gridState_cropping_track")
        eventMgr.events["mouseMove"].enabled := 1

        eventMgr.events["leftClick"].swap(2, "gridState_cropping_trackToAdjust")
        eventMgr.events["leftClick"].enabled := 1

        eventMgr.events["leftClickRelease"].swap(2, "gridState_cropping_crop")
        eventMgr.events["leftClickRelease"].enabled := 1

        eventMgr.events["rightClick"].swap(2, "gridState_cropping_abort")
        eventMgr.events["rightClick"].enabled := 1
    }

    menuShift() {
        menu.menus["file"].disable()
        menu.menus["edit"].disable()
        menu.menus["shape"].disable()
        menu.menus["line"].disable()
    }

    resetProperties() {
        backerPad.clear().update()
        actionStack.acceptingNewActions := 0
        this.collisionTarget := 0
        this.selectedShape := gridState_selecting.selectedShape
        this.x_baseLine := this.x := this.selectedShape.x
        this.y_baseLine := this.y := this.selectedShape.y
        this.w_baseLine := this.w := this.selectedShape.w
        this.h_baseLine := this.h := this.selectedShape.h
    }

    activate() {
        critical, on
        eventMgr.enabled := 0

        this.resetProperties()

        if (! this.selectedShape.bitmap) {
            gridState_default.activate()
            return
        }

        this.renderBackerBitmap()
        this.drawOutline()

        grid.lastActiveState := grid.activeState
        grid.activeState := "cropping"

        this.menuShift()
        this.eventShift()

        sleep 150
        critical, off
    }

    renderBackerBitmap() {
        this.selectedShape.renderImage(backerPad)
        this.selectedShape.clear()
        shapeLayer.update()
        backerPad.update()
    }

    drawOutline() {
        scratchPad.clear()
        this.selectedShape.outline("white")
        this.selectedShape.handleOutline("black", "lightGray")
        scratchPad.update()
    }

    track() {
        cc := coordComm.snapToGridCoords
        
        this.collisionTarget := grid.detectCollision_shapes_corners(cc.x, cc.y)
        (this.collisionTarget = 0) ? this.collisionTarget := grid.detectCollision_shapes_perimeters(cc.x, cc.y)

        if this.collisionTarget[1].alias != this.selectedShape.alias {
            cursor.reset()
            return
        }

        orientation := this.collisionTarget[2]

        if (orientation = "topLeft_rect" or orientation = "bottomRight_rect")
            cursor.set("resizeUpLeft")
        else if (orientation = "topRight_rect" or orientation = "bottomLeft_rect")
            cursor.set("resizeUpRight")
        else if (orientation = "midLeft_rect" or orientation = "midRight_rect")
            cursor.set("resizeSideToSide")
        else cursor.set("resizeUpDown")

        this.orientation := orientation
    }

    trackToAdjust() {
        cc := coordComm.gridCoords
        if ! grid.detectProximity_withShape(this.selectedShape.alias, cc[1], cc[2]) {
            this.crop()
            return
        }
        eventMgr.events["mouseMove"].swap(2, "gridState_cropping_adjust")
        eventMgr.events["leftClickRelease"].swap(2, "gridState_cropping_adjustToTrack")
    }

    adjustToTrack() {
        this.eventShift()
    }

    adjust() {
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
        
        this.selectedShape.updateCoords(this.x, this.y, this.w, this.h)
        shapeLayer.fillRect("transBlack", this.x_baseLine, this.y_baseLine, this.w_baseLine, this.h_baseLine)
        shapeLayer.clip(this.x, this.y, this.w, this.h).clear().unclip().update()
        this.drawOutline()
    }

    expandLeft() {
        cc := object()
        cc.x := coordComm.gridCoords[1]
        cc.y := coordComm.gridCoords[2]
        if (cc.x > this.selectedShape.x) {
            this.w := this.selectedShape.w - abs(cc.x - this.selectedShape.x)
            if this.w <= grid.minimumShapeWidth {
                this.x := this.selectedShape.topRight[1] - grid.minimumShapeWidth
                this.w := grid.minimumShapeWidth
            } else this.x := cc.x
        } else {
            this.x := cc.x
            this.w := this.selectedShape.w + abs(cc.x - this.selectedShape.x)
        }

        if (this.x < this.x_baseLine) {
            this.x := this.x_baseLine
            this.w := this.selectedShape.w + abs(this.x - this.selectedShape.x)
        }
    }

    expandUp() {
        cc := object()
        cc.x := coordComm.gridCoords[1]
        cc.y := coordComm.gridCoords[2]
        if (cc.y > this.selectedShape.y) {
            this.h := this.selectedShape.h - abs(cc.y - this.selectedShape.y)
            if this.h <= grid.minimumShapeHeight {
                this.y := this.selectedShape.bottomRight[2] - grid.minimumShapeHeight
                this.h := grid.minimumShapeHeight
            } else this.y := cc.y
        } else {
            this.y := cc.y
            this.h := this.selectedShape.h + abs(cc.y - this.selectedShape.y)
        }

        if (this.y < this.y_baseLine) {
            this.y := this.y_baseLine
            this.h := this.selectedShape.h + abs(this.y - this.selectedShape.y)
        }
    }

    expandRight() {
        cc := object()
        cc.x := coordComm.gridCoords[1]
        cc.y := coordComm.gridCoords[2]
        if (cc.x < this.selectedShape.topRight[1]) {
            this.w := this.selectedShape.w - abs(cc.x - this.selectedShape.topRight[1])
            if this.w <= grid.minimumShapeWidth
                this.w := grid.minimumShapeWidth
        } else this.w := this.selectedShape.w + abs(cc.x - this.selectedShape.topRight[1])

        if (this.w > (this.w_baseLine - (abs(this.x - this.x_baseLine)))) {
            this.w := (this.w_baseLine - (abs(this.x - this.x_baseLine)))
        }
    }

    expandDown() {
        cc := object()
        cc.x := coordComm.gridCoords[1]
        cc.y := coordComm.gridCoords[2]
        if (cc.y < this.selectedShape.bottomRight[2]) {
            this.h := this.selectedShape.h - abs(cc.y - this.selectedShape.bottomRight[2])
            if this.h <= grid.minimumShapeHeight
                this.h := grid.minimumShapeHeight
        } else this.h := this.selectedShape.h + abs(cc.y - this.selectedShape.bottomRight[2])

        if (this.h > (this.h_baseLine - (abs(this.y - this.y_baseLine)))) {
            this.h := (this.h_baseLine - (abs(this.y - this.y_baseLine)))
        }
    }

    crop() {
        eventMgr.enabled := 0

        s := this.selectedShape
        backerPad.clear().update()
        scratchPad.clear().update()
        shapeLayer.clip(this.x_baseLine, this.y_baseLine, this.w_baseLine, this.h_baseLine).clear().unclip()

        preCropBitmap := s.bitmap

        this.x := round(this.x, -1)
        this.y := round(this.y, -1)
        this.w := round(this.w, -1)
        this.h := round(this.h, -1)

        this.selectedShape.cropImage(this.x - this.x_baseLine, this.y - this.y_baseLine, this.w, this.h)
        this.selectedShape.repos(this.x, this.y, this.w, this.h)

        actionStack.acceptingNewActions := 1

        a := actionStack.add(s.alias)
        a.addUndoAction(s.alias, "attachBitmap").setParams(preCropBitmap)
        a.addUndoAction(s.alias, "repos").setParams(this.x_baseLine, this.y_baseLine, this.w_baseLine, this.h_baseLine)
        a.addRedoAction(s.alias, "cropImage").setParams(this.x - this.x_baseLine, this.y - this.y_baseLine, this.w, this.h)
        a.addRedoAction(s.alias, "repos").setParams(this.x, this.y, this.w, this.h)

        gridState_default.activate()
    }

    abort() {
        eventMgr.enabled := 0
        backerPad.clear().update()
        scratchPad.clear().update()
        shapeLayer.clip(this.x_baseLine, this.y_baseLine, this.w_baseLine, this.h_baseLine).clear().unclip()
        this.selectedShape.repos(this.x_baseLine, this.y_baseLine, this.w_baseLine, this.h_baseLine)
        shapeLayer.update()
        gridState_default.activate()
    }
}