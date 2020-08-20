class grid_lines extends grid_shapes
{
    addLine(origShape, origDirection, destShape, destDirection) {
        line := new gridLine(origShape, origDirection, destShape, destDirection)
        origShape.linesOriginatingFrom[line.alias.string] := line
        destShape.linesFeedingInto[line.alias.string] := line
        return line
    }

    importLine(aliasString) {
        lineAliasComponents := []
        loop, parse, aliasString, |
        {
            lineAliasComponents.push(a_loopField)
        } 
        return grid.addLine(grid.shapes[lineAliasComponents[1]]
                          , lineAliasComponents[2]
                          , grid.shapes[lineAliasComponents[3]]
                          , lineAliasComponents[4]) 
    }

    removeLine(alias) {
        this.updateLineReference(alias).remove()
    }

    redrawOneLine(alias) {
        lineLayer.clear()

        for i, s in this.shapes 
            for j, l in s.linesOriginatingFrom
                (j = alias) ? l.draw(lineLayer, 1) : l.draw(lineLayer, 0)

        lineLayer.update()        
    }

    redrawLines(recalculate = 1) {
        lineLayer.clear()

        for i, s in this.shapes 
            for j, l in s.linesOriginatingFrom
                l.draw(lineLayer, recalculate)

        lineLayer.update()
    }

    redrawLinesOf(shape) {
        lineLayer.clear()

        shapeLines := shape.getLines()

        for i, s in this.shapes {
            for j, l in s.linesOriginatingFrom {
                draw := 1
                for k, sl in shapeLines 
                    (j = sl) ? draw := 0
                (draw) ? l.draw(lineLayer, 0) : l.draw(lineLayer)
            }
        }

        lineLayer.update()
    }
}