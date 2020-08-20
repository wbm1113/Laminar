class gridAlign
{
    static 1Q := grid.xLimit / 4
    static M := grid.xLimit / 2
    static 3Q := grid.xLimit * 0.75

    detectCollision(shape) {
        smartGuideLayer_g.clear()
        , 1Q := 0, M := 0, 3Q := 0

        if shape.x < this.M and shape.x2 > this.M
            M := 1, this.guide := "M"
        if shape.x < this.1Q and shape.x2 > this.1Q
            1Q := 1, this.guide := "1Q"
        if shape.x < this.3Q and shape.x2 > this.3Q
            3Q := 1, this.guide := "3Q"

        if (1Q + M + 3Q != 1) {
            smartGuideLayer_g.update()
            return
        }

        gr := this[this.guide]
        
        smartGuideLayer_g.drawLine("blue", 1, gr, 1, gr, grid.yLimit - 1)
        , leftSideWidth := gr - shape.x
        , rightSideWidth := shape.x2 - gr

        if (this.w = leftSideWidth + rightSideWidth and this.y = shape.y and this.x = shape.x)
            return

        this.w := leftSideWidth + rightSideWidth
        , this.x := shape.x
        , this.y := shape.y
        , color := round(leftSideWidth, -1) = round(rightSideWidth, -1) ? "vibrantBlue" : "darkGray"

        if grid.activeState = "moving"
            if mod(leftSideWidth + rightSideWidth, 20) = 10
                color := "lightMediumGray"

        x := shape.x + abs(leftSideWidth - rightSideWidth)
        , y := shape.y - 15
        , smartGuideLayer_g.drawLine(color, 1, x, y + 2, x, y + 8)
        , smartGuideLayer_g.drawLine(color, 1, shape.x2, y + 2, shape.x2, y + 8)
        , y := shape.y - 10
        , smartGuideLayer_g.drawLine(color, 1, shape.x, y, shape.x2, y)

        if grid.activeState = "default" or grid.activeState = "selecting"
            return
        smartGuideLayer_g.update()
    }

    clear() {
        smartGuideLayer_g.clear().update()
        , this.w := -1
    }
}