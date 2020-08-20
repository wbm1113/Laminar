class gridState_addingLineAnchor
{
    static dummyWidth := 20
    static dummyHeight := 20

    eventShift() {
        eventMgr.enabled := 0
        eventMgr.resetToDefault()

        eventMgr.events["mouseMove"].swap(1, "init")
        eventMgr.events["mouseMove"].swap(2, "gridState_addingLineAnchor_track")
        eventMgr.events["mouseMove"].enabled := 1

        eventMgr.events["leftClick"].swap(1, "init")
        eventMgr.events["leftClick"].swap(2, 0)
        eventMgr.events["leftClick"].enabled := 1

        eventMgr.events["rightClick"].enabled := 1
    }

    menuShift() {
        menu.menus["file"].disable()
        menu.menus["edit"].disable()
        menu.menus["shape"].disable()
        menu.menus["line"].disable()
    }

    resetProperties() {
        cursorBox.hide()
    }

    detectInvalidConditions() {
        return (grid.activeState = "default") ? 0 : 1
    }

    activate() {
        if this.detectInvalidConditions()
            return



        grid.lastActiveState := grid.activeState
        grid.activeState := "addingLineAnchor"
        
        this.eventShift()
        this.menuShift()
        this.resetProperties()
    }

    track() {
        scratchPad.clear()

        cc := coordComm.gridCoords
        this.x := cc[1] - this.dummyWidth
        this.y := cc[2] - this.dummyHeight
        this.w := this.dummyWidth
        this.h := this.dummyHeight

        if (! isObject(this.dummy))
            this.dummy := new diamond(this.x, this.y, this.w, this.h)

        this.dummy.reset()
        this.dummy.updateCoords(this.x, this.y, this.w, this.h)

        if grid.detectProximity_shapes(this.x + this.dummyWidth // 2, this.y + this.dummyHeight // 2, grid.padding * 1.5) {
            eventMgr.events["leftClick"].swap(2, 0)
            this.dummy.draw(scratchPad, "offRed", 1)
        } else {
            eventMgr.events["leftClick"].swap(2, "gridState_addingLineAnchor_add")
            this.dummy.draw(scratchPad, "darkGray", 1)
        }

        scratchPad.update()
    }
    
    add() {
        eventMgr.enabled := 0
        scratchPad.clear().update()

        actionStack.acceptingNewActions := 0
        la := grid.addShape("diamond", this.x, this.y, this.w, this.h)
        la.isLineAnchor := 1
        la.setBgColor("lightBlue")
        la.repos(this.x, this.y, this.w, this.h)
        actionStack.acceptingNewActions := 1

        a := actionStack.add(la.alias)
        a.addUndoAction(grid, "removeShape").setParams(la.alias)
        a.addUndoAction(shapeLayer, "update")
        a.addRedoAction(grid, "importShape").setParams(la.type, la.export())
        a.addRedoAction(la.alias, "repos")
        a.addRedoAction(shapeLayer, "update")

        shapeLayer.update()
        gridState_default.activate()
    }
}