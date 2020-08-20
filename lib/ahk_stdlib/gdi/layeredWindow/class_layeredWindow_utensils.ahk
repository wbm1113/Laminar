class layeredWindow_utensils extends layeredWindow_canvas
{
    static pens := object()
    static brushes := object()

    createPen(colorAlias, thickness) {
        color := this.colors[colorAlias]

        dllCall("gdiplus\GdipCreatePen1"
               , "uint", color
               , "float", thickness
               , "int", 2
               , "ptr*", pen)

        this.pens[colorAlias thickness] := pen
        return pen
    }

    createDashedPen(colorAlias, thickness) {
        color := this.colors[colorAlias]

        dllCall("gdiplus\GdipCreateHatchBrush"
              , "int", 22
              , "uint", 0xffffffff
              , "uint", color
              , "ptr*", brush)

        dllCall("gdiplus\GdipCreatePen2"
              , "ptr", brush
              , "float", thickness
              , "int", 2
              , "ptr*", pen)

        this.deleteBrush(brush)
        this.pens[colorAlias thickness "_dashed"] := pen
        return pen
    }

    createBrush(colorAlias) {
        color := this.colors[colorAlias]

        dllCall("gdiplus\GdipCreateSolidFill", "uint", color, "ptr*", brush)

        this.brushes[colorAlias] := brush
        return brush
    }

    deletePen(pen) {
        return dllCall("gdiplus\GdipDeletePen", "ptr", pen)
    }

    deleteBrush(brush) {
        return dllCall("gdiplus\GdipDeleteBrush", "ptr", brush)
    }

    releaseUtensils() {
        for i, p in this.pens
            this.deletePen(p)
        for i, b in this.brushes
            this.deleteBrush(b)
    }
}