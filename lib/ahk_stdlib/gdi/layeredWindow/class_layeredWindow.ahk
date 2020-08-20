class layeredWindow extends layeredWindow_utensils
{
    static _ := layeredWindow.startup()
    static shutdownToken := 0

    startup() {
        if (! dllCall("GetModuleHandle", "str", "gdiplus", "ptr"))
            dllCall("LoadLibrary", "str", "gdiplus")
        
        varSetCapacity(startupInput, a_ptrSize = 4 ? 16 : 24)
        numPut(1, startupInput, 0, "int")

        dllCall("gdiplus\GdiplusStartup"
              , "ptr*", shutdownToken
              , "ptr", &startupInput
              , "ptr", 0)

        layeredWindow.shutdownToken := shutdownToken
    }

    shutdown() {
        dllCall("gdiplus\GdiplusShutdown", "ptr", layeredWindow.shutdownToken)
        (m := dllCall("GetModuleHandle", "str", "gdiplus", "ptr")) ? dllCall("FreeLibrary", "ptr", m)
    }

    __new(alias) {
        this.alias := alias
        this.setInitialStyles("noCaption", "alwaysOnTop", "owner", "toolWindow", "layered")

        for colorAlias, colorID in this.colors
            this.createBrush(colorAlias)
    }

    setBackground(bgColor) {
        this.fillRect(bgColor, 0, 0, this.window.w, this.window.h)
    }

    setBorder(colorAlias) {
        w := this.window
        this.drawRect(alias, 1, 0, 0, w.w, w.h)
        return this
    }

    setDrawingMode(mode) { ;// 0 = sharp, 1 = smooth
        if (mode = 0)
            this.setSmoothingMode("highQuality"), this.setCompositingMode("overwrite")
        if (mode = 1)
            this.setSmoothingMode("none"), this.setCompositingMode("blend")
        return this
    }
}