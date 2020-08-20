class layeredWindow_canvas extends layeredWindow_drawing
{
    getCanvas(bgColor = 0) {
        this.bitmap := this.createDibSection()
        this.dc := dllCall("CreateCompatibleDC", "ptr", 0)
        dllCall("SelectObject", "ptr", this.dc, "ptr", this.bitmap)
        dllCall("gdiplus\GdipCreateFromHDC", "ptr", this.dc, "ptr*", g)
        this.g := g
        this.setDrawingMode(0)
        (bgColor) ? this.setBackground(bgColor)
        return this
    }

    createDibSection(w = 0, h = 0, dc = 0) {
        dc := dc ? dc : dllCall("GetDC", "ptr", 0)

        w := w ? w : this.window.w
        h := h ? h : this.window.h

        varSetCapacity(bitmapInfo, 40)
        numPut(40, bitmapInfo, 0, "uint")
        numPut(w, bitmapInfo, 4, "uint")
        numPut(h, bitmapInfo, 8, "uint")
        numPut(1, bitmapInfo, 12, "ushort")
        numPut(32, bitmapInfo, 14, "ushort")
        numPut(0, bitmapInfo, 16, "uint")

        retVal := dllCall("CreateDIBSection"
                        , "ptr", dc
                        , "ptr", &bitmapInfo
                        , "uint", 0
                        , "ptr", 0
                        , "ptr", 0
                        , "uint", 0
                        , "ptr")
        
        dllCall("ReleaseDC", "ptr", 0, "ptr", dc)
        return retVal
    }

    static smoothingModes := { "default" : 1
                             , "highSpeed" : 2
                             , "highQuality" : 3
                             , "none" : 4
                             , "antiAlias" : 5 }

    setSmoothingMode(mode = "default") {
        return dllCall("gdiplus\GdipSetSmoothingMode"
                     , "ptr", this.g
                     , "int", this.smoothingModes[mode])
    }

    static compositingModes := { "blend" : 0
                               , "overwrite" : 1 }

    setCompositingMode(mode = "overwrite") {
        return dllCall("gdiplus\GdipSetCompositingMode"
                     , "ptr", this.g
                     , "int", this.compositingModes[mode])
    }

    static clippingModes := { "replace" : 0
                            , "intersect" : 1
                            , "union" : 2
                            , "Xor" : 3
                            , "exclude" : 4
                            , "complement" : 5 }

    clip(x, y, w, h, mode = "replace") {
        dllCall("gdiplus\GdipSetClipRect"
              , "ptr", this.g
              , "float", x
              , "float", y
              , "float", w
              , "float", h
              , "int", this.clippingModes[mode])
        return this
    }

    clipPath(path, mode = "replace") {
        dllCall("gdiplus\GdipSetClipPath"
              , "ptr", this.g
              , "ptr", path
              , "int", this.clippingModes[mode])
    }

    unClip() {
        dllCall("gdiplus\GdipResetClip", "ptr", this.g)
        return this
    }

    clear() {
        dllCall("gdiplus\GdipGraphicsClear"
               , "ptr", this.g
               , "int", 0x00ffffff)
        return this
    }

    update(alpha = 255) {
        dllCall("UpdateLayeredWindow"
              , "ptr", this.hwnd
              , "ptr", 0
              , "ptr", 0
              , "int64*", this.window.w | this.window.h << 32
              , "ptr", this.dc
              , "int64*", 0
              , "uint", 0
              , "uint*", alpha << 16 | 1 << 24
              , "uint", 2)
        return this
    }

    release() {
        dllCall("gdiplus\GdipDeleteGraphics", "ptr", this.g)
        dllCall("DeleteObject", "ptr", this.bitmap)
        dllCall("DeleteDC", "ptr", this.dc)
    }
}