class ctrl extends ctrl_actions
{
    visible := 1
    options := ""
    defaultOptions := object()
    events := []

    __new(parent, alias) {
        this.parent := parent
        this.alias := alias
    }

    setDimensions(x, y, w, h) {
        this.x := x
        this.y := y
        this.w := w
        this.h := h
        return this
    }

    text[]
    {
        get {
            controlGetText, t,, % "ahk_id " this.hwnd
            return t
        }
        set {
            controlSetText,, % value, % "ahk_id " this.hwnd
        }
    }

    draw(t = "") {
        gui, % this.parent.cmd("add"), % this.type, % "x" this.x " y" this.y " w" this.w " h" this.h " hwndh" this.defaultOptions[this.type] " " this.initialStyles, % t
        this.hwnd := h
        this.a_hwnd := "ahk_id " h
        this.parent.lastAddedCtrl := this.alias
        return this
    }

    redraw(t = "") {
        this.text := t = "" ? this.text : t
        guiControl, move, % this.hwnd, % "x" this.x " y" this.y - this.parent.window.yScrollAdj " w" this.w " h" this.h
        return this 
    }

    addEventListener() {
        b := objBindMethod(this, "eventListener")
        guiControl, +g, % this.hwnd, % b
        return this
    }

    addEvent(binding) {
        this.events.push(binding)
        return this
    }

    deleteEvents() {
        this.events := []
        return this
    }
}