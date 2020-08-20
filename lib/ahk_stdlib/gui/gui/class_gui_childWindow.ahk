class gui_childWindow extends gui_resize
{
    addChild(alias, x, y, w, h) {
        g := new gui(alias)
        g.parent := this
        g.create()
        g.setDimensions(x, y, w, h)
        g.setParent(this.hwnd)
        g.show("hide")
        g.setOwner(this.hwnd)
        dllCall("SetParent", "uint", g.hwnd, "uint", this.hwnd)
        g.applyStyles("focusParent")
        this.childWindows[alias] := g
        return g
    }

    addChild_layered(alias, x, y, w, h) {
        g := new layeredWindow(alias)
        g.parent := this
        g.create()
        g.setDimensions(x, y, w, h)
        g.setParent(this.hwnd)
        g.show("hide")
        g.setOwner(this.hwnd)
        dllCall("SetParent", "uint", g.hwnd, "uint", this.hwnd)
        g.applyStyles("focusParent")
        this.childWindows[alias] := g
        return g
    }
}