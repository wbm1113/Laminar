class gridLine_predictionPath extends gridLine
{
    __new(alias) {
        this.alias := alias
        , this.reset()
        , gridLine.predictionPathIndex++
        , gridLine.predictionPathCount++
    }

    init(origPoint, destPoint) {
        this.origPoint := origPoint
        , this.destPoint := destPoint
        , this.drawPoints.push(origPoint)
        return this
    }

    coerce(point) { ;// forces predictive paths to branch in new directions          
        this.coercedPoints.push(point)
        return this
    }
}