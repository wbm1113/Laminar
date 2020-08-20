class path extends protoClass
{
    __new() {
        this.reset()   
    }

    reset() {
        this.points := []
        this.pointCount := 0
        return this
    }

    add(x, y) {
        this.points.push([x, y])
        this.pointCount++
        return this
    }

    import(pointArray) {
        for i, p in pointArray {
            this.points.push(p)
            this.pointCount++
        }
        return this
    }
}