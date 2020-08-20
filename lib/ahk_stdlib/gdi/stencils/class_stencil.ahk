class stencil extends protoClass
{
    static dirMod := { "midTop" : "up"
                     , "midBottom" : "down"
                     , "midLeft" : "left"
                     , "midRight" : "right"
                     , "top" : "up"
                     , "bottom" : "down" 
                     , "up" : "up"
                     , "down" : "down"
                     , "left" : "left"
                     , "right" : "right"
                     , 0 : "up"}

    _pointsToward := "up"
    gdiPath := 0
    boundingBox := object()

    __new(alias = "") {
        this.alias := alias
        this.gdiPathGet()
    }

    pointsToward[] {
        get {
            return this._pointsToward
        }
        set {
            this._pointsToward := this.dirMod[value]
        }
    }

    createBoundingBox(x, y, w, h) {
        this.boundingBox := new rect().setDimensions(x, y, w, h, 1).getCornerRects().getPerimeterRects()
    }

    setBoundingBox(rectObj) {
        this.boundingBox := rectObj
        this.pointsToward := rectObj.pointsToward
    }

    gdiPathGet() {
        if (this.gdiPath)
            this.remove()

        dllCall("gdiplus\GdipCreatePath"
              , "int", 0
              , "ptr*", gdiPath)
            
        this.gdiPath := gdiPath
        return this.gdiPath
    }

    createPathLine(x, y, x2, y2) {
        dllCall("gdiplus\GdipAddPathLineI"
              , "ptr", this.gdiPath
              , "int", x
              , "int", y
              , "int", x2
              , "int", y2)
        return this
    }

    createPathArc(x, y, w, h, startAngle, sweepAngle) {
        dllCall("gdiplus\GdipAddPathArcI"
              , "ptr", this.gdiPath
              , "int", x
              , "int", y
              , "int", w
              , "int", h
              , "float", startAngle
              , "float", sweepAngle)
        return this
    }

    createPathEllipse(x, y, w, h) {
        dllCall("gdiplus\GdipAddPathEllipseI"
              , "ptr", this.gdiPath
              , "int", x
              , "int", y
              , "int", w
              , "int", h)
        return this
    }

    closePath() {
        dllCall("gdiplus\GdipClosePathFigure"
              , "ptr", this.gdiPath)
        return this
    }

    draw(canvas, colorAlias, thickness = 1, dashed = 0) {

        if (dashed)
            pen := canvas.pens[colorAlias thickness "_dashed"]
            , pen := pen ? pen : canvas.createDashedPen(colorAlias, thickness)
        else
            pen := canvas.pens[colorAlias thickness]
            , pen := pen ? pen : canvas.createPen(colorAlias, thickness)

        canvas.setDrawingMode(1)
        
        dllCall("gdiplus\GdipDrawPath"
              , "ptr", canvas.g
              , "ptr", pen
              , "ptr", this.gdiPath)

        return this
    }

    fill(canvas, colorAlias) {
        brush := canvas.brushes[colorAlias] ? canvas.brushes[colorAlias] : canvas.createBrush(colorAlias)
        canvas.setDrawingMode(0)
        dllCall("gdiplus\GdipFillPath"
              , "ptr", canvas.g
              , "ptr", brush
              , "ptr", this.gdiPath)

        return this
    }

    reset() {
        dllCall("gdiplus\GdipResetPath"
              , "ptr", this.gdiPath)
        return this
    }

    remove() {
        dllCall("gdiplus\GdipDeletePath", "ptr", this.gdiPath)
        return this
    }
}