class gridLine_arrowHead extends gridLine_pathCalculation
{
    static invert := { "midLeft" : "midRight"
                     , "midRight" : "midLeft"
                     , "midTop" : "midBottom"
                     , "midBottom" : "midTop"}

    setArrowHead(canvas) {
        adjustments := this.fixPositioning()
        this.arrowDirection := this.invert[this.destDirection]

        x := this.destPoint.x + adjustments[1]
        y := this.destPoint.y + adjustments[2]

        w := grid.gridSize - 4
        h := grid.gridSize - 3

        if (this.arrowDirection = "midLeft" or this.arrowDirection = "midRight") {
            w := grid.gridSize - 3
            h := grid.gridSize - 4
        }

        canvas.setDrawingMode(1)

        if (! isObject(this.arrowHead)) {
            this.arrowHead := new triangle()
        }

        this.arrowHead
            .updateCoords(x + 3, y + 3, w, h, this.arrowDirection)
            .fill(canvas, "black")
            .draw(canvas, "black", 1)

        return this
    }

    fixPositioning() {
        if this.destDirection = "midLeft"
            return [0, -6]
        else if this.destDirection = "midRight"
            return [-13, -6]
        else if this.destDirection = "midTop"
            return [-6, 0]
        else if this.destDirection = "midBottom"
            return [-6, -13]
    }
}