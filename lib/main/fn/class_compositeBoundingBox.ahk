class compositeBoundingBox
{
    __new(alias = "") {
        this.alias := alias
    }

    calculate(shapeArray) {
        x_smallest := 9999
        x2_largest := 0
        y_smallest := 9999
        y2_largest := 0

        for i, shape in shapeArray {
            x_smallest := min(x_smallest, shape.x)
            x2_largest := max(x2_largest, shape.x2)
            y_smallest := min(y_smallest, shape.y)
            y2_largest := max(y2_largest, shape.y2)
        }

        this.x_smallest := x_smallest
        this.x2_largest := x2_largest
        this.y_smallest := y_smallest
        this.y2_largest := y2_largest
    }

    create(widen = 0) {
        this.bb := new rect().setDimensionsByx2y2(this.x_smallest - widen
                                                , this.y_smallest - widen
                                                , this.x2_largest + widen
                                                , this.y2_largest + widen)
        return this.bb
    }
}