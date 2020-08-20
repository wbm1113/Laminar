class gridShape_dataTransfer extends rect
{
    static properties := [ "alias"
                         , "pointsToward"
                         , "form"
                         , "type"
                         , "isLineAnchor"
                         , "bgColor"
                         , "x"
                         , "y"
                         , "w"
                         , "h"
                         , "lines"
                         , "text"
                         , "textSize"
                         , "sizeAlias"
                         , "textBold"
                         , "bitmap" ]
    
    lines[] {
        get {
            return this.linesOriginatingFrom
        }
        set {
            if (! isObject(value))
                return
            this.linesOriginatingFrom := value
        }
    }

    export() {
        shape := object()
        for i, p in this.properties
            shape[p] := this[p]
        return shape
    }

    import(shape) {
        for i, p in this.properties
            this[p] := shape[p]
    }

    disableTextRedraw() {
        isObject(this.container) ? this.container.setRedraw(0)
    }

    enableTextRedraw() {
        isObject(this.container) ? this.container.setRedraw(1)
    }
}