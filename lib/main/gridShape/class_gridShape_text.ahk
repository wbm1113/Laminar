class gridShape_text extends gridShape_image
{   
    static leftoverTextContainers := []
    static textExtentAdjustments := {10:10, 14:16, 20:20}

    textSize := 10
    sizeAlias := "small"
    textBold := 0
    container := 0
    containerLineCount := 0
    containerColor := 0
    containerLineLimitMod := 0
    verticalPadding := 0
    yMin := 0
    hMax := 9999

    text[] {
        get {
            return this.container.text
        }   
        set {
            if this.container = 0 and value = ""
                return
            this.attachText()
            this.container.text := value
        }
    }

    attachText() {
        if (this.container = 0) {

            recycledContainer := this.leftoverTextContainers.pop()

            if (recycledContainer) {
                this.container := textLayer.ctrls[recycledContainer]
                this.container.deleteEvents()
            } else {
                this.container := textLayer.ctrls.add("edit", this.alias "text")
                this.container.setInitialStyles("center", "vScrollOff", "multiLine", "noBorder")
                this.container.setDimensions(0, 0, 50, 50)     
                this.container.draw()
            }

            this.container.addEventListener().addEvent(objBindMethod(this, "vCenterText"))
        }

        this.container.show()
    }

    updateText(text = -1, size = "", bold = "", color = "") {
        this.attachText()

        if (text != -1)
            this.text := text

        if (size != "")
            this.textSize := size

        if (bold != "")
            this.textBold := bold

        if (color != "")
            this.container.setColor(shapeLayer.lookupColorByAlias(this.bgColor, 1))
    }

    getTextBounds_rect() {
        this.tb_x := this.x + 10
        this.tb_y := this.y + this.h // 2 + 10
        this.tb_w := this.w - 20
        this.tb_h := (this.h - 20) // 2
    }

    getTextBounds_roundRect() {
        this.getTextBounds_rect()
    }

    getTextBounds_circle() {
        this.tb_w := sqrt(2 * (this.w // 2)**2)
        this.tb_h := sqrt(2 * (this.h // 2)**2)
        this.tb_x := this.center[1] - this.tb_w // 2
        this.tb_y := this.center[2] - this.tb_h // 2

        this.tb_x += 10
        this.tb_y += 10
        this.tb_w -= 20
        this.tb_h -= 20

        this.containerLineLimitMod := 1
    }

    getTextBounds_diamond() {
        this.tb_x := this.x + this.w * 0.25
        this.tb_y := this.y + this.h * 0.25
        this.tb_w := this.w // 2
        this.tb_h := this.h // 2

        this.tb_x += 10
        this.tb_y += 10
        this.tb_w -= 20
        this.tb_h -= 20

        this.verticalPadding := round((this.h * 0.25) * 2)
        this.yMin := this.y + this.h * 0.25
        this.hMax := this.h // 2
        this.containerLineLimitMod := 1
    }

    getTextBounds_arrow() {
        
        if this.pointsToward = "up" {

            this.tb_x := this.x + this.w * 0.25
            this.tb_y := this.y + this.h * 0.25
            this.tb_w := this.w * 0.5
            this.tb_h := this.h * 0.75
            this.yMin := this.y + this.h * 0.25
            this.hMax := this.h * 0.75
            this.containerLineLimitMod := 1

        } else if this.pointsToward = "down" {

            this.tb_x := this.x + this.w * 0.25
            this.tb_y := this.y
            this.tb_w := this.w * 0.5
            this.tb_h := this.h * 0.6
            this.yMin := this.y
            this.hMax := this.h * 0.6
            this.containerLineLimitMod := 1

        } else if this.pointsToward = "left" {

            this.tb_x := this.x + this.w * 0.2
            this.tb_y := this.y + this.h * 0.3
            this.tb_w := this.w * 0.8
            this.tb_h := this.h * 0.4
            this.yMin := this.tb_y
            this.hMax := this.h * 0.4
            this.containerLineLimitMod := 1

        } else if this.pointsToward = "right" {

            this.tb_x := this.x
            this.tb_y := this.y + this.h * 0.3
            this.tb_w := this.w * 0.8
            this.tb_h := this.h * 0.4
            this.yMin := this.tb_y
            this.hMax := this.h * 0.4
            this.containerLineLimitMod := 1

        }

        this.tb_x += 10
        this.tb_y += 10
        this.tb_w -= 20
        this.tb_h -= 20

    }

    conformTextToShape() {
        this.container.setFont(this.textSize, this.textBold ? "bold" : "normal")

        setFormat.hex()
        this.container.setColor(shapeLayer.lookupColorByAlias(this.bgColor, 1))
        setFormat.decimal()

        this.vCenterText()
    }

    vCenterText() {
        this["getTextBounds_" this.form]()

        this.containerLineCount := 0
        this.yBase := this.y + this.h // 2
        this.fontHeight := this.getTextExtentPoint("a", textLayer.fontName, this.textExtentAdjustments[this.textSize], this.textBold)[2]
        this.rowLimit := floor((this.h - 20) // this.fontHeight) - this.containerLineLimitMod

        this.containerLineCount := this.container.getLineCount()

        x := this.tb_x
        w := this.tb_w

        if this.containerLineCount >= this.rowLimit {
            verticalPadding := this.h - (this.rowLimit * this.fontHeight)
            y := this.y + verticalPadding // 2
            h := this.h - verticalPadding
        } else {
            y := this.yBase - (this.containerLineCount * floor(this.fontHeight // 2))
            h := this.fontHeight * this.containerLineCount
        }

        if (y < this.yMin) {
            y := this.yMin
        }

        if (h > this.hMax) {
            h := this.hMax
            m := mod(this.hMax, this.fontHeight)
            h -= m
            y += m // 2
        }

        this.container.move(x, y, w, h)
    }

    startEditingText() {
        this.attachText()
        this.conformTextToShape()
        
        this.container.focus()
        if this.text
            this.container.moveCaretToEnd()
        else this.text := "[enter shape text]", this.container.selectAll()

        textLayer.applyStyles("noClickThrough")
    }
    
    stopEditingText() {
        gui.ctrls["focusDumpster"].focus()
        textLayer.applyStyles("clickThrough")
    }

    detachText(preserve = 0) {
        if this.container {
            this.leftoverTextContainers.push(this.alias "text")
            this.container.text := preserve ? this.container.text : ""
            this.container.hide()
            this.container := 0
        }
    }

    GetTextExtentPoint(sString, sFaceName, nHeight = 9, bBold = False, bItalic = False, bUnderline = False, bStrikeOut = False, nCharSet = 0)
    {   ;// thanks Sean
        hDC := DllCall("GetDC", "Uint", 0)
        nHeight := -DllCall("MulDiv", "int", nHeight, "int", DllCall("GetDeviceCaps", "Uint", hDC, "int", 90), "int", 72)

        hFont := DllCall("CreateFont", "int", nHeight, "int", 0, "int", 0, "int", 0, "int", 400 + 300 * bBold, "Uint", bItalic, "Uint", bUnderline, "Uint", bStrikeOut, "Uint", nCharSet, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", sFaceName)
        hFold := DllCall("SelectObject", "Uint", hDC, "Uint", hFont)

        DllCall("GetTextExtentPoint32", "Uint", hDC, "str", sString, "int", StrLen(sString), "int64P", nSize)

        DllCall("SelectObject", "Uint", hDC, "Uint", hFold)
        DllCall("DeleteObject", "Uint", hFont)
        DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)

        nWidth  := nSize & 0xFFFFFFFF
        nHeight := nSize >> 32 & 0xFFFFFFFF

        Return [nWidth, nHeight]
    }
}


