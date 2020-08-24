class gridState_copying
{
    eventShift() {
        eventMgr.resetToDefault()

        eventMgr.events["mouseMove"].swap(1, "init")
        eventMgr.events["mouseMove"].swap(2, "gridState_copying_track")
        eventMgr.events["mouseMove"].enabled := 1

        eventMgr.events["leftClick"].swap(1, "init")
        eventMgr.events["leftClick"].swap(2, "gridState_copying_paste")
        eventMgr.events["leftClick"].enabled := 1

        eventMgr.events["rightClick"].swap(2, "gridState_copying_abort")
        eventMgr.events["rightClick"].enabled := 1
    }

    menuShift() {
        menu.menus["file"].disable()
        menu.menus["edit"].disable()
        menu.menus["shape"].disable()
        menu.menus["line"].disable()
    }

    resetProperties() {
        cursor.reset()
        this.selectedShape := gridState_selecting.selectedShape
    }

    activate() {
        critical, on
        eventMgr.enabled := 0
        
        if grid.activeState != "selecting" or ! isObject(gridState_selecting.selectedShape) {
            gridState_default.activate()
            return
        }

        grid.lastActiveState := grid.activeState
        grid.activeState := "copying" 

        this.resetProperties()
        if this.selectedShape.isLineAnchor {
            gridState_default.activate()
            return
        }

        this.menuShift()
        this.drawDashedOutline()
        this.eventShift()
        sleep 150
        critical, off
    }

    drawDashedOutline() {
        shape := this.selectedShape
        scratchPad2.drawRect("black", 1, shape.x, shape.y, shape.w, shape.h, 1, 1)
        scratchPad2.update()
    }

    detectAsynchronousCall() {
        return (grid.activeState = "copying") ? 0 : 1
    }

    renderDestinationOutline(valid) {
        shape := this.selectedShape

        color := valid ? "black" : "offRed"

        scratchPad.clear()
        scratchPad.drawRect(color, 1, this.x, this.y, shape.w, shape.h, 1)
        scratchPad.update()
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
        or grid.detectOverlap_shapes(this.x, this.y, shape.w, shape.h) {
            eventMgr.events["leftClick"].swap(2, "gridState_copying_abort")
            , this.renderDestinationOutline(0)
            , alignMgr.clear()
            return
        }

        this.collisionTarget := grid.detectProximity_shapes(cc[1], cc[2], grid.padding)

        if this.collisionTarget = 0 {
            eventMgr.events["leftClick"].swap(2, "gridState_copying_paste")
            , this.renderDestinationOutline(1)
            , alignMgr.detect(this.x, this.y, this.x2, this.y2, shape.alias)
        } else {
            eventMgr.events["leftClick"].swap(2, "gridState_copying_abort")
            , this.renderDestinationOutline(0)
            , alignMgr.clear()
        }
    }

    paste() {
        eventMgr.enabled := 0
        actionStack.acceptingNewActions := 0
        
        shape := this.selectedShape
        newShape := grid.addShape(shape.form, this.x, this.y, shape.w, shape.h)
        newShape.render()
        if (shape.text) {
            newShape.text := shape.text
            newShape.textSize := shape.textSize
            newShape.sizeAlias := shape.sizeAlias
            newShape.textBold := shape.textBold
        }
        (newShape.bitmap) ? newShape.bitmap := shape.bitmap
        newShape.repos(this.x, this.y, shape.w, shape.h)
        newShape.vCenterText()
        actionStack.acceptingNewActions := 1

        a := actionStack.add(newShape.alias)
        a.addUndoAction(grid, "removeShape").setParams(newShape.alias)
        a.addUndoAction(shapeLayer, "update")
        a.addRedoAction(grid, "importShape").setParams(newShape.form, newShape.export())
        a.addRedoAction(newShape.alias, "repos").setParams(newShape.x, newShape.y, newShape.w, newShape.h)

        gridState_default.activate()
    }

    abort() {
        eventMgr.enabled := 0
        gridState_default.activate()
    }
}