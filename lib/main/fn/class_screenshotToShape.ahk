class screenshotToShape
{
    beginCapture() {
        eventMgr.enabled := 0
        eventMgr.events["wm_activate"].enabled := -1
        eventMgr.events["NCmouseMove"].enabled := -1
        eventMgr.events["NCmouseLeave"].enabled := -1

        gui.window.minimize()
        cursor.set("cross")
        screenMask.show()        

        mouseHook.install()
        mouseHook.onMouseMove(screenshotToShape, "drawing")
        mouseHook.onLeftClick(screenshotToShape, "endCapture")
        mouseHook.onRightClick(screenshotToShape, "cleanup")

        w := screenMask.window
        screenMask.fillRect("transBlack", w.x, w.y, w.w, w.h)

        this.attachedShape := gridState_selecting.selectedShape

        screenMask.update()

        mouseProc(0, 0x200, 0)
        this.drawing()
    }

    drawing() {
        w := screenMask.window
        screenMask.fillRect("transBlack", w.x, w.y, w.w, w.h)

        shape := this.attachedShape

        w := shape.w
        h := shape.h
        x := mouseHook.pos.x - (w // 2) + 1
        y := mouseHook.pos.y - (h // 2) + 1

        this.w := w
        this.h := h
        this.x := x
        this.y := y

        if this.x + this.w > desktop.w
            this.x := desktop.w - this.w - 2
        else if this.x < desktop.topLeftX + 2
            this.x := 4
        
        if this.y + this.h > desktop.h
            this.y := desktop.h - this.h - 2
        else if this.y < desktop.topLeftY + 2
            this.y := 4

        colorAlias := getKeyState("control") ? "clickThrough" : "invisible"

        screenMask.clip(this.x, this.y, this.w, this.h)
        screenMask.fillRect(colorAlias, this.x, this.y, this.w, this.h)
        screenMask.unclip()
        screenMask.drawRect("offOrange", 2, this.x - 2, this.y - 2, this.w + 4, this.h + 4)

        screenMask.update()
    }

    endCapture() {
        if getKeyState("control")
            return

        x := this.x
        y := this.y
        w := this.w
        h := this.h

        screenBitMap := exBitmap.createFromScreen(x, y, w, h)

        shape := gridState_selecting.selectedShape
        shape.attachBitmap(screenBitmap)
        shape.renderImage()

        shapeLayer.update()
        this.cleanup()

        a := actionStack.add(shape.alias)
        a.addUndoAction(shape.alias, "detachBitmap")
        a.addUndoAction(shape.alias, "render")
        a.addUndoAction(shapeLayer, "update")
        a.addRedoAction(shape.alias, "attachBitmap").setParams(shape.bitmap)
        a.addRedoAction(shape.alias, "renderImage")
        a.addRedoAction(shapeLayer, "update")
    }

    cleanup() {
        cursor.reset()
        mouseHook.uninstall()
        menu.menus["shape"].disable()
        gui.window.restore()
        gui.window.activate()
        scratchPad.clear().update()
        screenMask.clear().update().hide()
        eventMgr.resetToDefault()
        eventMgr.events["leftClick"].swap(1, "gridState_default_activate")
        eventMgr.events["leftClick"].swap(2, 0)
        eventMgr.events["leftClick"].enabled := 1
        eventMgr.events["rightClick"].enabled := 1
    }
}