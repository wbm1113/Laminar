class ctrl_options extends protoClass
{
    static styleTable := { "center"     : "+center "
                         , "vScrollOff" : "-vScroll "
                         , "multiLine"  : "+multi "
                         , "disable"    : "+disabled "
                         , "enable"     : "-disabled " 
                         , "noBorder"   : "-E0x200 "}
    initialStyles := ""
    
    setInitialStyles(styles*) {
        for i, s in styles
            this.initialStyles .= this.styleTable[s]
        return this
    }

    setFont(size = 10, options = "normal", fontName = "") {
        this.parent.setFont(size, options, fontName)
        guiControl, font, % this.hwnd
        return this
    }

    setColor(bg = "", fg = "") {
        if (bg = "" and fg = "")
            ctlColors.detach(this.hwnd)
        else ctlColors.change(this.hwnd, bg, fg)
        return this
    }
}