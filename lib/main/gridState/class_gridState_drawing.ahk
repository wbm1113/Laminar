class gridState_drawing
{
    x := 0, y := 0 ;// updates from gridState_default

    eventShift() {
        eventMgr.resetToDefault()

        eventMgr.events["mouseMove"].swap(1, "init")
        eventMgr.events["mouseMove"].swap(2, "gridState_drawing_track")
        eventMgr.events["mouseMove"].enabled := 1

        eventMgr.events["leftClick"].swap(1, "init")
        eventMgr.events["leftClick"].swap(2, "gridState_drawing_addShape")
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
        this.collisionMode := 0
        this.anchorX := this.x
        this.anchorY := this.y
        cursorBox.hide()
    }

    activate() {
        critical, on
        eventMgr.enabled := 0

        if (grid.activeState != "default") {
            gridState_default.activate()
            return
        }

        this.menuShift()
        this.resetProperties()

        grid.lastActiveState := grid.activeState
        grid.activeState := "drawing"
        
        this.eventShift()
        critical, off
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

        if abs(w) < grid.minimumShapeWidth
            w := w < 0 ? -grid.minimumShapeWidth : grid.minimumShapeWidth
        if abs(h) < grid.minimumShapeHeight
            h := h < 0 ? -grid.minimumShapeHeight : grid.minimumShapeHeight

        x += w < 0 ? w : 0
        , y += h < 0 ? h : 0
        , w := abs(w)
        , h := abs(h)
        , this.x := x
        , this.y := y
        , this.w := w
        , this.h := h
        , this.x2 := this.x + this.w ;// for autoAlign only
        , this.y2 := this.y + this.h ;// for autoAlign only
    }

    detectAsynchronousCall() {
        return (grid.activeState = "drawing") ? 0 : 1
    }

    track() {
        if this.detectAsynchronousCall()
            return

        this.orientDrawingBox()

        if grid.detectOverlap_shapes(this.x, this.y, this.w, this.h)
            this.collisionMode := 1
            , eventMgr.events["leftClick"].enabled := 0
            , scratchPad.drawRect("offRed", 1, this.x, this.y, this.w, this.h, 1)
            , alignMgr.clear()
        else
            this.collisionMode := 0
            , eventMgr.events["leftClick"].enabled := 1
            , scratchPad.drawRect("black", 1, this.x, this.y, this.w, this.h, 1)
            , alignMgr.detect(this.x, this.y, this.x2, this.y2, -1)
            
        scratchPad.update()
    }

    addShape() {
        eventMgr.enabled := 0

        scratchPad.clear().update()
        
        x := round(this.x, -1)
        y := round(this.y, -1)
        w := round(this.w, -1)
        h := round(this.h, -1)

        grid.addShape("roundRect", x, y, w, h).render()
        grid.redrawLines()
        shapeLayer.update()
        gridState_default.activate()
    }
}