class mouseHook
{
    static pos := object()

    install() {
        this.reset()
        this.hook := dllCall("SetWindowsHookEx"
                            , "int", 14  ; WH_MOUSE_LL = 14
                            , "uint", registerCallback("mouseProc")
                            , "uint", 0
                            , "uint", 0)        
    }

    reset() {
        this.mouseMove := object()
        this.leftClick := object()
        this.rightClick := object()        
    }

    onMouseMove(obj, method = 0) {
        this.mouseMove := obj = "default" ? object() : objBindMethod(obj, method)
    }

    onLeftClick(obj, method = 0) {
        this.leftClick := obj = "default" ? object() : objBindMethod(obj, method)
    }

    onRightClick(obj, method = 0) {
        this.rightClick := obj = "default" ? object() : objBindMethod(obj, method)
    }

    uninstall() {
        dllCall("UnhookWindowsHookEx", "uint", this.hook)
    }
}

mouseProc(nCode, wParam, lParam)
{
    if (wParam = 0x200)
    {
        MouseGetPos, x, y
        mouseHook.pos.x := x
        mouseHook.pos.y := y
        mouseHook.mouseMove.call()
    } else if (wParam = 0x0201) {
        mouseHook.leftClick.call()
    } else if (wParam = 0x204) {
        mouseHook.rightClick.call()
    }
    return dllCall("CallNextHookEx"
                    , "uint", mouseHook.hook
                    , "int", nCode
                    , "uint", wParam
                    , "uint", lParam)
}