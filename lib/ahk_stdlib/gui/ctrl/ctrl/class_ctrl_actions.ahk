class ctrl_actions extends ctrl_options
{
    xLast := ""
    yLast := ""
    wLast := ""
    hLast := ""
    
    show() {
        if (this.visible)
            return
        this.visible := 1
        guiControl, show, % this.hwnd
        return this
    }

    hide() {
        if (this.visible = 0)
            return
        this.visible := 0
        guiControl, hide, % this.hwnd
        return this
    }

    enable() {
        guiControl, % "enabled", % this.hwnd
    }

    disable() {
        guiControl, % "disabled", % this.hwnd
    }

    makeReadOnly() {
        guiControl, % "+readOnly", % this.hwnd
    }

    setRedraw(toggle) {
        guiControl, % toggle ? "+redraw" : "-redraw", % this.hwnd
    }

    move(x = "", y = "", w = "", h = "") {
        this.x := x = "" ? this.x : x
        this.y := y = "" ? this.y : y
        this.w := w = "" ? this.w : w
        this.h := h = "" ? this.h : h
        if this.x = this.xLast and this.y = this.yLast and this.w = this.wLast and this.h = this.hLast
            return
        guiControl, move, % this.hwnd, % "x" this.x " y" this.y " w" this.w " h" this.h
        this.xLast := this.x
        this.yLast := this.y
        this.wLast := this.w
        this.hLast := this.h
        return this
    }

    focus() {
        controlFocus,, % this.a_hwnd
        return this
    }
}