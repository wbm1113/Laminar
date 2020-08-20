class coordComm
{
    updateCoords(strict = 0) {
        if ! gui.window.isActive() {
            cursor.reset()
            return 0
        }
        
        win := mouse.getHovWin()
        if gui.hwnd != win and bgLayer.hwnd != win {
            cursor.reset()
            return 0
        }
        
        this.clientCoords := this.yScrollAdj(mouse.setToClient().getPos())
        
        if ! bgLayer.window.isProximate(this.clientCoords[1], this.clientCoords[2], 9) {
            cursor.reset()
            if (strict) {
                eventMgr.enabled := 0
                if (grid.activeState = "copying")
                    gridState_copying.abort()
                else if (grid.activeState = "drawing")
                    gridState_drawing.abort()
                else if (grid.activeState = "moving")
                    gridState_moving.abort()
                else if (grid.activeState = "resizing")
                    gridState_resizing.abort()
                gridState_default.activate()
            }
            return 0
        }

        this.gridCoords := this.clientToGrid(this.clientCoords)

        if this.gridCoords[1] < 0 or this.gridCoords[1] > 760
            or this.gridCoords[2] < 0 or this.gridCoords[2] > 1000
                return 0

        this.snapToGridCoords := object()
        , this.snapToGridCoords.x := this.gridCoords[1].modDown(10)
        , this.snapToGridCoords.y := this.gridCoords[2].modDown(10)
    }

    yScrollAdj(xyArray) {
        return [xyArray[1], xyArray[2] + gui.window.yScrollAdj]
    }

    clientToGrid(xyArray) {
        return [xyArray[1] - bgLayer.window.x, xyArray[2] - bgLayer.window.y]
    }

    gridToClient(xyArray) {
        return [xyArray[1] + bgLayer.window.x, xyArray[2] + bgLayer.window.y - gui.window.yScrollAdj]
    }
}