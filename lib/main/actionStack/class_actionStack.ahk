class actionStack
{
    static completedActions := []
    static undoneActions := []
    static acceptingNewActions := 1
    static dummyObj := object()

    reset() {
        this.completedActions := []
        this.undoneActions := []
    }

    add(alias) {
        if ! this.acceptingNewActions
            return dummyObj

        a := new stackAction(alias)

        for i, action in this.undoneActions {
            for j, m in action.undoMethods
                for k, p in m.params
                    dllCall("gdiplus\GdipDisposeImage", "ptr", p)
            for j, m in action.redoMethods
                for k, p in m.params
                    dllCall("gdiplus\GdipDisposeImage", "ptr", p)
        }

        this.undoneActions := []
        this.completedActions.push(a)

        laminarData.saveCommandEnabled := 1
        return a
    }

    undo() {
        if this.completedActions.count() < 1
            return

        if ! this.acceptingNewActions
            return

        this.acceptingNewActions := 0

        action := this.completedActions.pop()
        action.undo()
        this.undoneActions.push(action)
        
        (grid.activeState != "default") ? gridState_default.activate()
        scratchPad.clear().update()

        this.acceptingNewActions := 1
        laminarData.saveCommandEnabled := 1
    }

    redo() {
        if this.undoneActions.count() < 1
            return

        if ! this.acceptingNewActions
            return

        this.acceptingNewActions := 0

        action := this.undoneActions.pop()
        action.redo()
        this.completedActions.push(action)

        scratchPad.clear().update()
        (grid.activeState != "default") ? gridState_default.activate()

        this.acceptingNewActions := 1
        laminarData.saveCommandEnabled := 1
    }
}