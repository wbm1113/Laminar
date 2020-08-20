class diamond extends stencil
{
    updateCoords(x = 0, y = 0, w = 0, h = 0) {
        isObject(x) ? this.setBoundingBox(x) : this.createBoundingBox(x, y, w, h)
        this.reset()

        b := this.boundingBox

        points := ([b.midLeft
                  , b.midTop
                  , b.midRight
                  , b.midBottom
                  , b.midLeft])

        i := 1
        loop 4 {
            j := i + 1
            this.createPathLine(points[i][1]
                              , points[i][2]
                              , points[j][1]
                              , points[j][2])
            i++
        }
        return this
    }
}