class grid extends grid_query
{
    static alias := "grid"
    static gridSize := 10
    static padding := grid.gridSize * 2
    static minimumShapeWidth := 60
    static minimumShapeHeight := 60
    static xLimit := 760
    static yLimit := 1000
    static shapes := object()
    static _activeState := ""

    generateShapeId() {
        loop {
            id := format("{:06}", randBetween.generate(0, 999999))
            for i, s in this.shapes
                if inStr(s.alias, id)
                    continue 2
            break
        }
        return id
    }

    activeState[] {
        get {
            return grid._activeState
        }
        set {
            grid._activeState := value
        }
    }

    clear() {
        for i, s in grid.shapes {
            s.deleteBitmap()

            for j, l in s.linesOriginatingFrom
                l.stencil.remove()
        }

        for i, a in gridState_connecting.originArrows
            a.remove()
        
        for i, a in gridState_connecting.destArrows
            a.remove()

        loop 20 {
            if this.shapes.count() < 1
                break
            for i, shape in this.shapes
                grid.removeShape(shape.alias)
        }
        
        this.shapes := object()
        this.activeState := ""
    }
}