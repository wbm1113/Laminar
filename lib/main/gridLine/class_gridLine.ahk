class gridLine extends gridLine_arrowHead
{
    static type = "line"
    static predictionPathCount := 0
    static predictionPathIndex := 0
    static offsetsByRectSide := { "midLeft"     : [ grid.gridSize * -1, 0 ]
                                , "midTop"      : [ 0, grid.gridSize * -1 ]
                                , "midRight"    : [ grid.gridSize, 0 ]    
                                , "midBottom"   : [ 0, grid.gridSize ] }

    static anchorPointOffsets := { "midLeft"     : [ 10, 0 ]
                                 , "midTop"      : [ 0, 10 ]
                                 , "midRight"    : [ -10, 0 ]
                                 , "midBottom"   : [ 0, -10 ] }
    
    arrowHead := 0
    stencil := 0

    __new(origShape, origDirection, destShape, destDirection) {
        this.origShape := origShape
        this.origDirection := origDirection
        this.destShape := destShape
        this.destDirection := destDirection
        this.getAlias()
    }

    getAlias() {
        this.alias := object()
        this.alias.string := this.origShape.alias "|" this.origDirection "|" this.destShape.alias "|" this.destDirection
        this.alias.origShape := this.origShape.alias
        this.alias.origDirection := this.origDirection
        this.alias.destShape := this.destShape.alias
        this.alias.destDirection := this.destDirection
    }
    
    reset() {
        gridLine.predictionPathIndex := 0
        this.drawPoints := []
        this.coercedPoints := []
    }

    calculateCollisionBoundaries() {
        lastDistance := 0
        this.collisionBoundaries := []
        loop % this.drawPoints.count() - 1 {
            currPoint := this.drawPoints[a_index]
            nextPoint := this.drawPoints[a_index + 1]
            this.collisionBoundaries.push(new rect(a_index).setDimensionsByx2y2(currPoint.x, currPoint.y, nextPoint.x, nextPoint.y, grid.gridSize))
        }
    }

    outline(dummyParam = 0, dummyParam2 = 0) { ;// consistent parameters w/ shape outlines
        scratchPad.setDrawingMode(0)
        loop % this.drawPoints.count() - 1
            scratchPad.drawLine("darkGray", 1, this.drawPoints[a_index].x, this.drawPoints[a_index].y, this.drawPoints[a_index + 1].x, this.drawPoints[a_index + 1].y)
        this.arrowHead.fill(scratchPad, "darkGray")
        this.arrowHead.draw(scratchPad, "darkGray", 1)
        scratchPad.update()
    }

    draw(canvas, calculate = 1) {
        
        if (! this.stencil)
            this.stencil := new stencil()

        if (calculate) {
            this.reset()
            this.calculatePath()
            this.optimize()
        }

        this.stencil.draw(canvas, "black")
        (this.destShape.isLineAnchor = 0) ? this.setArrowHead(canvas)
    }

    remove() {
        this.origShape.linesOriginatingFrom.delete(this.alias.string)
        this.destShape.linesFeedingInto.delete(this.alias.string)
    }
}