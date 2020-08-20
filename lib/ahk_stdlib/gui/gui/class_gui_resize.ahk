class gui_resize extends gui_options
{
    resize(w, h) {
        this.window.w := w, this.window.h := h
        this.vScrollUpdate()
    }

    vScrollUpdate() 
    {
        static SIF_RANGE=0x1, SIF_PAGE=0x2, SIF_DISABLENOSCROLL=0x8, SB_HORZ=0, SB_VERT=1
        guiHeight := this.window.h

        top := 9999
        bottom := 0

        for a, c in this.childwindows {
            (c.window.y < top) ? top := c.window.y
            (c.window.y + c.window.h > bottom) ? bottom := c.window.y + c.window.h
        }

        top -= 8
        bottom += 8
        scrollHeight := bottom - top

        adj := mem.struct.onScroll.get("nPos")

        s := mem.struct.scrollUpdate ; initialize scrollInfo
        s.put("fMask", SIF_RANGE | SIF_PAGE)   
        s.put("scrollHeight", scrollHeight) ;// update vertical scrollbar
        s.put("clientArea", guiHeight)
        dllCall("SetScrollInfo", "uint", this.hwnd, "uint", SB_VERT, "uint", s.ptr, "int", 1)
        if (top < 0 and bottom < guiHeight)
            y := abs(top) > guiHeight-Bottom ? guiHeight-bottom : abs(top)
        
        if (y) {
            mem.struct.onScroll.put("nPos", adj - y)
            onScroll("bypassFromvScrollUpdate", 0, 0x115, this.hwnd)
        }
    } 
}