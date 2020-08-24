class gridState_textEntry
{
    eventShift() {
        eventMgr.enabled := 0
        eventMgr.resetToDefault()

        eventMgr.events["leftClick"].swap(1, "init")
        eventMgr.events["leftClick"].swap(2, "gridState_textEntry_confirm")
        eventMgr.events["leftClick"].enabled := 1

        eventMgr.events["rightClick"].swap(2, "gridState_textEntry_confirm")
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
        this.initialShapeText := ""
    }

    activate() {
        critical, on
        eventMgr.enabled := 0

        actionStack.acceptingNewActions := 0

        this.shape := gridState_selecting.selectedShape

        if (this.shape.bitmap) {
            gridState_default.activate()
            sleep 300
            return
        }

        cc := coordComm.snapToGridCoords
        shapeUnderneathMouse := grid.detectProximity_shapes(cc.x, cc.y, grid.padding)
        if (shapeUnderneathMouse.alias != this.shape.alias) {
            gridState_default.activate()
            sleep 300
            return
        }

        grid.lastActiveState := grid.activeState
        grid.activeState := "textEntry"

        this.menuShift()
        this.resetProperties()

        this.shape.attachText()
        this.initialShapeText := this.shape.text
        this.shape.startEditingText()

        this.eventShift()
        sleep 150
        critical, off
    }

    confirm() {
        if grid.detectCollision_withShape(this.shape.alias, coordComm.snapToGridCoords.x, coordComm.snapToGridCoords.y)
            return

        this.shape.stopEditingText()

        actionStack.acceptingNewActions := 1
        
        a := actionStack.add(this.shape.alias)
        a.addUndoAction(this.shape.alias, "updateText").setParams(this.initialShapeText)
        a.addUndoAction(this.shape.alias, "conformTextToShape")
        a.addRedoAction(this.shape.alias, "updateText").setParams(this.shape.text)
        a.addRedoAction(this.shape.alias, "conformTextToShape")

        gridState_default.activate()
    }
}