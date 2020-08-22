class desktop
{
    static _ := desktop.get() ;// initializes automatically on startup
    static uselessWinTitles := ["Default IME"]
    
    get() {
        sysGet, topLeftX, 76
        sysGet, topLeftY, 77
        sysGet, screenW, 78
        sysGet, screenH, 79
        this.w := screenW
        this.h := screenH
        SysGet, primaryMonitor, MonitorPrimary
        SysGet, coords, Monitor, % primaryMonitor
        this.topLeftX := topLeftX
        this.topLeftY := topLeftY
        this.centerX := (coordsLeft + coordsRight) / 2
        this.centerY := (coordsTop + coordsBottom) / 2
    }

    getWindows() {
        windows := []
        winGet, winList, list
        loop {
            hwnd := "winList" A_Index
            hwnd := % %hwnd%
            if (! hwnd)
                break
            windows.push(hwnd)
        }
        return windows
    }

    compareWinLists(wl1, wl2) {
        for j, w2 in wl2 {
            hasWindow := 0
            for i, w1 in wl1
                (w2 = w1) ? hasWindow := 1
            if (! hasWindow)
                return w2
        }
        return 0
    }

    refresh() {
        postMessage, 0x111, 41504, 0,, ahk_class Progman
    }
}