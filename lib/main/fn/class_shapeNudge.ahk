class shapeNudge
{
    static nudges := { "left" : [-1 * grid.gridSize, 0]
                     , "up" : [0, -1 * grid.gridSize]
                     , "right" : [1 * grid.gridSize, 0]
                     , "down" : [0, 1 * grid.gridSize] }
    
    static nudging := 0

    nudge(direction, shapesToMove) {
        if this.nudging
            return

        this.nudging := 1
        if isObject(shapesToMove) {
            if shapesToMove.count() < 2 {
                this.nudgeOne(direction, shapesToMove[1])
            } else {
                this.nudgeMany(direction, shapesToMove)
            }
        } else this.nudgeOne(direction, shapesToMove)

        this.nudging := 0
    }

    nudgeOne(direction, shape) {

        a := actionStack.add(shape.alias)
        a.addUndoAction(shape.alias, "repos").setParams(shape.x, shape.y)
        a.addUndoAction(shapeLayer, "update")

        scratchPad.clear()
        direction := this.nudges[direction]
        x := shape.x + direction[1]
        , y := shape.y + direction[2]
        , w := shape.w
        , h := shape.h

        if grid.detectOverlap_shapes(x, y, shape.w, shape.h, shape.alias)
            return
        if grid.detectCollision_outOfBounds(x, y, x + w, y + h)
            return

        shape.rapidRepos(x, y, w, h, 0)
        overlappedLines := grid.getOverlappedLines(shape)
        lineLayer.clear()
        for i, ol in overlappedLines
            ol.draw(lineLayer, 1)
        grid.redrawLines(0)
        (shape.isLineAnchor) ? shape.outline("black", 2) : shape.handleOutline()
        shapeLayer.update()
        scratchPad.update()

        a.addRedoAction(shape.alias, "repos").setParams(x, y, w, h)
    }

    nudgeMany(direction, shapesToMove) {
        scratchPad.clear()
        direction := this.nudges[direction]

        bb := new compositeBoundingBox()
        bb.calculate(shapesToMove)

        bb.x_smallest += direction[1]
        bb.x2_largest += direction[1]
        bb.y_smallest += direction[2]
        bb.y2_largest += direction[2]

        bb := bb.create(grid.gridSize * 2)

        scratchPad.drawRect("black", 1, bb.x, bb.y, bb.w, bb.h, 0, 1)

        if grid.detectCollision_outOfBounds(bb.x, bb.y, bb.x2, bb.y2)
            return

        shapesToNotMove := []
        for i, shape in grid.shapes {
            for j, mover in shapesToMove {
                if (shape.alias = mover.alias) {
                    continue 2
                }
            }
            shapesToNotMove.push(shape)
        }

        for i, s in shapesToNotMove {
            if (s.x < bb.x + bb.w and s.x + s.w > bb.x and s.y < bb.y + bb.h and s.y + s.h > bb.y) {
                scratchPad.clear()
                s.outline("offRed", 2)
                scratchPad.update()
                return
            }
        }

        for i, shape in shapesToMove {
            x := shape.x + direction[1]
            , y := shape.y + direction[2]
            , w := shape.w
            , h := shape.h

            isObject(shape.container) ? shape.container.setRedraw(0)
            shape.rapidRepos(x, y, w, h, 0)
            (shape.isLineAnchor) ? shape.outline("black", 2) : shape.handleOutline()
        }

        for i, s in shapesToMove
            isObject(s.container) ? s.container.setRedraw(1)

        textLayer.window.speedRedraw()
        shapeLayer.update()
        scratchPad.update()
    }
}