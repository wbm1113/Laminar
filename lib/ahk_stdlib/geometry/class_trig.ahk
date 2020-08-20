class trig
{
    static pi := 3.141592653589793238462643383279502880

    toRadians(n) {
        return n * 0.01745329252
    }

    toDegrees(n) {
        return n * 57.29578
    }

    rotate(point, angle, center) {
        angle := this.toRadians(angle)
        x := point[1]
        y := point[2]
        xCenter := center[1]
        yCenter := center[2]
        rX := cos(angle) * (x - xCenter) - sin(angle) * (y - yCenter) + xCenter
        rY := sin(angle) * (x - xCenter) + cos(angle) * (y - yCenter) + yCenter
        return [round(rx), round(ry)]
    }
}