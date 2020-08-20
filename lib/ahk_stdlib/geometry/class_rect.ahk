class rect extends protoClass
{
    x := "", y := "", w := "", h := ""
    
    __new(alias = "") {
        this.alias := alias
    }

    setDimensions(x = "", y = "", w = "", h = "", includeExtendedProperties = 0) {
        x := x = "" ? this.x : x
        , y := y = "" ? this.y : y
        , w := w = "" ? this.w : w
        , h := h = "" ? this.h : h

        if (x = "" || y = "" || w = "" || h = "")
            throw exception("Invalid rectangle dimension", -2, "x: " x ", y: " y ", w: " w ", h: " h ", alias: " this.alias)
        
        this.x := round(x)
        , this.y := round(y)
        , this.w := round(w)
        , this.h := round(h)
        , this.x2 := this.x + this.w
        , this.y2 := this.y + this.h

        (includeExtendedProperties) ? this.setDimensionsEx()
        return this
    }

    setDimensionsEx() {
        x := this.x
        , y := this.y
        , w := this.w
        , h := this.h
        , this.center := [x + w // 2, y + h // 2]
        , this.topLeft := [x, y]
        , this.topRight := [x + w, y]
        , this.bottomRight := [x + w, y + h]
        , this.bottomLeft := [x, y + h]
        , this.midLeft := [x, y + h // 2]
        , this.midTop := [x + w // 2, y]
        , this.midRight := [x + w, y + h // 2]
        , this.midBottom := [x + w // 2, y + h]
        , this.midPoints := [this.midLeft, this.midTop, this.midRight, this.midBottom]
        return this
    }

    getCornerRects(widen = 10) {
        c := this.topLeft
        , this.topLeft_rect := new rect("topLeft_rect").setDimensionsByx2y2(c[1], c[2], c[1], c[2], widen).setDimensionsEx()
        , c := this.topRight
        , this.topRight_rect := new rect("topRight_rect").setDimensionsByx2y2(c[1], c[2], c[1], c[2], widen).setDimensionsEx()
        , c := this.bottomRight
        , this.bottomRight_rect := new rect("bottomRight_rect").setDimensionsByx2y2(c[1], c[2], c[1], c[2], widen).setDimensionsEx()
        , c := this.bottomLeft
        , this.bottomLeft_rect := new rect("bottomLeft_rect").setDimensionsByx2y2(c[1], c[2], c[1], c[2], widen).setDimensionsEx()
        , this.cornerRects := [this.topLeft_rect, this.topRight_rect, this.bottomRight_rect, this.bottomLeft_rect]
        return this
    }

    getPerimeterRects() {
        p1 := this.topLeft_rect.bottomLeft
        , p2 := this.bottomLeft_rect.topRight
        , this.midLeft_rect := new rect("midLeft_rect").setDimensionsByx2y2(p1[1], p1[2], p2[1], p2[2]).setDimensionsEx()
        , p1 := this.topLeft_rect.topRight
        , p2 := this.topRight_rect.bottomLeft
        , this.midTop_rect := new rect("midTop_rect").setDimensionsByx2y2(p1[1], p1[2], p2[1], p2[2]).setDimensionsEx()
        , p1 := this.topRight_rect.bottomLeft
        , p2 := this.bottomRight_rect.topRight
        , this.midRight_rect := new rect("midRight_rect").setDimensionsByx2y2(p1[1], p1[2], p2[1], p2[2]).setDimensionsEx()
        , p1 := this.bottomLeft_rect.topRight
        , p2 := this.bottomRight_Rect.bottomLeft
        , this.midBottom_rect := new rect("midBottom_rect").setDimensionsByx2y2(p1[1], p1[2], p2[1], p2[2]).setDimensionsEx()
        , this.perimeterRects := [this.midLeft_rect, this.midTop_rect, this.midRight_rect, this.midBottom_rect]
        return this
    }

    setDimensionsByx2y2(x1, y1, x2, y2, widen = 0) {
        if (x1 > x2 and y1 = y2)
            this.setDimensions(x2 - widen, y1 - widen, abs(x1 - x2) + widen, abs(y1 - y2) + widen)
        else if (x1 < x2 and y1 = y2)
            this.setDimensions(x1 - widen, y1 - widen, abs(x2 - x1) + widen, abs(y2 - y1) + widen)
        else if (x1 = x2 and y1 > y2)
            this.setDimensions(x2 - widen, y2 - widen, abs(x2 - x1) + widen, abs(y2 - y1) + widen)
        else if (x1 = x2 and y1 < y2)
            this.setDimensions(x1 - widen, y1 - widen, abs(x1 - x2) + widen, abs(y1 - y2) + widen)
        else this.setDimensions(x1 - widen, y1 - widen, x2 - x1 + widen, y2 - y1 + widen) ;// if the points are equal
        return this
    }

    contains(x, y) {
        return (this.x <= x && x <= this.x2 && this.y <= y && y <= this.y2) ? 1 : 0
    }

    isProximate(x, y, tolerance) {
        return (this.x - tolerance <= x && x <= this.x2 - 1 + tolerance && this.y - tolerance <= y && y <= this.y2 - 1 + tolerance) ? 1 : 0
    }

    resize(factor = 1) {
        this.w += 2 * factor
        , this.h += 2 * factor
        , this.x -= 1 * factor
        , this.y -= 1 * factor
        return this
    }
}