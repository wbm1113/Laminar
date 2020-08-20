class alignMgr
{
    clean := 1

    clear() {
        autoAlign.clear()
        gridAlign.clear()
    }

    detect(x, y, x2, y2, a) {
        if grid.activeState = "default" or grid.activeState = "selecting"
            return
        obj := {x: x, y: y, x2: x2, y2: y2, alias: a}
        gridAlign.detectCollision(obj)
        autoAlign.detectAlignment(obj)
    }
}