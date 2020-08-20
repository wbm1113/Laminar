class window extends rect
{
    _title := ""
    yScrollAdj := 0

    __new(alias) {
        this.alias := alias
        this.a_hwnd := "ahk_id " this.alias
    }

    title[] {
        get {
            winGetTitle, title, % this.a_hwnd ;// title validation (for class_gui)
            if this._title
                if ! this._title = title
                    this.title := this._title
            return this._title
        }
        set {
            winSetTitle, % this.a_hwnd,, % value
            this._title := value
        }
    }

    activate() {
        winActivate, % this.a_hwnd
        return this
    }

    isActive() {
        return this.alias = winActive(this.a_hwnd) ? 1 : 0
    }

    getDimensions() {
        winGetPos,,, w, h, % this.a_hwnd
        return [w, h]
    }

    move(x, y, redraw = 0) {
        base.setDimensions(x, y)
        winMove, % this.a_hwnd,, % this.x, % this.y
        if (redraw)
            winSet, redraw,, % this.a_hwnd
        return this
    }

    minimize() {
        winMinimize, % this.a_hwnd
    }

    restore() {
        winRestore, % this.a_hwnd
    }

    maximize() {
        winMaximize, % this.a_hwnd
    }

    speedRedraw() {
        varSetCapacity(r, 16, 0)
        numPut(this.x, r, 0, "uint")
        numPut(this.y, r, 4, "uint")
        numPut(this.w, r, 8, "uint")
        numPut(this.h, r, 12, "uint")

        dllCall("RedrawWindow"
              , "ptr", this.alias
              , "ptr", &r
              , "ptr", 0
              , "uint", 0x1|0x4)
    }

    alwaysOnTop(toggle = 1) {
        winSet, alwaysOnTop, % toggle, % this.a_hwnd
    }
}