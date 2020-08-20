#NoEnv
#singleInstance, force
#include C:\Users\Ward\Desktop\ahk_stdlib\struct\class_struct.ahk


mem.add("scrollUpdate")
mem.struct.scrollUpdate.define("m0", "fMask", "nMin", "scrollHeight", "clientArea", "nPos", "m6").declare()
mem.add("onScroll")
mem.struct.onScroll.define("m0", "fMask", "nMin", "scrollHeight", "clientArea", "nPos", "m6").declare()


OnMessage(0x115, "OnScroll") ; WM_VSCROLL
Gui, New, hwndHwnd
Gui, +Resize ; WS_VSCROLL | WS_HSCROLL
Loop 8
    Gui, Add, Edit, R5 W400, Edit %A_Index%
Gui, Add, Button,, Do absolutely nothing
Gui, Show, W200 H200
Gui, +LastFound
return


GuiSize:
    vScrollUpdate(a_guiHeight)
return


~WheelUp::
~WheelDown::
    ; SB_LINEDOWN=1, SB_LINEUP=0, WM_HSCROLL=0x114, WM_VSCROLL=0x115
    OnScroll(InStr(A_ThisHotkey,"Down") ? 1 : 0, 0, 0x115, hwnd)
return


vScrollUpdate(guiHeight)
{
    static SIF_RANGE=0x1, SIF_PAGE=0x2, SIF_DISABLENOSCROLL=0x8, SB_HORZ=0, SB_VERT=1
    
    ; Calculate scrolling area.
    Top := 9999
    Bottom := 0
    WinGet, ControlList, ControlList
    Loop, Parse, ControlList, `n
    {
        GuiControlGet, c, Pos, %A_LoopField%
        if (cY < Top)
            Top := cY
        if (cY + cH > Bottom)
            Bottom := cY + cH
    }
    Bottom += 8
    ScrollHeight := Bottom-Top

    ; Initialize SCROLLINFO.
    s := mem.struct.scrollUpdate
    s.put("fMask", SIF_RANGE | SIF_PAGE)   
    
    ; Update vertical scroll bar.
    s.put("scrollHeight", scrollHeight)
    s.put("clientArea", guiHeight)

    DllCall("SetScrollInfo", "uint", WinExist(), "uint", SB_VERT, "uint", s.ptr, "int", 1)
    

    if (Top < 0 and Bottom < GuiHeight)
        y := Abs(Top) > GuiHeight-Bottom ? GuiHeight-Bottom : Abs(Top)
    if (y)
        DllCall("ScrollWindow", "uint", WinExist(), "int", 0, "int", y, "uint", 0, "uint", 0)
    
    tooltip % "y = " y ", top = " top ", bot = " bottom
}

OnScroll(wParam, lParam, msg, hwnd)
{
    static SIF_ALL=0x17, SCROLL_STEP=30
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
    else return

    min := s.get("nMin")
    max := s.get("scrollHeight") - s.get("clientArea")

    new_pos := new_pos > max ? max : new_pos
    new_pos := new_pos < min ? min : new_pos

    old_pos := s.get("nPos")
    
    y := 0
    y := old_pos-new_pos
    DllCall("ScrollWindow", "uint", hwnd, "int", 0, "int", y, "uint", 0, "uint", 0)
    
    s.put("nPos", new_pos)
    DllCall("SetScrollInfo", "uint", hwnd, "int", bar, "uint", s.ptr, "int", 1)
}