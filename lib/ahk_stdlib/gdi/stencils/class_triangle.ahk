class triangle extends stencil
{
    updateCoords(x = 0, y = 0, w = 0, h = 0, pointsToward = "up") {
        this.pointsToward := pointsToward
        isObject(x) ? this.setBoundingBox(x) : this.createBoundingBox(x, y, w, h)
        this.reset()
        this[this.pointsToward]()
        return this
    }

    up() {
        b := this.boundingBox
        this.createPathLine(b.x, b.y2, b.x2, b.y2)
        this.createPathLine(b.x + b.w // 2, b.y, b.x, b.y2)
    }

    down() {
        b := this.boundingBox
        this.createPathLine(b.x, b.y, b.x2, b.y)
        this.createPathLine(b.x + b.w // 2, b.y2, b.x, b.y)
    }

    left() {
        b := this.boundingBox
        this.createPathLine(b.x2, b.y, b.x2, b.y2)
        this.createPathLine(b.x, b.y + b.h // 2, b.x2, b.y)
    }

    right() {
        b := this.boundingBox
        this.createPathLine(b.x, b.y, b.x, b.y2)
        this.createPathLine(b.x2, b.y + b.h // 2, b.x, b.y)
    }
}