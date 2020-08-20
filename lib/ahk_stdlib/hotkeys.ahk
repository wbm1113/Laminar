~WheelUp::
~WheelDown::
    g := lookupGuiByHwnd[mouse.getHovWin()]
    if g.window.isActive()
        onScroll(InStr(A_ThisHotkey,"Down") ? 1 : 0, 0, 0x115, g.hwnd)
return