class inspector
{
    init() {
        this.gui := new gui("inspector")
        
        this.gui.create()
        this.gui.makeResizable()
        this.gui.setDimensions(50, 100, 500, 800)

        this.gui.setFont(10)

        this.tree := this.gui.ctrls.add("tv", "inspector")
        this.tree.setDimensions(0, 0, 800, 800)
        this.tree.draw()

        this.gui.applyStyles("alwaysOnTop")
    }

    populate() {
        this.tree.setRedraw(0)
        this.tree.delete()
        
        shapeHeader := this.tree.add("shapes")
        
        for i, s in grid.shapes {
            shapeSubHeader := shapeHeader.add(s.alias)
            for i, p in s.properties
                shapeSubHeader.add(p ": " s[p])
        }

        stackHeader := this.tree.add("actionStack")

        stackComplete := stackHeader.add("completed")
        for i, action in actionStack.completedActions {

            alias := stackComplete.add(a_index ": " action.alias)

            undo := alias.add("undo")
            for j, undoMethod in action.undoMethods
                undo.add(undoMethod.alias "." undoMethod.method)

            ;redo := alias.add("redo")
            ;for k, redoMethod in action.redoMethods
            ;    redo.add(redoMethod.alias "." redoMethod.method)
            
        }

        stackUndone := stackHeader.add("undone")
        for i, action in actionStack.undoneActions {

            alias := stackUndone.add(a_index ": " action.alias)

            ;undo := alias.add("undo")
            ;for j, undoMethod in action.undoMethods
            ;    undo.add(undoMethod.alias "." undoMethod.method)
            
            redo := alias.add("redo")
            for k, redoMethod in action.redoMethods
                redo.add(redoMethod.alias "." redoMethod.method)

        }

        this.tree.setRedraw(1)

    }
}