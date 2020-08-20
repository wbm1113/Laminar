class grid_shapes extends grid_collisionDetection
{
    addShape(form, x, y, w, h, alias = 0) {
        alias := alias ? alias : this.generateShapeId() "SHAPE"

        s := new gridShape(alias, form, x, y, w, h)
        this.shapes[s.alias] := s

        a := actionStack.add(s.alias)
        a.addUndoAction(grid, "removeShape").setParams(s.alias)
        a.addUndoAction(shapeLayer, "update")
        a.addRedoAction(grid, "importShape").setParams(form, s.export())
        a.addRedoAction(s.alias, "render")
        a.addRedoAction(shapeLayer, "update")
        return s
    }

    importShape(form, shape) {
        s := new gridShape(shape.alias, form, shape.x, shape.y, shape.w, shape.h)
        s.import(shape)
        s.form := form
        this.shapes[s.alias] := s
        return s
    }

    removeShape(alias) {
        removedShape := this.shapes.delete(alias)

        a := actionStack.add(removedShape.alias)
        a.addUndoAction(grid, "importShape").setParams(removedShape.form, removedShape.export())
        for i, l in removedShape.linesOriginatingFrom
            a.addUndoAction(grid, "importLine").setParams(i)
        for i, l in removedShape.linesFeedingInto
            a.addUndoAction(grid, "importLine").setParams(i)
        a.addUndoAction(removedShape.alias, "repos").setParams(removedShape.x, removedShape.y, removedShape.w, removedShape.h)

        removedShape.remove()

        a.addRedoAction(grid, "removeShape").setParams(removedShape.alias)
        a.addRedoAction(shapeLayer, "update")
    }
}