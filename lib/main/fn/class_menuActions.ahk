class menuActions
{
    multiSelect() {
        gridState_multiSelecting.activate()
    }

    copy() {
        gridState_copying.activate()
    }

    setBgColor(color) {
        menu.menus["shape"].menus["color"].menus["gray"].uncheck()
        menu.menus["shape"].menus["color"].menus["red"].uncheck()
        menu.menus["shape"].menus["color"].menus["blue"].uncheck()
        menu.menus["shape"].menus["color"].menus["green"].uncheck()
        menu.menus["shape"].menus["color"].menus["yellow"].uncheck()
        menu.menus["shape"].menus["color"].menus["orange"].uncheck()
        menu.menus["shape"].menus["color"].menus["purple"].uncheck()

        if grid.activeState = "selecting"
            shapes := [gridState_selecting.selectedShape]
        else if grid.activeState = "multiSelecting"
            shapes := gridState_multiSelecting.selectedShapes

        a := actionStack.add("bgColor")

        for i, s in shapes {
            a.addUndoAction(s.alias, "setBgColor").setParams(s.bgColor)
            a.addUndoAction(s.alias, "render")
        }
        a.addUndoAction(shapeLayer, "update")

        for i, shape in shapes {
            shape.setBgColor("muted" color)
            shape.render()
            menu.menus["shape"].menus["color"].menus[strReplace(shape.bgColor, "muted")].check()
        }

        for i, s in shapes {
            a.addRedoAction(s.alias, "setBgColor").setParams(s.bgColor)
            a.addRedoAction(s.alias, "render")
        }

        a.addRedoAction(shapeLayer, "update")
        shapeLayer.update()
    }

    static forms := {"rectangle" : "rect"
                   , "rounded rectangle" : "roundRect"
                   , "circle" : "circle"
                   , "diamond" : "diamond" }

    changeShapeForm(form) {
        actionStack.acceptingNewActions := 0

        oldShape := gridState_selecting.selectedShape.export()
        grid.removeShape(oldShape.alias)

        if inStr(form, "arrow") {
            newShape := grid.importShape("arrow", oldShape)
            newShape.pointsToward := strReplace(form, " arrow")
            newShape.updateCoords()
        } else {
            form := this.forms[form]
            if (oldShape.form = form)
                return
            newShape := grid.importShape(form, oldShape)
        }

        newShape.repos()
        newShape.vCenterText()

        actionStack.acceptingNewActions := 1

        a := actionStack.add(newShape.alias)

        a.addUndoAction(grid, "removeShape").setParams(newShape.alias)
        a.addUndoAction(grid, "importShape").setParams(oldShape.form, oldShape)
        a.addUndoAction(oldShape.alias, "repos")
        a.addUndoAction(oldShape.alias, "vCenterText")
        a.addUndoAction(shapeLayer, "update")

        a.addRedoAction(grid, "removeShape").setParams(oldShape.alias)
        a.addRedoAction(grid, "importShape").setParams(newShape.form, newShape.export())
        a.addRedoAction(newShape.alias, "repos")
        a.addRedoAction(newShape.alias, "vCenterText")
        a.addRedoAction(shapeLayer, "update")

        gridState_default.activate()
    }

    adjustShapePosition(direction) {
        direction := regExReplace(direction, "i)`t[a-z ]++")
        if grid.activeState = "selecting" {
            shapeNudge.nudge(direction, [gridState_selecting.selectedShape])
        } else if grid.activeState = "multiSelecting" {
            shapeNudge.nudge(direction, gridState_multiSelecting.selectedShapes)
        }
    }

    crop() {
        gridState_cropping.activate()
    }

    editText() {
        gridState_textEntry.activate()
    }
    
    static fontSizes := { "small" : 10
                        , "large" : 14
                        , "huge" : 20 }

    updateTextProperty(p) {
        if grid.activeState = "selecting"
            shapes := [gridState_selecting.selectedShape]
        else if grid.activeState = "multiSelecting"
            shapes := gridState_multiSelecting.selectedShapes

        a := actionStack.add("updateTextProperty")
        for i, s in shapes {
            a.addUndoAction(s.alias, "updateText").setParams(s.text, s.textSize, s.textBold)
            a.addUndoAction(s.alias, "conformTextToShape")
        }
        a.addUndoAction(gridState_selecting, "activate")

        for i, shape in shapes {
            if (p = "normal")
                bold := 0
            else if (p = "bold")
                bold := 1
            else bold := shape.textBold

            if (this.fontSizes[p]) {
                newSize := this.fontSizes[p]
                shape.sizeAlias := p
            } else {
                newSize := shape.textSize
            }

            shape.updateText( , newSize, bold)
            shape.conformTextToShape()
        }

        for i, s in shapes {
            a.addRedoAction(s.alias, "updateText").setParams(s.text, s.textSize, s.textBold)
            a.addRedoAction(s.alias, "conformTextToShape")
        }
        a.addRedoAction(gridState_selecting, "activate")

        gridState_selecting.activate()
    }

    addLineAnchor() {
        gridState_addingLineAnchor.activate()
    }

    delete() {
        shape := gridState_selecting.selectedShape
        
        if grid.isLine(shape) {

            line := gridState_selecting.selectedShape
            line.remove()

            a := actionStack.add(line.alias.string)
            a.addUndoAction(grid, "importLine").setParams(line.alias.string)
            a.addUndoAction(grid, "redrawOneLine").setParams(line.alias.string)
            a.addRedoAction(line.alias.string).setParams("remove")
            a.addRedoAction(grid, "redrawLines").setParams(0)

        } else {

            if grid.activeState = "selecting"
                shapes := [gridState_selecting.selectedShape]
            else if grid.activeState = "multiSelecting"
                shapes := gridState_multiSelecting.selectedShapes

            for i, shape in shapes
                grid.removeShape(shape.alias)

            shapeLayer.update()

        }

        grid.redrawLines()
        gridState_default.activate()
    }
}