class autoAlign
{
    horizontalGuide(y) {
        smartGuideLayer_h.drawLine("aqua", 1, 1, y, grid.xLimit - 1, y)
    }

    verticalGuide(x) {
        smartGuideLayer_v.drawLine("aqua", 1, x, 1, x, grid.yLimit - 1)
    }

    detectAlignment(shape) {      
        hDetected := []
        vDetected := []

        for i, s in grid.shapes {
            if s.alias = shape.alias
                continue

            (round(shape.x, -1) = round(s.x, -1) || round(shape.x, -1) = round(s.x2, -1)) ? vDetected.push(round(shape.x, -1))
            (round(shape.x2, -1) = round(s.x, -1) || round(shape.x2, -1) = round(s.x2, -1)) ? vDetected.push(round(shape.x2, -1))
            (round(shape.y, -1) = round(s.y, -1) || round(shape.y, -1) = round(s.y2, -1)) ? hDetected.push(round(shape.y, -1))
            (round(shape.y2, -1) = round(s.y, -1) || round(shape.y2, -1) = round(s.y2, -1)) ? hDetected.push(round(shape.y2, -1))

            vCount := vDetected.count(), hCount := hDetected.count()
        }

        if (vCount > 0) {
            (this.vCount = vCount) ? smartGuideLayer_v.clear()
            for i, d in vDetected
                this.verticalGuide(d)
        } else smartGuideLayer_v.clear()
        
        this.vCount := vCount
        
        if (hCount > 0) {
            (this.hCount = hCount) ? smartGuideLayer_h.clear()
            for i, d in hDetected
                this.horizontalGuide(d)
        } else smartGuideLayer_h.clear()
        
        this.hCount := hDetected.count()

        if grid.activeState = "default" or grid.activeState = "selecting"
            return
        smartGuideLayer_v.update()
        smartGuideLayer_h.update()
    }

    clear() {
        smartGuideLayer_v.clear()
        smartGuideLayer_h.clear()
        smartGuideLayer_v.update()
        smartGuideLayer_h.update()
    }
}