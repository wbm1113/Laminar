class exBitmap
{
    __new(alias = "") {
        this.alias := alias
    }

    w[] {
        get {
            dllCall("gdiplus\GdipGetImageWidth", "ptr", this.handle, "uint*", w)
            return w
        }
    }

    h[] {
        get {
            dllCall("gdiplus\GdipGetImageHeight", "ptr", this.handle, "uint*", h)
            return h
        }
    }

    import(bitmap) {
        this.handle := bitmap
        return this
    }

    create(w, h) {
        dllCall("gdiplus\GdipCreateBitmapFromScan0"
              , "int", w
              , "int", h
              , "int", 0
              , "int", 0x26200A
              , "ptr", 0
              , "ptr*", bitmap)
        this.handle := bitmap
        return this
    }

    createFromDib(bitmap) {
        dllCall("gdiplus\GdipCreateBitmapFromHBITMAP"
              , "ptr", bitmap
              , "ptr", 0
              , "ptr*", outBitmap)
        return outBitmap
    }

    createFromHwnd(hwnd) {
        dimensions := new window(hwnd).getDimensions()

        bitmap := layeredWindow.createDibSection(dimensions[1] - 1, dimensions[2] - 1)
        dc := dllCall("CreateCompatibleDC", "ptr", 0)
        dllCall("SelectObject", "ptr", dc, "ptr", bitmap)

        dllCall("PrintWindow"
              , "ptr", hwnd
              , "ptr", dc
              , "uint", 0)
        
        outBitmap := this.createFromDib(bitmap)

        dllCall("DeleteObject", "ptr", bitmap)
        dllCall("DeleteDC", "ptr", dc)

        return outBitmap
    }

    createFromScreen(x, y, w, h) {

        cdc := dllCall("CreateCompatibleDC", "ptr", 0)
        bitmap := layeredWindow.createDibSection(w, h, cdc)
        dllCall("SelectObject", "ptr", cdc, "ptr", bitmap)
        dllCall("gdiplus\GdipCreateFromHDC", "ptr", cdc, "ptr*", g)

        dc := dllCall("GetDC", "ptr", 0)

        dllCall("gdi32\BitBlt"
              , "ptr", cdc
              , "int", 0
              , "int", 0
              , "int", w
              , "int", h
              , "ptr", dc
              , "int", x
              , "int", y
              , "uint", 0x00CC0020)

        dllCall("ReleaseDC", "ptr", 0, "ptr", dc)
        outBitmap := this.createFromDib(bitmap)

        dllCall("gdiplus\GdipDeleteGraphics", "ptr", g)
        dllCall("DeleteObject", "ptr", bitmap)
        dllCall("DeleteDC", "ptr", cdc)
        
        return outBitmap
    }

    crop(x, y, w, h) {
        bitmap := layeredWindow.createDibSection(w, h)
        dc := dllCall("CreateCompatibleDC", "ptr", 0)
        dllCall("SelectObject", "ptr", dc, "ptr", bitmap)
        dllCall("gdiplus\GdipCreateFromHDC", "ptr", dc, "ptr*", g)

        dllCall("gdiplus\GdipDrawImageRectRect"
              , "ptr", g
              , "ptr", this.handle
              , "float", 0
              , "float", 0
              , "float", w
              , "float", h
              , "float", x
              , "float", y
              , "float", w
              , "float", h
              , "int", 2
              , "ptr", 0
              , "ptr", 0
              , "ptr", 0)

        this.handle := this.createFromDib(bitmap)

        dllCall("gdiplus\GdipDeleteGraphics", "ptr", g)
        dllCall("DeleteObject", "ptr", bitmap)
        dllCall("DeleteDC", "ptr", dc)
        return this.handle
    }

    save(path) {
        Gdip_SaveBitmapToFile(this.handle, path, 100)
    }

    remove() {
        return dllCall("gdiplus\GdipDisposeImage", "ptr", this.handle)
    }
}