class gui_options extends protoClass
{
    static styleTable := { "alwaysOnTop"    : "+alwaysOnTop "
                         , "-alwaysOnTop"   : "-alwaysOnTop "
                         , "noMaximize"     : "-maximizeBox "
                         , "border"         : "+border "
                         , "noCaption"      : "-caption "
                         , "layered"        : "+E0X80000 "
                         , "clickThrough"   : "+E0x20 "
                         , "noClickThrough" : "-E0x20 "
                         , "toolWindow"     : "+toolWindow "
                         , "owner"          : "owner "
                         , "focusParent"    : "+0x40000000 -0x80000000 " }
    initialStyles := ""
    resizable := 0
    isClickThrough := 0                

    cmd(c) { ;// ez syntax
        return this.hwnd ": " c
    }

    setInitialStyles(styles*) {
        for i, s in styles
            this.initialStyles .= this.styleTable[s]
    }

    applyStyles(styles*) {
        for i, s in styles {
            style := this.styleTable[s]
            if (style = "clickThrough")
                this.isClickThrough := 1
            if (style = "noClickThrough")
                this.isClickThrough := 0
            gui, % this.cmd(style)
        }
    }

    setMargin(w = 4, h = 4) {
        gui, % this.cmd("margin"), % w, % h ;// margins are incorporated into ctrl placement methods
    }

    setColor(windowColor = "", ctrlColor = "") {
        this.windowColor := window
        this.ctrlColor := ctrlColor
        gui, % this.cmd("color"), % windowColor, % ctrlColor
    }
    
    setFont(fontSize = 10, fontOptions = "normal", fontName = "") {
        this.fontName := fontName
        this.fontSize := fontSize
        this.fontOptions := fontOptions
        gui, % this.cmd("font"), % "s" this.fontSize " " this.fontOptions, % this.fontName
    }

    setMaxSize(x, y) {
        gui, % this.cmd("+maxSize" x "x" y)
    }

    setParent(hwnd) {
        gui, % this.cmd("+parent" hwnd)
    }

    setOwner(hwnd) {
        gui, % this.cmd("+owner" hwnd)
    }

    makeResizable() {
        this.resizable := 1
        gui, % this.cmd("+labelGuiOn +resize")
        mem.add("scrollUpdate")
        mem.struct.scrollUpdate.define("m0", "fMask", "nMin", "scrollHeight", "clientArea", "nPos", "m6").declare()
        mem.add("onScroll")
        mem.struct.onScroll.define("m0", "fMask", "nMin", "scrollHeight", "clientArea", "nPos", "m6").declare()
        guiEventRouter[this.hwnd] := objBindMethod(this, "resize")
    }
}