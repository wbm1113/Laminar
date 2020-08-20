class circle extends stencil
{
    updateCoords(x = 0, y = 0, w = 0, h = 0) {
        isObject(x) ? this.setBoundingBox(x) : this.createBoundingBox(x, y, w, h)
        this.reset()
        b := this.boundingBox
        this.createPathEllipse(b.x, b.y, b.w, b.h)
        return this
    }
}