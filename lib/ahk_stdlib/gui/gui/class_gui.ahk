class gui extends gui_childWindow
{
    visible := 0
    enabled := 1
    lastAddedCtrl := ""
    vScrollEnable := 0
    margin := object()
    childWindows := object()

    __new(alias) {
        this.alias := alias
        this.ctrls := new ctrlMgr(this)
    }

    create() {
        gui, % this.alias ":new", % "hwndHwnd " this.initialStyles

        this.hwnd := hwnd
        this.a_hwnd := "ahk_id " this.hwnd

        this.window := new window(this.hwnd)
        this.window.title := this.alias
        
        lookupGuiByHwnd[this.hwnd] := this
    }

    setDimensions(x, y, w, h) {
        w := w
        h := h
        x := x = "" ? desktop.centerX - (w / 2) : x ;// specify empty strings for x, y to center
        y := y = "" ? desktop.centerY - (h / 2) : y  
        this.window.setDimensions(x, y, w, h)
    }

    show(options = "") {
        this.visible := 1
        gui, % this.cmd("show"), % "x" this.window.x " y" this.window.y " w" this.window.w " h" this.window.h " " options, % this.window.title
        return this
    }

    plainShow(options = "") {
        if this.visible
            return
        this.visible := 1
        gui, % this.cmd("show"), % options
        return this        
    }

    hide() {
        this.visible := 0
        gui, % this.cmd("hide")
        return this
    }

    disable() {
        if ! this.enabled
            return
        for a, c in this.ctrls.aliases
            this.ctrls[c].enabled := 0
        this.enabled := 0
    }

    enable() {
        if this.enabled
            return
        for a, c in this.ctrls.aliases
            this.ctrls[c].enabled := 1
        this.enabled := 1
    }
}