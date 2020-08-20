OnMessage(0x115, "OnScroll") ; WM_VSCROLL

global gui_scroll_list := []

onScroll(wParam, lParam, msg, hwnd)
{
    static SIF_ALL=0x17, SCROLL_STEP=50

    bar := msg=0x115 ; SB_HORZ=0, SB_VERT=1
    s := mem.struct.onScroll
    s.put("fMask", SIF_ALL)
    new_pos := s.get("nPos")

    if !DllCall("GetScrollInfo", "uint", hwnd, "int", bar, "uint", s.ptr)
        return
    
    action := wParam & 0xFFFF
    if action = 0 ; SB_LINEUP
        new_pos -= SCROLL_STEP
    else if action = 1 ; SB_LINEDOWN
        new_pos += SCROLL_STEP
    else if (action = 5 || action = 4) ; SB_THUMBTRACK || SB_THUMBPOSITION
        new_pos := wParam>>16
    else if (wParam = "bypassFromvScrollUpdate")
        new_pos += 0
    else return

    min := s.get("nMin")
    max := s.get("scrollHeight") - s.get("clientArea")

    new_pos := new_pos > max ? max : new_pos
    new_pos := new_pos < min ? min : new_pos

    old_pos := s.get("nPos")
    
    y := 0
    y := old_pos-new_pos

    for i, g in gui_scroll_list
        g.window.move(g.window.x, 10 - new_pos)
    
    s.put("nPos", new_pos)
    dllCall("SetScrollInfo", "uint", hwnd, "int", bar, "uint", s.ptr, "int", 1)
}