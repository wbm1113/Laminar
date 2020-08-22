/*
    wrapper for AHK mouse-related commands
*/

class mouse extends protoClass
{
    setToScreen() {
        coordMode, mouse, screen
        return this
    }

    setToClient() {
        coordMode, mouse, client
        return this
    }

    getPos() {
        mouseGetPos, x, y
        return [x, y]
    }

    getHovWin() {
        mouseGetPos,,, win
        return win
    }

    getHovCtrl() {
        mousegetpos,,,, ctrl
        return ctrl
    }

    click(x = "", y = "") {
        if (x = "" and y = "")
            sendInput {click}
        else sendInput {click %x%, %y%}
        return this
    }

    twoWayClick(x, y) { ;// returns the mouse to its original position after clicking
        this.savePos()
        , this.click(x, y)
        , this.restorePos()
    }

    savePos() {
        this.savedPos := {}
        , xy := this.getPos()
        , this.savedPos.x := xy[1]
        , this.savedPos.y := xy[2]
        return this
    }

    restorePos() {
        MouseMove, % this.savedPos.x, % this.savedPos.y, 0
        return this
    }
    
    setCoordsToZeroBase(x, y) {
        dx := desktop.topLeftX
        dy := desktop.topLeftY
        if (desktop.topLeftX < 0) {
            x = abs(dx)
        }
        if (desktop.topLeftY < 0) {
            y = abs(dy)
        }
        return [x, y]
    }
}
