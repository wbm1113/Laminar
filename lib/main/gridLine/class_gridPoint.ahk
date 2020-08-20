class gridPoint
{
    direction := ""

    __new(x, y) {
        this.x := x
        , this.y := y
    }

    score[] {
        get {
            return this._score
        }
        set {
            this._score := value
        }
    }

    getDirection(x, y) {
        if (this.y = y) {
            if (this.x > x)
                return "left"
            if (x > this.x)
                return "right"
        } else if (this.x = x) {
            if (this.y > y)
                return "above"
            if (y > this.y)
                return "below"
        }
    }

    getAxialMovementType(x, y) { ;// relative to x, y
        if abs(x - this.x) > 0
            this.direction := "x"
        else if abs(y - this.y) > 0
            this.direction := "y"
        return this.direction
    }

    isAlignedTo(x, y) {
        return this.x = x || this.y = y ? 1 : 0
    }
}