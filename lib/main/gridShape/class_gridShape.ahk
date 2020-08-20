class gridShape extends gridShape_drawing
{
    static type = "shape"
    form := 0
    x := 0
    y := 0
    bgColor := "mutedGray"
    linesOriginatingFrom := object()
    linesFeedingInto := object()
    container := 0
    bitmap := 0
    path := 0
    isLineAnchor := 0
    pointsToward := 0

    __new(alias, form, x, y, w, h) {
        this.alias := alias
        this.form := form

        if (form = "rect") {
            this.path := 0
        } else if (form = "diamond") { 
            this.path := new diamond(this)
        } else if (form = "circle") {
            this.path := new circle(this)
        } else if (form = "roundRect") {
            this.path := new roundRect(this)
        } else if (form = "arrow") {
            this.path := new arrow(this)
        }

        this.updateCoords(x, y, w, h)
    }

    updateCoords(x, y, w, h) {
        this.setDimensions(x, y, w, h, 1)
        this.getCornerRects(grid.gridSize)
        this.getPerimeterRects()
        (this.path) ? this.path.updateCoords(this)
    }

    setBgColor(color) {
        this.bgColor := color
        (this.container) ? this.updateText( , , , color)
    }

    getLines() {
        shapeLines := []

        for i, l in this.linesOriginatingFrom
            shapeLines.push(l.alias.string)
        for i, l in this.linesFeedingInto
            shapeLines.push(l.alias.string)

        if shapeLines.count() < 1
            shapeLines := 0

        return shapeLines
    }

    repos(x = "", y = "", w = "", h = "", update = 1) {
        a := actionStack.add(this.alias)
        a.addUndoAction(this.alias, "repos").setParams(this.x, this.y, this.w, this.h)
        a.addUndoAction(shapeLayer, "update")

        x := x ? round(x, -1) : x
        y := y ? round(y, -1) : y
        w := w ? round(w, -1) : w
        h := h ? round(h, -1) : h

        this.clear()
        this.updateCoords(x, y, w, h)

        this.render()
        (this.bitmap) ? this.renderImage()
        (update) ? shapeLayer.update()
        grid.redrawLines(1)
        isObject(this.container) ? this.vCenterText()

        a.addRedoAction(this.alias, "repos").setParams(this.x, this.y, this.w, this.h)
        a.addRedoAction(shapeLayer, "update")
    }

    rapidRepos(x = "", y = "", w = "", h = "", update = 1) {
        this.clear()
        this.updateCoords(x, y, w, h)
        this.render()
        (this.bitmap) ? this.renderImage()
        (update) ? shapeLayer.update()
        isObject(this.container) ? this.vCenterText()
    }

    contains(x, y) {
        return (this.x <= x && x <= this.x2 - 1 && this.y <= y && y <= this.y2 - 1) ? 1 : 0
    }

    isProximate(x, y, tolerance) {
        return (this.x - tolerance <= x && x <= this.x2 - 1 + tolerance && this.y - tolerance <= y && y <= this.y2 - 1 + tolerance) ? 1 : 0
    }

    clear(canvas = 0) {
        canvas := canvas ? canvas : shapeLayer
        canvas.clip(this.x, this.y, this.w + 1, this.h + 1).clear().unClip()
        return this
    }

    remove(preserveText = 0) {
        this.clear()

        loop 20 {
            remainingLines := 0
            for i, l in this.linesOriginatingFrom
                l.remove(), remainingLines++
            for i, l in this.linesFeedingInto
                l.remove(), remainingLines++
            if (remainingLines = 0)
                break
        }

        this.detachBitmap()
        this.detachText(preserveText)

        (this.path) ? this.path.remove()
    }
}