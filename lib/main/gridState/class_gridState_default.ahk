class gridState_default
{
    eventShift() {
        eventMgr.resetToDefault()
        eventMgr.enabled := 1
    }

    menuShift() {
        menu.menus["file"].enable()
        
        menu.menus["edit"].enable()
        menu.menus["edit"].menus["copy"].disable()
                          .menus["undo"].enable()
                          .menus["redo"].enable()
        
        menu.menus["shape"].disable()
        
        menu.menus["line"].enable()
        menu.menus["line"].menus["add line anchor"].enable()
        menu.menus["line"].menus["delete"].disable()
    }

    resetProperties() {
        actionStack.acceptingNewActions := 1
        , this.collisionMode := 1
        , this.hoveredShape := -1
        , this.collisionTarget := -1
        , gridState_selecting.collisionTarget := -1
        , gridState_selecting.selectedShape := -1
        , alignMgr.clear()
        , scratchPad.clear().update()
        , scratchPad2.clear().update()
        , backerPad.clear().update()
        , coordComm.updateCoords()
        gui.ctrls["focusDumpster"].focus()
        (! textLayer.isClickThrough) ? textLayer.applyStyles("clickThrough")
    }

    activate() {
        critical, on
        eventMgr.enabled := 0
        , grid.lastActiveState := grid.activeState
        , grid.activeState := "default"
        , this.menuShift()
        , this.resetProperties()
        , this.moveSelector()
        , gui.ctrls["focusDumpster"].focus()
        , this.eventShift()
        this.track()
        critical, off    
    }

    track() {
        cc := coordComm.snapToGridCoords

        shapeCollision := grid.detectProximity_shapes(cc.x, cc.y, grid.padding)
        if (shapeCollision) {
            if shapeCollision.isLineAnchor {
                this.collisionTarget := shapeCollision
                this.hoverShape(this.collisionTarget)
                return
            }
        }

        this.collisionTarget := grid.detectProximity_lines(cc.x, cc.y)
        if this.collisionTarget {
            this.hoverShape(this.collisionTarget)
            return
        }
        
        if (shapeCollision) {
            this.collisionTarget := shapeCollision
            this.hoverShape(this.collisionTarget)
            return
        }

        if (coordComm.gridCoords[1] = 760 or coordComm.gridCoords[2] = 1000) ;// keeps cursorbox from going out of bounds
            return

        this.moveSelector()
        this.export()

        (this.collisionMode) ? this.hoverGrid()
    }

    export() {
        cc := coordComm.snapToGridCoords
        gridState_drawing.x := cc.x
        , gridState_drawing.y := cc.y
        , gridState_multiSelect.x := cc.x
        , gridState_multiSelect.y := cc.y
    }

    moveSelector() { ;// the cursorBox window moves instead of being redrawn by GDI, so its coordinates are relative to client
        this.clientCoords := coordComm.gridToClient([coordComm.snapToGridCoords.x, coordComm.snapToGridCoords.y])
        , cursorBox.window.move(this.clientCoords[1], this.clientCoords[2])
    }

    hoverGrid() {
        this.hoveredShape := -1
        , this.collisionMode := 0
        , eventMgr.events["leftClick"].swap(2, "gridState_drawing_activate")
        , scratchPad.clear().update()
        , cursorBox.plainShow("NA")
        , cursor.reset()
    }

    hoverShape(shape) {
        if (shape.alias = this.hoveredShape.alias)
            return
        this.collisionMode := 1
        , eventMgr.events["leftClick"].swap(2, "gridState_selecting_activate")
        , cursorBox.hide()
        , scratchPad.clear()
        , outlineWidth := shape.isLineAnchor ? 2 : 1
        , shape.outline("black", outlineWidth)
        , scratchPad.update()
        , this.hoveredShape := shape
        gui.window.isActive() ? cursor.set("fingerPoint")
    }
}