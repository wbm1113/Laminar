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
        actionStack.acceptingNewActions := 0

        grid.lastActiveState := grid.activeState
        grid.activeState := "textEntry"

        this.shape := gridState_selecting.selectedShape

        this.eventShift()
        this.menuShift()
        this.resetProperties()

        this.shape.attachText()
        this.initialShapeText := this.shape.text
        this.shape.startEditingText()
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