class roundRect extends stencil
{
    r := 20

    updateCoords(x = 0, y = 0, w = 0, h = 0) {
        isObject(x) ? this.setBoundingBox(x) : this.createBoundingBox(x, y, w, h)
        this.reset()
        b := this.boundingBox
        r := this.r
        this.createPathArc(b.x, b.y, r, r, 180, 90)
        this.createPathArc(b.x2 - r, b.y, r, r, 270, 90)
        this.createPathArc(b.x2 - r, b.y2 - r, r, r, 360, 90)
        this.createPathArc(b.x, b.y2 - r, r, r, 90, 90)
        this.closePath()
        return this
    }
}