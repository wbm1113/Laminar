class layeredWindow_drawing extends layeredWindow_colors
{
    drawLine(colorAlias, thickness, x, y, x2, y2) {
        pen := this.pens[colorAlias thickness]
        pen := pen ? pen : this.createPen(colorAlias, thickness)

        dllCall("gdiplus\GdipDrawLine"
              , "ptr", this.g
              , "ptr", pen
              , "float", x
              , "float", y
              , "float", x2
              , "float", y2)

        return this
    }
    
    drawRect(colorAlias, thickness, x, y, w, h, singleInstance = 0, dashed = 0) {
        this.setDrawingMode(0)

        (singleInstance) ? this.clear()

        if (dashed)
            pen := this.pens[colorAlias thickness "_dashed"]
            , pen := pen ? pen : this.createDashedPen(colorAlias, thickness)
        else
            pen := this.pens[colorAlias thickness]
            , pen := pen ? pen : this.createPen(colorAlias, thickness)

        dllCall("gdiplus\GdipDrawRectangle"
              , "ptr", this.g
              , "ptr", pen
              , "float", x
              , "float", y
              , "float", w
              , "float", h)

        return this
    }
    
    fillRect(colorAlias, x, y, w, h) {
        this.setDrawingMode(0)

        brush := this.brushes[colorAlias]
        brush := brush ? brush : this.createBrush(colorAlias)

        dllCall("gdiplus\GdipFillRectangle"
              , "ptr", this.g
              , "ptr", brush
              , "float", x
              , "float", y
              , "float", w
              , "float", h)       

        return this
    }

    drawEllipse(colorAlias, thickness, x, y, w, h, singleInstance = 0, dashed = 0) {
        this.setDrawingMode(1)

        (singleInstance) ? this.clear()

        if (dashed)
            pen := this.pens[colorAlias thickness "_dashed"]
            , pen := pen ? pen : this.createDashedPen(colorAlias, thickness)
        else
            pen := this.pens[colorAlias thickness]
            , pen := pen ? pen : this.createPen(colorAlias, thickness)

        dllCall("gdiplus\GdipDrawEllipse"
              , "ptr", this.g
              , "ptr", pen
              , "float", x
              , "float", y
              , "float", w
              , "float", h)
        
        return this
    }

    fillEllipse(colorAlias, x, y, w, h) {
        this.setDrawingMode(1)

        brush := this.brushes[colorAlias]
        brush := brush ? brush : this.createBrush(colorAlias)

        dllCall("gdiplus\GdipFillEllipse"
              , "ptr", this.g
              , "ptr", brush
              , "float", x
              , "float", y
              , "float", w
              , "float", h)

        return this   
    }

    drawBitmap(bitmap, x, y, w, h, sx = 0, sy = 0, sw = "", sh = "") {

        bitmap := new exBitmap().import(bitmap)
        sw := sw = "" ? bitmap.w : sw
        sh := sh = "" ? bitmap.h : sh

        dllCall("gdiplus\GdipDrawImageRectRect"
              , "ptr", this.g
              , "ptr", bitmap.handle
              , "float", x
              , "float", y
              , "float", w
              , "float", h
              , "float", sx
              , "float", sy
              , "float", sw ? sw : bitmap.w
              , "float", sh ? sh : bitmap.h
              , "int", 2
              , "ptr", 0
              , "ptr", 0
              , "ptr", 0)

        return this
    }
}