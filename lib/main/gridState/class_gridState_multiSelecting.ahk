class gridState_multiSelecting
{
    eventShift() {
        eventMgr.enabled := 0

        eventMgr.resetToDefault()

        eventMgr.events["mouseMove"].swap(1, "init")
        eventMgr.events["mouseMove"].swap(2, 0)
        eventMgr.events["mouseMove"].enabled := 1

        eventMgr.events["leftClick"].swap(2, "gridState_multiSelecting_enableTracking")
        eventMgr.events["leftClick"].enabled := 1

        eventMgr.events["rightClick"].swap(1, "gridState_multiSelecting_abort")
        eventMgr.events["rightClick"].enabled := 1
    }

    menuShift() {
        menu.menus["file"].disable()
        
        menu.menus["edit"].disable()
        
        m := menu.menus["shape"]
        m.enable()
        m.menus["copy`tctrl+c"].disable()
        m.menus["connect to another shape`tx"].disable()
        m.menus["add screenshot to shape"].disable()
        m.menus["crop"].disable()
        m.menus["add/edit shape text"].disable()
        m.menus["text properties"].disable()
        m.menus["Delete"].disable()
        m.menus["color"].menus["gray"].uncheck()
        m.menus["color"].menus["red"].uncheck()
        m.menus["color"].menus["blue"].uncheck()
        m.menus["color"].menus["green"].uncheck()
        m.menus["color"].menus["yellow"].uncheck()
        m.menus["color"].menus["orange"].uncheck()
        m.menus["color"].menus["purple"].uncheck()
        
        menu.menus["line"].disable()
    }

    resetProperties() {
        this.preMoveCoords := []
        this.selectedShapes := []
        this.collisionTarget := 0
        cursor.reset()
        cursor.setAll("cross")
        cursorBox.hide()
    }

    activate() {
        grid.lastActiveState := grid.activeState
        grid.activeState := "multiSelecting"
        this.resetProperties()
        this.eventShift()
        this.menuShift()
    }

    enableTracking() {
        cc := coordComm.gridCoords
        this.anchorX := cc[1]
        this.anchorY := cc[2]
        
        eventMgr.events["mouseMove"].swap(2, "gridState_multiSelecting_track")
        eventMgr.events["leftClickRelease"].swap(2, "gridState_multiSelecting_select")
        eventMgr.events["leftClickRelease"].enabled := 1
    }

    orientDrawingBox() {
        cc := coordComm.gridCoords
        , x := this.anchorX
        , y := this.anchorY
        , w := cc[1] - x
        , h := cc[2] - y

        if getKeyState("shift")
            h := w > h ? w : h
            , w := h > w ? h : w

        x += w < 0 ? w : 0
        , y += h < 0 ? h : 0
        , w := abs(w)
        , h := abs(h)
        , this.x := x
        , this.y := y
        , this.w := w
        , this.h := h
    }

    track() {
        this.orientDrawingBox()
        scratchPad2.drawRect("black", 1, this.x, this.y, this.w, this.h, 1, 1)
        scratchPad2.update()
    }

    select() {
        if (this.x = "" or this.y = "" or this.w = "" or this.h = "")
            return

        this.eventShift()

        scratchPad2.clear().update()
        scratchPad.clear().update()

        this.selectedShapes := grid.getOverlappedShapes(this.x, this.y, this.w, this.h)

        for i, s in this.selectedShapes
            s.handleOutline()

        this.selectedShapes_initialStates := []
        for i, s in this.selectedShapes
            this.selectedShapes_initialStates.push(s.export())

        this.shapesToNotMove := []
        for i, shape in grid.shapes {
            for j, mover in this.selectedShapes {
                if (shape.alias = mover.alias) {
                    continue 2
                }
            }
            this.shapesToNotMove.push(shape)
        }

        scratchPad.update()
        cursor.reset()
        eventMgr.events["leftClick"].swap(2, "gridState_multiSelecting_confirm")
    }

    confirm() {
        cc := coordComm.gridCoords
        this.collisionTarget := grid.detectCollision_shapes(cc[1], cc[2])
        if (this.collisionTarget) {
            this.preMoveCoords := cc
            textLayerEffects.fadeOut()
            while textLayerEffects.fading
                sleep 10
            eventMgr.events["mouseMove"].swap(2, "gridState_multiSelecting_multiMove_track")
            eventMgr.events["leftClickRelease"].swap(1, 0)
            eventMgr.events["leftClickRelease"].enabled := 1
        } else {
            this.multiMove_move()
        }
    }

    multiMove_track() {
        cc := coordComm.gridCoords

        scratchPad.clear()
        shapeLayer.clear()

        for i, shape in this.shapesToNotMove
            shape.rapidRepos(,,,, 0)

        for i, shape in this.selectedShapes {
            shape_initial_state := this.selectedShapes_initialStates[a_index]
            shape.x := shape_initial_state.x + cc[1] - this.preMoveCoords[1]
            shape.y := shape_initial_state.y + cc[2] - this.preMoveCoords[2]
            shape.rapidRepos(x, y, shape.w, shape.h, 0)
            (shape.isLineAnchor) ? shape.outline("black", 2) : shape.handleOutline()
        }

        bb := new compositeBoundingBox()
        bb.calculate(this.selectedShapes)
        bb := bb.create(grid.gridSize * 2)

        if grid.detectCollision_outOfBounds(bb.x, bb.y, bb.x2, bb.y2) {
            eventMgr.events["leftClickRelease"].swap(1, 0)
            scratchPad.drawRect("offRed", 1, bb.x, bb.y, bb.w, bb.h)
            shapeLayer.update()
            scratchPad.update()
            return
        }

        this.collisionTarget := 0
        for i, s in this.shapesToNotMove {
            if (s.x < bb.x + bb.w and s.x + s.w > bb.x and s.y < bb.y + bb.h and s.y + s.h > bb.y) {
                this.collisionTarget := s
                break
            }
        }

        if (this.collisionTarget) {
            eventMgr.events["leftClickRelease"].swap(1, 0)
            scratchPad.drawRect("offRed", 1, bb.x, bb.y, bb.w, bb.h)
            shapeLayer.update()
            scratchPad.update()
            return
        }

        eventMgr.events["leftClickRelease"].swap(1, "gridState_multiSelecting_multiMove_move")
        scratchPad.drawRect("black", 1, bb.x, bb.y, bb.w, bb.h, 0, 1)

        shapeLayer.update()
        scratchPad.update()
    }

    multiMove_move() {
        eventMgr.enabled := 0
        shapeLayer.clear()

        a := actionStack.add("multiSelect_move")
        a.addUndoAction(shapeLayer, "clear")
        for i, s in this.selectedShapes {
            iS := this.selectedShapes_initialStates[a_index]
            a.addUndoAction(s.alias, "disableTextRedraw")
            a.addUndoAction(s.alias, "rapidRepos").setParams(iS.x, iS.y,,, 0)
        }
        a.addUndoAction(grid, "redrawLines")
        for i, s in grid.shapes
            a.addUndoAction(s.alias, "rapidRepos").setParams(,,,, 0)
        for i, s in this.selectedShapes
            a.addUndoAction(s.alias, "enableTextRedraw")
        a.addUndoAction(textlayer.window, "speedRedraw")
        a.addUndoAction(shapeLayer, "update")

        actionStack.acceptingNewActions := 0
        shapeLayer.clear()
        for i, s in grid.shapes
            s.rapidRepos(round(s.x, -1), round(s.y, -1),,, 0)
        for i, s in this.selectedShapes
            s.disableTextRedraw()
        grid.redrawLines()
        for i, s in grid.shapes
            s.rapidRepos(,,,, 0)
        for i, s in this.selectedShapes
            s.enableTextRedraw()
        textLayer.window.speedRedraw()
        shapeLayer.update()
        actionStack.acceptingNewActions := 1

        a.addRedoAction(shapeLayer, "clear")
        for i, s in this.selectedShapes
            a.addRedoAction(s.alias, "disableTextRedraw")
            , a.addRedoAction(s.alias, "rapidRepos").setParams(s.x, s.y,,, 0)
        a.addRedoAction(grid, "redrawLines")
        for i, s in grid.shapes
            a.addRedoAction(s.alias, "rapidRepos").setParams(,,,, 0)
        for i, s in this.selectedShapes
            a.addRedoAction(s.alias, "enableTextRedraw")
        a.addRedoAction(textlayer.window, "speedRedraw")
        a.addRedoAction(shapeLayer, "update")

        textLayerEffects.fadeIn()
        gridState_default.activate()
    }

    abort() {
        eventMgr.enabled := 0
        shapeLayer.clear()
        for i, s in this.selectedShapes
            s.import(this.selectedShapes_initialStates[a_index])
        for i, s in grid.shapes
            s.rapidRepos(,,,, 0)
        grid.redrawLines()
        shapeLayer.update()
        gridState_default.activate()
        textLayerEffects.fadeIn()
    }
}