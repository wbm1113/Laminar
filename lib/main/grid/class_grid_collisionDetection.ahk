class grid_collisionDetection
{
    detectCollision_outOfBounds(x, y, x2, y2) {
        return (x < 0 || x2 > bgLayer.window.w || y < 0 || y2 > bgLayer.window.h) ? 1 : 0
    }

    detectCollision_shapes_corners(x, y) {
        for i, s in this.shapes
            for j, r in s.cornerRects
                if r.contains(x, y)
                    return [s, r.alias]
        return 0
    }

    detectCollision_shapes_perimeters(x, y) {
        for i, s in this.shapes
            for j, r in s.perimeterRects
                if r.contains(x, y)
                    return [s, r.alias]
        return 0    
    }

    detectCollision_shapes(x, y) {
        for i, s in this.shapes
            if s.contains(x, y)
                return s
        return 0
    }

    detectCollision_withShape(alias, x, y) {
        return (this.shapes[alias].contains(x, y)) ? 1 : 0
    }

    detectProximity_shapes(x, y, tolerance, exclude = -1) {
        for i, s in this.shapes
            if s.isProximate(x, y, tolerance)
                if s.alias != exclude
                    return s
        return 0
    }

    detectProximity_withShape(alias, x, y, tolerance = 20) {
        for i, s in this.shapes
            if s.alias = alias
                if s.isProximate(x, y, tolerance)
                    return s
        return 0        
    }

    detectOverlap_shapes(x, y, w, h, exclude = -1) {
        if (x = "" or y = "" or w = "" or h = "")
            return 0
        p := new rect().setDimensions(x, y, w, h).resize(grid.padding)
        for i, s in this.shapes 
            if (s.x < p.x + p.w and s.x + s.w > p.x and s.y < p.y + p.h and s.y + s.h > p.y)
                if s.alias != exclude
                    return 1
        return 0
    }

    getOverlappedShapes(x, y, w, h) {
        overlappedShapes := []
        p := new rect().setDimensions(x, y, w, h)
        for i, s in this.shapes 
            if (s.x < p.x + p.w and s.x + s.w > p.x and s.y < p.y + p.h and s.y + s.h > p.y)
                overlappedShapes.push(s)
        return overlappedShapes     
    }

    detectProximity_lines(x, y) {
        for i, s in this.shapes
            for j, l in s.linesOriginatingFrom
                for k, b in l.collisionBoundaries
                    if b.contains(x, y)
                        return l
        return 0
    }

    getOverlappedLines(shape) {
        overlappedLines := []
        for i, s in this.shapes {
            for j, l in s.linesOriginatingFrom {
                for k, p in l.collisionBoundaries {
                    if (shape.x - 20 < p.x + p.w and shape.x + shape.w + 20 > p.x and shape.y - 20 < p.y + p.h and shape.y + shape.h + 20 > p.y) {
                        overlappedLines.push(l)
                        continue 2
                    }
                }
            }
        }
        return overlappedLines
    }
}