class gridShape_drawing extends gridShape_text
{
    outline(colorAlias = 0, thickness = 1, dashed = 0) {
        if (colorAlias = 0) {
            this.clear()
        } else {
            if (this.path) {
                scratchPad.setDrawingMode(1)
                this.path.draw(scratchPad, colorAlias, thickness, dashed)
            } else {
                scratchPad.setDrawingMode(0)
                scratchPad.drawRect(colorAlias, thickness, this.x, this.y, this.w, this.h, 0, dashed)
            }
        }
        return this
    }

    render(canvas = 0, borderColor = 0, fillColor = 0) {
        canvas := canvas ? canvas : shapeLayer
        fillColor := fillColor ? fillColor : this.bgColor
        borderColor := borderColor ? borderColor : "darkGray"
        if (this.path) {
            shapeLayer.setDrawingMode(1)
            (this.bitmap = 0) ? this.path.fill(canvas, fillColor)
            this.path.draw(canvas, borderColor, 1)
        } else {
            shapeLayer.setDrawingMode(0)
            (this.bitmap = 0) ? canvas.fillRect(fillColor, this.x, this.y, this.w, this.h)
            canvas.drawRect(borderColor, 1, this.x, this.y, this.w, this.h)
        }
        return this
    }

    handleOutline(fill = "", stroke = "") {
        scratchPad.setDrawingMode(0)
        scratchPad.drawRect("darkGray", 1, this.x, this.y, this.w, this.h)
        scratchPad.setDrawingMode(1)

        fill := fill ? fill : "white"
        stroke := stroke ? stroke : "mediumGray"

        gd := grid.gridSize
        g := (grid.gridSize) // 2

        for i, r in this.cornerRects
            x := r.x + g, y := r.y + g
            , scratchPad.fillEllipse(fill, x, y, gd, gd)
            , scratchPad.drawEllipse(stroke, 2, x, y, gd, gd)

        for i, r in this.midPoints
            x := r[1] - g, y := r[2] - g
            , scratchPad.fillEllipse(fill, x, y, gd, gd)
            , scratchPad.drawEllipse(stroke, 2, x, y, gd, gd)             
    }
}