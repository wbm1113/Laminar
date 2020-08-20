class gridLine_pathCalculation
{
    getBeginningAndFinalPoints() {
        g := grid.gridSize
        orig := this.origShape[this.origDirection]
        dest := this.destShape[this.destDirection]

        offsets := this.offsetsByRectSide[this.origDirection]

        firstPoint := [ orig[1].modDown(g), orig[2].modDown(g) ]
        this.origPoint := new gridPoint(firstPoint[1], firstPoint[2])

        secondPoint := [ firstPoint[1] + offsets[1], firstPoint[2] + offsets[2] ]
        this.secondPoint := new gridPoint(secondPoint[1], secondPoint[2])
        this.secondPoint.getAxialMovementType(this.origPoint.x, this.origPoint.y)
        
        finalPoint := [ dest[1].modDown(g), dest[2].modDown(g) ]
        this.finalPoint := new gridPoint(finalPoint[1], finalPoint[2])

        offsets := this.offsetsByRectSide[this.destDirection]

        secondToFinalPoint := [ finalPoint[1] + offsets[1], finalPoint[2] + offsets[2] ]
        this.destPoint := new gridPoint(secondToFinalPoint[1], secondToFinalPoint[2])         

        this.drawPoints.push(this.origPoint, this.secondPoint)
    }

    getNeighboringPoints(point) {
        x := point.x, y := point.y
        return [ [x - grid.gridSize, y], [x, y + grid.gridSize], [x + grid.gridSize, y], [x, y - grid.gridSize] ]
    }

    containsDestPoint(points) {
        loop % points.count()
            if points[a_index][1] = this.destPoint.x and points[a_index][2] = this.destPoint.y
                return 1
        return 0
    }

    filterCollisionPoints(points) {
        remainingPoints := []
        loop % points.count()
            if ! grid.detectProximity_shapes(points[a_index][1], points[a_index][2], 1)
                remainingPoints.push(points[a_index])
        return remainingPoints
    }

    enforcePointCoercion(points) {
        if this.coercedPoints.count() < 1
            return points

        loop % points.count() {
            p := points[a_index]
            for i, c in this.coercedPoints
                if p[1] = c[1] and p[2] = c[2]
                    return [ this.coercedPoints.removeAt(a_index) ]
        }
        return points
    }

    preventBacktracking(points) {
        remainingPoints := []
        counter := 0

        loop % points.count() {
            b_index := a_index
            for i, p in this.drawPoints
                if points[b_index][1] = p.x and points[b_index][2] = p.y
                    continue 2
            remainingPoints.push(points[a_index])
        }

        if remainingPoints.count() < 1
            throw exception("No points remaining after preventBacktracking()", -1, "line: " this.alias ", index: " this.drawIndex)
        return remainingPoints
    }

    convertPointsToObjects(points) {
        pointObjects := []

        loop % points.count()
            pointObjects.push(new gridPoint(points[a_index][1], points[a_index][2]))

        return pointObjects
    }

    getPointProperties(pointObjects) { 
        x2 := this.destPoint.x
        y2 := this.destPoint.y

        for i, gp in pointObjects {

            score := 0
            pp := this.prevPoint

            ;// calculate total distance between the current point and the destination point
            score += x2 > gp.x ? x2 - gp.x : gp.x - x2
            score += y2 > gp.y ? y2 - gp.y : gp.y - y2

            ;// strongly avoids points that move directly away from the destination point
            cd := pp.getDirection(gp.x, gp.y)
            dd := gp.getDirection(this.destPoint.x, this.destPoint.y)
            if (cd and dd) {
                if (cd = "right" and dd = "left")
                or (cd = "left" and dd = "right")
                or (cd = "above" and dd = "below")
                or (cd = "below" and dd = "above")
                    score += 20
            }

            ;// points prefer to stay aligned to the origin/destination points
            if ! grid.detectProximity_shapes(gp.x, gp.y, grid.gridSize)
                if gp.isAlignedTo(this.origPoint.x, this.origPoint.y)
                    or gp.isAlignedTo(x2, y2)
                        score -= 1

            ;// points resist changing direction           
            score -= gp.getAxialMovementType(pp.x, pp.y) = pp.direction ? 2 : 0

            gp.score := score
        }
        return pointObjects
    }

    getBestPoints(pointObjects) { ;// the lower the score, the closer the point is to the destination
        bestScore := 1000

        for i, gp in pointObjects
            bestScore := gp.score < bestScore ? gp.score : bestScore

        bestPoints := []
        for i, gp in pointObjects
            if gp.score = bestScore
                bestPoints.push(gp)

        if bestPoints.count() < 1
            throw exception("Failed to get best points", -1)
        return bestPoints
    }

    calculatePath() {
        if this.alias != "predictionPath"
            this.getBeginningAndFinalPoints()

        this.drawIndex := this.drawPoints.count()
        
        this.prevPoint := this.drawPoints[this.drawIndex]

        loop {

            neighbors := this.getNeighboringPoints(this.drawPoints[this.drawIndex])
            if this.containsDestPoint(neighbors)
                break
            neighbors := this.filterCollisionPoints(neighbors)
            , neighbors := this.enforcePointCoercion(neighbors)
            , neighbors := this.preventBacktracking(neighbors)
            , neighbors := this.convertPointsToObjects(neighbors)
            , neighbors := this.getPointProperties(neighbors)
            , neighbors := this.getBestPoints(neighbors)
            , bestPointsSnapshot := neighbors

            if neighbors.count() = 1 or gridLine.predictionPathIndex > 1 {

                this.nextPoint := neighbors[1]

            } else {

                pathPredictions := []

                for i, gp in neighbors
                    pathPredictions.push(new gridLine_predictionPath("predictionPath").init(this.prevPoint, this.destPoint).coerce([gp.x, gp.y]).calculatePath().drawIndex)

                smallestPath := min(pathPredictions*)

                for i, p in pathPredictions
                    if (p = smallestPath)
                        this.nextPoint := neighbors[a_index]   

            }

            if this.alias != "predictionPath"
                gridLine.predictionPathIndex := 0

            if (a_index > 150)
                throw exception("Path recursion limit exceeded", -1)
            
            this.drawPoints.push(this.nextPoint)
            , this.prevPoint := this.nextPoint
            , this.drawIndex++
        }

        this.drawPoints.push(this.destPoint, this.finalPoint)
        return this
    }

    optimize() {
        optimizedPoints := []
        numberOfPoints := this.drawPoints.count()
        anchorPoint := this.drawPoints[1]

        if (this.origShape.isLineAnchor) {
            extDir := this.anchorPointOffsets[this.origDirection]
            extPoint := object()
            extPoint.x := anchorPoint.x + extDir[1]
            extPoint.y := anchorPoint.y + extDir[2]
            optimizedPoints.push(extPoint)
        }

        optimizedPoints.push(anchorPoint)

        loop % numberOfPoints {
            currPoint := this.drawPoints[a_index - 1]
            , nextPoint := this.drawPoints[a_index]

            if anchorPoint.x = nextPoint.x or anchorPoint.y = nextPoint.y
                continue

            anchorPoint := currPoint
            , optimizedPoints.push(anchorPoint)
        }

        optimizedPoints.push(this.drawPoints[numberOfPoints])

        if (this.destShape.isLineAnchor) {
            extDir := this.anchorPointOffsets[this.destDirection]
            extPoint := object()
            extPoint.x := this.drawPoints[numberOfPoints].x + extDir[1]
            extPoint.y := this.drawPoints[numberOfPoints].y + extDir[2]
            optimizedPoints.push(extPoint)
        }

        this.drawPoints := []
        this.drawPoints := optimizedPoints
        this.calculateCollisionBoundaries()

        this.stencil.reset()

        i := 1
        loop % this.drawPoints.count() - 1 {
            j := i + 1
            this.stencil.createPathLine(this.drawPoints[i].x, this.drawPoints[i].y, this.drawPoints[j].x, this.drawPoints[j].y)
            i ++
        }
    }
}