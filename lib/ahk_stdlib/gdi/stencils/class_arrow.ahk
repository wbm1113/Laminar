    /*                   1
                        /\
                       /  \
                      /    \
                     /      \
                    /        \
                   /          \
                  /            \
                2/____3     ____\7
                      |    |6
                      |    |
                      |    |
                      |    |
                      |    |
                      |    |
                     4|____|5
    */

class arrow extends stencil
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
        bx_bw_2 := b.x + b.w // 2
        by_bh_2 := b.y + b.h // 2
        bx_bw_25 := b.x + b.w * 0.25
        bx_bw_75 := b.x + b.w * 0.75
        by_bh := b.y + b.h
        this.createPathLine(bx_bw_2, b.y, b.x, by_bh_2)
            .createPathLine(bx_bw_25, by_bh_2, bx_bw_25, by_bh)
            .createPathLine(bx_bw_75, by_bh, bx_bw_75, by_bh_2)
            .createPathLine(b.x + b.w, by_bh_2, bx_bw_2, b.y)
    }

    down() { ;// i'll refactor later
        b := this.boundingBox
        this.createPathLine(b.x + b.w * 0.25, b.y, b.x + b.w * 0.75, b.y)
            .createPathLine(b.x + b.w * 0.75, b.y + b.h // 2, b.x2, b.y + b.h // 2)
            .createPathLine(b.x + b.w // 2, b.y2, b.x, b.y + b.h // 2)
            .createPathLine(b.x + b.w * 0.25, b.y + b.h // 2, b.x + b.w * 0.25, b.y)
    }

    left() {
        b := this.boundingBox
        this.createPathLine(b.x, b.y + b.h // 2, b.x + b.w // 2, b.y)
            .createPathLine(b.x + b.w // 2, b.y + b.h * 0.25, b.x2, b.y + b.h * 0.25)
            .createPathLine(b.x2, b.y + b.h * 0.75, b.x + b.w // 2, b.y + b.h * 0.75)
            .createPathLine(b.x + b.w // 2, b.y2, b.x, b.y + b.h // 2)
    }

    right() {
        b := this.boundingBox
        this.createPathLine(b.x, b.y + b.h * 0.25, b.x + b.w // 2, b.y + b.h * 0.25)
            .createPathLine(b.x + b.w // 2, b.y, b.x2, b.y + b.h // 2)
            .createPathLine(b.x + b.w // 2, b.y2, b.x + b.w // 2, b.y + b.h * 0.75)
            .createPathLine(b.x, b.y + b.h * 0.75, b.x, b.y + b.h * 0.25)
    }
}