class gridState_selecting
{
    eventShift() {
        critical, on

        eventManager.enabled := 0
        eventMgr.resetToDefault()

        eventMgr.events["mouseMove"].swap(1, "init")
        eventMgr.events["mouseMove"].swap(2, "gridState_selecting_track")
        eventMgr.events["mouseMove"].enabled := 1

        eventMgr.events["leftClick"].enabled := 1

        eventMgr.events["rightClick"].enabled := 1

        critical, off
    }

    eventShift2() { ;// eventShift() has to happen in order for selectShape() to work; this function depends on selectShape()
        if this.selectedShape.bitmap or this.shapeType = "lineAnchor" {
            eventManager.events["doubleLeftClick"].enabled := 0
        } else {
            eventMgr.events["doubleLeftClick"].swap(2, "gridState_textEntry_activate")
            eventMgr.events["doubleLeftClick"].enabled := 1
        }
    }

    menuShift() {
        menu.menus["file"].disable()
        menu.menus["edit"].enable()

        if this.shapeType = "shape" {
            menu.menus["shape"].enable()
            menu.menus["line"].disable()
            m := menu.menus["shape"]
            (grid.shapes.count() < 2) ? m.menus["Connect to another shape`tx"].disable() : m.menus["Connect to another shape`tx"].enable()
            m.menus["color"].enable()
            m.menus["copy`tctrl+c"].enable()
            m.menus["connect to another shape`tx"].enable()
            m.menus["Delete"].enable()
            m.menus["Crop"].disable()
            m.menus["color"].menus["gray"].uncheck()
            m.menus["color"].menus["red"].uncheck()
            m.menus["color"].menus["blue"].uncheck()
            m.menus["color"].menus["green"].uncheck()
            m.menus["color"].menus["yellow"].uncheck()
            m.menus["color"].menus["orange"].uncheck()
            m.menus["color"].menus["purple"].uncheck()
            m.menus["color"].menus[strReplace(this.selectedShape.bgColor, "muted")].check()
            if this.selectedShape.container {
                m.menus["text properties"].enable()
                m.menus["add screenshot to shape"].disable()
                m.menus["text properties"].menus["normal"].check()
                m.menus["text properties"].menus["bold"].uncheck()
                m.menus["text properties"].menus["small"].uncheck()
                m.menus["text properties"].menus["large"].uncheck()
                m.menus["text properties"].menus["huge"].uncheck()
                m.menus["text properties"].menus[this.selectedShape.sizeAlias].check()
                if this.selectedShape.textBold
                    m.menus["text properties"].menus["bold"].check(), m.menus["text properties"].menus["normal"].uncheck()
            } else if this.selectedShape.bitmap {
                m.menus["add screenshot to shape"].enable()
                m.menus["crop"].enable()
                m.menus["color"].disable()
                m.menus["add/edit shape text"].disable()
            } else {
                m.menus["text properties"].disable()
                m.menus["add/edit shape text"].enable()
                m.menus["add screenshot to shape"].enable() 
                m.menus["crop"].disable()
            }
        } else if this.shapeType = "line" {
            menu.menus["line"].enable()
            menu.menus["shape"].disable()
            menu.menus["line"].menus["add line anchor"].disable()
            menu.menus["line"].menus["delete"].enable()
        } else if this.shapeType = "lineAnchor" {
            menu.menus["file"].disable()
            menu.menus["edit"].disable()
            m := menu.menus["shape"]
            m.enable()
            m.menus["Copy`tCtrl+C"].disable()
            m.menus["Connect to another shape`tx"].enable()
            m.menus["Form"].disable()
            m.menus["Color"].disable()
            m.menus["Adjust Position"].disable()
            m.menus["Add screenshot to shape"].disable()
            m.menus["Crop"].disable()
            m.menus["Add/edit shape text"].disable()
            m.menus["Text properties"].disable()
            m.menus["Delete"].enable()
            menu.menus["line"].disable()
        }
    }

    resetProperties() {
        this.selectedShape := -1
        this.collisionTarget := -1
        cursor.reset()
        alignMgr.clear()
    }

    activate(forceSelection = 0) {
        critical, on
        grid.lastActiveState := grid.activeState
        grid.activeState := "selecting"
        this.resetProperties()
        this.eventShift()

        if (forceSelection) {
            gridState_default.collisionTarget := forceSelection
        }

        this.selectShape(gridState_default.collisionTarget)
        this.menuShift()
        this.eventShift2()
        critical, off
    }

    detectAsynchronousCall() {
        return grid.activeState = "selecting" ? 0 : 1
    }

    track() {
        if this.detectAsynchronousCall()
            return

        cc := coordComm.snapToGridCoords

        if this.shapeType != "lineAnchor" {
            this.collisionTarget := grid.detectCollision_shapes_corners(cc.x, cc.y)
            if this.collisionTarget {
                this.hoverEdge(this.collisionTarget)
                return
            }
            this.collisionTarget := grid.detectCollision_shapes_perimeters(cc.x, cc.y)
            if this.collisionTarget {
                this.hoverEdge(this.collisionTarget)
                return
            }
        }

        cursor.reset()

        this.collisionTarget := grid.detectCollision_shapes(cc.x, cc.y)

        if this.collisionTarget.alias = this.selectedShape.alias {
            eventMgr.events["leftClick"].swap(2, "gridState_moving_activate") 
        } else if this.collisionTarget {
            eventMgr.events["leftClick"].swap(2, "gridState_selecting_swapSelection")
        } else eventMgr.events["leftClick"].swap(2, "gridState_default_activate")
    }

    swapSelection() {
        eventManager.enabled := 0
        this.activate(this.collisionTarget)
    }

    selectShape(shape) {
        this.selectedShape := shape
        this.shapeType := grid.isLineAnchor(shape) ? "lineAnchor" : grid.extractType(this.selectedShape)
        scratchPad.clear()
        if (this.shapeType = "line" or this.shapeType = "lineAnchor")
            this.selectedShape.outline("black", 2)
        else if (this.shapeType = "shape")
            this.selectedShape.handleOutline()
        scratchPad.update()
    }

    hoverEdge(shape) {
        if shape[1].alias != this.selectedShape.alias
            return

        eventMgr.events["leftClick"].swap(2, "gridState_resizing_activate")
        shapeObj := shape[1]
        orientation := shape[2]

        if (orientation = "topLeft_rect" or orientation = "bottomRight_rect")
            cursor.set("resizeUpLeft")
        else if (orientation = "topRight_rect" or orientation = "bottomLeft_rect")
            cursor.set("resizeUpRight")
        else if (orientation = "midLeft_rect" or orientation = "midRight_rect")
            cursor.set("resizeSideToSide")
        else cursor.set("resizeUpDown")

        this.export(orientation)
    }

    export(orientation) {
        gridState_resizing.orientation := orientation
    }
}
